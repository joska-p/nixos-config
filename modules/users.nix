{ pkgs, ... }:
{
  users.users.muratha = {
    isNormalUser = true;
    description = "muratha";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "gamemode"
    ];
  };
}
