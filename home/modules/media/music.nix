{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    spotify
    netease-cloud-music-gtk
  ];
}
