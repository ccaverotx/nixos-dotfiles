# ~/nixos-config/home-manager/modules/plasma-panel.nix
# Define los paneles y sus widgets, instala paquetes necesarios.
{ config, pkgs, lib, ... }:

let
  # Importamos la definición completa del widget colorizer
  colorizerWidget = import ./plasma-panel-widgets/plasma-panel-colorizer.nix { inherit pkgs; };
  # Podrías importar otros widgets complejos aquí
in
{
  # Instalar paquetes necesarios para los widgets de ESTE módulo
  home.packages = with pkgs; [
    plasma-panel-colorizer     # Para el widget importado 'colorizerWidget'
    #plasma-window-title-applet # Para el widget 'org.kde.windowtitle' definido abajo
    # plasma-applet-commandoutput # Si descomentas el widget Command Output
  ];

  # Definir la opción programs.plasma.panels
  programs.plasma.panels = [
    { # Panel Superior
      height = 29;
      location = "top";
      floating = false;
      widgets = [
        # Kickoff con icono Nix
        { kickoff.icon = "nix-snowflake"; }
        # Título de ventana
        {
          name = "org.kde.windowtitle";
          config.General = { capitalFont=false; filterActivityInfo=false; useActivityIcon=false; };
        }
        # Menú global
        "org.kde.plasma.appmenu"
        # Espaciador
        "org.kde.plasma.panelspacer"
        # Widget Command Output (COMENTADO)
        # {
        #   name = "com.github.zren.commandoutput";
        #   config.General = { command = "${pkgs.panel-system-info}/bin/panel-system-info"; ... };
        # }
        # Bandeja de Sistema
        {
          systemTray.items = {
            hidden = [ "Clementine" "org.kde.kscreen" # ...etc
                     ];
            shown = [ "org.kde.plasma.battery" "org.kde.plasma.volume" # ...etc
                    ];
          };
        }
        # Reloj Digital
        {
          digitalClock = { date.enable = false; time.showSeconds = "always"; };
        }
        # Widget Colorizer (Importado desde el otro archivo)
        colorizerWidget
      ]; # Fin widgets
    } # Fin panel
  ]; # Fin panels

}
