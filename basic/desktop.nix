{ config, pkgs, ... }:
{
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # # Configure keymap in X11
  services.xserver.xkb = {
    layout = "cn";
    variant = "";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # Enable the hyprland Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = false;

  environment.variables = {
    NIXOS_OZONE_WL = "1";
    KITTY_ENABLE_WAYLAND = "1";
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
    # jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.blueman.enable = true;         
  hardware.bluetooth.enable = true;       
  services.dbus.enable = true; 
}
