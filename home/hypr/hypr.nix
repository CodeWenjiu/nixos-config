{ config, pkgs, lib, ... }:
let
  statusBar = "waybar";
  
  screenshot = "grim";
  screenshotConfig =
    if screenshot == "flameshot" then ''
      # --- Screenshot (Flameshot) ---
      bind = , PRINT, exec, flameshot gui
    ''
    else if screenshot == "grim" then ''
      # --- Screenshot (grim + slurp) ---
      $screenshot_dir = $HOME/Pictures/Screenshots
      # 截图选定区域 -> 保存到文件
      bind = , PRINT, exec, grim -g "$(slurp)" "$screenshot_dir/$(date +'%Y-%m-%d_%H-%M-%S').png"
      # 截图选定区域 -> 复制到剪贴板
      bind = SHIFT, PRINT, exec, grim -g "$(slurp)" - | wl-copy
      # 截图选定区域 -> 使用 swappy 编辑
      bind = CTRL, PRINT, exec, grim -g "$(slurp)" - | swappy -f -
    ''
    else '''';

  hyprlandConfigText = ''
    $status_bar = ${statusBar}

    ${builtins.readFile ./hypr/hyprland.conf.template}
    
    ${screenshotConfig}
  '';

  hyprConfigDir = pkgs.runCommand "hypr-config" { } ''
    mkdir -p $out
    cp -r ${./hypr}/. $out/
    cp ${pkgs.writeText "hyprland.conf" hyprlandConfigText} $out/hyprland.conf
    rm $out/hyprland.conf.template
  '';
in {

  # status bar
  imports = [
    ./status_bar/${statusBar}.nix
    ./screenshot/${screenshot}.nix
  ];

  home.packages = with pkgs; [
    hyprland
    rofi-wayland
    hyprpaper

    # controler
    brightnessctl
    pamixer  

    wl-clipboard
  ];
  
  # xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
  xdg.configFile."hypr".source = hyprConfigDir;

  xdg.configFile."rofi".source = ./rofi;
}
