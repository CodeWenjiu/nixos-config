{
  pkgs,
  ...
}:
let
  screenshot = "grim"; # could be `grim`
in
{
  # Pass parameters to child modules via _module.args
  _module.args = {
    inherit screenshot;
  };

  # status bar
  imports = [
    ./screenshot/${screenshot}.nix
    ./noctalia/main.nix
  ];

  home.packages = with pkgs; [
    # controler
    brightnessctl
    pamixer

    wl-clipboard
  ];
}
