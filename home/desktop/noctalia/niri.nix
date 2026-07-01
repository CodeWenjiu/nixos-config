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
    libdisplay-info
    waylyrics
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      spawn-at-startup = [
        {
          command = [ "noctalia" ];
        }
      ];
      window-rules = [
        {
          draw-border-with-background = false;
          clip-to-geometry = true;
          opacity = 0.94;
          geometry-corner-radius = {
            bottom-left = 10.0;
            bottom-right = 10.0;
            top-left = 10.0;
            top-right = 10.0;
          };
        }

        {
          matches = [
            { app-id = "io.github.waylyrics.Waylyrics"; }
          ];
          open-floating = true;
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
        "Mod+Shift+F".action = toggle-window-floating;

        "Mod+M".action = set-column-width "-10%";
        "Mod+Shift+M".action = set-column-width "+10%";
        "Mod+Alt+M".action = maximize-window-to-edges;

        "Mod+C".action = close-window;

        "Mod+O".action = toggle-overview;

        # Screen Shot
        "XF86SelectiveScreenshot".action = {
          screenshot = {
            show-pointer = false;
          };
        };

        # Others
        "Mod+Shift+S".action = spawn "noctalia" "msg" "session" "lock";
        "Mod+Shift+Q".action = spawn "noctalia" "msg" "session" "lock-and-suspend";
        "Mod+Shift+slash".action = show-hotkey-overlay;

        # open applications
        "Mod+T".action = spawn "ghostty";
        "Mod+E".action = spawn "zeditor";
        "Mod+B".action = spawn "firefox";
        "Mod+F".action = spawn "nautilus";
        "Mod+A".action = spawn "noctalia" "msg" "panel-toggle" "launcher";
        "Mod+W".action = spawn "noctalia" "msg" "panel-toggle" "wallpaper";

        # Volume control
        "XF86AudioRaiseVolume".action = spawn "noctalia" "msg" "volume-up";
        "XF86AudioLowerVolume".action = spawn "noctalia" "msg" "volume-down";
        "XF86AudioMute".action = spawn "noctalia" "msg" "volume-mute";
        "XF86AudioMicMute".action = spawn "noctalia" "msg" "mic-mute";

        # Media control (music widget / MPRIS)
        "Mod+P".action = spawn "noctalia" "msg" "media" "toggle";
        "Mod+bracketleft".action = spawn "noctalia" "msg" "media" "previous";
        "Mod+bracketright".action = spawn "noctalia" "msg" "media" "next";

        # Brightness control
        "XF86MonBrightnessUp".action = spawn "noctalia" "msg" "brightness-up";
        "XF86MonBrightnessDown".action = spawn "noctalia" "msg" "brightness-down";
      };

      hotkey-overlay.skip-at-startup = true;
    };
  };
}
