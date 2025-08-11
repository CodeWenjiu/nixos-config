{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./browser.nix
    ./chat.nix
    ./music.nix
    ./read.nix
    ./vedio.nix
  ];
}
