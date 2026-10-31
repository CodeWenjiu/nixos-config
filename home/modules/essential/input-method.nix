# Fcitx5 输入法框架（用户级）：引擎、Rime 与主题。
# 青简的 addon 由 qingjian.nix 加进同一个 addons 列表。
{ pkgs, ... }:
let
  # XWayland / SDL / 其它应用靠这些变量找 fcitx（XIM、Qt、GTK immodule）。
  imVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    INPUT_METHOD = "fcitx";
    GLFW_IM_MODULE = "ibus";
  };
in
{
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      waylandFrontend = true;

      # fcitx5 包自带 XDG autostart（profile 的 etc/xdg/autostart），由 systemd 的
      # xdg-autostart generator 拉起；再开这个服务只会启动第二个实例后立刻退出。
      systemd.enable = false;

      addons = with pkgs; [
        fcitx5-rime
        qt6Packages.fcitx5-chinese-addons
        fcitx5-material-color
        qt6Packages.fcitx5-qt
      ];

      # 只写进 hm-session-vars.sh（登录 shell），GUI 会话用不到；保留给终端应用。
      sessionVariables = imVariables;
    };
  };

  # environment.d 由 systemd 用户管理器在登录时读取，niri 与它启动的应用
  # （包括 XWayland 的微信）都会继承。改了之后需要重新登录才生效。
  systemd.user.sessionVariables = imVariables;
}
