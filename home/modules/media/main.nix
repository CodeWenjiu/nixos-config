{
  pkgs,
  ...
}:
{
  imports = [
    ./browser.nix
    ./chat.nix
    ./music.nix
    ./doc.nix
    ./mime.nix
    ./email.nix
    ./vedio.nix
    ./obs.nix
    ./niri-zoom.nix
  ];

  home.packages = with pkgs; [
    ffmpeg
  ];
}
