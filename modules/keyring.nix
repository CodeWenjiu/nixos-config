{ pkgs, ... }:
{
  # Enable gnome-keyring for credential storage
  services.gnome.gnome-keyring.enable = true;

  # Enable the keyring daemon in user sessions
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.passwd.enableGnomeKeyring = true;

  # Ensure keyring is unlocked on login
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  # Install gnome-keyring at system level (needed for D-Bus service)
  # libsecret and seahorse are installed at user level via home/modules/essential/keyring.nix
  environment.systemPackages = with pkgs; [
    gnome-keyring
  ];

  # Enable D-Bus session services
  services.dbus.packages = with pkgs; [
    gnome-keyring
  ];

  # GNOME_KEYRING_CONTROL and SSH_AUTH_SOCK are automatically set
  # by PAM when gnome-keyring is enabled (see security.pam.services above).
  # No need to hardcode UID-based paths here.
  environment.variables = {
    SECRET_BACKEND = "gnome-keyring";
  };

  # The gnome-keyring service is automatically managed by the system
  # when services.gnome.gnome-keyring.enable = true is set
}
