# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ ... }:
{
  imports = [
    ./basic/desktop.nix
    ./basic/console.nix
    ./basic/fonts.nix
    ./basic/boot.nix
    ./basic/io.nix

    ./modules/mihomo.nix
    ./modules/game.nix
    ./modules/keyring.nix
    ./modules/tailscale.nix
  ];

  i18n.defaultLocale = "zh_CN.UTF-8";

  # Enable networking
  networking.networkmanager.enable = true;

  security.sudo.enable = false;
  security.sudo-rs.enable = true;

  # Fingerprint reader — for noctalia lock screen (SDDM keeps password-only)
  services.fprintd.enable = true;

  # Disable fingerprint for sudo & tty login (password only)
  security.pam.services.sudo.fprintAuth = false;
  security.pam.services.login.fprintAuth = false;

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
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # 国内二进制缓存镜像（TUNA），官方源兜底。
    # 镜像内容与官方 cache.nixos.org 签名一致，无需额外信任 key。
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
      # niri-unstable 的二进制缓存（epireyn/niri-flake 提供，仅 x86_64-linux）
      "https://niri-epireyn.cachix.org"
    ];

    # 与默认值（cache.nixos.org）按列表拼接，不会覆盖默认信任。
    trusted-public-keys = [
      "niri-epireyn.cachix.org-1:tlVyFN7CtsDT+ZcLPS+ekFWeT1X6X4OqvWqbBMyIzFA="
    ];
  };

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
