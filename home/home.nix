{
  pkgs,
  ...
}:
{
  home.username = "wenjiu";
  home.homeDirectory = "/home/wenjiu";

  home.stateVersion = "25.05";

  xdg.enable = true;

  imports = [
    ./modules/essential/main.nix
    ./modules/develop/main.nix
  ];
}
