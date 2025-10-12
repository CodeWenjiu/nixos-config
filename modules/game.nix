{
  pkgs,
  ...
}:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true; # Enable gamescope session for better performance

    # Enable additional Steam features for external libraries
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # Enable necessary graphics and gaming support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Gaming-related packages
  environment.systemPackages = with pkgs; [
    gamescope
    gamemode
    steam-run
    protontricks
    winetricks
    lutris
    mangohud
    glxinfo
    vulkan-tools
    mesa-demos
    intel-gpu-tools

    waydroid-helper
  ];

  # Environment variables for gaming optimization
  environment.variables = {
    # Intel Arc optimizations
    INTEL_MEDIA_RUNTIME = "ONEVPL";
    LIBVA_DRIVER_NAME = "iHD";
    VDPAU_DRIVER = "va_gl";

    # Vulkan optimizations
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";

    # Steam optimizations
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/wenjiu/.steam/root/compatibilitytools.d";

    # Gaming performance
    __GL_THREADED_OPTIMIZATIONS = "1";
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
  };

  # Enable GameMode optimization
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
        ioprio = 0;
        inhibit_screensaver = 1;
        desiredgov = "performance";
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };

  # android container, see https://nixos.wiki/wiki/WayDroid
  # To use ARM software, see https://github.com/casualsnek/waydroid_script
  # To use Google Plat, see TODO
  virtualisation.waydroid.enable = true;
}
