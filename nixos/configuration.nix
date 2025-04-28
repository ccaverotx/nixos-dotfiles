# ./nixos/configuration.nix
#
# Archivo principal de configuración del sistema NixOS.
# Importa la configuración específica del hardware y módulos de funcionalidades.

# --- Argumentos Recibidos ---
# Estos argumentos vienen del flake.nix a través de `specialArgs` y `lib.nixosSystem`.
# - config: Acceso a la configuración final del sistema.
# - pkgs: El conjunto de paquetes Nixpkgs.
# - lib: Las funciones de utilidad de Nixpkgs.
# - inputs: Todos los inputs del flake (nixpkgs, home-manager, etc.). ¡Útil!
# - myUsername: La variable 'myUsername' definida en el flake.
# - system: La arquitectura del sistema (ej. "x86_64-linux").
{ config, pkgs, lib, inputs, myUsername, system, ... }:

{
  # --- Importaciones ---
  # Lista de otros archivos .nix que se incluirán en esta configuración.
  imports = [
    # 1. Configuración detectada automáticamente para tu hardware específico.
    ./hardware-configuration.nix

    # 2. Nuestros módulos personalizados para organizar la configuración.
    ./modules/weston-greeter.nix # Configura SDDM + Weston como definimos arriba.
    # --- Placeholders para futura modularización ---
    # ./modules/networking.nix
    # ./modules/locale.nix
    # ./modules/audio.nix
    # ./modules/users.nix
    # ./modules/packages.nix
    # ./modules/services.nix # Para servicios como SSH, impresión, etc.
  ];

  # --- Arranque (Bootloader) ---
  boot.loader.grub = {
    enable = true;          # Habilitar el gestor de arranque GRUB.
    device = "/dev/nvme0n1"; # Disco donde se instalará GRUB (¡verifica que sea el correcto!).
    useOSProber = true;     # Intentar detectar otros sistemas operativos (ej. Windows).
  };

  # --- Red ---
  # Nombre de host de la máquina. Debería coincidir con la clave usada en `nixosConfigurations` del flake.
  networking.hostName = "nixos"; # O config.networking.hostName si quieres que se establezca automáticamente desde el flake output name.
  # Habilitar NetworkManager para gestionar conexiones de red (Wi-Fi, Ethernet).
  networking.networkmanager.enable = true;

  # --- Hora y Localización ---
  time.timeZone = "America/La_Paz"; # Tu zona horaria.

  # Configuración de idioma y formatos regionales.
  i18n.defaultLocale = "en_US.UTF-8"; # Idioma principal para mensajes del sistema.
  i18n.extraLocaleSettings = { # Sobrescribe formatos específicos a Español (Bolivia).
    LC_ADDRESS = "es_BO.UTF-8";
    LC_IDENTIFICATION = "es_BO.UTF-8";
    LC_MEASUREMENT = "es_BO.UTF-8"; # Sistema métrico.
    LC_MONETARY = "es_BO.UTF-8";    # Símbolo de moneda, separadores.
    LC_NAME = "es_BO.UTF-8";        # Formato de nombres.
    LC_NUMERIC = "es_BO.UTF-8";     # Separador decimal/miles.
    LC_PAPER = "es_BO.UTF-8";       # Tamaño de papel (A4).
    LC_TELEPHONE = "es_BO.UTF-8";   # Formato de números de teléfono.
    LC_TIME = "es_BO.UTF-8";        # Formato de fecha y hora.
  };

  # --- Entorno de Escritorio ---
  # Habilita el entorno de escritorio KDE Plasma 6.
  services.desktopManager.plasma6.enable = true;

  # Habilita el servidor gráfico Xorg. Aunque Plasma 6 prioriza Wayland,
  # Xorg puede ser necesario para compatibilidad con drivers, algunas aplicaciones,
  # o si eliges explícitamente la sesión "Plasma (X11)" en el login.
  services.xserver.enable = true;

  # --- Teclado ---
  # Configuración del layout de teclado para sesiones gráficas (X11 y Wayland).
  services.xserver.xkb = {
    layout = "us";        # Layout base (US English).
    variant = "alt-intl"; # Variante 'alt-intl' para escribir tildes y caracteres internacionales.
  };
  # Configuración del layout para la consola TTY (fuera del entorno gráfico).
  console.keyMap = "dvorak"; # Establecido a Dvorak aquí.

  # --- Servicios del Sistema ---
  # Habilitar servicio de impresión (CUPS).
  services.printing.enable = true;

  # Configuración del sistema de sonido moderno PipeWire.
  services.pulseaudio.enable = false; # Deshabilitar PulseAudio explícitamente para evitar conflictos.
  security.rtkit.enable = true;     # Habilitar RealtimeKit para mejorar rendimiento de audio de baja latencia.
  services.pipewire = {
    enable = true;            # Habilitar PipeWire.
    alsa.enable = true;       # Habilitar soporte ALSA a través de PipeWire.
    alsa.support32Bit = true; # Habilitar soporte para aplicaciones ALSA de 32 bits.
    pulse.enable = true;      # Habilitar el servidor de PulseAudio sobre PipeWire (para compatibilidad).
  };

  # --- Usuarios ---
  # Definición de la cuenta de usuario principal.
  # La mayoría de la configuración del entorno del usuario (dotfiles, aplicaciones)
  # debería gestionarse con Home Manager (en home.nix).
  users.users.${myUsername} = { # Usa la variable 'myUsername' del flake.
    isNormalUser = true;       # Es una cuenta de usuario estándar.
    description = "Carlos Cavero"; # Nombre completo o descripción.
    # Grupos adicionales a los que pertenece el usuario:
    extraGroups = [
      "networkmanager" # Permite gestionar redes con applets de NM.
      "wheel"          # Permite usar 'sudo' o 'doas' (si está configurado).
      # Añadir otros grupos si son necesarios: 'audio', 'video', 'docker', 'libvirtd', 'adbusers', etc.
    ];
    # Paquetes instalados a nivel de sistema sólo para este usuario (¡raro!).
    # Es preferible usar Home Manager para los paquetes del usuario.
    packages = with pkgs; [ ];
  };

  # --- Configuración de Nix y Nixpkgs ---
  # Permitir la instalación de paquetes con licencias no libres (ej. drivers NVIDIA, Steam).
  nixpkgs.config.allowUnfree = true;

  # Lista de paquetes que estarán disponibles globalmente para todos los usuarios en el sistema.
  # Mantener esta lista mínima, con utilidades esenciales del sistema.
  # 'weston' ahora se instala a través del módulo 'weston-greeter.nix'.
  environment.systemPackages = with pkgs; [
    git   # Sistema de control de versiones.
    unrar # Utilidad para descomprimir archivos RAR.
    # Añadir aquí otras herramientas CLI esenciales: htop, wget, curl, etc.
  ];

  # Configuración de Nix (los features de Flakes se habilitan al invocar el comando nix).
  # nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # --- SSH / Firewall (Opcional, comentado) ---
  # services.openssh.enable = true;  # Habilitar servidor SSH.
  # networking.firewall.enable = false; # Firewall deshabilitado por defecto.

  # --- Versión del Sistema ---
  # ¡IMPORTANTE! Establece la versión de NixOS con la que se escribió/probó esta configuración.
  # Ayuda a NixOS a gestionar cambios entre versiones. Asegúrate de que coincida con tu canal nixpkgs.
  system.stateVersion = "24.11"; # Ajusta esto si estás usando una versión diferente (ej. "23.11", "24.05").

}
