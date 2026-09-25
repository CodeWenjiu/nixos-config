{
  config,
  lib,
  pkgs,
  ...
}:
let
  proxy = "http://127.0.0.1:7897";
  # Tailnet, loopback and LAN must never go through the proxy.
  noProxy = lib.concatStringsSep "," [
    "localhost"
    "127.0.0.1"
    "::1"
    ".ts.net" # MagicDNS names
    "100.64.0.0/10" # tailnet + MagicDNS
    "10.0.0.0/8"
    "172.16.0.0/12"
    "192.168.0.0/16"
  ];
in
{
  # Clash Verge's "system proxy" only reaches applications that read dconf's
  # GNOME proxy keys (GTK/libsoup); browsers keep their own settings and
  # everything else - curl, git, electron apps - needs it in the environment.
  environment.variables = {
    HTTP_PROXY = proxy;
    HTTPS_PROXY = proxy;
    http_proxy = proxy;
    https_proxy = proxy;
    ALL_PROXY = "socks5://127.0.0.1:7897";
    all_proxy = "socks5://127.0.0.1:7897";
    NO_PROXY = noProxy;
    no_proxy = noProxy;
  };

  programs.clash-verge = {
    enable = true;
    autoStart = true;
    serviceMode = true;
    tunMode = true;
  };

  # Keep the tailnet on tailscale0 no matter which router grabs the default
  # route. mihomo's TUN (auto-route) installs its ip rules ahead of tailscale's
  # `5270: from all lookup 52`, so packets to 100.64.0.0/10 - tailnet peers and
  # MagicDNS at 100.100.100.100 alike - are pulled into the TUN and blackholed,
  # because only tailscale0 can reach those addresses. A higher-precedence rule
  # that looks the tailnet up in tailscale's table 52 fixes both at once, and
  # since table 52 holds no default route, everything else still falls through
  # to mihomo. (`Script.js` in home/desktop/clash-verge covers the same ground
  # from mihomo's side and adds the tailscale.com DIRECT rules.)
  systemd.services = lib.mkIf (config.programs.clash-verge.enable && config.services.tailscale.enable) {
    clash-tailnet-bypass = {
      description = "Pin tailnet traffic to tailscale0 (survives TUN-based routers)";
      wantedBy = [ "multi-user.target" ];
      after = [ "tailscaled.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ${pkgs.iproute2}/bin/ip rule del to 100.64.0.0/10 lookup 52 priority 1000 2>/dev/null || true
        ${pkgs.iproute2}/bin/ip rule add to 100.64.0.0/10 lookup 52 priority 1000
        ${pkgs.iproute2}/bin/ip -6 rule del to fd7a:115c:a1e0::/48 lookup 52 priority 1000 2>/dev/null || true
        ${pkgs.iproute2}/bin/ip -6 rule add to fd7a:115c:a1e0::/48 lookup 52 priority 1000
      '';
    };

    # mihomo runs as root under clash-verge.service, but the unit's
    # CapabilityBoundingSet from nixpkgs omits CAP_NET_BIND_SERVICE, so
    # `dns.listen: :53` fails with EACCES - it has been failing on every start
    # in the logs since 2025-08, which is why nothing ever listened on :53.
    # List-valued options merge, so this appends to the module's set.
    clash-verge.serviceConfig.CapabilityBoundingSet =
      lib.mkIf config.programs.clash-verge.serviceMode [ "CAP_NET_BIND_SERVICE" ];
  };
}
