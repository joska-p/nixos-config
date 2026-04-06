{ pkgs, ... }:
{
  # System-wide package configuration
  nixpkgs.config.allowUnfree = true;

  # --- System-level Programs ---
  # These are programs that need special integration with the OS

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

  # System-wide browser and tools
  programs.firefox = {
    enable = true;

    languagePacks = [
      "en-US"
      "fr"
    ];

    policies = {
      # Updates & Background Services
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;

      # Feature Disabling
      DisableBuiltinPDFViewer = true;
      DisableFirefoxStudies = true;
      DisableFirefoxScreenshots = true;
      DisableForgetButton = true;
      DisableMasterPasswordCreation = true;
      DisableProfileImport = true;
      DisableProfileRefresh = true;
      DisableSetDesktopBackground = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFormHistory = true;
      DisablePasswordReveal = true;

      # Access Restrictions
      BlockAboutConfig = false;
      BlockAboutProfiles = true;
      BlockAboutSupport = true;

      # UI and Behavior
      DisplayMenuBar = "never";
      DontCheckDefaultBrowser = true;
      HardwareAcceleration = false;
      OfferToSaveLogins = false;

      profiles.default.search = {
        force = true;
        default = "DuckDuckGo";
        privateDefault = "DuckDuckGo";

      };
    };
  };

  programs.vscode.enable = true; # VS Code often needs system-level help for auth/keyring

  # Zsh must be enabled at the system level to be a valid login shell
  programs.zsh.enable = true;

  # Steam and Gaming optimizations
  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general.renice = 10;
      gpu.gpu_device = 1;
    };
  };

  # --- System-wide Packages ---
  # These are tools that are useful for all users or system maintenance
  environment.systemPackages = with pkgs; [
    # Core utilities
    vim
    p7zip
    aria2
    zenity

    # System monitoring & hardware tools
    nvtopPackages.full # GPU monitor
    mesa-demos
    vulkan-tools
    usbutils
    pciutils

    # KDE Utilities
    kdePackages.discover # Optional: Software center for Flatpaks/firmware updates
    kdePackages.kcalc # Calculator
    kdePackages.kcharselect # Character map
    kdePackages.kcolorchooser # Color picker
    kdePackages.kolourpaint # Simple paint program
    kdePackages.ksystemlog # System log viewer
    kdiff3 # File/directory comparison tool

    # Hardware/System Utilities (Optional)
    kdePackages.isoimagewriter # Write hybrid ISOs to USB
    kdePackages.partitionmanager # Disk and partition management
    hardinfo2 # System benchmarks and hardware info
    wayland-utils # Wayland diagnostic tools
    wl-clipboard # Wayland copy/paste support
  ];
}
