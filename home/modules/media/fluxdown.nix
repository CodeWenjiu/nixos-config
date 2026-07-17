{ pkgs, ... }:
let
  fluxdown-unwrapped = pkgs.appimageTools.wrapType2 {
    pname = "fluxdown";
    version = "0.1.54";
    extraPkgs = p: with p; [ libepoxy ];
    src = pkgs.fetchurl {
      url = "https://github.com/zerx-lab/FluxDown/releases/download/v0.1.54/FluxDown-0.1.54-linux-x64.AppImage";
      sha256 = "90464c0817c3fa6b6defa082435948eca18054e64f03550963d52703ebd1d2c2";
    };
  };
in
{
  home.packages = [ fluxdown-unwrapped ];

  xdg.desktopEntries.fluxdown = {
    name = "FluxDown";
    exec = "${fluxdown-unwrapped}/bin/fluxdown";
    icon = "${fluxdown-unwrapped}/bin/fluxdown"; # AppImage wraps its own icon
    terminal = false;
    categories = [ "Network" ];
    comment = "Download Manager";
  };
}
