{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    usbutils
  ];
}
