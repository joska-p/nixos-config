{ pkgs, ... }:
{
  # Steam and Gaming optimizations
  programs.steam = {
    enable = true;
    protontricks.enable = true; # Tool to install dependencies in Steam games
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general.renice = 10; # Lower process priority for better performance
      gpu.gpu_device = 1; # Target specific GPU for GameMode
    };
  };
}
