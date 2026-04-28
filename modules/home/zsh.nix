{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # --- General ---
      ll = "ls -l";
      la = "ls -lah";
      ".." = "cd ..";
      "..." = "cd ../..";
      v = "vim";
      z = "zed";
      c = "cursor"; # Shortcut for your new editor

      # --- NixOS Management ---
      # Always references your config directory regardless of current path
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config"; 
      
      # Nuclear update: updates all flake inputs and then rebuilds
      update = "sudo nixos-rebuild switch --upgrade --flake ~/nixos-config";
      
      ## Go to the cursor package folder, update it, and rebuild the system
      up-cursor = "cd ~/nixos-config/pkgs/cursor && node update.js && rebuild";
      
      # Cleaning tools
      nix-clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      nix-list = "nix-env --list-generations --profile /nix/var/nix/profiles/system";
      
      # Nix Shell shortcut (e.g., 'ns python3' for a temporary environment)
      ns = "nix shell nixpkgs#";

      # --- Git ---
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      
      # --- Navigation ---
      conf = "cd ~/nixos-config";
    };

    oh-my-zsh = {
      enable = true;
      theme = "refined";
      plugins = [
        "git"
        "sudo"
        "direnv"
        "extract" # Type 'extract <file>' for any archive type
      ];
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
}