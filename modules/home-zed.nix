{ pkgs, lib, ... }:

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
            "/home/muratha/.local/share/zed/external_agents/gemini/0.36.0/node_modules/@google/gemini-cli/bundle/gemini.js"
            "--acp"
          ];
          env = { };
        };
      };

      languages = {
        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
        };
      };
      theme = "Gruvbox Dark";
      ui_font_size = 16;
      buffer_font_size = 16;
    };
  };
}
