{ config, pkgs, ... }:
{
  home.username = "wenjiu";
  home.homeDirectory = "/home/wenjiu";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    zip
  ];

  imports = [
    ./modules/browser.nix
    ./modules/chat.nix
    ./modules/editor.nix
    ./modules/shell.nix
    ./modules/tools.nix
    ./modules/vcs.nix
  ];
}
