{ config, pkgs, lib, ... }:
let
  statusBar = "waybar";
  
  hyprlandConfigText = ''
    $status_bar = ${statusBar}

    ${builtins.readFile ./hypr/hyprland.conf.template}
  '';

  hyprConfigDir = pkgs.runCommand "hypr-config" { } ''
    mkdir -p $out
    cp -r ${./hypr}/. $out/
    cp ${pkgs.writeText "hyprland.conf" hyprlandConfigText} $out/hyprland.conf
    rm $out/hyprland.conf.template
  '';
in {
  home.packages = with pkgs; [
    hyprland
    rofi-wayland
    hyprpaper

    # controler
    brightnessctl
    pamixer  
  ];

  # status bar
  imports = let
    statusBarImport = ./. + "/status_bar/${statusBar}.nix";
  in lib.optional (builtins.pathExists statusBarImport) statusBarImport;

  # xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
  xdg.configFile."hypr".source = hyprConfigDir;

  xdg.configFile."rofi".source = ./rofi;
}
