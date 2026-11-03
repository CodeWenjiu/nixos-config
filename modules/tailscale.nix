{ pkgs, ... }:
let
  # The dsh Web UI (home/modules/develop/editor/vibe.nix) listens on
  # loopback:3080. Publishing it through tailscaled keeps the listener on
  # loopback and leaves the firewall alone, and the --bg config survives
  # reboots, so this unit only exists to make a fresh install reproducible.
  dshWebPort = 3080;
  servePort = 8080;
in
{
  services.tailscale.enable = true;

  systemd.services.tailscale-serve-dsh-web = {
    description = "Publish the dsh Web UI through tailscale serve";
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      # At boot this races tailscaled being logged in; retry until it works.
      Restart = "on-failure";
      RestartSec = 10;
    };
    script = ''
      set -eu
      # Serve config survives tailscaled restarts, so only install it when the
      # port is not already published (re-running would fail with EADDRINUSE).
      if ! ${pkgs.tailscale}/bin/tailscale serve status 2>/dev/null \
        | grep -q ":${toString servePort}"; then
        ${pkgs.tailscale}/bin/tailscale serve --bg --http=${toString servePort} ${toString dshWebPort}
      fi
    '';
  };
}
