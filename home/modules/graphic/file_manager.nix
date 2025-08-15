{
  pkgs,
  ...
}:
{
  # home.packages = with pkgs; [
  #   xfce.thunar
  #   xfce.thunar-volman
  #   xfce.thunar-archive-plugin
  # ];

  # xdg.configFile."gtk-3.0/bookmarks".text = ''
  #   file:///mnt/data Data
  # ''; # default data mount position

  home.packages = with pkgs; [
    kdePackages.dolphin
    kdePackages.kio-extras
    kdePackages.ffmpegthumbs
    kdePackages.kdegraphics-thumbnailers
    kdePackages.kio-fuse
  ];
}
