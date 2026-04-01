# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-btw"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
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

  # Graphics drivers and hybrid GPU (PRIME) configuration
  # - Keep graphics-related options grouped for clarity.
  hardware.enableRedistributableFirmware = lib.mkDefault true; # allow microcode updates
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # NVIDIA driver settings. `open = false` selects the proprietary driver;
  # change to `true` if you prefer the open-source stack.
  hardware.nvidia = {
    open = false;
    prime = {
      # PRIME offload configuration: enables NVIDIA offloading helper. On NixOS
      # the convenience wrapper is typically named `nvidia-offload` (similar to
      # Arch's `prime-run`). Use `nvidia-offload <command>` to run an application
      # on the NVIDIA GPU when `enableOffloadCmd` is enabled.
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # NOTE: Verify these Bus IDs with `lspci` on your machine.
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
      # amdgpuBusId = "PCI:5@0:0:0"; # If you have an AMD iGPU
    };
  };

  # X server configuration: include `modesetting` so the iGPU can handle displays
  # while the nvidia driver is used for offloading.
  services.xserver = {
    enable = true;
    videoDrivers = [ "modesetting" "nvidia" ];
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs; [
    kdePackages.elisa # Music player
    kdePackages.kate # Text editor
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  # Nix optimization / maintenance settings
  # - `nix.optimise` (british spelling) runs Nix-specific optimisation tasks.
  # - `nix.gc` controls garbage collection schedules and options.
  nix.optimise = {
    automatic = true;
    dates = [ "03:45" ]; # local times (HH:MM) when optimisation runs
  };

  nix.gc = {
    automatic = true;
    dates = [ "weekly" ];     # schedule GC weekly
    options = "--delete-older-than 30d";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.muratha = {
    isNormalUser = true;
    description = "muratha";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    # Development tools
    gcc
    nodejs
    nil
    p7zip
    zed-editor

    # System monitoring
    nvtopPackages.full

    # Multimedia and desktop apps managed per-user
    easyeffects
    vlc

    # Wine and related tools
    wine
    winetricks

    # GUI / desktop packages
    aria2
    kdePackages.discover
    kdePackages.kcalc
    kdePackages.kolourpaint
    kdePackages.ksystemlog
    kdePackages.sddm-kcm
    kdiff3
    mesa-demos
    uget
    wayland-utils
    wl-clipboard
    zenity
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    vista-fonts
    corefonts
  ];

  # Install firefox.
  programs.firefox.enable = true;

  programs.bash = {
      shellAliases = {
        ll = "ls -l";
        rebuild = "sudo nixos-rebuild switch";
       };
    };

  programs.git = {
    enable = true;
  };

  programs.vscode.enable = true;

  # Enable Flatpak
  services.flatpak.enable = true;

  # Steam
  programs.steam = {
    enable = true; # Master switch, already covered in installation
    remotePlay.openFirewall = false;  # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports for Source Dedicated Server hosting
    # Other general flags if available can be set here.
  };

  # GameMode is a tool that improves gaming performance by enabling various
  # system optimizations.
  programs.gamemode.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # core developer/user tools
    vim
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
