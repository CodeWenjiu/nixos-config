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
    ./modules/horizon-launcher.nix
    ./modules/rigili.nix
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

    # 官方源优先。TUNA 镜像缺不少 NAR（构建时见过 “does not exist in binary
    # cache”），放第一位会让每个缺失的路径都多问一次，而且它的连接更容易
    # stalled。国内直连官方源在这里实际走 mihomo 代理，够快。
    substituters = [
      "https://cache.nixos.org"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # niri-unstable 的二进制缓存（epireyn/niri-flake 提供，仅 x86_64-linux）
      "https://niri-epireyn.cachix.org"
    ];

    # 默认 stalled-download-timeout 是 300 秒、download-attempts 是 5：一条连上了
    # 但对面不回数据的连接会让 nix 静默等 5 分钟，期间屏幕一动不动，看着像卡死；
    # 算上重试要 25 分钟才报错。收紧到 30 秒 / 3 次，卡住就重连。
    connect-timeout = 5;
    stalled-download-timeout = 30;
    download-attempts = 3;

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
