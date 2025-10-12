{
  pkgs,
  inputs,
  config,
  ...
}:
{

  imports = [
    inputs.noctalia.homeModules.default
    inputs.niri.homeModules.niri
  ];

  home.packages = with pkgs; [
    inputs.noctalia.packages.${system}.default
  ];

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
    settings = {
      spawn-at-startup = [
        { command = [ "noctalia-shell" ]; }
      ];

      binds = with config.lib.niri.actions; {
        "Mod+T".action = spawn "kitty";
        "Mod+R".action = spawn "rofi" "-show" "drun";
      };
    };
  };

  # configure options
  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        density = "compact";
        position = "right";
        showCapsule = false;
        widgets = {
          left = [
            {
              id = "SidePanelToggle";
              useDistroLogo = true;
            }
            {
              id = "WiFi";
            }
            {
              id = "Bluetooth";
            }
          ];
          center = [
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
            }
          ];
          right = [
            {
              alwaysShowPercentage = false;
              id = "Battery";
              warningThreshold = 30;
            }
            {
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              id = "Clock";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
        };
      };
      colorSchemes.predefinedScheme = "Monochrome";
      general = {
        avatarImage = "/home/drfoobar/.face";
        radiusRatio = 0.2;
      };
      location = {
        monthBeforeDay = true;
        name = "Marseille, France";
      };
    };
  };
}
