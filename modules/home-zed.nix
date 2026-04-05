{ pkgs, lib, ... }:

{
  programs.zed-editor = {

    enable = true;

    # This populates the userSettings "auto_install_extensions"
    extensions = [
      "nix"
      "toml"
    ];

    # Everything inside of these brackets are Zed options
    userSettings = {
      agent = {
        default_model = {
          provider = "copilot_chat";
          model = "oswe-vscode-prime";
        };
        model_parameters = [ ];
      };

      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };

      auto_update = false;

      terminal = {
        copy_on_select = false;
        dock = "bottom";
        detect_venv = {
          on = {
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
            activate_script = "default";
          };
        };
        env = {
          TERM = "alacritty";
        };
        font_family = "JetBrainsMono Nerd Font";
        font_features = null;
        font_size = null;
        line_height = "comfortable";
        option_as_meta = false;
        button = false;
        shell = "system";
        working_directory = "current_project_directory";
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

      base_keymap = "VSCode";

      theme = "Gruvbox Dark";

      ui_font_size = 16;
      buffer_font_size = 16;
    };
  };
}
