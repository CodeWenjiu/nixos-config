{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
  ];
  xdg.configFile."hypr/hyprland.conf".text = ''
    env = HYPRCURSOR_THEME,rose-pine-hyprcursor
  '';
}
