{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    vscode
    vim
  ];

  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
      ];
      userSettings = {
        "editor.fontSize" = 14;
        "editor.fontFamily" = "'JetBrains Mono', 'Droid Sans Mono', monospace";
        "workbench.colorTheme" = "Dracula";
        "workbench.iconTheme" = "material-icon-theme";
      };
    };
  };
}