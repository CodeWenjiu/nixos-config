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
  ];

  home.packages = with pkgs; [
    # controler
    brightnessctl
    pamixer

    wl-clipboard

    # wallpaper
    swww
  ];
}
