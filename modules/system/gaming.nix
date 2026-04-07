{ pkgs, ... }:
{
  # Steam and Gaming optimizations
  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general.renice = 10;
      gpu.gpu_device = 1;
    };
  };
}
