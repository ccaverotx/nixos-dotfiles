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
    # Añade más paquetes aquí
  ];

  # --- Configuración de Programas ---
  # Ejemplo: configurar Git
  programs.git = {
    enable = true;
    userName = "Tu Nombre"; # ¡Cambia esto!
    userEmail = "tu_email@example.com"; # ¡Cambia esto!
  };

  # Aquí añadirás más configuraciones de Home Manager más adelante...
  # (dotfiles, variables de entorno, otros programas, etc.)

}
