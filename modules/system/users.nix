{ pkgs, vars, ... }:
{
  # Main user account
  users.users.${vars.username} = {
    isNormalUser = true;
    description = vars.username;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "gamemode"
    ];
  };

  # Home Manager bridge
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit vars; };
    users.${vars.username} = import ../home;
  };
}
