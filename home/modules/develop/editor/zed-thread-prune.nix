{
  pkgs,
  ...
}:
let
  # Bound the size of Zed's stored agent-thread history. Each thread is one
  # zstd blob that gets decompressed in full whenever its workspace opens, so
  # a thread that keeps growing turns into a multi-second workspace-open.
  # Zed has no setting for this (compaction only shrinks what the model sees),
  # so the prune script (see zed-thread-prune.js) trims old, oversized threads,
  # archives what it drops, and never touches a thread idle for under a week.
  # Run `zed-thread-prune --dry-run` to see what it would do.
  zed-thread-prune = pkgs.writeShellApplication {
    name = "zed-thread-prune";
    runtimeInputs = [ pkgs.nodejs ];
    text = ''
      exec node ${./zed-thread-prune.js} "$@"
    '';
  };
in
{
  home.packages = [ zed-thread-prune ];

  systemd.user.services.zed-thread-prune = {
    Unit.Description = "Prune old, oversized Zed agent threads";
    Service = {
      Type = "oneshot";
      ExecStart = "${zed-thread-prune}/bin/zed-thread-prune";
    };
  };

  systemd.user.timers.zed-thread-prune = {
    Unit.Description = "Daily Zed agent-thread prune";
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "30m";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
