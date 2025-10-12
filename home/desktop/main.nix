{
  pkgs,
  ...
}:
let
  screenshot = "grim"; # could be `grim`
  wallpaper = "swww"; # could be `swww`, `hyprpaper`
in
{
  # Pass parameters to child modules via _module.args
  _module.args = {
    inherit screenshot wallpaper;
  };

  # status bar
  imports = [
    ./screenshot/${screenshot}.nix
    ./noctalia/main.nix
    ./wallpaper/${wallpaper}/main.nix
  ];

  home.packages = with pkgs; [
    rofi

    # controler
    brightnessctl
    pamixer

    wl-clipboard
  ];

  xdg.configFile."rofi".source = ./rofi;
}
