{ pkgs, vars, ... }:
{
  imports = [
    ./git.nix
    ./zsh.nix
    ./zed.nix
  ];

  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";

  # State version for tracking stateful data. Do not change.
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    # --- Text Editors & IDEs ---
    nixd # Language server for Nix
    zed-editor # High-performance code editor

    # --- Development & Build Tools ---
    cmake # Build system for C/C++
    gcc # GNU Compiler Collection
    nodejs # JavaScript runtime environment
    nixfmt-rfc-style # Nix code formatter
    direnv # Shell extension that manages your environment
    nix-direnv # Faster, nix-integrated direnv

    # --- Multimedia & Audio ---
    vlc # Universal media player
    easyeffects # Audio effects for PipeWire (Equalizer, etc.)

    # --- Utilities ---
    bat # Better cat command with syntax highlighting
    uget # Versatile download manager
    kdiff3 # File comparison tool
    flatpak # Sandboxed desktop application support

    # --- Gaming & Compatibility ---
    wine # Windows compatibility layer
    winetricks # Helper script for Wine/Proton
    protonplus # Tool to manage Proton versions
  ];

  programs.home-manager.enable = true;
}
