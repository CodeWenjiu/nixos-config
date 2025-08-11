{ config, pkgs, lib, ... }:
let
  statusBar = "waybar";
  
  hyprlandConfig = pkgs.substituteAll {
    src = ./hyprland.conf.template;
    status_bar = statusBar;
  };
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
  xdg.configFile."hypr/hyprland.conf".text = ''
      $status_bar = ${statusBar}
      ${builtins.readFile ./hyprland.conf}
    '';
  xdg.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  xdg.configFile."hypr/wallpaper.png".source = ./wallpaper.png;

  xdg.configFile."rofi".source = ./rofi;
}
