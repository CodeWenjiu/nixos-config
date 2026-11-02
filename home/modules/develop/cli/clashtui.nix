{
  config,
  lib,
  pkgs,
  ...
}:
# Stage 1 of the Clash Verge -> clashtui migration: run a *second*, isolated
# mihomo as a user service on its own ports, with TUN and DNS hijack off, so
# Clash Verge keeps owning :7897, :53 and the default route until this path is
# proven. Nothing here touches the system network stack.
let
  stateDir = "${config.xdg.configHome}/mihomo-tui";
  clashtuiDir = "${config.xdg.configHome}/clashtui";
  overrideDir = "${clashtuiDir}/mihomo";

  # Minimal, direct-only config so the staging core can start before any
  # subscription is imported. clashtui overwrites this file when a profile is
  # selected, which is expected.
  #
  # The disabled tun block is not cosmetic: mihomo reports stack "Mips" when
  # the section is absent, and clashtui 0.3.1 rejects that value while parsing
  # GET /configs, so the TUI would fail before showing anything.
  seedMihomo = pkgs.writeText "mihomo-tui-seed.yaml" ''
    mixed-port: 7898
    allow-lan: false
    mode: rule
    log-level: info
    ipv6: true
    external-controller: 127.0.0.1:9091
    secret: ""
    profile:
      store-selected: true
    tun:
      enable: false
      stack: gvisor
      auto-route: false
    rules:
      - MATCH,DIRECT
  '';

  # Top-level keys clashtui merges into every generated profile. Pinning the
  # ports and the disabled TUN keeps imported subscriptions from colliding
  # with Clash Verge during the coexistence phase.
  seedOverride = pkgs.writeText "mihomo-tui-override.yaml" ''
    external-controller: 127.0.0.1:9091
    mixed-port: 7898
    secret: ""
    tun:
      enable: false
      stack: gvisor
      auto-route: false
  '';

  # clashtui reads controller/mixed-port out of the override file and restarts
  # the unit named here. Kept as plain files (not home.file symlinks) because
  # clashtui rewrites them at runtime.
  seedClashtui = pkgs.writeText "clashtui-config.yaml" ''
    mihomo:
      core:
        config_dir: ${stateDir}
        bin_path: ${config.home.profileDirectory}/bin/mihomo
        config_path: ${stateDir}/config.yaml
      core_service:
        service_name: mihomo-tui
        is_user: true
    singbox:
      core:
        config_dir: ${stateDir}
        bin_path: ${config.home.profileDirectory}/bin/sing-box
        config_path: ${stateDir}/config.json
      core_service:
        service_name: mihomo-tui
        is_user: true
    extra:
      edit_cmd: ""
      open_dir_cmd: ""
  '';
in
{
  home.packages = [
    pkgs.clashtui
    pkgs.mihomo
  ];

  home.activation.clashtuiStaging = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # clashtui only creates its per-core data directories on a first run
    # (no config.yaml yet). A profile directory left by an older release
    # skips that branch, and the TUI then fails at startup with ENOENT while
    # reading the missing profiles/templates directories.
    run mkdir -p ${stateDir} ${clashtuiDir} ${overrideDir} \
      ${overrideDir}/profiles ${overrideDir}/templates \
      ${clashtuiDir}/sing-box/profiles ${clashtuiDir}/sing-box/templates \
      ${clashtuiDir}/sing-box/proxy_providers
    if [ ! -e ${stateDir}/config.yaml ]; then
      run cp ${seedMihomo} ${stateDir}/config.yaml
      run chmod u+w ${stateDir}/config.yaml
    fi
    if [ ! -e ${clashtuiDir}/config.yaml ]; then
      run cp ${seedClashtui} ${clashtuiDir}/config.yaml
      run chmod u+w ${clashtuiDir}/config.yaml
    fi
    if [ ! -e ${overrideDir}/core_override_config.yaml ]; then
      run cp ${seedOverride} ${overrideDir}/core_override_config.yaml
      run chmod u+w ${overrideDir}/core_override_config.yaml
    fi
  '';

  systemd.user.services.mihomo-tui = {
    Unit = {
      Description = "Mihomo staging core for clashtui (no TUN, no DNS hijack)";
    };
    Service = {
      ExecStart = "${pkgs.mihomo}/bin/mihomo -d ${stateDir} -f ${stateDir}/config.yaml";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
