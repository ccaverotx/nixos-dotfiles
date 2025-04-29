# ./home-manager/modules/Kwin Modules/kwin.nix
# Configura KWin y decoraciones Breeze: habilita plugins, define escritorios virtuales,
# y elimina las barras de título de las ventanas.
{ lib, pkgs, config, inputs, ... }:

let
  krohnkiteSettings = import ./kwin-plugins/krohnkite.nix { inherit lib; };
  blurModule = import ./kwin-plugins/blur.nix;
in
{
  imports = [ blurModule ];

  # 1. Paquetes necesarios.
  home.packages = [
    pkgs.kdePackages.krohnkite
    inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
  ];

  # 2. Configura archivos kwinrc y breezerc directamente.
  #    `programs.plasma.configFile` es un conjunto de atributos donde cada
  #    clave es el nombre del archivo (relativo a ~/.config/) y el valor
  #    es la estructura INI deseada para ese archivo.
  programs.plasma.configFile = {

    # --- Archivo: kwinrc ---
    "kwinrc" = {
      # Grupo [Plugins]
      Plugins = {
        krohnkiteEnabled = true;
        blurEnabled = false;
        forceblurEnabled = true;
      };
      # Grupo [Script-krohnkite]
      "Script-krohnkite" = krohnkiteSettings;
      # Grupo [Desktops]
      Desktops = {
        Number = 4;
        Rows = 1;
        Name_1 = "🌍 General";
        Name_2 = "💻 Desarrollo";
        Name_3 = "🌐 Navegador";
        Name_4 = "💬 Comunicación";
      };
      # Otros grupos kwinrc...
      # Windows = { BorderlessMaximizedWindows = true; };
    }; # Fin "kwinrc"


    # --- Archivo: breezerc --- (AÑADIDO PARA OCULTAR TÍTULOS)
    "breezerc" = {
      # Define excepciones a las reglas de decoración del tema Breeze.
      # Vamos a añadir una regla (#0) que se aplique a todas las ventanas.
      "Windeco Exception 0" = {
        Enabled = true;          # Habilitar esta regla de excepción.
        ExceptionType = 0;       # Tipo 0 = Coincidencia por Clase de Ventana (usando RegExp).
        ExceptionPattern = ".*"; # RegExp: "." (cualquier carácter), "*" (cero o más veces) -> Coincide con TODO.
        HideTitleBar = true;     # ¡La acción! Ocultar la barra de título para las ventanas que coincidan.

        # NOTA sobre sintaxis: Usamos `Clave = Valor;`. Si por alguna razón esto no aplicara
        # la configuración, el siguiente intento sería probar `Clave.value = Valor;`,
        # pero el formato estándar INI es más probable que funcione con `configFile`.
      };
      # Puedes añadir más excepciones numeradas ("Windeco Exception 1", etc.)
      # para aplicar reglas diferentes a ventanas específicas si lo necesitas.
    }; # Fin "breezerc"

  }; # Fin programs.plasma.configFile
}
