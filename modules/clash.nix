{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Deliberately no HTTP_PROXY/ALL_PROXY environment variables: a static
  # proxy address makes every process that inherits it (curl, git, Zed,
  # Electron apps) depend on the core staying up. Clash Verge's exit stops
  # the core and closes the mixed port, and those processes then keep
  # dialling 127.0.0.1:7897 - the machine reads as "no network" until clash
  # is started again. While clash runs, TUN mode covers transparent routing,
  # and Clash Verge's own "system proxy" toggle covers GUI apps (it resets
  # that toggle on exit itself). Export proxies per-shell when they are
  # wanted, e.g. `export HTTPS_PROXY=http://127.0.0.1:7897`.
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
