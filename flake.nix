{
  description = "Configuracion de NixOS con Flakes :D";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      myUsername = "ccaverotx";
      myHostname = "nixos";

      nixosConfigModule = import ./nixos/configuration.nix;
      homeConfigModule = import ./home-manager/home.nix;

    in {
      nixosConfigurations = {
        ${myHostname} = lib.nixosSystem {
          inherit system;

          specialArgs = { inherit inputs myUsername system; };

          modules = [
            nixosConfigModule
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs myUsername system; };

                users.${myUsername} = {
                  imports = [
                    homeConfigModule
                    inputs.plasma-manager.homeManagerModules.plasma-manager
                  ];
                };
              };
            }
          ];
        };
      };
    };
}
