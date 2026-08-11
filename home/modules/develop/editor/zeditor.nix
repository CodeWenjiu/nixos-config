{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;

    extraPackages = with pkgs; [
      github-mcp-server
    ];
  };

  # Standalone config files — edit zed-settings.json / zed-keymap.json directly
  xdg.configFile."zed/settings.json".source = ./zed-settings.json;
  xdg.configFile."zed/keymap.json".source = ./zed-keymap.json;

  programs.nushell.extraConfig = ''
    $env.config.buffer_editor = "zeditor";
  '';

  home.packages = with pkgs; [
    package-version-server
  ];
}
