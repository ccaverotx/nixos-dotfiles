# ~/nixos-config/home-manager/kate.nix
{ config, pkgs, lib, ... }:

{
  # Configuración usando el módulo programs.kate extendido/proporcionado por plasma-manager
  programs.kate = {
    enable = true; # Habilita el módulo de Kate de plasma-manager

    # --- Opciones del Editor (programs.kate.editor.*) ---
    editor = {
      tabWidth = 2; # Ancho visual del tabulador
      indent = {
        width = 2;                # Ancho del nivel de indentación
        replaceWithSpaces = true; # ¡Importante: Usar espacios en lugar de tabs!
        showLines = true;         # Mostrar líneas verticales de indentación
        # undoByShiftTab = true; # Ya es el default en el módulo
        # tabFromEverywhere = false; # Ya es el default
        # backspaceDecreaseIndent = true; # Ya es el default
        # autodetect = true; # Ya es el default
      };
      font = {
         # Familia de fuente preferida
         family = "JetBrains Mono";
         # Tamaño en puntos
         pointSize = 12;
         # Otros atributos de fuente si los necesitas (weight, style, etc.)
         # weight = "medium";
         # style = "normal";
      };
      brackets = {
         # Añadir paréntesis/corchetes de cierre automáticamente
         automaticallyAddClosing = true;
         # Resaltar el bracket correspondiente
         highlightMatching = true;
         # Puedes cambiar los caracteres considerados brackets si quieres
         # characters = "<>(){}[]'\"`"; # Default
      };
      # inputMode = "normal"; # Opciones: "normal", "vi"
      theme = {
         # Nombre del tema de resaltado de sintaxis del editor
         # Usa un nombre de tema existente en el sistema (ej. los de KDE)
         name = "Breeze Dark";

         # Opcional: Si tienes un archivo .theme personalizado, pon la ruta aquí.
         # Esto lo copiará a la ubicación correcta y establecerá 'name' automáticamente.
         # src = ./ruta/relativa/a/mi/tema_kate.theme;
      };
    };

    # --- Opciones de UI (programs.kate.ui.*) ---
    # ui = {
    #   # Puedes forzar un esquema de color para la interfaz de Kate
    #   # distinto al del sistema si quieres (ej. "BreezeDark")
    #   colorScheme = "BreezeDark";
    # };

    # --- Opciones LSP (programs.kate.lsp.*) ---
    # ¡Esto te permite configurar servidores LSP declarativamente!
    lsp.customServers = {
       # Ejemplo para configurar 'nil' (Nix Language Server)
       # Asegúrate de tener 'nil' en home.packages en tu home.nix principal
       nix = {
         command = [ "${pkgs.nil}/bin/nil" ]; # Ruta al ejecutable de nil
         languages = [ "nix" ];               # Activar para archivos .nix
         # settings = {}; # Configuraciones específicas para nil si las necesitas
       };

       # Ejemplo para Python (necesitarías añadir python3Packages.python-lsp-server a home.packages)
       # python = {
       #   command = [ "${pkgs.python3Packages.python-lsp-server}/bin/pylsp" ];
       #   languages = [ "python" ];
       # };
    };

    # --- Paquete Kate (Opcional - programs.kate.package) ---
    # Por defecto, en Plasma 6 usará pkgs.kdePackages.kate.
    # Puedes cambiarlo si es necesario, por ejemplo, para forzar la versión Qt5:
    # package = pkgs.libsForQt5.kate;
  }; # Fin de programs.kate
}
