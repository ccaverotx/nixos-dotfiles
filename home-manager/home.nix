{ pkgs, inputs, config, lib, myUsername, system, ... }:

{
  imports = [
    ./modules/kde/plasma-manager.nix
    ./modules/kde/kate.nix
    ./modules/kde/kwin.nix
  ];

  home.stateVersion = "24.11";

  home.username = myUsername;
  home.homeDirectory = "/home/${myUsername}";

  home.packages = with pkgs; [
    firefox
    htop
    nil
    unrar
    nodejs
    nodePackages.live-server
    kdePackages.kate
    zoom-us
    obsidian
    insomnia
    onlyoffice-bin
    vesktop
    freetube
  ];

  programs.git = {
    enable = true;
    userName = "Carlos Cavero";
    userEmail = "ccaverotx@gmail.com";
  };
}
