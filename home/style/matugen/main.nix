{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    matugen
  ];

  xdg.configFile."matugen".source = ./config;

  xdg.configFile."gtk-3.0/gtk.css".text = ''
    @import 'colors.css';
  '';

  xdg.configFile."gtk-4.0/gtk.css".text = ''
    @import 'colors.css';
  '';

  xdg.configFile."yazi/yazi.toml".text = ''
    [preview]
    image_quality = 90

    [tasks]
    image_alloc = 0
  '';
}
