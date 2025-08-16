# Mark: No maintain

{
  pkgs,
  ...
}:
{
  # Stylix https://github.com/nix-community/stylix
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.polarity = "dark";

  # opacity
  # stylix.opacity.applications = 0.7;
  # stylix.opacity.desktop = 0.7;
  # stylix.opacity.popups = 0.7;
  # stylix.opacity.terminal = 0.7;

  stylix.overlays.enable = false;
  stylix.targets.firefox.profileNames = [ "default" ];
  # Disable stylix targets for zed to avoid conflicts with manual configuration
  # stylix.targets.zed.enable = false;
  # Enable stylix theming for fcitx5 to match system color scheme
  stylix.targets.fcitx5.enable = false;

  # fonts
  stylix.fonts.sizes.desktop = 8;
  stylix.fonts.sizes.popups = 8;
  stylix.fonts.sizes.terminal = 8;

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
}
