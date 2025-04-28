# ~/nixos-config/home-manager/modules/Kwin Modules/krohnkite.nix
# Define las configuraciones específicas para el script Krohnkite en kwinrc

{ lib, ... }: # Solo necesita lib de los argumentos estándar

let
  # Definimos el gap aquí para este bloque de configuración
  tilingGap = 15;
in
{
  # Este bloque corresponde al grupo [Script-krohnkite] en kwinrc

  # --- Layouts ---
  enableBTreeLayout = true;
  enableColumnsLayout = false;
  enableMonocleLayout = false;
  enableSpiralLayout = false;
  enableSpreadLayout = false;
  enableStairLayout = false;
  enableThreeColumnLayout = false;
  enableTileLayout = true; # Layout Tile activado

  # --- Ventanas Ignoradas ---
  # Clases de ventana (WM_CLASS) a ignorar
  ignoreClass = lib.concatStringsSep "," [
    "kded" "krunner" "ksshaskpass"
    "org.freedesktop.impl.portal.desktop.kde" "org.kde.plasmashell"
    "org.kde.polkit-kde-authentication-agent-1" "qalculate-qt"
    "spectacle" "xwaylandvideobridge" "yakuake"
  ];
  # Títulos de ventana a ignorar
  ignoreTitle = lib.concatStringsSep "," [
     "Configure — System Settings" "KDE Wayland Compositor"
  ];

  # --- Otros Ajustes ---
  monocleMaximize = false;
  screenGapBottom = tilingGap;
  screenGapLeft = tilingGap;
  screenGapRight = tilingGap;
  screenGapTop = tilingGap;
  tileLayoutGap = tilingGap; # Gap entre ventanas en modo Tile
}
