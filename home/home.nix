{
  ...
}:
{
  home.username = "wenjiu";
  home.homeDirectory = "/home/wenjiu";

  home.stateVersion = "25.05";

  xdg.enable = true;

  # Don't manage GTK themes via home-manager (handled by noctalia)
  gtk.gtk4.enable = false;

  # Explicitly disable kitty (we use ghostty)
  programs.kitty.enable = false;

  imports = [
    ./modules/remote.nix
    ./modules/essential/main.nix

    ./modules/media/main.nix
    ./modules/develop/main.nix

    ./desktop/main.nix

    ./style/main.nix
  ];
}
