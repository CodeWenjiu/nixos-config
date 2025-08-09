{ config, pkgs, ... }:
let
  # oh-my-rime 仓库源
  ohMyRime = pkgs.fetchFromGitHub {
    owner = "Mintimate";
    repo = "oh-my-rime";
    rev = "main";  # 可替换为特定 commit 或 tag
    sha256 = "1v6aj2021wgdc30ddlc8d1yyfl7waik07w03z8bgz1scl23lvf4v";  # 需替换实际 hash
  };

  # 创建自动链接脚本
  rimeConfLinker = pkgs.writeShellScriptBin "rime-conf-linker" ''
    mkdir -p ~/.local/share/fcitx5/rime
    ln -sf ${ohMyRime}/* ~/.local/share/fcitx5/rime/
  '';
in {
  # fcitx5 输入法配置
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-rime
      fcitx5-chinese-addons
    ];
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  # systemd 服务配置 - 自动链接 oh-my-rime 配置
  systemd.user.services.fcitx5-rime-init = {
    description = "Link oh-my-rime config to Fcitx5";
    wantedBy = [ "fcitx5.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${rimeConfLinker}/bin/rime-conf-linker";
      User = "%I";
    };
  };

  # 输入法相关环境变量
  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  # 中文字体配置
  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    sarasa-gothic
  ];

  # 将链接脚本添加到系统包中
  environment.systemPackages = with pkgs; [
    rimeConfLinker
  ];
}
