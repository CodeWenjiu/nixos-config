{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    matugen
  ];

  xdg.configFile."matugen".source = ./config;

  programs.kitty.extraConfig = ''
    include current-theme.conf
  '';

  xdg.configFile."gtk-3.0/gtk.css".text = ''
    @import 'current-theme.css';
  '';

  xdg.configFile."gtk-4.0/gtk.css".text = ''
    @import 'current-theme.css';
  '';
}
