# ~/nixos-config/home-manager/modules/plasma-panel-widgets/plasma-panel-colorizer.nix
# Devuelve el atributo que representa este widget para la lista 'widgets' del panel
{ pkgs, ... }:

{
  # Nombre interno del widget
  name = "luisbocanegra.panel.colorizer";
  # Configuración específica del widget (va bajo la clave 'config')
  config.General = {
    colorMode = "1";
    colorModeTheme = "9";
    enableCustomPadding = "true";
    fgColorMode = "1";
    fgContrastFixEnabled = "false";
    fgLightness = "0.55";
    hideWidget = "true";
    marginRules = "org.kde.plasma.kickoff,1,0|org.kde.windowtitle,1,0|plasmusic-toolbar,0,-15";
    panelPadding = "16";
    panelRealBgOpacity = "0.5";
    panelSpacing = "10";
    radius = "7";
    widgetBgEnabled = "false";
    widgetBgVMargin = "3";
  };
}
