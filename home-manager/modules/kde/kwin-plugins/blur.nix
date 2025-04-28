# ~/nixos-config/home-manager/modules/Kwin Modules/kwin-plugins/blur.nix
# Configuraciones detalladas para el efecto KWin 'Better Blur' (forceblur)

{ config, lib, pkgs, ... }: # Necesita lib para strings

with lib; # Para usar strings.concatStringsSep directamente
let
  # --- ¡¡DEFINE TUS PREFERENCIAS AQUÍ!! ---

  # Lista de clases de ventana donde SIEMPRE quieres blur.
  # Usa `xprop WM_CLASS` en una terminal y haz clic en una ventana para ver su clase.
  # Ejemplo: [ "dolphin" "kate" "konsole" "yakuake" ]
  forceBlurClasses = [ "konsole" "yakuake" ];

  # Radio de las esquinas redondeadas que aplica el efecto (ej. 8, 10, 15)
  cornerRadiusValue = 10;

  # Intensidad del blur principal (ej. 8, 9, 10)
  blurStrengthValue = 9;

  # Intensidad del blur cuando hay una ventana detrás (más suave, ej. 3, 4)
  lowBlurStrengthValue = 3;

  # Saturación del color en el área desenfocada (1.0 = normal)
  blurSaturationValue = 1.3;

in
{
  # --- Escribe en ~/.config/kwinbetterblurrc ---
  programs.plasma.configFile."kwinbetterblurrc" = {
    # Propiedades globales del efecto Better Blur
    "WindowRules/Global/Properties" = {
      BlurStrength.value = blurStrengthValue;
      CornerAntialiasing.value = 1; # 0=off, 1=msaa, 2=ssaa
      WindowOpacityAffectsBlur.value = false;
    };

    # Regla ForceBlur: Aplica blur a ventanas específicas siempre
    "WindowRules/ForceBlur/Conditions/0" = {
      WindowClass.value = builtins.replaceStrings [ "." ] [ "\\." ]
                          (lib.strings.concatStringsSep "|" forceBlurClasses);
      WindowType.value = "Dialog Normal Menu Toolbar Tooltip Utility";
    };
    "WindowRules/ForceBlur/Conditions/1" = { # Excepción para menús firefox
      Negate.value = "WindowType";
      WindowClass.value = "firefox";
      WindowType.value = "Menu";
    };
    "WindowRules/ForceBlur/Properties" = {
      BlurContent.value = true;
      BlurDecorations.value = true;
    };

    # Regla StaticBlur: Blur menos intensivo si no hay ventana detrás
    "WindowRules/StaticBlur/Conditions/0".HasWindowBehind.value = false;
    "WindowRules/StaticBlur/Properties".StaticBlur.value = true;

    # Regla LowBlurStrength: Blur suave si hay ventana detrás
    "WindowRules/LowBlurStrength".Priority.value = 1;
    "WindowRules/LowBlurStrength/Conditions/0".HasWindowBehind.value = true;
    "WindowRules/LowBlurStrength/Properties".BlurStrength.value = lowBlurStrengthValue;

    # Regla WindowCorners: Esquinas redondeadas para ventanas normales no maximizadas
    "WindowRules/WindowCorners/Conditions/0" = {
      Negate.value = "WindowState";
      WindowState.value = "Fullscreen Maximized";
      WindowType.value = "Normal";
    };
    "WindowRules/WindowCorners/Properties".CornerRadius.value = cornerRadiusValue;

    # Regla MenuCorners: Esquinas redondeadas para menús
    "WindowRules/MenuCorners/Conditions/0".WindowType.value = "Menu";
    "WindowRules/MenuCorners/Properties".CornerRadius.value = cornerRadiusValue; # Usa el mismo radio, o pon otro valor
  }; # Fin kwinbetterblurrc

  # --- Escribe en ~/.config/kwinrc ---
  programs.plasma.configFile."kwinrc" = {
     # Grupo [Effect-blurplus]: Ajustes relacionados
     "Effect-blurplus" = {
       ConvertSimpleConfigToRules.value = false;
       Saturation.value = blurSaturationValue;
     };
     # Nota: La activación/desactivación de plugins (forceblurEnabled, blurEnabled)
     # se hace en el archivo kwin.nix principal.
  }; # Fin kwinrc
} # Fin del módulo blur.nix
