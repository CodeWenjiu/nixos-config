{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    polybarFull
  ];

  xdg.configFile."polybar".source = ./polybar;
  xdg.configFile."polybar".recursive = true;
}
