{
  config,
  pkgs,
  lib,
  ...
}: let
  statusBar = "waybar";

  screenshot = "grim";

  screenshotConfig = import ./screenshot/screenshot.nix {screenshot = screenshot;};

  hyprlandConfigText = ''
    $status_bar = ${statusBar}

    ${builtins.readFile ./hypr/hyprland_temp.conf}

    ${screenshotConfig}
  '';

  hyprConfigDir = pkgs.runCommand "hypr-config" {} ''
    mkdir -p $out
    cp -r ${./hypr}/. $out/
    cp ${pkgs.writeText "hyprland.conf" hyprlandConfigText} $out/hyprland.conf
    rm $out/hyprland_temp.conf
  '';
in {
  # status bar
  imports = [
    ./status_bar/${statusBar}.nix
    ./screenshot/${screenshot}.nix
  ];

  home.packages = with pkgs; [
    hyprland
    rofi-wayland
    hyprpaper

    # controler
    brightnessctl
    pamixer

    wl-clipboard
  ];

  # xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
  xdg.configFile."hypr".source = hyprConfigDir;

  xdg.configFile."rofi".source = ./rofi;
}
