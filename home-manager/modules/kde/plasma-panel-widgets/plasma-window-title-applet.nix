# ~/nixos-config/home-manager/modules/plasma-panel-widgets/plasma-window-title-applet.nix
# Definición de cómo construir el widget personalizado
{ fetchFromGitHub, stdenv, lib }: # Dependencias que Nix inyectará vía callPackage

stdenv.mkDerivation rec {
  pname = "plasma-window-title-applet";
  # Usamos una versión descriptiva basada en el commit, o puedes dejar la que tenías
  version = "0.9.0-git-${lib.strings.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "dhruv8sh";
    repo = "plasma6-window-title-applet";
    rev = "6d6b939bb8138a8b1640cf2f6d395a3030d7bbaa"; # Commit específico
    hash = "sha256-dfJcRbUubv3/1PAWCFtNWzc8nyIcgTW39vryFLOOqzs="; # Hash verificado
  };

  # Fase de instalación: simplemente copia los archivos al lugar correcto
  installPhase = ''
    mkdir -p $out/share/plasma/plasmoids/org.kde.windowtitle
    cp -r $src/metadata.json $src/contents $out/share/plasma/plasmoids/org.kde.windowtitle
  '';

  # Metadatos (útiles para Nix)
  meta = with lib; { # Usamos 'lib' aquí
    description = "Plasma 6 Window Title applet";
    homepage = "https://github.com/dhruv8sh/plasma6-window-title-applet";
    license = licenses.gpl3Plus; # ¡IMPORTANTE! Verifica la licencia real en el repo de GitHub
    platforms = platforms.linux;
  };
}
