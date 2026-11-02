{ pkgs, ... }:
# Desktop shortcuts for the mihomo service (modules/mihomo.nix). Both scripts
# talk to the local REST API, so they never need root and take effect instantly.
let
  api = "http://127.0.0.1:9091";

  # Noctalia owns org.freedesktop.Notifications on this desktop; a plain
  # dbus-send keeps the scripts independent of any notifier package.
  notify = pkgs.writeShellScript "mihomo-notify" ''
    exec ${pkgs.dbus}/bin/dbus-send --session --type=method_call \
      --dest=org.freedesktop.Notifications /org/freedesktop/Notifications \
      org.freedesktop.Notifications.Notify \
      string:mihomo uint32:0 string: string:mihomo "string:$1" \
      array:string: dict:string:variant: int32:2500
  '';

  tunToggle = pkgs.writeShellScriptBin "mihomo-tun-toggle" ''
    set -eu
    api=${api}
    json=$(${pkgs.curl}/bin/curl -sf -m 3 "$api/configs") || {
      ${notify} "mihomo 未运行"
      exit 1
    }
    if printf '%s' "$json" | ${pkgs.jq}/bin/jq -e '.tun.enable == true' >/dev/null; then
      want=false
      msg="TUN 已关闭"
    else
      want=true
      msg="TUN 已开启"
    fi
    ${pkgs.curl}/bin/curl -sf -m 5 -X PATCH "$api/configs" \
      -H 'Content-Type: application/json' \
      -d "{\"tun\":{\"enable\":$want}}" >/dev/null
    ${notify} "$msg"
  '';

  # niri has no OS-level proxy setting (GLib ships no GNOME proxy resolver
  # module here, so gsettings proxy keys would be inert). "System proxy" is
  # therefore the routing switch: direct bypasses every proxy, rule sends
  # traffic through the subscription's rules again.
  proxyToggle = pkgs.writeShellScriptBin "mihomo-proxy-toggle" ''
    set -eu
    api=${api}
    json=$(${pkgs.curl}/bin/curl -sf -m 3 "$api/configs") || {
      ${notify} "mihomo 未运行"
      exit 1
    }
    mode=$(printf '%s' "$json" | ${pkgs.jq}/bin/jq -r '.mode')
    if [ "$mode" = "Direct" ] || [ "$mode" = "direct" ]; then
      new=rule
      msg="代理：规则模式"
    else
      new=direct
      msg="代理：直连模式"
    fi
    ${pkgs.curl}/bin/curl -sf -m 5 -X PATCH "$api/configs" \
      -H 'Content-Type: application/json' \
      -d "{\"mode\":\"$new\"}" >/dev/null
    ${notify} "$msg"
  '';
in
{
  home.packages = [
    tunToggle
    proxyToggle
  ];
}
