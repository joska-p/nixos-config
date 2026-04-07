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
    {
      nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          # Import the main configuration file
          ./hosts/nixos-btw/configuration.nix

          # Include the Home Manager module
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
