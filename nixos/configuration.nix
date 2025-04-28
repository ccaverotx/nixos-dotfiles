# ~/nixos-config/configuration.nix (o nixos/configuration.nix)
{ config, pkgs, lib, ... }: # Añadimos lib por si acaso

# --- AÑADIDO: Bloque let para generar weston.ini ---
let
  westonIniContent = ''
    [core]
    # idle-time=0 # opcional

    # Configuración del monitor principal
    [output]
    name=DP-1
    mode=1920x1080@180
    transform=normal
    position=0,0

    # Configuración del monitor secundario
    [output]
    name=DP-2
    mode=1920x1080
    transform=270
    position=1920,0

    [shell]
    background-color=0xff002244 # Color sólido: Azul oscuro
  '';

  generatedWestonIni = pkgs.writeText "weston.ini" westonIniContent;
in
{ # Inicio de la configuración principal
  imports = [
  ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/La_Paz";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_BO.UTF-8";
    LC_IDENTIFICATION = "es_BO.UTF-8";
    LC_MEASUREMENT = "es_BO.UTF-8";
    LC_MONETARY = "es_BO.UTF-8";
    LC_NAME = "es_BO.UTF-8";
    LC_NUMERIC = "es_BO.UTF-8";
    LC_PAPER = "es_BO.UTF-8";
    LC_TELEPHONE = "es_BO.UTF-8";
    LC_TIME = "es_BO.UTF-8";
  };

  services.xserver.enable = true; # Necesario para la sesión Plasma X11 si la usas

  # --- MODIFICADO: Configuración SDDM para usar Weston ---
  services.displayManager.sddm = {
    enable = true;             # Habilitar SDDM
    wayland.enable = true;     # Habilitar el modo Wayland para el greeter SDDM
    wayland.compositor = "weston"; # Usar Weston como compositor para el greeter

    settings = {
      # Sección [Wayland] en la configuración de SDDM
      Wayland = {
        # Comando para lanzar Weston:
        # - Usa la ruta del paquete Nix (${pkgs.weston}/bin/weston)
        # - Usa el modo kiosk (pantalla completa simple)
        # - Le pasa nuestro archivo weston.ini generado (${generatedWestonIni})
        CompositorCommand = "${pkgs.weston}/bin/weston --shell=kiosk -c ${generatedWestonIni}";
      };
    };
    # Asegúrate de que no haya un setupScript definido de intentos anteriores
    # setupScript = "";
  };
  # --- FIN MODIFICADO ---

  # Habilitar el escritorio Plasma 6
  services.desktopManager.plasma6.enable = true;

  # Configuración de teclado X11
  services.xserver.xkb = {
    layout = "us";
    variant = "alt-intl";
  };

  # Configuración de teclado en consola TTY
  console.keyMap = "dvorak";

  services.printing.enable = true; # Impresión

  # Configuración de sonido Pipewire
  services.pulseaudio.enable = false; # Deshabilitar pulseaudio explícitamente
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Flakes (Redundante si se gestiona desde fuera del flake)
  # nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Cuenta de usuario
  users.users.ccaverotx = {
    isNormalUser = true;
    description = "Carlos Cavero";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ]; # Paquetes específicos para el usuario a nivel sistema (vacío ahora)
  };

  # Permitir paquetes no libres
  nixpkgs.config.allowUnfree = true;

  # --- MODIFICADO: Paquetes del sistema ---
  environment.systemPackages = with pkgs; [
    git
    unrar
    weston # <-- Añadido Weston
    # Ya no necesitamos kscreen aquí
  ];
  # --- FIN MODIFICADO ---

  # SSH / Firewall (comentados)
  # services.openssh.enable = true;
  # networking.firewall.enable = false;

  # Versión del estado del sistema
  system.stateVersion = "24.11";
}
