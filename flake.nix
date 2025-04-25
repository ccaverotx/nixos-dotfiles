{
  description = "Flake NixOS de ccaverotx con Home Manager"; # Descripción actualizada

  # --- INPUTS ---
  inputs = {
    # Nixpkgs (usando registry + canal)
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # --- AÑADIDO ---
    # Home Manager (de nix-community, siguiendo la versión de nixpkgs)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Asegura que usen la misma base de paquetes
    };
    # --- FIN AÑADIDO ---
  };

  # --- OUTPUTS ---
  # Añadimos home-manager a los argumentos de la función
  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    # --- AÑADIDO: Bloque 'let' para variables ---
    let
      system = "x86_64-linux"; # Ajustar si es necesario
      # Necesitamos 'lib' para nixosSystem
      lib = nixpkgs.lib;
      # Definimos usuario y hostname (¡verifica que sean correctos!)
      myUsername = "ccaverotx";
      myHostname = "nixos";
      nixosConfigModule = import ./nixos/configuration.nix;
    in {
    # --- FIN AÑADIDO ---
      nixosConfigurations = {
        # Usamos la variable myHostname para el nombre
        ${myHostname} = lib.nixosSystem { # Usamos lib.nixosSystem
          inherit system; # Pasamos la variable system

          # --- AÑADIDO: Argumentos especiales ---
          # Pasan inputs y variables a los módulos
          specialArgs = { inherit inputs myUsername; };
          # --- FIN AÑADIDO ---

          modules = [
            # Tu configuration.nix (en la raíz del flake)
            nixosConfigModule

            # --- AÑADIDO: Integración de Home Manager ---
            home-manager.nixosModules.home-manager
            {
              # Configuración global de la integración
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # Pasar argumentos también a los módulos de HM
              home-manager.extraSpecialArgs = { inherit inputs myUsername; };
              # Configuración específica para tu usuario
              home-manager.users.${myUsername} = {
                imports = [
                  # Tu archivo de configuración de Home Manager
                  # Debe estar en la raíz del flake: ~/nixos-config/home.nix
                  ./home-manager/home.nix
                ];
              };
            }
            # --- FIN AÑADIDO ---
          ];
        };
      };
    };
}
