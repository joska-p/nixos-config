{ pkgs, ... }:
{
  # Your Zsh configuration.
  # Home Manager is much better at managing shell configs.
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # --- General ---
      ll = "ls -l";
      la = "ls -lah"; # Show all files with detailed info and human-readable sizes
      ".." = "cd ..";
      "..." = "cd ../..";
      v = "vim";
      z = "zed";

      # --- NixOS Management ---
      rebuild = "sudo nixos-rebuild switch --flake .#nixos-laptop";
      update = "sudo nixos-rebuild switch --upgrade --flake .#nixos-laptop";
      nix-clean = "sudo nix-collect-garbage -d"; # Deep clean old generations
      nix-list = "nix-env --list-generations --profile /nix/var/nix/profiles/system";

      # --- Git ---
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
    };

    oh-my-zsh = {
      enable = true;
      theme = "refined";
    };
  };
}
