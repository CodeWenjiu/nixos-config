{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    matugen
    gsettings-qt
  ];

  xdg.configFile."matugen".source = ./config;

  xdg.configFile."gtk-3.0/gtk.css".text = ''
    @import 'colors.css';
  '';
  xdg.configFile."gtk-4.0/gtk.css".text = ''
    @import 'colors.css';
  '';

  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    color_scheme_path=wenjiu/.config/qt5ct/colors/matugen.conf
    custom_palette=true
  '';
  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    color_scheme_path=wenjiu/.config/qt6ct/colors/matugen.conf
    custom_palette=true
  '';

  xdg.configFile."helix/config.toml".text = ''
    theme = "matugen"
  '';

  programs.zed-editor.userSettings.theme = "matugen";
}
