# ./nixos/modules/weston-greeter.nix
#
# Módulo para configurar SDDM (Login Manager) y usar Weston como compositor Wayland
# para el 'greeter' (la pantalla de login).
# Esto ayuda a tener una configuración de pantalla (resolución, rotación, posición)
# consistente entre el login y la sesión de usuario final en Wayland.
{ config, pkgs, lib, ... }:

let
  # --- Contenido del archivo de configuración de Weston ---
  # Define cómo se comportará Weston, especialmente las salidas de pantalla.
  # Adapta 'name', 'mode', 'transform', y 'position' a tu configuración de monitores.
  # Puedes listar tus monitores con 'weston --scan-outputs' desde una TTY.
  westonIniContent = ''
    [core]
    #idle-time=0 # Descomenta para deshabilitar el apagado de pantalla por inactividad en Weston.

    # Configuración del monitor principal (Ej: DisplayPort 1)
    [output]
    name=DP-1          # Identificador del monitor
    mode=1920x1080@180 # Resolución y tasa de refresco preferida
    transform=normal   # Orientación normal (otras: 90, 180, 270, flipped, etc.)
    position=0,0       # Coordenada X,Y de la esquina superior izquierda

    # Configuración del monitor secundario (Ej: DisplayPort 2)
    [output]
    name=DP-2
    mode=1920x1080     # Resolución (tasa de refresco usualmente automática si no se especifica)
    transform=270      # Rotado 270 grados (vertical, girado a la derecha)
    position=1920,0    # Posicionado a la derecha del monitor principal (0,0 + 1920 ancho)

    # --- Configuración del Shell ---
    # Weston se lanzará con '--shell=kiosk', que es muy simple.
    [shell]
    background-color=0xff002244 # Color de fondo sólido (formato ARGB hex: 0xAARRGGBB)
                                 # 0xff = opaco, 002244 = Azul oscuro
  ''; # Fin del contenido de weston.ini

  # --- Generación del Archivo ---
  # Usa 'pkgs.writeText' para crear un archivo inmutable en el Nix store
  # que contiene el texto definido arriba. Esto devuelve una ruta tipo /nix/store/...-weston.ini
  generatedWestonIni = pkgs.writeText "weston.ini" westonIniContent;

in {
  # --- Opciones de Configuración que este Módulo Establece ---

  # 1. Asegurar que el paquete 'weston' esté instalado en el sistema.
  #    Es necesario para que SDDM pueda ejecutar el comando CompositorCommand.
  environment.systemPackages = [ pkgs.weston ];

  # 2. Configurar el Display Manager (SDDM).
  services.displayManager.sddm = {
    enable = true;        # Asegura que SDDM esté habilitado (puede ser redundante, pero no daña).
    wayland.enable = true; # Habilita que SDDM use Wayland para mostrar el greeter.
    wayland.compositor = "weston"; # Indica que Weston será el compositor Wayland para el greeter.

    # Configuración específica para el archivo sddm.conf
    settings = {
      # Sección [Wayland] dentro de sddm.conf
      Wayland = {
        # El comando exacto que SDDM ejecutará para iniciar Weston.
        CompositorCommand =
          # Ruta absoluta al binario de Weston desde el paquete Nix.
          "${pkgs.weston}/bin/weston " +
          # Opciones para Weston:
          "--shell=kiosk " + # Usar el shell 'kiosk' (pantalla completa simple, bueno para greeters).
          "-c ${generatedWestonIni}"; # Usar nuestro archivo de configuración generado ('--config').
      };
    };
    # setupScript = null; # Asegura que no haya scripts de setup conflictivos (normalmente no necesario con NixOS).
  };

  # 3. (Opcional) Habilitar X Server. Plasma 6 usa Wayland por defecto.
  #    Podrías necesitar 'services.xserver.enable = true;' en tu config principal
  #    si usas la sesión Plasma X11 o si alguna aplicación/driver lo requiere indirectamente.
  #    Lo dejaremos en configuration.nix para decidir allí.
}
