{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    eww
    jq
    playerctl
    socat
    imagemagick
  ];

  xdg.configFile."eww".source = ./eww;
}
