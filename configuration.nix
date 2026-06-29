# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, ... }:
{
  imports = [
    ./basic/desktop.nix
    ./basic/boot.nix
    ./basic/io.nix

    ./modules/clash.nix
    ./modules/rime.nix
    ./modules/game.nix
    ./modules/keyring.nix
    ./modules/tailscale.nix
  ];

  # Enable networking
  networking.networkmanager.enable = true;

  security.sudo.enable = false;
  security.sudo-rs.enable = true;

  # Enable fingerprint reader
  services.fprintd.enable = true;

  # see https://flatpak.org/setup/NixOS
  services.flatpak.enable = true;

  services.udisks2.enable = true;
  services.gvfs.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [ ];

  # gc
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # flake
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
