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
  hardware.graphics = { enable = true; enable32Bit = true; };
  hardware.nvidia = {
    open = false;
    modesetting.enable = true; # THIS IS CRITICAL
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = { Experimental = true; FastConnectable = true; };
      Policy = { AutoEnable = true; };
    };
  };

  # --- Desktop Environment ---
  services.xserver = { enable = true; videoDrivers = [ "modesetting" "nvidia" ]; };
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.autoNumlock = true;
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs; [ kdePackages.elisa kdePackages.kate ];
  services.xserver.xkb = { layout = "fr"; variant = ""; };
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
    extraGroups = [ "networkmanager" "wheel" "gamemode" ];
    packages = with pkgs; [
      cmake gcc nodejs nil p7zip zed-editor nvtopPackages.full easyeffects vlc wine winetricks
      aria2 kdePackages.discover kdePackages.kcalc kdePackages.kolourpaint kdePackages.ksystemlog
      kdePackages.sddm-kcm kdiff3 mesa-demos uget wayland-utils wl-clipboard zenity
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # --- Programs ---
  programs.firefox.enable = true;
  programs.bash.shellAliases = { ll = "ls -l"; rebuild = "sudo nixos-rebuild switch"; update = "sudo nixos-rebuild switch --upgrade"; };
  programs.git.enable = true;
  programs.vscode.enable = true;

  # --- Games ---
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
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
    nerd-fonts.jetbrains-mono noto-fonts noto-fonts-cjk-sans noto-fonts-color-emoji
    liberation_ttf fira-code fira-code-symbols mplus-outline-fonts.githubRelease
    dina-font proggyfonts vista-fonts corefonts
  ];

  # --- Optimization and Maintenance ---
  nix.optimise = { automatic = true; dates = [ "03:45" ]; };
  nix.gc = { automatic = true; dates = [ "weekly" ]; options = "--delete-older-than 30d"; };

  # --- System Packages ---
  environment.systemPackages = with pkgs; [ vim ];

  # --- System State ---
  system.stateVersion = "25.11";
}
