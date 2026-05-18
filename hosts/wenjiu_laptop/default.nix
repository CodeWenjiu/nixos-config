# Host entry point for wenjiu laptop.
# Imports hardware config + shared configuration + host-specific modules.
# Host-specific settings (hostname, users, keyboard, bluetooth, etc.) are declared here.
{ pkgs, config, lib, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../configuration.nix

    ../../platform/intel.nix
    ../../modules/data-mount.nix
  ];

  networking.hostName = "wenjiu";
  time.timeZone = "Asia/Hong_Kong";
  system.stateVersion = "25.05";

  services.getty.autologinUser = "wenjiu";

  users.users.wenjiu = {
    isNormalUser = true;
    description = "wenjiu";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "dialout"
      "embedded"
      "disk"
      "storage"
    ];
    shell = pkgs.nushell;
  };

  services.xserver.xkb = {
    layout = "cn";
    variant = "";
  };

  hardware.bluetooth.enable = true;

  # Lid close behavior — set per-host
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };
}
