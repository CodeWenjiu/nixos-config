{
  pkgs,
  ...
}:
{
  home.username = "wenjiu";
  home.homeDirectory = "/home/wenjiu";

  home.stateVersion = "25.05";

  xdg.enable = true;

  # Additional fonts for eww widgets
  home.packages = with pkgs; [
    font-awesome
    material-icons
    comic-mono
    icomoon-feather
  ];

  imports = [
    ./modules/remote.nix
    ./modules/essential/main.nix

    ./modules/media/main.nix
    ./modules/game/main.nix
    ./modules/terminal/main.nix
    ./modules/graphic/main.nix
    ./modules/develop/main.nix

    ./desktop/main.nix

    ./style/main.nix
  ];
}
