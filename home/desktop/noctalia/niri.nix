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
    package = pkgs.niri;
    config = builtins.readFile ./niri-config.kdl;
  };
}
