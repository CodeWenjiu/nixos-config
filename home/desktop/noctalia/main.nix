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

    swww
    gpu-screen-recorder
    cava

    bibata-cursors

    xwayland-satellite
  ];

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
    settings = {
      window-rules = [
        {
          draw-border-with-background = false;
          clip-to-geometry = true;
          geometry-corner-radius = {
            bottom-left = 12.0;
            bottom-right = 12.0;
            top-left = 12.0;
            top-right = 12.0;
          };
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
    };
  };

  # configure options
  programs.noctalia-shell = {
    enable = true;
    settings = {
      settingsVersion = 15;
      bar = {
        position = "top";
        backgroundOpacity = 0.5;
        monitors = [ ];
        density = "default";
        showCapsule = true;
        floating = true;
        marginVertical = 0.25;
        marginHorizontal = 0.25;
        widgets = {
          left = [
            {
              id = "SystemMonitor";
            }
            {
              id = "ActiveWindow";
            }
            {
              id = "MediaMini";
            }
          ];
          center = [
            {
              id = "Workspace";
            }
          ];
          right = [
            {
              id = "ScreenRecorder";
            }
            {
              id = "Tray";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "WiFi";
            }
            {
              id = "NotificationHistory";
            }
            {
              id = "Battery";
            }
            {
              id = "Volume";
            }
            {
              id = "Brightness";
            }
            {
              id = "Clock";
            }
            {
              id = "ControlCenter";
            }
          ];
        };
      };
      general = {
        avatarImage = "/mnt/data/AvatarImage/avatar.png";
        dimDesktop = true;
        showScreenCorners = false;
        forceBlackScreenCorners = false;
        radiusRatio = 1;
        screenRadiusRatio = 1;
        animationSpeed = 1;
        animationDisabled = false;
      };
      location = {
        name = "GuangDong";
        useFahrenheit = false;
        use12hourFormat = false;
        showWeekNumberInCalendar = true;
      };
      screenRecorder = {
        directory = "/mnt/data/recordings";
        frameRate = 60;
        audioCodec = "opus";
        videoCodec = "h264";
        quality = "very_high";
        colorRange = "limited";
        showCursor = true;
        audioSource = "default_output";
        videoSource = "portal";
      };
      wallpaper = {
        enabled = true;
        directory = "/mnt/data/wallpapers";
        enableMultiMonitorDirectories = false;
        setWallpaperOnAllMonitors = true;
        defaultWallpaper = "/mnt/data/wallpapers/1.png";
        fillMode = "crop";
        fillColor = "#000000";
        randomEnabled = false;
        randomIntervalSec = 60;
        transitionDuration = 1500;
        transitionType = "random";
        transitionEdgeSmoothness = 0.05;
        monitors = [ ];
      };
      appLauncher = {
        enableClipboardHistory = true;
        position = "top";
        backgroundOpacity = 1;
        pinnedExecs = [ ];
        useApp2Unit = false;
        sortByMostUsed = true;
        terminalCommand = "ghostty -e";
      };
      controlCenter = {
        position = "close_to_bar_button";
        quickSettingsStyle = "compact";
        widgets = {
          quickSettings = [
            {
              id = "WiFi";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "Notifications";
            }
            {
              id = "ScreenRecorder";
            }
            {
              id = "PowerProfile";
            }
            {
              id = "WallpaperSelector";
            }
          ];
        };
      };
      dock = {
        displayMode = "always_visible";
        backgroundOpacity = 1;
        floatingRatio = 1;
        onlySameOutput = true;
        monitors = [ ];
        pinnedApps = [ ];
      };
      network = {
        wifiEnabled = true;
      };
      notifications = {
        doNotDisturb = false;
        monitors = [ ];
        location = "top_right";
        alwaysOnTop = false;
        lastSeenTs = 0;
        respectExpireTimeout = false;
        lowUrgencyDuration = 3;
        normalUrgencyDuration = 8;
        criticalUrgencyDuration = 15;
      };
      osd = {
        enabled = true;
        location = "top_right";
        monitors = [ ];
        autoHideMs = 2000;
      };
      audio = {
        volumeStep = 5;
        volumeOverdrive = true;
        cavaFrameRate = 60;
        visualizerType = "linear";
        mprisBlacklist = [ ];
        preferredPlayer = "";
      };
      ui = {
        fontDefault = "Inter";
        fontFixed = "JetBrains Mono";
        fontDefaultScale = 1;
        fontFixedScale = 1;
        monitorsScaling = [ ];
        idleInhibitorEnabled = false;
        tooltipsEnabled = true;
      };
      brightness = {
        brightnessStep = 5;
      };
      colorSchemes = {
        useWallpaperColors = true;
        predefinedScheme = "Noctalia (default)";
        darkMode = true;
        matugenSchemeType = "scheme-fruit-salad";
        generateTemplatesForPredefined = true;
      };
      templates = {
        gtk = true;
        qt = true;
        kitty = false;
        ghostty = true;
        foot = false;
        fuzzel = false;
        discord = true;
        discord_vesktop = true;
        discord_webcord = true;
        discord_armcord = true;
        discord_equibop = true;
        discord_lightcord = true;
        discord_dorion = true;
        pywalfox = false;
        enableUserTemplates = false;
      };
      nightLight = {
        enabled = false;
        forced = false;
        autoSchedule = true;
        nightTemp = "4000";
        dayTemp = "6500";
        manualSunrise = "06:30";
        manualSunset = "18:30";
      };
      hooks = {
        enabled = false;
        wallpaperChange = "";
        darkModeChange = "";
      };
    };
  };
}
