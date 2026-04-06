{ pkgs, ... }:
{
  imports = [
    ./home-git.nix
    ./home-zsh.nix
    ./home-zed.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "muratha";
  home.homeDirectory = "/home/muratha";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update NixOS.
  # See the Home Manager release notes for a list of state version changes.
  home.stateVersion = "25.11"; # Match this with your initial install version

  # The home.packages option allows you to install user-specific software.
  # These will only be available to your user, keeping the system path clean.
  home.packages = with pkgs; [
    # --- Text Editors & IDEs ---
    nixd # Language server for Nix (autocomplete)

    # --- Development & Build Tools ---
    cmake # Build system for C and C++
    gcc # Compiler for C and C++
    nodejs # JavaScript runtime
    nixfmt # Formatter for Nix files

    # --- Multimedia & Audio ---
    vlc
    easyeffects # Advanced audio manipulation for PipeWire

    # --- Utilities ---
    bat # Improved cat command
    uget # Download manager
    kdiff3 # File comparison tool

    # --- Desktop Apps ---
    flatpak

    # --- Gaming & Windows Compatibility ---
    wine
    winetricks
    protonplus
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
