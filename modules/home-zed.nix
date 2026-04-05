{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    userSettings = {
      theme = "Gruvbox Dark";
      ui_font_size = 16;
      buffer_font_family = "JetBrainsMono Nerd Font";
      autosave = "on_focus_change";
      vim_mode = false;
      telemetry = {
        metrics = false;
      };
      languages = {
        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
        };
      };
    };
  };
}
