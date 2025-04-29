# ./home-manager/home.nix
#
# Archivo principal de configuración de Home Manager para el usuario ${myUsername}.
# Gestiona paquetes de usuario, dotfiles, servicios, y configuración de aplicaciones.

{ pkgs, inputs, config, lib, myUsername, system, ... }: # Argumentos disponibles

{
  # --- Importaciones de Módulos Locales ---
  # Importa archivos .nix con partes de la configuración de Home Manager.
  # Las opciones definidas en estos módulos se fusionarán.
  imports = [
    # Módulo organizativo principal para la configuración de Plasma.
    # Este archivo debería contener `programs.plasma.enable = true;`
    # y puede definir configuraciones base o importar otros submódulos (ej. plasma-panel.nix).
    # IMPORTANTE: Este es TU archivo local, no el módulo oficial del flake 'plasma-manager'.
    ./modules/kde/plasma-manager.nix  # <- Se importa tu módulo local con este nombre.

    # Módulo local para configuraciones específicas del editor Kate.
    # Debería definir opciones bajo `programs.plasma.kate.*` o `programs.kate.*`.
    ./modules/kde/kate.nix

    # Módulo local para configuraciones específicas del gestor de ventanas KWin.
    # Debería definir opciones bajo `programs.plasma.kwin.*`.
    ./modules/kde/kwin.nix

    # Otros módulos para organizar la configuración (ejemplos):
    # ./modules/terminal.nix
    # ./modules/git.nix # Podrías mover programs.git aquí.
  ];

  # --- Versión de Estado de Home Manager ---
  # Esencial para la gestión de cambios entre versiones.
  # Debe coincidir aproximadamente con la versión de nixpkgs/HM que usas.
  home.stateVersion = "24.11"; # Alineado con system.stateVersion = "24.11"

  # --- Información Básica del Usuario ---
  # Identifica al usuario y su directorio home.
  home.username = myUsername;
  home.homeDirectory = "/home/${myUsername}";

  # --- Paquetes Instalados para el Usuario ---
  # Lista de paquetes que sólo este usuario necesita.
  home.packages = with pkgs; [
    # Navegadores
    firefox
    # Utilidades CLI / Sistema
    htop
    nil
    unrar
    # Herramientas de Desarrollo
    nodejs
    nodePackages.live-server
    # Aplicaciones de Escritorio / Productividad
    kdePackages.kate # Paquete explícito (Kate)
    zoom-us          # Requiere allowUnfree=true
    obsidian
    insomnia
    onlyoffice-bin
    vesktop
    # Añadir más paquetes aquí...
  ];

  # --- Configuración de Programas Gestionados por Home Manager ---
  # Configura aplicaciones específicas de forma declarativa.

  # Configuración de Git (podría moverse a ./modules/git.nix)
  programs.git = {
    enable = true;
    userName = "Carlos Cavero"; # Tu nombre para commits
    userEmail = "ccaverotx@gmail.com"; # Tu email para commits
    # Ejemplo de configuración adicional:
    # extraConfig = {
    #   init.defaultBranch = "main";
    #   pull.rebase = false; # O true si lo prefieres
    # };
  };

  # --- Placeholders para otras configuraciones comunes ---
  # (Descomenta y adapta según necesites)

  # Gestión de Dotfiles:
  # home.file.".config/mi_app/config.toml".text = ''
  #   opcion = "valor"
  # '';
  # home.xdg.configFile."kitty/kitty.conf".source = ./terminal/kitty.conf;

  # Variables de Entorno:
  # home.sessionVariables = {
  #   EDITOR = "nvim";
  #   LANG = "es_BO.UTF-8"; # Puede complementar i18n de NixOS
  # };

  # Servicios de Usuario (Systemd):
  # systemd.user.services.mi-script-background = {
  #   Unit.Description = "Ejecuta mi script";
  #   Service.ExecStart = "${pkgs.bash}/bin/bash ${./mi-script.sh}";
  #   Install.WantedBy = [ "default.target" ];
  # };

}
