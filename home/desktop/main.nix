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

  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    theme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
