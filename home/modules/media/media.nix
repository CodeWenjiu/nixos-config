{ config, pkgs, ... }:
{

  imports = [
    ./browser.nix
    ./chat.nix
    ./music.nix
    ./vedio.nix
  ];
}
