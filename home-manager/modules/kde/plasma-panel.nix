# ~/nixos-config/home-manager/modules/plasma-panel.nix
# Define los paneles y sus widgets para múltiples monitores, instala paquetes necesarios.
{ config, pkgs, lib, ... }:

let
  # Importamos la definición completa del widget colorizer
  colorizerWidget = import ./plasma-panel-widgets/plasma-panel-colorizer.nix { inherit pkgs; };
  # Podrías importar otros widgets complejos aquí si los defines en archivos separados
  # windowTitleWidget = import ./plasma-panel-widgets/window-title.nix { inherit pkgs; };
  windowTitleAppletPkg = pkgs.callPackage ./plasma-panel-widgets/plasma-window-title-applet.nix {};
in
{
  # --- Paquetes necesarios para los widgets usados en CUALQUIER panel ---
  home.packages = with pkgs; [
    plasma-panel-colorizer     # Para el widget importado 'colorizerWidget'
    windowTitleAppletPkg # Para el widget 'org.kde.windowtitle'
    # plasma-applet-commandoutput # Sigue comentado si no defines panel-system-info
  ];

  # --- Definición de Paneles (¡Ahora una lista con DOS paneles!) ---
    programs.plasma.panels = [

    # --- Panel 1: Monitor Principal (ID 0) ---
    {
      # Asignar a pantalla específica (¡Verifica tu ID con kscreen-doctor -o!)
      screen = 0; # 0 suele ser el primario

      # Configuración del panel (la que ya tenías)
      height = 29;
      location = "top";
      floating = false;
      widgets = [
        { kickoff.icon = "nix-snowflake"; } # Lanzador
        { name = "org.kde.windowtitle"; config.General = { capitalFont=false; filterActivityInfo=false; useActivityIcon=false; }; } # Título Ventana
        "org.kde.plasma.appmenu" # Menú Global
        "org.kde.plasma.panelspacer" # Espaciador
        # Widget Command Output (Comentado)
        # { name = "com.github.zren.commandoutput"; ... }
        { # Bandeja Sistema
          systemTray.items = {
            hidden = [ "Clementine" "org.kde.kscreen" "org.kde.kdeconnect" "org.kde.plasma.brightness" "org.kde.plasma.cameraindicator" "org.kde.plasma.clipboard" "org.kde.plasma.keyboardlayout" "org.kde.plasma.keyboardindicator" "org.kde.plasma.manage-inputmethod" "org.kde.plasma.mediacontroller" "vmware-tray" "Yakuake" ];
            shown = [ "org.kde.plasma.battery" "org.kde.plasma.volume" "org.kde.plasma.networkmanagement" ];
          };
        }
        { # Reloj
          digitalClock = { date.enable = false; time.showSeconds = "always"; };
        }
        colorizerWidget # Widget Colorizer importado
      ]; # Fin widgets panel 0
    } # Fin panel 0

    # --- Panel 2: Monitor Secundario (Vertical Izquierdo, ID 1) ---
    {
      # Asignar a pantalla específica (¡Verifica tu ID!)
      screen = 1;

      # --- Elige UNA de las siguientes configuraciones o crea la tuya ---

      # --- EJEMPLO A: Panel superior mínimo (solo reloj) ---
      # location = "top";
      # height = 29;
      # widgets = [
      #   "org.kde.plasma.panelspacer", # Empuja el reloj a la derecha
      #   { digitalClock = { date.enable = false; time.showSeconds = "always"; }; }
      # ];

      # --- EJEMPLO B: Sin panel en este monitor ---
      # La forma más simple: simplemente define el screen y una lista vacía de widgets.
      widgets = [ ];

      # --- EJEMPLO C: Dock vertical izquierdo simple ---
      # location = "left";
      # height = 48; # Controla el ANCHO del panel vertical
      # alignment = "center";
      # widgets = [
      #   "org.kde.plasma.kickoff",       # Lanzador
      #   "org.kde.plasma.icontasks",   # Gestor de tareas (iconos)
      #   "org.kde.plasma.showdesktop", # Mostrar escritorio
      #   "org.kde.plasma.trash",       # Papelera
      # ];

    } # Fin panel 1

    # Si tuvieras un tercer monitor (ej. ID 2), añadirías otro bloque {...}

  ]; # Fin lista de panels
 # Fin lista de panels
}
