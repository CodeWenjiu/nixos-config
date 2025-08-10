{ config, pkgs, ... }:
{
  home.username = "wenjiu";
  home.homeDirectory = "/home/wenjiu";

  home.stateVersion = "25.05";

  xdg.enable = true;

  gtk = {
    enable = true;
      theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
      iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  home.sessionVariables = {
    GTK_THEME = "Adwaita:dark";
  };

  imports = [
    ./modules/fonts.nix
    ./modules/remote.nix
    
    ./modules/media/media.nix
    ./modules/terminal/terminal.nix
    ./modules/graphic/graphic.nix

    ./hypr/hypr.nix
  ];
}
