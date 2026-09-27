// Managed by nixos-config (home/desktop/clash-verge/Script.js) - this is the
// global Clash Verge "Script" profile, so it runs on *every* config
// generation: subscription updates, profile switches and GUI edits all keep
// these injections. Edit it in the repo, not in the Clash Verge GUI.
//
// Keep this file defensive. If it throws, Clash Verge refuses to apply the new
// config and keeps running the previous one, which is louder (and safer) than
// silently applying a config without the tailnet fixes.

function main(config, profileName) {
  // 1. Rules that must not ride the subscription's routing.
  var direct = [
    // Tailscale's control plane and DERP servers are ordinary internet
    // traffic. Without a rule they fall into the catch-all proxy group, so
    // with TUN on they would be tunnelled through the subscription's node.
    'DOMAIN-SUFFIX,tailscale.com,DIRECT',
    'DOMAIN-SUFFIX,tailscale.io,DIRECT',
    // Personal model relay on Zeabur. It answers with different ingress IPs
    // depending on the resolver: CN resolvers (and mihomo's own, with the
    // policy below) return a Tencent IP that is fine to reach directly, while
    // the relay nodes' overseas resolvers return Azure JP addresses that are
    // not directly reachable from here - and that the nodes themselves
    // intermittently fail to dial ("dial tcp 20.x:443: i/o timeout"). Without
    // a rule it rides the catch-all group, so under TUN a model request dies
    // whenever the auto-selected node cannot reach the Azure answer.
    'DOMAIN-SUFFIX,xin1122.zeabur.app,DIRECT',
  ];
  var rules = (config.rules || []).filter(function (r) {
    return direct.indexOf(r) === -1;
  });
  config.rules = direct.concat(rules);

  // 2. Keep the tailnet itself out of mihomo's TUN. The rules already say
  //    DIRECT, but DIRECT means "send it out the physical interface", and only
  //    tailscale0 can reach 100.64.0.0/10 - so with auto-route on, tailnet
  //    traffic is blackholed. (The nix-side `ip rule ... lookup 52` covers the
  //    same ground for MagicDNS; this one keeps mihomo out of it as well.)
  config.tun = config.tun || {};
  config.tun['route-exclude-address'] = ['100.64.0.0/10', 'fd7a:115c:a1e0::/48'];

  // 3. *.ts.net must resolve through MagicDNS (100.100.100.100) instead of the
  //    proxy's DNS, which cannot know tailnet names, and must not become a
  //    fake-ip, or `IP-CIDR,100.64.0.0/10,DIRECT` can never match.
  config.dns = config.dns || {};
  var filters = (config.dns['fake-ip-filter'] || []).filter(function (p) {
    return p !== '*.ts.net';
  });
  filters.push('*.ts.net');
  config.dns['fake-ip-filter'] = filters;
  config.dns['nameserver-policy'] = config.dns['nameserver-policy'] || {};
  config.dns['nameserver-policy']["+.ts.net"] = [
    '100.100.100.100',
    '199.247.155.53',
  ];

  // 4. Drive the relay above straight at its Tencent ingress. mihomo races
  //    all of its nameservers, and 8.8.8.8's global view can return the Azure
  //    addresses that are not reachable directly from here; pinning both the
  //    resolution and the route to the CN side keeps the two consistent.
  config.dns['nameserver-policy']["+.xin1122.zeabur.app"] = [
    'https://doh.pub/dns-query',
    'https://dns.alidns.com/dns-query',
  ];

  return config;
}
