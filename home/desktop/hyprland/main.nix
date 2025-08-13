{
  statusBar,
  screenshot,
  wallpaper,
  ...
}:
let
  screenshotConfig = import ./config/screenshot.nix { screenshot = screenshot; };
  wallpaperConfig = import ./config/wallpaper.nix { wallpaper = wallpaper; };
  baseHyprConf = builtins.readFile ./hypr/hyprland_temp.conf;

  hyprlandConfigText = ''
    $status_bar = ${statusBar}

    ${baseHyprConf}

    ${screenshotConfig}

    ${wallpaperConfig}
  '';
in
{
  xdg.configFile."hypr/hyprland.conf".text = hyprlandConfigText;
  xdg.configFile."hypr/scripts".source = ./hypr/scripts;
}
