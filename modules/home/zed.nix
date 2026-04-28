{
  pkgs,
  lib,
  vars,
  inputs,
  ...
}:

{
  programs.zed-editor = {
    enable = true;
    # Use the official stable package from the Zed flake input
    package = inputs.zed-editor.packages.${pkgs.stdenv.hostPlatform.system}.default;

    extensions = [
      "nix"
      "toml"
    ];

    # Everything inside of these brackets are Zed options
    userSettings = {
      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };

      hour_format = "hour24";
      auto_update = false;

      terminal = {
        font_family = "JetBrainsMono Nerd Font";
      };

      languages = {
        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
        };
      };

      vim_mode = false;

      # Tell Zed to use direnv and direnv can use a flake.nix environment
      load_direnv = "shell_hook";
      base_keymap = "VSCode";
      theme = "Gruvbox Dark";
      ui_font_size = 16;
      buffer_font_size = 16;
    };
  };
}