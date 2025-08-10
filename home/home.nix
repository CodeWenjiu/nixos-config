{ config, pkgs, ... }:
{
  home.username = "wenjiu";
  home.homeDirectory = "/home/wenjiu";

  home.stateVersion = "25.05";

  xdg.enable = true;

  imports = [
    ./modules/fonts.nix
    ./modules/remote.nix
    
    ./modules/media/media.nix
    ./modules/terminal/terminal.nix
    ./modules/graphic/graphic.nix

    ./hypr/hypr.nix
  ];
}
