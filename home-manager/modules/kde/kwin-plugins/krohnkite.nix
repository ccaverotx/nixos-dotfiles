# ./home-manager/modules/Kwin Modules/kwin-plugins/krohnkite.nix
{ lib, ... }:

let
  tilingGap = 10;
  betweenTiles = 5;
in
{
  enableBTreeLayout = true;
  enableColumnsLayout = false;
  enableMonocleLayout = false;
  enableSpiralLayout = false;
  enableSpreadLayout = false;
  enableStairLayout = false;
  enableThreeColumnLayout = false;
  enableTileLayout = true;

  ignoreClass = lib.concatStringsSep "," [
    "kded" "krunner" "ksshaskpass"
    "org.freedesktop.impl.portal.desktop.kde"
    "org.kde.plasmashell"
    "org.kde.polkit-kde-authentication-agent-1"
    "qalculate-qt" "spectacle"
    "xwaylandvideobridge" "yakuake"
  ];

  ignoreTitle = lib.concatStringsSep "," [
    "Configure — System Settings"
    "KDE Wayland Compositor"
  ];

  monocleMaximize = false;

  # screenGap = tilingGap;
  screenGapBottom = tilingGap;
  screenGapLeft = tilingGap;
  screenGapRight = tilingGap;
  screenGapTop = tilingGap;
  screenGapBetween = betweenTiles;
  tileLayoutGap = betweenTiles; # << Este es el 'between tiles'
}
