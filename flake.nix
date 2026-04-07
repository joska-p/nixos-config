{
  description = "NixOS configuration with Flakes and Home Manager";

  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Home Manager, which manages user-specific configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      vars = rec {
        username = "muratha";
        hostname = "nixos-laptop";
        gitName = "joska";
        gitEmail = "jpotin@gmail.com";
        configDir = "/home/${username}/nixos-config";
      };
    in
    {
      nixosConfigurations.${vars.hostname} = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs vars; };
        modules = [
          # Import the main configuration file
          ./hosts/laptop/configuration.nix

          # Include the Home Manager module
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
