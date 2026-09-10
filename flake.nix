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
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      # ==========================================================
      # VARIABLES GLOBALES
      # ==========================================================
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
            {
              pkgs,
              lib,
              vars,
              ...
            }:
            {
              imports = [
                ./hardware-configuration.nix
              ];

              # State version for tracking stateful data. Do not change.
              system.stateVersion = "26.05";

              # ==========================================================
              # BOOT
              # ==========================================================
              boot.loader.systemd-boot.enable = true;
              boot.loader.efi.canTouchEfiVariables = true;

              # ==========================================================
              # LOCALISATION
              # ==========================================================
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

              # ==========================================================
              # RESEAU
              # ==========================================================
              networking.hostName = vars.hostname;
              networking.networkmanager.enable = true;

              # ==========================================================
              # CONTENEURS : Podman (remplace Docker) + devcontainers
              # ==========================================================
              # Podman en mode "compat Docker" : expose un socket à
              # /run/docker.sock et un alias `docker` -> podman. C'est ce
              # que cherchent par défaut le CLI devcontainer, l'extension
              # VS Code "Dev Containers", et la plupart des outils.
              virtualisation.podman = {
                enable = true;
                dockerCompat = true; # crée la commande `docker` -> podman
                dockerSocket.enable = true; # /run/docker.sock compatible
                defaultNetwork.settings.dns_enabled = true; # DNS entre conteneurs (utile pour docker-compose)
              };

              # ==========================================================
              # NIX : options, garbage collection, mises à jour auto
              # ==========================================================
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

              # System-wide package configuration
              nixpkgs.config.allowUnfree = true;

              # ==========================================================
              # MATERIEL : GPU, firmware, bluetooth, audio
              # ==========================================================
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

              # Gestion d'énergie (laptop) : profils Performance/Équilibré/
              # Économie accessibles depuis l'applet batterie de Plasma.
              # Ne PAS activer TLP en même temps (les deux se marchent dessus).
              services.power-profiles-daemon.enable = true;
              # Thermald : gère le throttling thermique côté CPU Intel
              # (pertinent ici vu le GPU Intel intégré en offload avec la Nvidia).
              services.thermald.enable = true;

              # Sound via pipewire (remplace pulseaudio)
              services.pulseaudio.enable = false;
              security.rtkit.enable = true;
              services.pipewire = {
                enable = true;
                alsa.enable = true;
                alsa.support32Bit = true;
                pulse.enable = true;
                # If you want to use JACK applications, uncomment this
                #jack.enable = true;

                # Use the WirePlumber session manager
                #wireplumber.enable = true;
              };

              # ==========================================================
              # ENVIRONNEMENT GRAPHIQUE : X11, SDDM, Plasma 6, polices
              # ==========================================================
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

              services.displayManager.sddm = {
                enable = true;
                wayland.enable = true;
              };
              services.desktopManager.plasma6.enable = true;

              environment.plasma6.excludePackages = with pkgs; [
                kdePackages.elisa
              ];

              fonts.packages = with pkgs; [
                nerd-fonts.jetbrains-mono # Developer font with many icons
                noto-fonts # Standard Google fonts for all languages
                noto-fonts-cjk-sans # CJK character support
                noto-fonts-color-emoji # Color emoji support
                liberation_ttf # Open-source versions of standard fonts
                fira-code # Popular coding font with ligatures
                fira-code-symbols # Extra symbols for Fira Code
                mplus-outline-fonts.githubRelease # Versatile Japanese font
                vista-fonts # Microsoft fonts from the Vista era
                corefonts # Microsoft core web fonts (Arial, etc.)
              ];

              services.flatpak.enable = true;

              # ==========================================================
              # PROGRAMMES SYSTEME (nécessitent une intégration OS)
              # ==========================================================
              programs.firefox = {
                enable = true;
                languagePacks = [
                  "en-US"
                  "fr"
                ];
              };

              # VS Code souvent gardé "sous la main" en complément de Zed
              # (nécessite le wrapper FHS pour l'auth/le keyring)
              programs.vscode = {
                enable = true;
                package = pkgs.vscode.fhs;
              };

              # Zsh must be enabled at the system level to be a valid login shell
              programs.zsh.enable = true;

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

              # --- Gaming ---
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

              programs.gamescope.enable = true;

              # ==========================================================
              # PAQUETS SYSTEME (environment.systemPackages)
              # ==========================================================
              environment.systemPackages = with pkgs; [
                # --- Utilitaires de base ---
                vim # Éditeur minimal, utile en secours (TTY/SSH sans DE)
                p7zip # File archiver for .7z
                aria2 # Multi-protocol download utility (CLI)
                zenity # GUI dialog boxes from shell
                libnotify # System notifications (notify-send)
                aha # ANSI to HTML converter

                # --- Navigateurs ---
                google-chrome

                # --- Diagnostic système & matériel ---
                nvtopPackages.full # GPU status viewer
                mesa-demos # OpenGL/graphics diagnostic tools
                vulkan-tools # Vulkan diagnostic tools
                usbutils # USB device listing (lsusb)
                pciutils # PCI device listing (lspci)
                hardinfo2 # System benchmarks and hardware info
                wayland-utils # Wayland diagnostic tools
                wl-clipboard # Wayland copy/paste support

                # --- Utilitaires KDE ---
                kdePackages.kate # Éditeur générique (hors dev)
                kdePackages.discover # Software center
                kdePackages.kcalc # Scientific calculator
                kdePackages.kcharselect # Character map
                kdePackages.kcolorchooser # Color picker
                kdePackages.kolourpaint # Simple paint program
                kdePackages.ksystemlog # System log viewer
                kdiff3 # File/directory comparison tool
                kdePackages.isoimagewriter # USB ISO writer
                kdePackages.partitionmanager # Disk partition management
              ];

              # ==========================================================
              # COMPTE UTILISATEUR
              # ==========================================================
              users.users.${vars.username} = {
                isNormalUser = true;
                description = vars.username;
                shell = pkgs.zsh;
                extraGroups = [
                  "networkmanager"
                  "wheel"
                  "gamemode"
                  "podman"
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
              {
                pkgs,
                vars,
                pkgs-unstable,
                lib,
                ...
              }:
              {
                home.username = vars.username;
                home.homeDirectory = "/home/${vars.username}";

                # State version for tracking stateful data. Do not change.
                home.stateVersion = "26.05";

                # ========================================================
                # PAQUETS UTILISATEUR (home.packages)
                # ========================================================
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
                  eza # ls moderne (couleurs, icônes, infos git) — utilisé par les alias ll/la
                  devcontainer # CLI officiel (containers.dev) : devcontainer up/exec/build

                  # --- Multimédia ---
                  vlc # Lecteur média universel
                  easyeffects # Effets audio pour PipeWire (égaliseur, etc.)
                  yt-dlp # Téléchargement de vidéos
                  ffmpeg # Conversion/traitement audio-vidéo
                  gimp # Retouche d'image

                  # --- Utilitaires ---
                  uget # Gestionnaire de téléchargements (GUI)

                  # --- Gaming & compatibilité Windows ---
                  wine # Couche de compatibilité Windows
                  winetricks # Script d'aide pour Wine/Proton
                  protonplus # Gestion des versions de Proton
                  discord # Client Discord
                  heroic # Client GOG
                ];

                # --- Correction du lanceur KSystemLog ---
                xdg.desktopEntries = {
                  "org.kde.ksystemlog" = {
                    name = "KSystemLog";
                    genericName = "System Log Viewer";
                    comment = "System log viewer tool";
                    exec = "ksystemlog";
                    icon = "utilities-log-viewer";
                    settings = {
                      X-KDE-SubstituteUID = "false";
                    };
                  };
                };

                programs.home-manager.enable = true;

                # ========================================================
                # GIT
                # ========================================================
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

                # ========================================================
                # SSH & GPG
                # ========================================================
                programs.gpg.enable = true;

                services.gpg-agent = {
                  enable = true;
                  enableSshSupport = true; # gpg-agent sert aussi d'agent SSH (plus besoin de ssh-agent séparé)
                  pinentry.package = pkgs.pinentry-qt; # boîte de dialogue Qt/KDE pour saisir le mot de passe
                  defaultCacheTtl = 3600; # 1h avant de redemander le mot de passe
                  maxCacheTtl = 86400; # 24h max
                };

                programs.ssh = {
                  enable = true;

                  # 1. Désactive l'ancienne configuration par défaut obsolète
                  enableDefaultConfig = false;

                  # 2. Nouvelle structure générique "settings"
                  settings = {
                    # On remplace l'ancien "addKeysToAgent" global par le bloc par défaut "*"
                    "*" = {
                      AddKeysToAgent = "yes";
                    };

                    # On remplace "matchBlocks" par des déclarations directes de blocs
                    "github.com" = {
                      IdentityFile = "~/.ssh/id_ed25519";
                    };
                  };
                };

                # ========================================================
                # EDITEUR PRINCIPAL : Zed
                # ========================================================
                programs.zed-editor = {
                  enable = true;
                  package = pkgs-unstable.zed-editor;

                  extensions = [
                    "nix"
                    "toml"
                  ];

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

                # ========================================================
                # SHELL : Zsh + oh-my-zsh + alias
                # ========================================================
                programs.zsh = {
                  enable = true;
                  enableCompletion = true;
                  autosuggestion.enable = true;
                  syntaxHighlighting.enable = true;

                  shellAliases = {
                    # --- General ---
                    ll = "eza -l --icons --group-directories-first";
                    la = "eza -la --icons --group-directories-first";
                    lt = "eza --tree --icons"; # Arborescence
                    ".." = "cd ..";
                    "..." = "cd ../..";

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

                # direnv générique (les environnements de dev spécifiques
                # sont gérés par ta flake de dev à part)
                programs.direnv = {
                  enable = true;
                  nix-direnv.enable = true;
                  enableZshIntegration = true;
                };

                # ========================================================
                # NAVIGATION & RECHERCHE : zoxide + fzf
                # ========================================================
                # zoxide : "cd" intelligent qui apprend tes dossiers fréquents.
                # vers Zed. Ex: après avoir fait `cd ~/nixos-config` une fois,
                # `z nixos` te ramène dedans depuis n'importe où.
                programs.zoxide = {
                  enable = true;
                  enableZshIntegration = true;
                  options = [ "--cmd z" ];
                };

                # fzf : recherche floue interactive.
                # Ctrl+R -> historique de commandes, Ctrl+T -> fichiers,
                # Alt+C -> changer de dossier par recherche floue.
                programs.fzf = {
                  enable = true;
                  enableZshIntegration = true;
                };
              };
          }
        ];
      };
    };
}
