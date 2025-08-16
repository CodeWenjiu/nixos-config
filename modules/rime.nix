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
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-cove
      source-han-sans
      source-han-serif
      noto-fonts-color-emoji

      # other fonts
      font-awesome
      material-icons
      comic-mono
      icomoon-feather
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [
          "JetBrainsMono Nerd Font"
          "CaskaydiaCove Nerd Font Mono"
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
