{
  pkgs,
  lib,
  pkgs-unstable,
  ...
}:

{
  programs.zed-editor = {
    enable = true;
    package = pkgs-unstable.zed-editor;

    extensions = [
      "nix"
      "toml"
    ];

    # Everything inside of these brackets are Zed options
    userSettings = {
      agent = {
        default_model = {
          provider = "copilot_chat";
          model = "gpt-5-mini";
          enable_thinking = false;
          effort = "high";
        };
        favorite_models = [ ];
        model_parameters = [ ];
      };
      agent_servers = {
        github-copilot-cli = {
          type = "registry";
        };
        gemini = {
          type = "registry";
        };
      };

      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };

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
