{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    matugen
  ];

  xdg.configFile."matugen".source = ./config;

  xdg.configFile."hypr/hyprland.conf".text = ''
    source = colors.conf
  '';

  programs.kitty.extraConfig = ''
    include colors.conf
  '';

  xdg.configFile."gtk-3.0/gtk.css".text = ''
    @import 'colors.css';
  '';

  xdg.configFile."gtk-4.0/gtk.css".text = ''
    @import 'colors.css';
  '';
}
