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

      # --- NixOS Management ---
      rebuild = "sudo nixos-rebuild switch --flake .";
      update = "sudo nixos-rebuild switch --upgrade --flake .";
      nix-clean = "sudo nix-collect-garbage -d";
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
