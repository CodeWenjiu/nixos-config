{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    matugen
  ];

  xdg.configFile."matugen".source = ./config;

  xdg.configFile."ghostty/config".text = ''
    theme = matugen
  '';

  xdg.configFile."helix/config.toml".text = ''
    theme = "matugen"
  '';
}
