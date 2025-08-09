{ config, pkgs, ... }:
{
  home.username = "wenjiu";
  home.homeDirectory = "/home/wenjiu";

  home.stateVersion = "25.05";

  xdg.enable = true;

  imports = [
    ./modules/browser.nix
    ./modules/chat.nix
    ./modules/editor.nix
    ./modules/fonts.nix
    ./modules/music.nix
    ./modules/remote.nix
    ./modules/shell.nix
    ./modules/terminal.nix
    ./modules/tools.nix
    ./modules/vcs.nix

    ./hypr/hypr.nix
  ];
}
