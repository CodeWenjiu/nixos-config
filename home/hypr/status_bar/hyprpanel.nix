{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprpanel
  ];

  programs.hyprpanel = {
    # Configure and theme almost all options from the GUI.
    # See 'https://hyprpanel.com/configuration/settings.html'.
    # Default: <same as gui>
    settings = {

      # Configure bar layouts for monitors.
      # See 'https://hyprpanel.com/configuration/panel.html'.
      # Default: null
      layout = {
        bar.layouts = {
          "0" = {
            left = [ "dashboard" "workspaces" ];
            middle = [ "media" ];
            right = [ "volume" "systrayed" "notifications" ];
          };
        };
      };

      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;
      bar.workspaces.show_numbered = false;
      bar.workspaces.workspaceMask = false;
      bar.workspaces.showWsIcons = true;
      bar.workspaces.showApplicationIcons = true;

      bar.battery.label = true;
      bar.battery.hideLabelWhenFull = true;

      menus.clock = {
        time = {
          military = true;
          hideSeconds = true;
        };
        weather.unit = "metric";
      };

      menus.dashboard.directories.enabled = true;
      menus.dashboard.stats.enable_gpu = true;
      menus.power.lowBatteryNotification =  true;
      menus.transitionTime = 100;

      theme.bar.menus.enableShadow = true;
      theme.bar.floating = true;
      theme.bar.buttons.enableBorders = true;
      theme.bar.transparent = true;

      theme.font = {
        size = "1.0rem";
        name = "CaskaydiaCove NF";
      };
    };
  };
}
