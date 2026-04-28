{
  description = "NixOS configuration with Flakes and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      cursor-pkg = pkgs.callPackage ./pkgs/cursor/default.nix { };

      vars = rec {
        username = "muratha";
        hostname = "nixos-laptop";
        gitName = "joska";
        gitEmail = "jpotin@gmail.com";
        configDir = "/home/${username}/nixos-config";
      };

      # Import the unstable package set for your system
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.${vars.hostname} = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs vars pkgs-unstable cursor-pkg; };
        modules = [
          ./hosts/laptop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = { inherit inputs vars pkgs-unstable cursor-pkg; };
          }

        ];
      };
    };
}
