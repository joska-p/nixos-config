# NixOS Configuration File
# Define system settings, packages, and services.

{ pkgs, lib, ... }:

{
  # --- System Settings ---
  imports = [ ./hardware-configuration.nix ]; # Include hardware scan results
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos-btw";
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

  # --- Hardware Configuration ---
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    open = false;
    modesetting.enable = true; # THIS IS CRITICAL
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # Find your GPU IDs with:
      #   lspci -nn | grep -E "VGA|3D"
      # Example output:
      #   00:02.0 VGA compatible controller [0300]: Intel Corporation ...
      #   01:00.0 3D controller [0302]: NVIDIA Corporation ...
      # Convert to Nix format `PCI:<domain>@<bus>:<slot>:<func>` (or use the IDs that match your machine):
      #   intelBusId = "PCI:0@0:2:0"
      #   nvidiaBusId = "PCI:1@0:0:0"
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

  # --- Desktop Environment ---
  services.xserver = {
    enable = true;
    videoDrivers = [
      "modesetting"
      "nvidia"
    ];
  };
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.autoNumlock = true;
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs; [
    kdePackages.elisa
    kdePackages.kate
  ];
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };
  console.keyMap = "fr";

  # --- Services ---
  networking.networkmanager.enable = true;
  services.printing.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.flatpak.enable = true;

  # --- User Configuration ---
  users.users.muratha = {
    isNormalUser = true;
    description = "muratha";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "gamemode"
    ];
    packages = with pkgs; [
      kdePackages.discover
      kdePackages.kcalc
      kdePackages.kolourpaint
      kdePackages.ksystemlog
      kdePackages.sddm-kcm
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # --- Programs ---
  programs.firefox.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
      rebuild = "sudo nixos-rebuild switch";
      update = "sudo nixos-rebuild switch --upgrade";
    };
    histSize = 10000;
    histFile = "$HOME/.zsh_history";
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
    ];
    ohMyZsh = {
      enable = true;
      theme = "refined";
    };
  };
  programs.git.enable = true;
  programs.vscode.enable = true;

  # --- Games ---
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
    protontricks.enable = true;
  };
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      gpu = {
        gpu_device = 1;
      };
    };
  };

  # --- Fonts ---
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

  # --- Optimization and Maintenance ---
  nix.optimise = {
    automatic = true;
    dates = [ "03:45" ];
  };
  nix.gc = {
    automatic = true;
    dates = [ "weekly" ];
    options = "--delete-older-than 30d";
  };
  system.autoUpgrade = {
    enable = true;
    channel = null; # use current system channel
    dates = "04:00"; # daily at 04:00 (systemd.time syntax)
    allowReboot = false; # do not reboot automatically after upgrade
  };

  # --- System Packages ---
  environment.systemPackages = with pkgs; [
    vim
    cmake
    gcc
    nodejs
    nil
    p7zip
    zed-editor
    nvtopPackages.full
    easyeffects
    vlc
    wine
    winetricks
    protonplus
    aria2
    kdiff3
    mesa-demos
    uget
    wayland-utils
    wl-clipboard
    zenity
  ];

  # --- System State ---
  system.stateVersion = "25.11";
}
