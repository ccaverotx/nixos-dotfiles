# ./home-manager/modules/Kwin Modules/kwin.nix
# Configura KWin: plugins, escritorios virtuales, esquinas redondeadas,
# decoraciones, y ajustes multi-monitor para Krohnkite.
{ lib, pkgs, config, inputs, ... }:

let
  # --- Variable para Radio de Esquinas ---
  cornerRadiusValue = 10; # Ajusta el radio a tu gusto (ej. 8, 10, 12)

  # --- Configuraciones Importadas ---
  krohnkiteSettings = import ./kwin-plugins/krohnkite.nix { inherit lib; };
  blurModule = import ./kwin-plugins/blur.nix; # Módulo para config. de Blur/ForceBlur
in
{
  # Importa definiciones del módulo de blur.
  imports = [ blurModule ];

  # 1. Paquetes necesarios para KWin.
  home.packages = [
    pkgs.kdePackages.krohnkite                         # Script Tiling Krohnkite.
    inputs.kwin-effects-forceblur.packages.${pkgs.system}.default # Efecto ForceBlur.
    pkgs.kde-rounded-corners                           # Efecto Esquinas Redondeadas.
  ];

  # 2. Configuración principal de Plasma (archivos y atajos).
  programs.plasma = {

    # --- Configuración directa de archivos INI ---
    # Gestiona el contenido de ~/.config/kwinrc y ~/.config/breezerc
    configFile = {

      "kwinrc" = {
        # Grupo [Plugins]
        Plugins = {
          krohnkiteEnabled = true;
          blurEnabled = false;
          forceblurEnabled = true;
          kwin4_effect_shapecornersEnabled = true;
        };
        # Grupo [Script-krohnkite]
        "Script-krohnkite" = krohnkiteSettings;
        # Grupo [Desktops]
        Desktops = {
          Number = 4; Rows = 1; Name_1 = "🌍 General"; Name_2 = "💻 Desarrollo"; Name_3 = "🌐 Navegador"; Name_4 = "💬 Comunicación";
        };
        # Grupo [MaximizeTile]
        MaximizeTile = {
          DisableOutlineTile = false;
        };
        # Grupo [PrimaryOutline]
        PrimaryOutline = {
          ActiveOutlineUseCustom = false; ActiveOutlineUsePalette = true; InactiveOutlineAlpha = 200; InactiveOutlineUseCustom = false; InactiveOutlineUsePalette = true;
        };
        # Grupo [Effect-kwin4_effect_shapecorners]
        "Effect-kwin4_effect_shapecorners" = {
          AnimationEnabled = false; InactiveCornerRadius = cornerRadiusValue; InactiveShadowSize = 40; ShadowSize = 40; Size = cornerRadiusValue;
          DisableOnTile = false;
          DisableOnMaximize = false;
        };
        # Grupo [SecondOutline]
        SecondOutline = {
          InactiveSecondOutlineThickness = 0; SecondOutlineThickness = 0;
        };
        # Grupo [Shadow]
        Shadow = {
          ActiveShadowUseCustom = true; ActiveShadowUsePalette = false; InactiveShadowUseCustom = true; InactiveShadowUsePalette = false;
        };
        # Grupo [Windows]
        Windows = {
          SeparateScreenFocus = true; # IMPORTANTE para Krohnkite multi-monitor
        };
      }; # Fin "kwinrc"

      "breezerc" = {
        # Regla para ocultar barras de título en todas las ventanas.
        "Windeco Exception 0" = {
          Enabled = true; ExceptionType = 0; ExceptionPattern = ".*"; HideTitleBar = true;
        };
      }; # Fin "breezerc"

    }; # Fin configFile


    # --- Atajos Globales ---
    # Define atajos en ~/.config/kglobalshortcutsrc usando la estructura:
    # shortcuts.<componente>.<NombreAccion> = "CombinacionTeclas";
    shortcuts = {

      # --- Atajos específicos de KWin ---
      kwin = {
        # Atajos Multi-Monitor (basados en nombres verificados)
        KrohnkiteFocusDown = "Ctrl+Shift+S";
        KrohnkiteFocusLeft = "Ctrl+Shift+A";
        KrohnkiteFocusRight = "Ctrl+Shift+D";
        KrohnkiteFocusUp = "Ctrl+Shift+W";
        KrohnkiteStackedLayout = "Ctrl+Alt+S";
        KrohnkiteSpiralLayout = "Ctrl+Alt+A";
        # Otros Atajos de KWin (puedes añadir los de tu ejemplo aquí si quieres)
        "Switch to Desktop 1" = "Ctrl+1";
        "Switch to Desktop 2" = "Ctrl+2";
        "Switch to Desktop 3" = "Ctrl+3";
        "Switch to Desktop 4" = "Ctrl+4";
        "Window to Desktop 1" = "Ctrl+Alt+1";
        "Window to Desktop 2" = "Ctrl+Alt+2";
        "Window to Desktop 3" = "Ctrl+Alt+3";
        "Window to Desktop 4" = "Ctrl+Alt+4";
        # "Window Close" = "Meta+Q";
        # KrohnkiteFocusDown = "Meta+S"; # Los nombres de acciones de Krohnkite son específicos
        # KrohnkiteFocusLeft = "Meta+A";
        # ... etc ...
      }; # Fin shortcuts.kwin

      # --- Atajos de otros componentes (ejemplos del snippet que pasaste) ---
      # plasmashell = {
      #   "activate application launcher" = "none";
      #   "manage activities" = "none";
      #   # ... etc ...
      # };
      # "services/org.kde.dolphin.desktop"."_launch" = "Meta+Shift+E";
      # "services/org.kde.krunner.desktop"."_launch" = "Meta+X";
      # "services/org.kde.spectacle.desktop"."_launch" = "Print";

    }; # Fin shortcuts

    # --- Comandos Personalizados (Opcional, basado en tu ejemplo) ---
    # Si quieres definir atajos que ejecuten comandos específicos,
    # puedes usar la estructura `hotkeys.commands` como en tu ejemplo.
    # hotkeys.commands = lib.mapAttrs' (name: value: ...) shortcuts_let_binding;

  }; # Fin programs.plasma
} # Fin del módulo
