{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    zip
    unzip
    ffmpeg
    dust
    duf
  ];
}
