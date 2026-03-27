{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # krita
    pinta
  ];
}
