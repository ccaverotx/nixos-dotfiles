{
  # Mantenemos tu descripción, ¡o cámbiala!
  description = "One flake to rule them all";

  inputs = {
    # Nixpkgs (usando registry + canal)
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # Home Manager (de nix-community, siguiendo la versión de nixpkgs)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Asegura que usen la misma base de paquetes
    };

    # Plasma Manager (de nix-community, rama principal para Plasma 6)
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      # Buena idea añadir 'follows' para home-manager también
      inputs.home-manager.follows = "home-manager";
    };
  };

  # --- OUTPUTS ---
  outputs = { self, nixpkgs, home-manager, plasma-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      myUsername = "ccaverotx";
      myHostname = "nixos";
      # Importa configuration.nix (asumiendo que está en la raíz)
      nixosConfigModule = import ./nixos/configuration.nix;
    in {
      nixosConfigurations = {
        ${myHostname} = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs myUsername; }; # Pasa inputs/vars a módulos
          modules = [
            # 1. Módulo principal del sistema
            nixosConfigModule

            # 2. Módulo de Home Manager para NixOS
            home-manager.nixosModules.home-manager
            # --- Bloque de Configuración de HM ---
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs myUsername; };
              # Configuración específica para tu usuario
              home-manager.users.${myUsername} = {
                # --- Lista de Imports para Home Manager ---
                imports = [
                  # a) Tu archivo home.nix (desde la raíz)
                  ./home-manager/home.nix

                  # b) El módulo de plasma-manager (¡AQUÍ DENTRO!)
                  inputs.plasma-manager.homeManagerModules.plasma-manager
                  # (Si 'default' diera error más tarde, probaríamos '.plasma-manager')
                ];
                # --- Fin Imports de HM ---
              };
            }
            # --- Fin Bloque de HM ---

            # --- ERROR CORREGIDO: La línea de plasma-manager NO va aquí fuera ---

          ]; # Fin lista de modules de NixOS
        }; # Fin lib.nixosSystem
      }; # Fin nixosConfigurations
    }; # Fin outputs
}
