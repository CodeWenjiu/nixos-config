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
    ./vedio.nix
  ];

  home.packages = with pkgs; [
    ffmpeg
  ];
}
