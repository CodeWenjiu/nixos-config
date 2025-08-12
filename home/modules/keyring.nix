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

  # Set up environment variables for applications
  home.sessionVariables = {
    GNOME_KEYRING_CONTROL = "/run/user/1000/keyring";
    SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
    SECRET_BACKEND = "gnome-keyring";
  };

  # Enable keyring unlock on login via PAM
  # The system-level keyring service will handle the daemon
}
