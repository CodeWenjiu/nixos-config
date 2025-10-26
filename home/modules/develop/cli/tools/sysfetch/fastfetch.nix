{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    fastfetch
  ];

  xdg.configFile."fastfetch/config.jsonc".source = ./fastfetch.jsonc;
}
