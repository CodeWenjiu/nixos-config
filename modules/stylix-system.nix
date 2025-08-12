{ pkgs, ... }:
{
  # System-level Stylix configuration
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.polarity = "dark";

  # Enable stylix targets for system-level applications
  stylix.targets = {
    # Enable theming for console/TTY
    console.enable = true;

    # Enable theming for GRUB if using GRUB bootloader
    grub.enable = true;

    # This will help with fcitx5/rime theming at system level
    gtk.enable = true;
  };

  # System-level font configuration that works with stylix
  stylix.fonts = {
    monospace = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
    sansSerif = {
      name = "Source Han Sans SC";
      package = pkgs.source-han-sans;
    };
    serif = {
      name = "Source Han Serif SC";
      package = pkgs.source-han-serif;
    };
  };
}
