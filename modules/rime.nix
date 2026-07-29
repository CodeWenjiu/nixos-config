{ pkgs, inputs, ... }:
{
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      # ── Engines ────────────────────────────
      fcitx5-rime
      qt6Packages.fcitx5-chinese-addons

      # ── Voice input ─────────────────────────
      inputs.fcitx5-vinput.packages.${pkgs.stdenv.hostPlatform.system}.default

      # ── UI & Themes ────────────────────────
      fcitx5-material-color
      qt6Packages.fcitx5-qt
    ];
  };

  i18n.defaultLocale = "zh_CN.UTF-8";

  # Environment variables for fcitx5
  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    INPUT_METHOD = "fcitx";
    GLFW_IM_MODULE = "ibus";
  };
}
