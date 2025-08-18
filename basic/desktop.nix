{
  pkgs,
  desktop_manager,
  ...
}:
let
  custom-sddm-astronaut = pkgs.sddm-astronaut.override {
    # embeddedTheme = "purple_leaves";
    # embeddedTheme = "pixel_sakura";
    embeddedTheme = "hyprland_kath";
    themeConfig = {
      # see https://github.com/Keyitdev/sddm-astronaut-theme/tree/master/Themes
      AllowUppercaseLettersInUsernames = "true";
    };
  };
in
{
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;

  # # Configure keymap in X11
  services.xserver.xkb = {
    layout = "cn";
    variant = "";
  };

  # # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # Enable the waylane Desktop Environment.
  services.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = false;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  # UWSM configuration for proper session management
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };
  };
  # services.desktopManager.cosmic = {
  #   enable = true;
  #   xwayland.enable = true;
  # };
  # services.displayManager.cosmic-greeter.enable = true;

  # https://github.com/Keyitdev/sddm-astronaut-theme/issues/51
  services.displayManager = {
    defaultSession = "hyprland-uwsm";
    sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;
      wayland = {
        enable = true;
      };
      autoNumlock = true;
      enableHidpi = true;
      theme = "sddm-astronaut-theme";
      settings = {
        Theme = {
          Current = "sddm-astronaut-theme";
          CursorTheme = "Bibata-Modern-Ice";
          CursorSize = 24;
        };
      };
      extraPackages = [
        custom-sddm-astronaut
      ];
    };
  };
  # ACPI
  environment.systemPackages = with pkgs; [
    custom-sddm-astronaut
    kdePackages.qtmultimedia

    acpi

    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
  ];

  # XDG Portal configuration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # Use GTK portal for file dialogs and other general functions
    # Use Hyprland portal for screenshots and screen sharing
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
        # Hyprland-specific portals
        "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
      };
    };
  };

  services.acpid = {
    enable = true;
  };

  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
    powerKey = "suspend";
    powerKeyLongPress = "poweroff";

    extraConfig = ''
      HandleLidSwitch=suspend
      HandleLidSwitchExternalPower=suspend
      HandleLidSwitchDocked=ignore
      LidSwitchIgnoreInhibited=yes
      HoldoffTimeoutSec=10
      IdleAction=ignore
      IdleActionSec=30min
    '';
  };
  services.udev.extraRules = ''
    SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_INPUT_SWITCH}=="1", ENV{SWITCH_STATE}=="1", RUN+="${pkgs.xorg.xset}/bin/xset dpms force off"
  '';

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1800
    SuspendState=mem
    SuspendMode=platform
  '';

  environment.variables = {
    NIXOS_OZONE_WL = "1"; # cause vsc warn for https://github.com/NixOS/nixpkgs/issues/271461
    KITTY_ENABLE_WAYLAND = "1";
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

  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  services.dbus.enable = true;
}
