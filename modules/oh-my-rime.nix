{ pkgs, ... }:
let
  ohMyRime = pkgs.fetchFromGitHub {
    owner = "Mintimate";
    repo = "oh-my-rime";
    rev = "main";
    sha256 = "1v6aj2021wgdc30ddlc8d1yyfl7waik07w03z8bgz1scl23lvf4v"; # 需替换实际 hash
  };

  rimeConfLinker = pkgs.writeShellScriptBin "rime-conf-linker" ''
    mkdir -p ~/.local/share/fcitx5/rime
    ln -sf ${ohMyRime}/* ~/.local/share/fcitx5/rime/
  '';
in
{
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-chinese-addons
    ];
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  systemd.user.services.fcitx5-rime-init = {
    description = "Link oh-my-rime config to Fcitx5";
    wantedBy = [ "fcitx5.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${rimeConfLinker}/bin/rime-conf-linker";
      User = "%I";
    };
  };

  # Font configuration with fallback support
  fonts = {
    packages = with pkgs; [
      # Already included by Stylix, but explicitly listed for clarity
      nerd-fonts.caskaydia-cove
      source-han-sans
      source-han-serif
      noto-fonts-color-emoji
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [
          "CaskaydiaCove Nerd Font Mono"
          "Source Han Sans SC"
          "Source Han Mono SC"
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

  environment.systemPackages = [
    rimeConfLinker
  ];
}
