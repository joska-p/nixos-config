{ pkgs, vars, inputs, pkgs-unstable, cursor-pkg, ... }:
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
    cursor-pkg # Custom cursor buil from the local pkgs directory

    # --- Text Editors & IDEs ---
    nixd # Language server for Nix
    nodejs # Required for many JavaScript-based tools
    corepack # Manages npm/pnpm/yarn versions as specified in package.json

    # --- Development & Build Tools ---
    cmake # Build system for C/C++
    gcc # GNU Compiler Collection
    nixfmt # Nix code formatter
    direnv # Shell extension that manages your environment
    nix-direnv # Faster, nix-integrated direnv
    jq # JSON query tool

    # --- Multimedia & Audio ---
    vlc # Universal media player
    easyeffects # Audio effects for PipeWire (Equalizer, etc.)
    yt-dlp # Downloader for YouTube and other video platforms
    ffmpeg # Complete, cross-platform solution to record, convert and stream audio and video
    gimp # GNU Image Manipulation Program

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
