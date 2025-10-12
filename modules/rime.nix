{ pkgs, ... }:
{
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      librime
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
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };
}
