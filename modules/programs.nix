{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;
  programs.git.enable = true;
  programs.vscode.enable = true;

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
    ohMyZsh = {
      enable = true;
      theme = "refined";
    };
  };

  programs.steam = {
    enable = true;
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

  environment.systemPackages = with pkgs; [
    # --- Text Editors & IDEs ---
    vim # The classic terminal-based editor for quick config edits
    zed-editor # High-performance, modern code editor (Wayland native)

    # --- Development & Build Tools ---
    cmake # Cross-platform build system generator
    gcc # The standard C/C++ compiler collection
    nodejs # JavaScript runtime for web and tooling development
    nil # Language server for Nix (provides autocomplete for .nix files)
    kdiff3 # Advanced file/directory comparison and merge tool

    # --- Utilities & Archives ---
    p7zip # Command-line archive utility for .7z and other formats
    aria2 # Ultra-fast, multi-protocol command-line download tool
    uget # Lightweight, full-featured GUI download manager
    zenity # Allows shell scripts to display GTK+ dialog boxes

    # --- Hardware & System Monitoring ---
    nvtopPackages.full # Interactive GPU task monitor (like 'htop' but for Nvidia/AMD)
    mesa-demos # Tools like 'glxinfo' and 'glxgears' to test 3D acceleration
    wayland-utils # Tools to display information about the Wayland compositor
    wl-clipboard # Command-line copy/paste utilities for Wayland

    # --- Multimedia & Audio ---
    vlc # Versatile media player that handles almost any codec
    easyeffects # Advanced audio manipulation (EQ, Limiter) for PipeWire

    # --- Gaming & Windows Compatibility ---
    wine # Compatibility layer to run Windows applications on Linux
    winetricks # Helper script to install DLLs and settings for Wine
    protonplus # GUI to manage Proton, Wine, and GE-Proton versions

    # --- KDE Plasma Desktop Apps ---
    kdePackages.discover # The KDE software center/store
    kdePackages.kcalc # Simple and powerful desktop calculator
    kdePackages.kolourpaint # Easy-to-use paint/drawing program (like MS Paint)
    kdePackages.ksystemlog # GUI for viewing system logs and troubleshooting
    kdePackages.sddm-kcm # Settings module to configure the SDDM login screen
  ];
}
