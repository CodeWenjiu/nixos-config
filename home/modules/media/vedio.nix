{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bilibili
    bilibili-tui
    mpv
  ];
}
