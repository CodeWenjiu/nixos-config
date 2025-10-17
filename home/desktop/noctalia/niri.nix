{
  pkgs,
  inputs,
  config,
  ...
}:
{

  imports = [
    inputs.niri.homeModules.niri
  ];

  home.packages = with pkgs; [
    xwayland-satellite
  ];

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  # see niri flake documentation: https://github.com/sodiboo/niri-flake/blob/main/docs.md
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
    settings = {
      window-rules = [
        {
          draw-border-with-background = false;
          clip-to-geometry = true;
          geometry-corner-radius = {
            bottom-left = 20.0;
            bottom-right = 20.0;
            top-left = 20.0;
            top-right = 20.0;
          };
        }
      ];

      layer-rules = [
        {
          matches = [
            {
              namespace = "^quickshell-overview$";
            }
          ];
          place-within-backdrop = true;
        }
      ];

      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 24;
      };

      binds = with config.lib.niri.actions; {
        "Mod+T".action = spawn "ghostty";
        "Mod+E".action = spawn "zeditor";
        "Mod+B".action = spawn "firefox";
        "Mod+F".action = spawn "nautilus";
        "Mod+A".action = spawn "noctalia-shell" "ipc" "call" "launcher" "toggle";
        "Mod+W".action = spawn "noctalia-shell" "ipc" "call" "wallpaper" "random";
        "Mod+Shift+Q".action = quit;
        "Mod+Shift+slash".action = show-hotkey-overlay;
        "Mod+C".action = close-window;
        "Mod+O".action = open-overview;

        # Volume control
        "XF86AudioRaiseVolume".action = spawn "noctalia-shell" "ipc" "call" "volume" "increase";
        "XF86AudioLowerVolume".action = spawn "noctalia-shell" "ipc" "call" "volume" "decrease";
        "XF86AudioMute".action = spawn "noctalia-shell" "ipc" "call" "volume" "muteOutput";
        "XF86AudioMicMute".action = spawn "noctalia-shell" "ipc" "call" "volume" "muteInput";

        # Brightness control
        "XF86MonBrightnessUp".action = spawn "noctalia-shell" "ipc" "call" "brightness" "increase";
        "XF86MonBrightnessDown".action = spawn "noctalia-shell" "ipc" "call" "brightness" "decrease";
      };

      hotkey-overlay.skip-at-startup = true;
    };
  };

}
