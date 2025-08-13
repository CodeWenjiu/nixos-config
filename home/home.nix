{
  pkgs,
  inputs,
  ...
}:
{
  home.username = "wenjiu";
  home.homeDirectory = "/home/wenjiu";

  home.stateVersion = "25.05";

  xdg.enable = true;

  # Stylix https://github.com/nix-community/stylix
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.polarity = "dark";

  # opacity
  stylix.opacity.applications = 0.7;
  stylix.opacity.desktop = 0.7;
  stylix.opacity.popups = 0.7;
  stylix.opacity.terminal = 0.7;

  # cursor
  stylix.cursor.size = 10;
  stylix.cursor.package = inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default;
  stylix.cursor.name = "BreezX-RosePine-Linux";

  stylix.overlays.enable = false;
  stylix.targets.firefox.profileNames = [ "default" ];
  # Disable stylix targets for zed to avoid conflicts with manual configuration
  stylix.targets.zed.enable = false;
  # Enable stylix theming for fcitx5 to match system color scheme
  # Set to false if you want to use manual fcitx5 theme configuration
  stylix.targets.fcitx5.enable = false;

  # fonts
  stylix.fonts.monospace = {
    name = "JetBrainsMono Nerd Font";
    package = pkgs.nerd-fonts.jetbrains-mono;
  };

  stylix.fonts.sansSerif = {
    name = "Source Han Sans SC";
    package = pkgs.source-han-sans;
  };

  stylix.fonts.serif = {
    name = "Source Han Serif SC";
    package = pkgs.source-han-serif;
  };

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
    ./modules/terminal/main.nix
    ./modules/graphic/main.nix
    ./modules/develop/main.nix

    ./desktop/main.nix
  ];
}
