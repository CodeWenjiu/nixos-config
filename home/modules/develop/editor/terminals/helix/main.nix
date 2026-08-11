{ pkgs, ... }:
{
  home.packages = with pkgs; [
    helix
  ];

  # Standalone config — edit config.toml directly
  xdg.configFile."helix/config.toml".source = ./config.toml;

  programs.nushell.extraConfig = ''
    $env.EDITOR = "hx";
  '';
}
