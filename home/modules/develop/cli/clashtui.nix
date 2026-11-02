{
  config,
  lib,
  pkgs,
  ...
}:
# Stage 2a: clashtui now fronts the system-wide mihomo service defined in
# modules/mihomo.nix. It still runs on the staging ports and with TUN off, so
# Clash Verge keeps owning :7897 and the default route until the cutover.
#
# clashtui rewrites these files at runtime, so they must stay plain files:
# a home.file symlink would make every save fail with EROFS.
let
  clashtuiDir = "${config.xdg.configHome}/clashtui";
  overrideDir = "${clashtuiDir}/mihomo";

  seedClashtui = pkgs.writeText "clashtui-config.yaml" ''
    mihomo:
      core:
        config_dir: /var/lib/mihomo
        bin_path: ${config.home.profileDirectory}/bin/mihomo
        config_path: /var/lib/mihomo/config.yaml
      core_service:
        service_name: mihomo
        is_user: false
    singbox:
      core:
        config_dir: /var/lib/mihomo
        bin_path: ${config.home.profileDirectory}/bin/mihomo
        config_path: /var/lib/mihomo/config.json
      core_service:
        service_name: mihomo
        is_user: false
    extra:
      edit_cmd: ""
      open_dir_cmd: ""
  '';

  # Top-level keys clashtui merges into every generated profile. The gvisor
  # stack is pinned even while TUN is off: mihomo reports stack "Mips" for an
  # absent tun section, and clashtui 0.3.1 refuses to parse that value.
  seedOverride = pkgs.writeText "mihomo-override.yaml" ''
    external-controller: 127.0.0.1:9091
    mixed-port: 7898
    secret: ""
    profile:
      store-selected: true
    tun:
      enable: false
      stack: gvisor
      auto-route: false
  '';
in
{
  home.packages = [
    pkgs.clashtui
    pkgs.mihomo
  ];

  home.activation.clashtuiConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # clashtui only creates its per-core data directories on a first run (no
    # config.yaml yet). A config left by an older release skips that branch,
    # and the TUI then dies at startup with ENOENT while reading the missing
    # profiles/templates directories.
    run mkdir -p ${clashtuiDir} ${overrideDir} \
      ${overrideDir}/profiles ${overrideDir}/templates \
      ${clashtuiDir}/sing-box/profiles ${clashtuiDir}/sing-box/templates \
      ${clashtuiDir}/sing-box/proxy_providers
    if [ ! -e ${clashtuiDir}/config.yaml ]; then
      run cp ${seedClashtui} ${clashtuiDir}/config.yaml
      run chmod u+w ${clashtuiDir}/config.yaml
    fi
    if [ ! -e ${overrideDir}/core_override_config.yaml ]; then
      run cp ${seedOverride} ${overrideDir}/core_override_config.yaml
      run chmod u+w ${overrideDir}/core_override_config.yaml
    fi
  '';
}
