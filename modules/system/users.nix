{ pkgs, vars, ... }:
{
  # Define the main user account
  users.users.${vars.username} = {
    isNormalUser = true;
    description = vars.username;
    shell = pkgs.zsh; # Use Zsh as the default login shell
    extraGroups = [
      "networkmanager" # Allow user to manage networks
      "wheel" # Enable sudo access
      "gamemode" # Allow user to use Feral Gamemode
    ];
  };

  # Home Manager configuration for the user
  # This section ties the system configuration to your home environment
  home-manager = {
    useGlobalPkgs = true; # Use the system's nixpkgs version
    useUserPackages = true; # Install packages into /etc/profiles/per-user
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit vars; };
    users.${vars.username} = import ../home;
  };
}
