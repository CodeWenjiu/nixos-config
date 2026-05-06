{ ... }:

{
  # Ensure /mnt/data has correct permissions for the user
  systemd.tmpfiles.rules = [
    "d /mnt/data 0755 wenjiu users - -"
    "d /mnt/data/SteamLibrary 0755 wenjiu users - -"
    "d /mnt/data/Games 0755 wenjiu users - -"
  ];

  # Permissions handled above by systemd.tmpfiles.rules

  boot.kernelModules = [ "ext4" ];
}
