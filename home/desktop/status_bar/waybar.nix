{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    waybar
  ];

  xdg.configFile."waybar".source = ./waybar;
  xdg.configFile."waybar".recursive = true;
}
