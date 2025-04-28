# ~/nixos-config/home-manager/plasma.nix
{ config, pkgs, lib, inputs, myUsername, ... }: # Recibe los mismos args que home.nix

{
  # --- Configuración de Plasma usando el módulo integrado de Home Manager ---
  programs.plasma = {
    enable = true; # Habilita la gestión declarativa de Plasma

    # --- AQUÍ ES DONDE AÑADIRÁS TODA TU CONFIGURACIÓN DE PLASMA ---
    # Consulta las opciones en:
    # https://nix-community.github.io/home-manager/options.html#opt-programs.plasma.enable

    # Ejemplos básicos (descomenta y adapta):

    # -- Apariencia General --
    workspace = {
      # clickItemTo = "open"; # If you liked the click-to-open default from plasma 5
      lookAndFeel = "org.kde.breezedark.desktop";
      #iconTheme = "Papirus-Dark";
      #wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";
    };
    # ksplash.theme = "None"; # Deshabilitar splash screen

    # -- Fondos y Escritorio --
    # workspace.wallpaper.image = "/ruta/absoluta/a/tu/fondo.jpg"; # O usa paquetes: "${pkgs.plasma5Packages.plasma-wallpaper-dynamic}/share/wallpapers/Dynamic"
    # workspace.wallpaper.sourceDir = "~/Imágenes/Fondos"; # Directorio para fondos de pantalla de presentación
    # workspace.containments.desktop.appletsrc.Configuration.General.positions = "..."; # Config avanzada de iconos/widgets

    # -- Atajos (KGlobalAccel) --
    # shortcuts = {
    #   "KWin" = {
    #     "Switch to Desktop 1" = "Meta+1";
    #     "Switch to Desktop 2" = "Meta+2";
    #   };
    #   "plasmashell" = {
    #     "activate task manager entry 1" = "Meta+Z";
    #   };
    # };

    # -- KWin (Gestor de ventanas) --
    # kwin.virtualDesktops.number = 4;
    # kwin.virtualDesktops.rows = 1;
    # kwin.effect.screenedge.bottom = "DesktopGrid";

    # ... y muchas otras opciones para paneles, krunner, etc. ...

  }; # Fin de programs.plasma

  # También puedes configurar apps específicas de KDE aquí si quieres,
  # aunque podrías ponerlas en otros módulos (ej. konsole.nix)
  # programs.konsole = {
  #   enable = true;
  #   profiles.Default.terminalColumns = 100;
  #   profiles.Default.terminalRows = 30;
  # };

}
