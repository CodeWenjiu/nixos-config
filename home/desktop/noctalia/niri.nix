{
  pkgs,
  inputs,
  config,
  ...
}:
let
  randomWallpaperScript = "~/.config/niri/scripts/random-wallpaper.nu";
in
{

  imports = [
    inputs.niri.homeModules.niri
  ];

  home.packages = with pkgs; [
    xwayland-satellite
  ];

  xdg.configFile."niri/scripts".source = ./scripts;

  # see niri flake documentation: https://github.com/sodiboo/niri-flake/blob/main/docs.md
  programs.niri = {
    enable = true;
    settings = {
      spawn-at-startup = [
        {
          command = [ "swww-daemon" ];
        }
        {
          command = [
            "${randomWallpaperScript}"
            "--restore"
          ];
        }
      ];
      window-rules = [
        {
          draw-border-with-background = false;
          clip-to-geometry = true;
          geometry-corner-radius = {
            bottom-left = 10.0;
            bottom-right = 10.0;
            top-left = 10.0;
            top-right = 10.0;
          };
        }
      ];

      layer-rules = [
        {
          matches = [
            {
              namespace = "^wallpaper$";
            }
          ];
          place-within-backdrop = true;
        }
      ];

      layout.background-color = "transparent";

      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 24;
      };

      binds = with config.lib.niri.actions; {
        # section control
        "Mod+L".action = focus-column-right;
        "Mod+H".action = focus-column-left;
        "Mod+J".action = focus-window-or-workspace-down;
        "Mod+K".action = focus-window-or-workspace-up;

        "Mod+Shift+L".action = move-column-right;
        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+J".action = move-window-down-or-to-workspace-down;
        "Mod+Shift+K".action = move-window-up-or-to-workspace-up;

        "Mod+M".action = set-column-width "-10%";
        "Mod+Shift+M".action = set-column-width "+10%";

        "Mod+C".action = close-window;

        "Mod+O".action = toggle-overview;

        # Screen Shot
        "Mod+S".action = {
          screenshot = {
            show-pointer = false;
          };
        };

        # Others
        "Mod+Shift+S".action = suspend;
        "Mod+Shift+Q".action = quit;
        "Mod+Shift+slash".action = show-hotkey-overlay;

        # open applications
        "Mod+T".action = spawn "ghostty";
        "Mod+E".action = spawn "zeditor";
        "Mod+B".action = spawn "firefox";
        "Mod+F".action = spawn "nautilus";
        "Mod+A".action = spawn "noctalia-shell" "ipc" "call" "launcher" "toggle";
        "Mod+W".action = spawn "${randomWallpaperScript}";
        "Mod+Shift+W".action = spawn "${randomWallpaperScript}" "-g";

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
