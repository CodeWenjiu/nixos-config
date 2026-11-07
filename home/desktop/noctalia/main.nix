{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
    ./niri.nix
  ];

  home.packages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default

    gpu-screen-recorder
    mpvpaper
    wf-recorder
    cava
    cliphist
    wlsunset

    bibata-cursors
    papirus-icon-theme

    xwayland-satellite
  ];

  # mpv-hook.lua: auto-sync video wallpaper colors to noctalia theme
  xdg.configFile."mpv/scripts/mpv-hook.lua".source = ./mpv-hook.lua;

  # Noctalia plugin source for the mihomo status widget. A path source keeps
  # the plugin Nix-managed and read-only for Noctalia.
  xdg.configFile."noctalia-plugins/mihomo-status".source = ./plugins/mihomo-status;

  programs.noctalia = {
    enable = true;
    systemd.enable = false;
    # Use the exported GUI config directly as a TOML file
    settings = ./config.toml;
  };
}
