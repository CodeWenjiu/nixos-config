{
  pkgs,
  ...
}:
{
  imports = [
    ./browser.nix
    ./chat.nix
    ./music.nix
    ./read.nix
    ./vedio.nix
  ];

  home.packages = with pkgs; [
    ffmpeg
  ];
}
