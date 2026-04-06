{ pkgs, lib, ... }:

{
  programs.zed-editor = {
    enable = true;
    # Everything inside of these brackets are Zed options
    userSettings = {
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
