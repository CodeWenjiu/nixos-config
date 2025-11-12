{
  ...
}:
{
  home.username = "wenjiu";
  home.homeDirectory = "/home/wenjiu";

  home.stateVersion = "25.05";

  xdg.enable = true;

  imports = [
    ./modules/remote.nix
    ./modules/essential/main.nix

    ./modules/media/main.nix
    ./modules/develop/main.nix

    ./desktop/main.nix

    ./style/main.nix
  ];
}
