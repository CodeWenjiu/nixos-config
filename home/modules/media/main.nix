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
    ./email.nix
    ./vedio.nix
    ./obs.nix
    ./niri-zoom.nix
    ./fluxdown.nix
  ];

  home.packages = with pkgs; [
    ffmpeg
  ];
}
