{
  pkgs,
  inputs,
  ...
}:
{

  imports = [
    inputs.noctalia.homeModules.default
    ./niri.nix
  ];

  home.packages = with pkgs; [
    inputs.noctalia.packages.${system}.default

    swww
    gpu-screen-recorder
    wf-recorder
    cava
    cliphist
    wlsunset

    bibata-cursors

    xwayland-satellite
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QS_ICON_THEME = "youricontheme";
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
        enableMultiMonitorDirectories = true;
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
        gtk = false;
        qt = false;
        kitty = false;
        ghostty = false;
        foot = false;
        fuzzel = false;
        discord = false;
        discord_vesktop = false;
        discord_webcord = false;
        discord_armcord = false;
        discord_equibop = false;
        discord_lightcord = false;
        discord_dorion = false;
        pywalfox = false;
        enableUserTemplates = true;
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
