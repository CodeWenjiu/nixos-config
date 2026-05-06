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

  # Permissions handled above by systemd.tmpfiles.rules

  # Enable ACL support for better file permissions
  boot.kernelModules = [ "ext4" ];

  # Ensure the user has access to necessary groups for gaming
  users.users.wenjiu.extraGroups = lib.mkAfter [
    "disk"
    "storage"
  ];
}
