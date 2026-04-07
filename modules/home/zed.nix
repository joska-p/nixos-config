{
  pkgs,
  lib,
  vars,
  ...
}:

{
  programs.zed-editor = {
    enable = true;
    # Everything inside of these brackets are Zed options
    userSettings = {
      agent_servers = {
        "Gemini CLI Custom" = {
          type = "custom";
          command = "node";
          args = [
            "/home/${vars.username}/.local/share/zed/external_agents/gemini/0.36.0/node_modules/@google/gemini-cli/bundle/gemini.js"
            "--acp"
          ];
          env = { };
        };
      };

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
