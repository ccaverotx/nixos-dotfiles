# ./home-manager/modules/plasma-panel.nix
#
# Define las configuraciones de los paneles de Plasma y sus widgets.
# Gestiona la instalación de paquetes necesarios para widgets personalizados o de terceros.
# Este módulo es importado por tu módulo central de Plasma (`plasma-manager.nix`).

{ config, pkgs, lib, ... }: # Argumentos estándar

let
  # --- Importación/Definición de Widgets Personalizados ---

  # Importa la ESTRUCTURA de configuración para el widget 'Colorizer'.
  # Asumimos que este archivo .nix devuelve un conjunto de atributos (AttrSet)
  # listo para ser incluido en la lista `widgets` de un panel.
  # NOTA: El *paquete* que contiene el widget, `plasma-panel-colorizer`,
  # también se instala explícitamente a través de `home.packages` más abajo.
  colorizerWidget = import ./plasma-panel-widgets/plasma-panel-colorizer.nix { inherit pkgs; };

  # Define y construye el PAQUETE para un applet de título de ventana personalizado.
  # Utiliza `pkgs.callPackage` para crear una derivación de Nix desde un archivo local.
  # Este paquete necesita ser instalado para que Plasma encuentre el applet.
  windowTitleAppletPkg = pkgs.callPackage ./plasma-panel-widgets/plasma-window-title-applet.nix {};
  # El identificador de este widget al usarlo en la lista `widgets` será probablemente 'org.kde.windowtitle'.

in
{
  # --- Paquetes Necesarios para los Widgets ---
  # Lista de paquetes que deben estar instalados para que los widgets
  # definidos en *cualquier* panel de este archivo funcionen correctamente.
  home.packages = with pkgs; [
    # Paquete que proporciona el widget Colorizer.
    # (Podría ser de nixpkgs, de un overlay, o local si lo defines tú mismo).
    plasma-panel-colorizer

    # El paquete del applet de título de ventana que compilamos localmente arriba.
    # ¡Necesario para que el sistema conozca este widget!
    windowTitleAppletPkg

    # Otros paquetes de widgets si los necesitaras:
    # plasma-applet-commandoutput # Ejemplo si usaras el widget 'Command Output'.
    # lattevcs-git # Ejemplo si usaras un widget de Latte Dock.
  ];

  # --- Definición de Paneles ---
  # `programs.plasma.panels` es una lista. Cada elemento en la lista es un
  # conjunto de atributos que describe un panel.
  programs.plasma.panels = [

    # =========================================
    # --- Panel 1: Asignado a 'screen = 0' ---
    # =========================================
    #
    # Necesitas asegurarte de que `screen = 0` corresponde al monitor donde quieres este panel.
    # - Plasma internamente numera las pantallas (0, 1, 2...).
    # - Ejecuta `kscreen-doctor -o` en Konsole. Te mostrará "Output: 1 DP-1", "Output: 2 DP-2", etc.
    # - Ve a la Configuración del Sistema -> Pantalla y Monitor -> Disposición de pantallas. Identifica cuál es tu pantalla "Primaria".
    # - La pantalla marcada como "Primaria" en Plasma *suele* ser `screen = 0` para `plasma-manager`, pero NO está garantizado.
    # - La forma más segura de saberlo es probar: aplica la config y mira en qué monitor aparece el panel. Si no es el correcto, cambia el número de `screen`.
    # - Según tu info anterior, DP-2 (HP E242, vertical izq) es tu Primaria (Output 2). DP-1 (MSI, horiz der) es Output 1.
    #   Es muy posible que `screen = 0` sea DP-2 y `screen = 1` sea DP-1. ¡Confírmalo!
    {
      screen = 0; # ID numérico de la pantalla (¡VERIFICAR!)

      # --- Configuración del Panel ---
      height = 29;        # Altura en píxeles para paneles horizontales (o ancho para verticales).
      location = "top";   # Posición: top, bottom, left, right.
      floating = false;   # ¿Panel flotante? (true/false).
      # alignment = "center"; # Para paneles más cortos que el borde de la pantalla.

      # --- Widgets de este Panel (en orden) ---
      widgets = [
        # 1. Lanzador de Aplicaciones Kickoff (icono Nix).
        { kickoff.icon = "nix-snowflake"; }

        # 2. Applet Título de Ventana (usa `windowTitleAppletPkg`).
        {
          name = "org.kde.windowtitle"; # ID del widget.
          config.General = {           # Configuración específica del widget.
             capitalFont = false;
             filterActivityInfo = false;
             useActivityIcon = false;
          };
        }

        # 3. Menú Global de Aplicación.
        "org.kde.plasma.appmenu" # Nombre estándar del widget.

        # 4. Espaciador (útil para empujar widgets a los extremos).
        "org.kde.plasma.panelspacer"

        # 5. Bandeja del Sistema (Configuración detallada).
        {
          systemTray.items = {
            hidden = [ # Lista de IDs de elementos a ocultar siempre.
              "Clementine" "org.kde.kscreen" "org.kde.kdeconnect"
              "org.kde.plasma.brightness" "org.kde.plasma.cameraindicator"
              "org.kde.plasma.clipboard" "org.kde.plasma.keyboardlayout"
              "org.kde.plasma.keyboardindicator" "org.kde.plasma.manage-inputmethod"
              "org.kde.plasma.mediacontroller" "vmware-tray" "Yakuake"
            ];
            shown = [ # Lista de IDs de elementos a mostrar siempre (si están activos).
              "org.kde.plasma.battery" "org.kde.plasma.volume"
              "org.kde.plasma.networkmanagement"
            ];
          };
        }

        # 6. Reloj Digital (Configuración de formato).
        {
          digitalClock = {
            date.enable = false;        # No mostrar fecha.
            time.showSeconds = "always"; # Mostrar segundos siempre.
          };
        }

        # 7. Widget Colorizer (usando la estructura importada).
        colorizerWidget

      ]; # Fin lista `widgets` para screen = 0.
    } # Fin definición panel screen = 0.


    # =========================================
    # --- Panel 2: Asignado a 'screen = 1' ---
    # =========================================
    # Asumiendo que screen = 1 es tu monitor secundario (MSI / DP-1).
    {
      screen = 1; # ID numérico de la pantalla

      # --- Configuración del Panel ---
      height = 29;        # Altura en píxeles para paneles horizontales (o ancho para verticales).
      # Si quieres un panel aquí, comenta esta línea y descomenta/adapta uno de los ejemplos.
      widgets = [
        "org.kde.plasma.pager"
      ];

      # --- EJEMPLO C: Dock vertical izquierdo simple ---
      # location = "left";
      # height = 48; # Controla el ANCHO del panel vertical
      # alignment = "center"; # Alineación de los widgets dentro del panel
      # widgets = [
      #   "org.kde.plasma.kickoff",     # Lanzador
      #   "org.kde.plasma.icontasks", # Gestor de tareas (solo iconos)
      #   "org.kde.plasma.showdesktop",# Botón Mostrar escritorio
      #   "org.kde.plasma.trash",     # Papelera
      # ];

    } # Fin definición panel screen = 1.

    # --- Otros Paneles ---
    # Si tuvieras un tercer monitor (screen = 2), añadirías otro bloque similar aquí.

  ]; # Fin lista `programs.plasma.panels`.
}
