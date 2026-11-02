{
  pkgs,
  ...
}:
let
  configer = "noctalia";
in
{
  # status bar
  imports = [
    ./${configer}/main.nix
    ./mihomo-keys.nix
  ];

  home.packages = with pkgs; [
    # controler
    brightnessctl
    pamixer

    wl-clipboard
  ];
}
