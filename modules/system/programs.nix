{ pkgs, ... }:

{
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
  # These are tools that are useful for all users or system maintenance
  environment.systemPackages = with pkgs; [
    # Core utilities
    vim # Terminal text editor
    p7zip # File archiver for .7z
    aria2 # Multi-protocol download utility
    zenity # GUI dialog boxes from shell
    libnotify # System notifications (notify-send)
    vscode.fhs # VSCode FHS wrapper

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
}
