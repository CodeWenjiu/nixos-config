{
  pkgs,
  desktop_manager,
  ...
}:
let
  statusBar = "waybar"; # could be `waybar`, `hyprpanel`, `eww`, `polybar`(can't use for now)
  screenshot = "grim"; # could be `grim`
  wallpaper = "swww"; # could be `swww`, `hyprpaper`
in
{
  # Pass parameters to child modules via _module.args
  _module.args = {
    inherit statusBar screenshot wallpaper;
  };

  # status bar
  imports = [
    ./status_bar/${statusBar}.nix
    ./status_bar/eww.nix # Debug
    ./screenshot/${screenshot}.nix
    ./${desktop_manager}/main.nix
    ./wallpaper/${wallpaper}/main.nix
  ];

  home.packages = with pkgs; [
    rofi-wayland

    # controler
    brightnessctl
    pamixer

    wl-clipboard
  ];

  xdg.configFile."rofi".source = ./rofi;
}
