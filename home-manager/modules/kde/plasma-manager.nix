# ~/nixos-config/home-manager/modules/plasma.nix
# Módulo principal para la configuración de Plasma. Importa submódulos.
{ config, pkgs, lib, ... }:

{
  # Importa los módulos específicos de Plasma que has creado
  imports = [
    ./plasma-panel.nix  # Importa la configuración de paneles y widgets
    # ./plasma-theme.nix  # Podrías crear uno para temas/workspace
    # ./plasma-shortcuts.nix # Podrías crear uno para atajos
  ];

  # Aquí pones la configuración general de 'programs.plasma'
  programs.plasma = {
    # Habilita el módulo principal de plasma-manager (proporcionado por su import en flake.nix)
    enable = true;

    # Ejemplo: Configuración de workspace (Apariencia General)
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      colorScheme = "Breeze Dark";
    };

    # La configuración de 'panels' viene del import de ./plasma-panel.nix
    # La configuración de 'kwin' viene del import de ./kwin.nix (hecho en home.nix)
    # La configuración de 'shortcuts' podría venir de ./plasma-shortcuts.nix

  }; # Fin programs.plasma
}
