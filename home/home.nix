{ config, pkgs, inputs, ... }:
{
  home.username = "wenjiu";
  home.homeDirectory = "/home/wenjiu";

  home.stateVersion = "25.05";

  xdg.enable = true;

  # Stylix https://github.com/nix-community/stylix
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  
  stylix.polarity = "dark"; 

  # opacity
  stylix.opacity.applications = 0.7;
  stylix.opacity.desktop = 0.7;
  stylix.opacity.popups = 0.7;
  stylix.opacity.terminal = 0.7;

  # cursor
  stylix.cursor.size = 10;
  stylix.cursor.package = inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default;
  stylix.cursor.name = "BreezX-RosePine-Linux";

  stylix.overlays.enable = false;
  stylix.targets.firefox.profileNames = ["default"];

  imports = [
    ./modules/fonts.nix
    ./modules/remote.nix
    
    ./modules/media/media.nix
    ./modules/terminal/terminal.nix
    ./modules/graphic/graphic.nix

    ./hypr/hypr.nix
  ];
}
