{ pkgs, ... }:
{
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      rime-data
      fcitx5-rime
      fcitx5-chinese-addons
      fcitx5-gtk
      fcitx5-configtool
      fcitx5-mellow-themes
    ];
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  # Font configuration with fallback support
  fonts = {
    packages = with pkgs; [
      # Already included by Stylix, but explicitly listed for clarity
      nerd-fonts.jetbrains-mono
      source-han-sans
      source-han-serif
      noto-fonts-color-emoji
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [
          "JetBrainsMono Nerd Font"
          "Source Han Sans SC"
        ];
        sansSerif = [
          "Source Han Sans SC"
          "Noto Sans"
        ];
        serif = [
          "Source Han Serif SC"
          "Noto Serif"
        ];
      };
    };
  };

  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };
}
