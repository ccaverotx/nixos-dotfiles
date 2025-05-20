{ lib, pkgs, config, inputs, ... }:

let
  cornerRadiusValue = 10;
  krohnkiteSettings = import ./kwin-plugins/krohnkite.nix { inherit lib; };
in
{
  home.packages = [
    pkgs.kdePackages.krohnkite
    inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
    pkgs.kde-rounded-corners
  ];

  programs.plasma = {
    configFile = {
      "kwinrc" = {
        Plugins = {
          krohnkiteEnabled = true;
          blurEnabled = false;
          forceblurEnabled = true;
          kwin4_effect_shapecornersEnabled = true;
        };

        "Script-krohnkite" = krohnkiteSettings;

        Desktops = {
          Number = 4;
          Rows = 1;
          Name_1 = "🌍 General";
          Name_2 = "💻 Desarrollo";
          Name_3 = "🌐 Navegador";
          Name_4 = "💬 Comunicación";
        };

        MaximizeTile = {
          DisableOutlineTile = false;
        };

        PrimaryOutline = {
          ActiveOutlineUseCustom = false;
          ActiveOutlineUsePalette = true;
          InactiveOutlineAlpha = 200;
          InactiveOutlineUseCustom = false;
          InactiveOutlineUsePalette = true;
        };

        "Effect-kwin4_effect_shapecorners" = {
          AnimationEnabled = false;
          InactiveCornerRadius = cornerRadiusValue;
          InactiveShadowSize = 40;
          ShadowSize = 40;
          Size = cornerRadiusValue;
          DisableOnTile = false;
          DisableOnMaximize = false;
        };

        SecondOutline = {
          InactiveSecondOutlineThickness = 0;
          SecondOutlineThickness = 0;
        };

        Shadow = {
          ActiveShadowUseCustom = true;
          ActiveShadowUsePalette = false;
          InactiveShadowUseCustom = true;
          InactiveShadowUsePalette = false;
        };

        Windows = {
          SeparateScreenFocus = true;
        };
      };

      "breezerc" = {
        "Windeco Exception 0" = {
          Enabled = true;
          ExceptionType = 0;
          ExceptionPattern = ".*";
          HideTitleBar = true;
        };
      };
    };

    shortcuts = {
      kwin = {
        KrohnkiteFocusDown = "Ctrl+Shift+S";
        KrohnkiteFocusLeft = "Ctrl+Shift+A";
        KrohnkiteFocusRight = "Ctrl+Shift+D";
        KrohnkiteFocusUp = "Ctrl+Shift+W";
        KrohnkiteStackedLayout = "Ctrl+Alt+S";
        KrohnkiteSpiralLayout = "Ctrl+Alt+A";
        "Switch to Desktop 1" = "Ctrl+1";
        "Switch to Desktop 2" = "Ctrl+2";
        "Switch to Desktop 3" = "Ctrl+3";
        "Switch to Desktop 4" = "Ctrl+4";
        "Window to Desktop 1" = "Ctrl+Alt+1";
        "Window to Desktop 2" = "Ctrl+Alt+2";
        "Window to Desktop 3" = "Ctrl+Alt+3";
        "Window to Desktop 4" = "Ctrl+Alt+4";
      };
    };
  };
}
