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
  programs.firefox.enable = true;
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

  # Power management
  # Replace power-profiles-daemon with tlp
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
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
    wayland-utils
    wl-clipboard
    usbutils
    pciutils

    # KDE/System helpers
    kdePackages.discover
  ];
}
