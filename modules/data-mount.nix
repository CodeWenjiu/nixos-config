{
  pkgs,
  lib,
  ...
}:

{
  # Ensure /mnt/data has correct permissions for the user
  systemd.tmpfiles.rules = [
    "d /mnt/data 0755 wenjiu users - -"
    "d /mnt/data/SteamLibrary 0755 wenjiu users - -"
    "d /mnt/data/Games 0755 wenjiu users - -"
  ];

  # Alternative: use a systemd service to set permissions after mount
  systemd.services.setup-data-permissions = {
    description = "Setup permissions for /mnt/data";
    after = [ "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "setup-data-permissions" ''
        # Wait for mount to be available
        if [ -d /mnt/data ]; then
          # Change ownership of the data directory to user
          ${pkgs.coreutils}/bin/chown wenjiu:users /mnt/data
          ${pkgs.coreutils}/bin/chmod 755 /mnt/data

          # Create Steam library directory if it doesn't exist
          if [ ! -d /mnt/data/SteamLibrary ]; then
            ${pkgs.coreutils}/bin/mkdir -p /mnt/data/SteamLibrary
            ${pkgs.coreutils}/bin/chown wenjiu:users /mnt/data/SteamLibrary
            ${pkgs.coreutils}/bin/chmod 755 /mnt/data/SteamLibrary
          fi

          # Create general Games directory if it doesn't exist
          if [ ! -d /mnt/data/Games ]; then
            ${pkgs.coreutils}/bin/mkdir -p /mnt/data/Games
            ${pkgs.coreutils}/bin/chown wenjiu:users /mnt/data/Games
            ${pkgs.coreutils}/bin/chmod 755 /mnt/data/Games
          fi

          echo "Data directory permissions setup completed"
        else
          echo "Warning: /mnt/data is not mounted"
          exit 1
        fi
      '';
    };
  };

  # Enable ACL support for better file permissions
  boot.kernelModules = [ "ext4" ];

  # Ensure the user has access to necessary groups for gaming
  users.users.wenjiu.extraGroups = lib.mkAfter [
    "disk"
    "storage"
  ];
}
