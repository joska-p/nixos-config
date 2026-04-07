{ pkgs, ... }:
let
  # Define the custom background package with the correct relative path
  background-package = pkgs.stdenvNoCC.mkDerivation {
    name = "background-image";
    src = ../../assets/wallpaper.jpg; # Place wallpaper.jpg in the same directory as this config file
    dontUnpack = true;
    installPhase = ''
      cp $src $out
    '';
  };

in
{
  # System-wide package configuration
  nixpkgs.config.allowUnfree = true;

  # --- System-level Programs ---
  # These are programs that need special integration with the OS

  programs.vscode.enable = true; # VS Code often needs system-level help for auth/keyring

  # Zsh must be enabled at the system level to be a valid login shell
  programs.zsh.enable = true;

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
    kdePackages.sddm-kcm # SDDM theme configuration

    # Hardware/System Utilities (Optional)
    kdePackages.isoimagewriter # Write hybrid ISOs to USB
    kdePackages.partitionmanager # Disk and partition management
    hardinfo2 # System benchmarks and hardware info
    wayland-utils # Wayland diagnostic tools
    wl-clipboard # Wayland copy/paste support

    # SDDM theme configuration
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background = "${background-package}"
    '')
  ];
}
