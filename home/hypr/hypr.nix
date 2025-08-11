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
    acpi    
  ];

  # status bar
  imports = lib.optionals (statusBar == "waybar") [ ./status_bar/waybar.nix ]
         ++ lib.optionals (statusBar == "hyprpanel") [ ./status_bar/hyprpanel.nix ]
         ++ lib.optionals (statusBar == "eww") [ ./status_bar/eww.nix ];

  # xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
  xdg.configFile."hypr/hyprland.conf".text = ''
      $status_bar = ${statusBar}
      ${builtins.readFile ./hyprland.conf}
    '';

  xdg.configFile."rofi".source = ./rofi;
}
