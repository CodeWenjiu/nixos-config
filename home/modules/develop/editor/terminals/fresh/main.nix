{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    fresh-editor
  ];

  # Standalone config — edit config.json directly
  xdg.configFile."fresh/config.json".source = ./config.json;

  programs.nushell.extraConfig = ''
    $env.EDITOR = "fresh";
  '';
}