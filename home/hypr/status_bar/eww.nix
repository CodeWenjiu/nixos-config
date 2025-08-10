{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    eww
    jq
    playerctl
    brightnessctl
    socat
    imagemagick
    pamixer  # 音量控制
    acpi     # 电池信息
    networkmanager  # 网络信息
  ];
  
  xdg.configFile."eww".source = ./eww;
}
