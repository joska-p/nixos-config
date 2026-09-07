{
  description = "NixOS configuration with Flakes and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      vars = rec {
        username = "muratha";
        hostname = "nixos-laptop";
        gitName = "joska";
        gitEmail = "jpotin@gmail.com";
        configDir = "/home/${username}/nixos-config";
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.${vars.hostname} = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs vars pkgs-unstable; };
        modules = [
          (
            { pkgs, lib, vars, ... }:
            {
              imports = [
               "./hardware-configuration.nix"
              ];

              boot.loader.systemd-boot.enable = true;
              boot.loader.efi.canTouchEfiVariables = true;

              # State version for tracking stateful data. Do not change.
              system.stateVersion = "26.05";

              # --- Graphics & X11 ---
              services.xserver = {
                enable = true;
                videoDrivers = [
                  "modesetting"
                  "nvidia"
                ];
                xkb = {
                  layout = "fr";
                  variant = "";
                };
              };

              # --- Desktop Environment (KDE Plasma 6) ---
              services.displayManager.sddm = {
                enable = true;
                wayland.enable = true;
              };
              services.desktopManager.plasma6.enable = true;
              environment.plasma6.excludePackages = with pkgs; [
                kdePackages.elisa
                kdePackages.kate
              ];

              # --- Audio (PipeWire) ---
              services.pipewire = {
                enable = true;
                alsa.enable = true;
                alsa.support32Bit = true;
                pulse.enable = true;
              };

              programs.firefox = {
                enable = true;
                languagePacks = [
                  "en-US"
                  "fr"
                ];
              };

              fonts.packages = with pkgs; [
                nerd-fonts.jetbrains-mono # Developer font with many icons
                noto-fonts # Standard Google fonts for all languages
                noto-fonts-cjk-sans # CJK character support
                noto-fonts-color-emoji # Color emoji support
                liberation_ttf # Open-source versions of standard fonts
                fira-code # Popular coding font with ligatures
                fira-code-symbols # Extra symbols for Fira Code
                mplus-outline-fonts.githubRelease # Versatile Japanese font
                dina-font # Crisp bitmapped coding font
                proggyfonts # Small coding fonts
                vista-fonts # Microsoft fonts from the Vista era
                corefonts # Microsoft core web fonts (Arial, etc.)
              ];

              programs.steam = {
                enable = true;
                protontricks.enable = true; # Tool to install dependencies in Steam games
              };

              programs.gamemode = {
                enable = true;
                settings = {
                  general.renice = 10; # Lower process priority for better performance
                  gpu.gpu_device = 1; # Target specific GPU for GameMode
                };
              };

              services.udev.extraRules = ''
                # Razer DeathAdder V3 - Disable USB Autosuspend
                ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="00b2", ATTR{power/control}="on"
                # Xbox One Controller - Disable USB Autosuspend
                ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="045e", ATTR{idProduct}=="02ea", ATTR{power/control}="on"
              '';

              hardware.enableRedistributableFirmware = lib.mkDefault true;
              hardware.graphics = {
                enable = true;
                enable32Bit = true;
              };
              hardware.nvidia = {
                open = false;
                # GTX 1050 Ti = architecture Pascal : les branches "stable"/"production"/
                # "beta" ne supportent plus Pascal/Maxwell depuis les drivers 590+.
                # Il faut rester sur la dernière branche legacy qui les supporte encore.
                # Vérifie sur search.nixos.org/options?query=hardware.nvidia.branch
                # que "legacy_580" est bien dans les valeurs acceptées avant d'installer.
                branch = "legacy_580";
                modesetting.enable = true; # Required for NVIDIA PRIME
                powerManagement.enable = true; # Meilleure autonomie / veille sur portable
                prime = {
                  offload = {
                    enable = true;
                    enableOffloadCmd = true;
                  };
                  # GPU IDs (Run: lspci -nn | grep -E "VGA|3D")
                  # Format: PCI:<domain>@<bus>:<slot>:<func>
                  intelBusId = "PCI:0@0:2:0";
                  nvidiaBusId = "PCI:1@0:0:0";
                };
              };
              hardware.bluetooth = {
                enable = true;
                powerOnBoot = true;
                settings = {
                  General = {
                    Experimental = true;
                    FastConnectable = true;
                  };
                  Policy = {
                    AutoEnable = true;
                  };
                };
              };

              # Enable nix-ld to run unpatched binaries (like Zed language servers)
              programs.nix-ld.enable = true;
              programs.nix-ld.libraries = with pkgs; [
                stdenv.cc.cc
                zlib
                fuse3
                icu
                nss
                openssl
                curl
                expat
              ];

              # System-wide package configuration
              nixpkgs.config.allowUnfree = true;

              services.flatpak.enable = true;

              # --- System-level Programs ---
              # These are programs that need special integration with the OS

              # VS Code often needs system-level help for auth/keyring
              programs.vscode = {
                enable = true;
                package = pkgs.vscode.fhs;
              };

              # Zsh must be enabled at the system level to be a valid login shell
              programs.zsh.enable = true;

              # --- System-wide Packages ---
              environment.systemPackages = with pkgs; [
                # Core utilities
                vim # Terminal text editor
                p7zip # File archiver for .7z
                aria2 # Multi-protocol download utility
                zenity # GUI dialog boxes from shell
                libnotify # System notifications (notify-send)

                # Web browsers
                google-chrome

                # System monitoring & hardware tools
                nvtopPackages.full # GPU status viewer
                mesa-demos # OpenGL/graphics diagnostic tools
                vulkan-tools # Vulkan diagnostic tools
                usbutils # USB device listing (lsusb)
                pciutils # PCI device listing (lspci)

                # KDE Utilities
                kdePackages.discover # Software center
                kdePackages.kcalc # Scientific calculator
                kdePackages.kcharselect # Character map
                kdePackages.kcolorchooser # Color picker
                kdePackages.kolourpaint # Simple paint program
                kdePackages.ksystemlog # System log viewer
                kdiff3 # File/directory comparison tool

                # Hardware/System Utilities
                kdePackages.isoimagewriter # USB ISO writer
                kdePackages.partitionmanager # Disk partition management
                hardinfo2 # System benchmarks and hardware info
                wayland-utils # Wayland diagnostic tools
                wl-clipboard # Wayland copy/paste support
              ];

              # --- Networking ---
              networking.hostName = vars.hostname;
              networking.networkmanager.enable = true;

              # --- Localization ---
              time.timeZone = "Europe/Paris";
              i18n.defaultLocale = "en_US.UTF-8";
              i18n.extraLocaleSettings = {
                LC_ADDRESS = "fr_FR.UTF-8";
                LC_IDENTIFICATION = "fr_FR.UTF-8";
                LC_MEASUREMENT = "fr_FR.UTF-8";
                LC_MONETARY = "fr_FR.UTF-8";
                LC_NAME = "fr_FR.UTF-8";
                LC_NUMERIC = "fr_FR.UTF-8";
                LC_PAPER = "fr_FR.UTF-8";
                LC_TELEPHONE = "fr_FR.UTF-8";
                LC_TIME = "fr_FR.UTF-8";
              };
              console.keyMap = "fr";

              # --- Nix Settings & Optimization ---
              nix.settings.experimental-features = [
                "nix-command"
                "flakes"
              ];
              nix.optimise.automatic = true;
              nix.gc = {
                automatic = true;
                dates = [ "weekly" ];
                options = "--delete-older-than 30d";
              };

              # --- Auto-Upgrades ---
              system.autoUpgrade = {
                enable = true;
                flake = vars.configDir;
                flags = [
                  "--update-input"
                  "nixpkgs"
                  "--commit-lock-file"
                ];
                dates = "09:00";
                randomizedDelaySec = "45min";
              };

              # Main user account
              users.users.${vars.username} = {
                isNormalUser = true;
                description = vars.username;
                shell = pkgs.zsh;
                extraGroups = [
                  "networkmanager"
                  "wheel"
                  "gamemode"
                ];
              };
            }
          )

          # ============================================================
          # MODULE HOME-MANAGER
          # ============================================================
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs vars pkgs-unstable; };

            home-manager.users.${vars.username} =
              { pkgs, vars, inputs, pkgs-unstable, lib, ... }:
              {
                home.username = vars.username;
                home.homeDirectory = "/home/${vars.username}";

                # State version for tracking stateful data. Do not change.
                home.stateVersion = "26.05";

                home.packages = with pkgs; [
                  # --- Editeurs & langages ---
                  nixd # Language server pour Nix (utilisé par Zed)
                  nodejs # Requis par le réglage "node.path" de Zed

                  # --- Outils Nix / shell ---
                  nixfmt # Formatteur Nix
                  direnv # Charge automatiquement les nix shell par dossier
                  nix-direnv # Cache direnv accéléré pour Nix
                  jq # Traitement JSON en ligne de commande
                  bat # cat avec coloration syntaxique

                  # --- Multimédia ---
                  vlc # Lecteur média universel
                  easyeffects # Effets audio pour PipeWire (égaliseur, etc.)
                  yt-dlp # Téléchargement de vidéos
                  ffmpeg # Conversion/traitement audio-vidéo
                  gimp # Retouche d'image

                  # --- Utilitaires ---
                  uget # Gestionnaire de téléchargements

                  # --- Gaming & compatibilité Windows ---
                  wine # Couche de compatibilité Windows
                  winetricks # Script d'aide pour Wine/Proton
                  protonplus # Gestion des versions de Proton
                ];

                programs.home-manager.enable = true;

                programs.git = {
                  enable = true;
                  settings = {
                    user = {
                      name = vars.gitName;
                      email = vars.gitEmail;
                    };
                    init.defaultBranch = "main";
                    push.autoSetupRemote = true; # Crée automatiquement la branche distante au push
                  };
                };

                programs.zed-editor = {
                  enable = true;
                  package = pkgs-unstable.zed-editor;

                  extensions = [
                    "nix"
                    "toml"
                  ];

                  # Everything inside of these brackets are Zed options
                  userSettings = {
                    node = {
                      path = lib.getExe pkgs.nodejs;
                      npm_path = lib.getExe' pkgs.nodejs "npm";
                    };

                    hour_format = "hour24";
                    auto_update = false;

                    terminal = {
                      font_family = "JetBrainsMono Nerd Font";
                    };

                    languages = {
                      Nix = {
                        language_servers = [
                          "nixd"
                          "!nil"
                        ];
                      };
                    };

                    vim_mode = false;

                    # Tell Zed to use direnv and direnv can use a flake.nix environment
                    load_direnv = "shell_hook";
                    base_keymap = "VSCode";
                    theme = "Gruvbox Dark";
                    ui_font_size = 16;
                    buffer_font_size = 16;
                  };
                };

                programs.zsh = {
                  enable = true;
                  enableCompletion = true;
                  autosuggestion.enable = true;
                  syntaxHighlighting.enable = true;

                  shellAliases = {
                    # --- General ---
                    ll = "ls -l";
                    la = "ls -lah";
                    ".." = "cd ..";
                    "..." = "cd ../..";
                    v = "vim";
                    z = "zed";
                    c = "code"; # VSCode

                    # --- NixOS Management ---
                    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config";
                    update = "sudo nixos-rebuild switch --upgrade --flake ~/nixos-config";

                    # Cleaning tools
                    nix-clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
                    nix-list = "nix-env --list-generations --profile /nix/var/nix/profiles/system";

                    # Nix Shell shortcut (e.g., 'ns python3' for a temporary environment)
                    ns = "nix shell nixpkgs#";

                    # --- Git ---
                    gs = "git status";
                    ga = "git add";
                    gc = "git commit";
                    gp = "git push";

                    # --- Navigation ---
                    conf = "cd ~/nixos-config";
                  };

                  oh-my-zsh = {
                    enable = true;
                    theme = "refined";
                    plugins = [
                      "git"
                      "sudo"
                      "direnv"
                      "extract" # Type 'extract <file>' for any archive type
                    ];
                  };
                };

                programs.direnv = {
                  enable = true;
                  nix-direnv.enable = true;
                  enableZshIntegration = true;
                };
              };
          }
        ];
      };
    };
}
