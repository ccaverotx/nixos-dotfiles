{
  # Descripción general de la configuración de Nix.
  # Puedes mantener la tuya o usar esta sugerencia más descriptiva.
  description = "Configuracion de NixOS con Flakes :D";

  # --- INPUTS ---
  # Define las dependencias externas (fuentes de software/configuración) de este flake.
  inputs = {
    # Nixpkgs: La colección principal de paquetes y módulos de NixOS.
    # Se utiliza la rama 'nixos-unstable' a través del registro de Nix (una forma corta y estándar).
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # Home Manager: Herramienta para gestionar la configuración del entorno de usuario ('dotfiles').
    home-manager = {
      url = "github:nix-community/home-manager";
      # 'follows' asegura que Home Manager use exactamente la misma versión de nixpkgs
      # que el resto del sistema. Esto es crucial para evitar conflictos.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Dependencia externa para un efecto de KWin personalizado (Force Blur).
    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      # También debe seguir la versión de nixpkgs para compatibilidad.
      inputs.nixpkgs.follows = "nixpkgs";
      # Nota: Este input no se usa directamente en las 'outputs' de este flake,
      # sino que probablemente se referencia dentro de ./nixos/configuration.nix
      # o ./home-manager/home.nix para instalar o configurar el efecto.
    };

    # Plasma Manager: Herramienta para gestionar configuraciones específicas de KDE Plasma.
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      # Asegura que use las mismas versiones de nixpkgs y home-manager que el resto del sistema.
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  # --- OUTPUTS ---
  # Define lo que este flake proporciona al exterior (configuraciones, paquetes, etc.).
  outputs = { self, nixpkgs, home-manager, ... }@inputs: # '@inputs' captura todos los inputs definidos arriba.
    let
      # --- Variables Locales ---
      # Define variables reutilizables dentro de las 'outputs'.

      # Sistema operativo y arquitectura destino. Hardcoded para simplificar.
      # Si necesitaras soportar múltiples sistemas (ej. aarch64-linux),
      # podrías usar herramientas como 'flake-utils'.
      system = "x86_64-linux";

      # Alias conveniente para acceder a las funciones de utilidad de nixpkgs (lib.*).
      lib = nixpkgs.lib;

      # Variables de configuración personal. Centralizar estos valores aquí es útil.
      myUsername = "ccaverotx"; # Tu nombre de usuario principal.
      myHostname = "nixos";     # El nombre de host de esta máquina específica.

      # --- Importación de Módulos Principales ---
      # Importa los archivos principales de configuración para NixOS y Home Manager.
      # Es una buena práctica separar las configuraciones en archivos/directorios dedicados.

      # Carga la configuración principal de NixOS.
      # Se asume que existe en ./nixos/configuration.nix relativo a este flake.nix
      nixosConfigModule = import ./nixos/configuration.nix;

      # Carga la configuración principal de Home Manager.
      # Se asume que existe en ./home-manager/home.nix relativo a este flake.nix
      homeConfigModule = import ./home-manager/home.nix;

    in {
      # --- Configuraciones de NixOS ---
      # Define una o más configuraciones completas del sistema operativo.
      nixosConfigurations = {
        # La clave aquí es el nombre de host ('nixos'). Al construir, harías 'nixos-rebuild switch --flake .#nixos'.
        ${myHostname} = lib.nixosSystem {
          inherit system; # Especifica la arquitectura para esta configuración.

          # Argumentos especiales ('specialArgs') que se pasan a todos los módulos de NixOS.
          # Muy útil para que los módulos (como configuration.nix) puedan acceder a los 'inputs'
          # del flake (ej. inputs.kwin-effects-forceblur) y a variables personalizadas.
          specialArgs = { inherit inputs myUsername system; }; # Pasamos 'inputs', 'myUsername', 'system'.

          # Lista de módulos que componen la configuración final de este sistema NixOS.
          # El orden puede ser relevante si hay definiciones conflictivas.
          modules = [
            # 1. El módulo principal importado que contiene el grueso de tu config de NixOS.
            nixosConfigModule

            # 2. El módulo de NixOS proporcionado por Home Manager.
            #    Esto integra Home Manager en el proceso de construcción del sistema.
            home-manager.nixosModules.home-manager

            # 3. Un módulo inline para configurar Home Manager a nivel de sistema.
            {
              home-manager = {
                # Opciones globales de Home Manager:
                useGlobalPkgs = true; # Permite a HM usar paquetes definidos en 'environment.systemPackages'.
                useUserPackages = true; # Permite a HM instalar paquetes en el perfil del usuario.

                # Argumentos especiales ('extraSpecialArgs') pasados a todos los módulos de Home Manager.
                # Análogo a 'specialArgs' de NixOS, permite acceder a 'inputs' en tu 'home.nix'.
                extraSpecialArgs = { inherit inputs myUsername system; };

                # Define las configuraciones para usuarios específicos gestionados por Home Manager.
                users.${myUsername} = {
                  # Lista de módulos que componen la configuración de Home Manager para este usuario.
                  imports = [
                    # a) El módulo principal importado que contiene tu config de Home Manager.
                    homeConfigModule

                    # b) El módulo de Home Manager proporcionado por 'plasma-manager'.
                    #    Esto te permite usar las opciones de 'plasma-manager' dentro de tu 'home.nix'
                    #    para configurar KDE Plasma de forma declarativa.
                    inputs.plasma-manager.homeManagerModules.plasma-manager
                  ];
                }; # Fin users.${myUsername}
              }; # Fin home-manager config
            } # Fin del módulo inline de Home Manager
          ]; # Fin de la lista 'modules' de NixOS
        }; # Fin de lib.nixosSystem para ${myHostname}
      }; # Fin de nixosConfigurations

      # --- (Opcional) Otras Salidas del Flake ---
      # Podrías exponer otras cosas desde tu flake si lo necesitaras, por ejemplo:
      #
      # homeConfigurations = {
      #   # Para gestionar home-manager independientemente de NixOS
      #   "${myUsername}@${myHostname}" = home-manager.lib.homeManagerConfiguration { ... };
      # };
      #
      # packages.${system} = {
      #   # Paquetes personalizados definidos localmente
      #   my-custom-package = nixpkgs.legacyPackages.${system}.callPackage ./pkgs/my-custom-package {};
      # };
      #
      # devShells.${system} = {
      #   # Entornos de desarrollo
      #   default = nixpkgs.legacyPackages.${system}.mkShell { ... };
      # };

    }; # Fin de la sección 'outputs'
}
