{
  pkgs,
  ...
}:
{
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;
  programs.xwayland.enable = true;

  # Enable the waylane Desktop Environment.
  services.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = false;

  programs.niri.enable = true;
  # noctalia-shell systemd service is deprecated — now spawned from niri's spawn-at-startup
  programs.gpu-screen-recorder.enable = true;

  # https://github.com/Keyitdev/sddm-astronaut-theme/issues/51
  services.displayManager = {
    sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;
      wayland = {
        enable = true;
      };
      autoNumlock = true;
      enableHidpi = true;
      theme = "where_is_my_sddm_theme";
      settings = {
        Theme = {
          Current = "where_is_my_sddm_theme";
          CursorTheme = "Bibata-Modern";
          CursorSize = 24;
        };
      };
      extraPackages = [
        pkgs.where-is-my-sddm-theme
      ];
    };
  };
  # ACPI
  environment.systemPackages = with pkgs; [
    kdePackages.qtmultimedia
    where-is-my-sddm-theme

    acpi
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
  ];

  # XDG Portal configuration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    config = {
      common = {
        default = [
          "wls"
          "gtk"
        ];
      };
      niri = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = "gnome";
        "org.freedesktop.impl.portal.Screenshot" = "gnome";
      };
    };
  };

  services.acpid = {
    enable = true;
  };

  # Enable UPower for battery management
  services.upower = {
    enable = true;
  };

  services.logind = {
    settings = {
      Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "suspend";
        HandlePowerKey = "poweroff";
        HandlePowerKeyLongPress = "poweroff";
      };
    };
  };
  services.udev.extraRules = ''
    SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_INPUT_SWITCH}=="1", ENV{SWITCH_STATE}=="1", RUN+="${pkgs.xset}/bin/xset dpms force off"
  '';

  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "1800";
    SuspendState = "mem";
    SuspendMode = "platform";
  };

  environment.variables = {
    NIXOS_OZONE_WL = "1"; # cause vsc warn for https://github.com/NixOS/nixpkgs/issues/271461
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    ELECTRON_ENABLE_WAYLAND = "1";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.dbus.enable = true;
}
