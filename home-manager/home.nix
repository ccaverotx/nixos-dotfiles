# ~/nixos-config/home.nix
{ config, pkgs, inputs, lib, myUsername, ... }:

{
  # ¡Importante! Establece la versión de estado.
  # Usa la versión estable sobre la que basas tu configuración
  # o la última estable si usas unstable. Ej: "24.05" o "23.11"
  home.stateVersion = "24.05"; # ¡Ajusta si es necesario!

  # Necesario para que Home Manager funcione
  home.username = myUsername; # Usa la variable pasada desde el flake
  home.homeDirectory = "/home/${myUsername}";

  # --- Paquetes de Usuario ---
  # Aquí puedes empezar a listar los paquetes que quieres instalar
  # solo para tu usuario (ej: navegadores, herramientas dev, juegos...).
  home.packages = with pkgs; [
    firefox # Ejemplo
    htop    # Ejemplo
    kdePackages.kate
    zoom-us
    # Añade más paquetes aquí
  ];

  # --- Configuración de Programas ---
  # Ejemplo: configurar Git
  programs.git = {
    enable = true;
    userName = "ccaverotx"; # ¡Cambia esto!
    userEmail = "ccaverotx@gmail.com";
  };

  # --- AÑADIDO: Configuración de Plasma Manager ---
  programs.plasma = {
    # Aquí es donde usarás las opciones documentadas en
    # https://github.com/nix-community/plasma-manager

    # Puedes empezar vacío o con algo simple:
    enable = true; # Algunos módulos de HM requieren un enable explícito

    # Ejemplo MUY básico (revisar opciones exactas en la documentación):
    # workspace = {
    #   theme = "Breeze Dark"; # Nombre interno del Look & Feel global
    #   colorScheme = "Breeze Dark";
    #   iconTheme = "breeze-dark";
    # };

    # Ejemplo usando el módulo 'files' para kdeglobals (más bajo nivel)
    # files."kdeglobals"."Icons"."Theme".value = "breeze-dark";

  };
  # --- FIN AÑADIDO ---

  # Aquí añadirás más configuraciones de Home Manager más adelante...
  # (dotfiles, variables de entorno, otros programas, etc.)

}
