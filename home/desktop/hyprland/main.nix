{
  pkgs,
  statusBar,
  screenshot,
  ...
}:
let
  screenshotConfig = import ./config/screenshot.nix { screenshot = screenshot; };

  hyprlandConfigText = ''
    $status_bar = ${statusBar}

    ${builtins.readFile ./hypr/hyprland_temp.conf}

    ${screenshotConfig}
  '';

  hyprConfigDir = pkgs.runCommand "hypr-config" { } ''
    mkdir -p $out
    cp -r ${./hypr}/. $out/
    cp ${pkgs.writeText "hyprland.conf" hyprlandConfigText} $out/hyprland.conf
    rm $out/hyprland_temp.conf
  '';
in
{
  home.packages = with pkgs; [
    hyprpaper
  ];

  xdg.configFile."hypr".source = hyprConfigDir;
}
