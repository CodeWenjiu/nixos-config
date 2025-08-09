{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprland
    waybar
    rofi-wayland
    hyprpaper
  ];
  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
}
