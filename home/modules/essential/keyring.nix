{ pkgs, ... }:
{
  # Enable keyring services at user level
  services.gnome-keyring = {
    enable = true;
    components = [
      "secrets"
      "ssh"
    ];
  };

  # Install keyring packages
  home.packages = with pkgs; [
    libsecret # For secret storage
    seahorse # GUI keyring manager (optional)
  ];

  # GNOME_KEYRING_CONTROL and SSH_AUTH_SOCK are automatically set
  # by the gnome-keyring PAM module (services.gnome-keyring at home level).
  # Hardcoding /run/user/<uid>/keyring is fragile — UID is not guaranteed to be 1000.
  home.sessionVariables = {
    SECRET_BACKEND = "gnome-keyring";
  };

  # Enable keyring unlock on login via PAM
  # The system-level keyring service will handle the daemon
}
