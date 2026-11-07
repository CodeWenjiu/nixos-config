{
  config,
  lib,
  pkgs,
  ...
}:
# mihomo as a system service, driven by clashtui for profiles, switching and
# service restarts. The service runs as the interactive user so clashtui can
# rewrite the core config without sudo; TUN and :53 privileges come from
# systemd capabilities instead of from running as root.
#
# Two rules cannot be expressed through clashtui's override file (it replaces
# top-level keys instead of merging lists), so a small guard re-adds them
# whenever clashtui regenerates the config: boot time through ExecStartPre and
# runtime through a path unit watching the file.
let
  user = "wenjiu";
  home = config.users.users.${user}.home;
  stateDir = "/var/lib/mihomo";
  configFile = "${stateDir}/config.yaml";
  # First start reuses whatever clashtui generated during the staging phase,
  # so a fresh machine comes up with a working subscription instead of an
  # empty direct-only config.
  stagingConfig = "${home}/.config/mihomo-tui/config.yaml";

  yq = "${pkgs.yq-go}/bin/yq";
  curl = "${pkgs.curl}/bin/curl";

  ruleList = [
    "DOMAIN-SUFFIX,tailscale.com,DIRECT"
    "DOMAIN-SUFFIX,tailscale.io,DIRECT"
    "IP-CIDR,192.200.0.0/24,DIRECT,no-resolve"
    "IP-CIDR6,2606:b740:49::/48,DIRECT,no-resolve"
    "DOMAIN-SUFFIX,xin1122.zeabur.app,DIRECT"
  ];

  # Tailscale must not depend on the proxy. With fake-ip, mihomo hands out a
  # synthetic address for controlplane.tailscale.com and remembers the mapping
  # in memory only. Every mihomo restart therefore invalidated the address
  # tailscaled had cached, the register request timed out, tailscaled reported
  # itself logged out, and the only way back was `tailscale up` minting a new
  # node key - i.e. a fresh browser login.
  #
  # Three settings keep it independent:
  #   * tailscale domains opt out of fake-ip, so the addresses tailscaled
  #     caches stay valid across mihomo restarts;
  #   * the control-plane ranges match DIRECT by IP, since the domain is gone
  #     from the connection once it is a plain address;
  #   * the same ranges are excluded from the TUN, so those packets skip mihomo
  #     entirely and keep working while it is down.
  fakeIpFilter = [
    "+.tailscale.com"
    "+.tailscale.io"
  ];

  routeExclude = [
    "192.200.0.0/24"
    "2606:b740:49::/48"
  ];

  # Rules are prepended in order; filters and exclusions are appended.
  rulesLiteral = builtins.toJSON ruleList;
  fakeIpLiteral = builtins.toJSON fakeIpFilter;
  routeExcludeLiteral = builtins.toJSON routeExclude;

  injectRules =
    reload:
    pkgs.writeShellScript "mihomo-inject-rules" ''
      set -eu
      cfg=${configFile}
      [ -f "$cfg" ] || exit 0

      missing_rules=$(${yq} '(${rulesLiteral} - (.rules // [])) | length' "$cfg")
      missing_filters=$(${yq} '((${fakeIpLiteral}) - (.dns.fake-ip-filter // [])) | length' "$cfg")
      missing_excludes=$(${yq} '((${routeExcludeLiteral}) - (.tun.route-exclude-address // [])) | length' "$cfg")

      if [ "$missing_rules" != "0" ] || [ "$missing_filters" != "0" ] || [ "$missing_excludes" != "0" ]; then
        ${yq} -i '
          .rules = ((${rulesLiteral} - (.rules // [])) + (.rules // []))
          | .dns.fake-ip-filter = ((.dns.fake-ip-filter // []) + (${fakeIpLiteral} - (.dns.fake-ip-filter // [])))
          | (if .tun then .tun.route-exclude-address = ((.tun.route-exclude-address // []) + (${routeExcludeLiteral} - (.tun.route-exclude-address // []))) else . end)
        ' "$cfg"
        ${lib.optionalString reload ''
          # Let the running core pick the patched file up. Harmless when it is
          # not running yet (ExecStartPre path, or a restart in progress).
          ${curl} -sS -m 10 -X PUT "http://127.0.0.1:9091/configs?force=true" \
            -H 'Content-Type: application/json' \
            -d '{"path":"${configFile}","payload":""}' >/dev/null || true
        ''}
      fi
    '';
in
{
  systemd.services.mihomo = {
    description = "Mihomo proxy daemon (clashtui-managed)";
    documentation = [ "https://wiki.metacubex.one/" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = user;
      Group = "users";
      StateDirectory = "mihomo";
      StateDirectoryMode = "0750";
      ExecStart = "${pkgs.mihomo}/bin/mihomo -d ${stateDir} -f ${configFile}";
      ExecStartPre = injectRules false;
      Restart = "on-failure";
      RestartSec = 5;
      NoNewPrivileges = true;

      # TUN device creation, raw sockets and binding dns.listen on :53.
      AmbientCapabilities = [
        "CAP_NET_ADMIN"
        "CAP_NET_RAW"
        "CAP_NET_BIND_SERVICE"
      ];
      CapabilityBoundingSet = [
        "CAP_NET_ADMIN"
        "CAP_NET_RAW"
        "CAP_NET_BIND_SERVICE"
      ];
    };
  };

  # clashtui rewrites config.yaml and reloads through the API, which never
  # reaches ExecStartPre; the path unit covers those live regenerations.
  systemd.services.mihomo-rules = {
    description = "Re-add the DIRECT rules clashtui cannot inject";
    serviceConfig = {
      Type = "oneshot";
      User = user;
      ExecStart = injectRules true;
    };
  };

  systemd.paths.mihomo-rules = {
    wantedBy = [ "multi-user.target" ];
    pathConfig = {
      PathModified = configFile;
      Unit = "mihomo-rules.service";
    };
  };

  # clashtui owns config.yaml afterwards; seed it once and leave it alone.
  system.activationScripts.mihomoSeed = ''
    install -d -o ${user} -g users -m 0750 ${stateDir}
    if [ ! -e ${configFile} ] && [ -e ${stagingConfig} ]; then
      install -o ${user} -g users -m 0600 ${stagingConfig} ${configFile}
    fi
  '';

  # clashtui restarts the core through sudo; only this one unit is delegated.
  # Password prompts would otherwise suspend the TUI mid-operation.
  security.sudo-rs.extraRules = [
    {
      users = [ user ];
      commands = [
        {
          command = "/run/current-system/sw/bin/systemctl start mihomo";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl stop mihomo";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl restart mihomo";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Keep the tailnet on tailscale0 no matter which router grabs the default
  # route. mihomo's TUN (auto-route) installs its ip rules ahead of tailscale's
  # `5270: from all lookup 52`, so packets to 100.64.0.0/10 - tailnet peers and
  # MagicDNS at 100.100.100.100 alike - are pulled into the TUN and blackholed,
  # because only tailscale0 can reach those addresses. A higher-precedence rule
  # that looks the tailnet up in tailscale's table 52 fixes both at once, and
  # since table 52 holds no default route, everything else still falls through
  # to mihomo.
  systemd.services.mihomo-tailnet-bypass = lib.mkIf config.services.tailscale.enable {
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
}
