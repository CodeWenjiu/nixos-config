{
  pkgs,
  desktop_manager,
  ...
}:
let
  statusBar = "waybar";
  screenshot = "grim";
in
{
  # Pass parameters to child modules via _module.args
  _module.args = {
    inherit statusBar screenshot;
  };

  # status bar
  imports = [
    ./status_bar/${statusBar}.nix
    ./status_bar/eww.nix # Debug
    ./screenshot/${screenshot}.nix
    ./${desktop_manager}/main.nix
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
