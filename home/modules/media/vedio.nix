{ pkgs, ... }:
let
  bilibili-latest = pkgs.appimageTools.wrapType2 {
    pname = "bilibili";
    version = "1.17.9-2";
    src = pkgs.fetchurl {
      url = "https://github.com/msojocs/bilibili-linux/releases/download/v1.17.9-2/bilibili-1.17.9-x86_64.AppImage";
      sha256 = "f18a2a78c0f5855e5604e2fd2dfacf2b6b5954e336396060d54139f4e67ec1ff";
    };
  };
in
{
  home.packages = with pkgs; [
    bilibili-latest
    mpv
  ];

  xdg.desktopEntries.bilibili = {
    name = "Bilibili";
    exec = "${bilibili-latest}/bin/bilibili";
    icon = "bilibili";
    terminal = false;
    categories = [ "AudioVideo" "Network" ];
  };
}
