{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    matugen
  ];

  xdg.configFile."matugen".source = ./config;

  xdg.configFile."yazi/yazi.toml".text = ''
    [preview]
    image_quality = 90

    [tasks]
    image_alloc = 0
  '';

  xdg.configFile."helix/config.toml".text = ''
    theme = "matugen"
  '';
}
