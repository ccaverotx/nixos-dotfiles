# ~/nixos-config/home-manager/kate.nix
# Configuración declarativa para el editor Kate.
# Utiliza el módulo 'programs.kate' extendido por 'plasma-manager'.
{ pkgs, ... }: # Se asume que pkgs se pasa correctamente desde la configuración principal de HM

{
  programs.kate = {
    # Habilita la gestión de Kate a través de este módulo de Home Manager.
    enable = true;

    # --- Opciones Generales del Editor ---
    editor = {

      # Define el ancho visual (en número de espacios) de un carácter de tabulación.
      tabWidth = 2;

      # --- Configuración de la Indentación ---
      indent = {
        # Ancho de cada nivel de indentación, medido en espacios.
        width = 2;
        # Si es 'true', reemplaza automáticamente los caracteres de tabulación por espacios.
        replaceWithSpaces = true;
        # Muestra líneas verticales como guía visual para cada nivel de indentación.
        showLines = true;
        # Intenta detectar automáticamente el estilo de indentación del archivo al abrirlo.
        autodetect = true;
        # Si es 'false', elimina los espacios extra que no forman parte de un nivel de indentación estándar.
        keepExtraSpaces = false;
        # Permite desindentar la línea actual o seleccionada usando Shift+Tab.
        undoByShiftTab = true;
        # Si es 'false', la tecla Tab solo indenta si el cursor está al principio de la línea (o en espacios en blanco).
        tabFromEverywhere = false;
        # Podrías habilitar otras opciones del módulo aquí si las necesitaras, como:
        # autoIndent = true; # Indentar automáticamente al presionar Enter.
        # backspaceDecreaseIndent = true; # Hacer que Backspace desindente un nivel.
      }; # --- Fin Indentación ---

      # --- Fuente del Editor ---
      font = {
        # Nombre de la familia de fuente a utilizar.
        family = "Fixed";
        # Tamaño de la fuente en puntos. Mutuamente excluyente con 'pixelSize'.
        pointSize = 11;

        # --- Atributos de Fuente Adicionales (mostrados con sus valores por defecto del módulo) ---
        # Puedes descomentar y cambiar los que necesites ajustar.

        # Tamaño exacto en píxeles (usualmente se prefiere pointSize).
        # pixelSize = null;

        # Pista sobre el tipo general de fuente para el sistema de renderizado.
        # Valores comunes: "anyStyle", "sansSerif", "serif", "monospace".
        # styleHint = "anyStyle";

        # Peso (grosor) de la fuente. Puede ser un nombre o un número (1-1000).
        # Nombres: "thin", "extraLight", "light", "normal", "medium", "demiBold", "bold", "extraBold", "black".
        # weight = "normal";

        # Estilo de la fuente. Opciones: "normal", "italic", "oblique".
        # style = "normal";

        # Subrayar el texto.
        # underline = false;

        # Tachar el texto.
        # strikeOut = false;

        # Forzar el tratamiento como fuente de ancho fijo (monoespaciada).
        # fixedPitch = false;

        # Forzar una capitalización específica.
        # Opciones: "mixedCase", "allUppercase", "allLowercase", "smallCaps", "capitalise".
        # capitalization = "mixedCase";

        # Unidad para el espaciado entre letras ('percentage' o 'absolute').
        # letterSpacingType = "percentage";

        # Cantidad de espaciado entre letras (positivo o negativo).
        # letterSpacing = 0;

        # Cantidad de espaciado entre palabras (en píxeles).
        # wordSpacing = 0;

        # Factor de estiramiento o condensación de la fuente.
        # Puede ser un número (100=normal) o un nombre (ej: "condensed", "expanded").
        # stretch = "anyStretch";

        # Nombre de estilo específico que sobrescribe 'weight' y 'style' (para fuentes complejas).
        # styleName = null;

        # Estrategia detallada de renderizado y selección de fuentes.
        # styleStrategy = {
        #   prefer = "default";
        #   matchingPrefer = "default";
        #   antialiasing = "default";
        #   noSubpixelAntialias = false;
        #   noFontMerging = false;
        #   preferNoShaping = false;
        # };
      }; # --- Fin Fuente ---

      # --- Configuración de Brackets (Paréntesis, Corchetes, etc.) ---
      brackets = {
        # Inserta automáticamente el bracket/paréntesis/corchete de cierre al escribir el de apertura.
        automaticallyAddClosing = true;
        # Resalta visualmente el bracket correspondiente al que está junto al cursor.
        highlightMatching = true;
        # Hace que el bracket correspondiente "parpadee" brevemente al mover el cursor a su lado.
        flashMatching = false;
        # Define qué caracteres se consideran "brackets" para las funciones anteriores.
        characters = "<>(){}[]'\"`";
      }; # --- Fin Brackets ---

      # --- Modo de Entrada del Editor ---
      # Define el comportamiento del teclado (similar a Vim o Emacs).
      # Opciones: "normal", "vi".
      inputMode = "normal";

      # --- Tema de Resaltado de Sintaxis ---
      theme = {
        # Nombre del tema de color para el código (debe estar instalado).
        name = "Breeze Dark";
        # Si quisieras usar un archivo .theme personalizado:
        # src = ./ruta/a/tu/tema.theme; # Esto lo copiaría e instalaría.
      }; # --- Fin Tema ---

    }; # --- Fin Editor ---

    # --- Configuración del Servidor de Lenguaje (LSP) ---
    lsp = {
      # Define servidores LSP personalizados. Kate los usará automáticamente
      # para los lenguajes especificados si el plugin LSP Client está activo.
      customServers = {
        # Configuración para 'nil', el LSP para el lenguaje Nix.
        nix = {
          # Comando para ejecutar el servidor. Usa la ruta del paquete Nix.
          # ¡Recuerda añadir 'pkgs.nil' a 'home.packages' en tu home.nix!
          command = [ "${pkgs.nil}/bin/nil" ];
          # Lista de identificadores de lenguaje para los que se usará este servidor.
          languages = [ "nix" ];
          # Configuraciones adicionales específicas para 'nil' (si son necesarias).
          # settings = {};
        };
        # Ejemplo para Python (necesitarías instalar python-lsp-server):
        # python = {
        #   command = [ "${pkgs.python3Packages.python-lsp-server}/bin/pylsp" ];
        #   languages = [ "python" ];
        # };
      }; # --- Fin customServers ---
    }; # --- Fin LSP ---

  }; # --- Fin programs.kate ---
}
