{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # freecad-wayland
    bambu-studio
  ];
}
