# ~/nixos-config/home-manager/modules/Kwin Modules/kwin.nix
# Instala Krohnkite, lo habilita e importa su configuración detallada.
{ lib, pkgs, config, ... }:

let
  # Importamos la configuración detallada desde el archivo vecino krohnkite.nix
  # Le pasamos 'lib' porque lo necesita.
  krohnkiteSettings = import ./kwin-plugins/krohnkite.nix { inherit lib; };
in
{
  # 1. Instala el paquete Krohnkite
  home.packages = [ pkgs.kdePackages.krohnkite ];

  # 2. Configura kwinrc usando plasma.files
  programs.plasma.configFile."kwinrc" = { # <-- CAMBIO AQUÍ: programs.plasma.configFile

    # Grupo [Plugins]: Habilita el script Krohnkite
    Plugins = {
      krohnkiteEnabled = true;
    };

    # --- USA LA CONFIGURACIÓN IMPORTADA ---
    # Asigna el contenido importado de krohnkite.nix al grupo [Script-krohnkite]
    "Script-krohnkite" = krohnkiteSettings;

  }; # Fin plasma.files."kwinrc"
}
