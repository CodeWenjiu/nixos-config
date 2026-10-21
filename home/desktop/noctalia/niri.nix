{
  pkgs,
  inputs,
  ...
}:
{

  imports = [
    inputs.niri.homeModules.niri
  ];

  home.packages = with pkgs; [
    xwayland-satellite
    libdisplay-info
    waylyrics
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
    config = builtins.readFile ./niri-config.kdl;
  };
}
