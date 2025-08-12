{ pkgs, ... }:
{
  # Enable polkit for authentication
  security.polkit.enable = true;

  # Enable gnome-keyring for credential storage
  services.gnome.gnome-keyring.enable = true;

  # Enable the keyring daemon in user sessions
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.passwd.enableGnomeKeyring = true;

  # Ensure keyring is unlocked on login
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  # Install necessary packages
  environment.systemPackages = with pkgs; [
    gnome-keyring
    seahorse # GUI for keyring management
    libsecret # Required for many applications
  ];

  # Enable D-Bus session services
  services.dbus.packages = with pkgs; [
    gnome-keyring
  ];

  # Configure environment variables for keyring
  environment.variables = {
    GNOME_KEYRING_CONTROL = "/run/user/1000/keyring";
    # Ensure apps know about the secret service
    SECRET_BACKEND = "gnome-keyring";
  };

  # The gnome-keyring service is automatically managed by the system
  # when services.gnome.gnome-keyring.enable = true is set
}
