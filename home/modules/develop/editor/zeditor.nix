{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;

    extraPackages = with pkgs; [
      github-mcp-server
    ];

    extensions = [
      "assembly"
      "dockerfile"
      "git-firefly"
      "glsl"
      "html"
      "json"
      "just"
      "just-ls"
      "log"
      "markdown"
      "mcp-server-context7"
      "mcp-server-github"
      "nix"
      "nu"
      "probe-rs"
      "python"
      "rust"
      "scala"
      "scss"
      "toml"
      "typescript"
      "typst"
      "verilog"
      "zig"
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
