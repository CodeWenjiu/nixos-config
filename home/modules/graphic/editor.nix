{ config, pkgs, ... }:
{
    programs.vscode = {
        enable = true;
        package = pkgs.vscode;
        profiles.default = {
            extensions = with pkgs.vscode-extensions; [
                rust-lang.rust-analyzer
            ];
            userSettings = {
                "editor.fontSize" = 14;
                "editor.fontFamily" = "'CaskaydiaCove Mono', monospace";
                "workbench.colorTheme" = "Dracula";
                "workbench.iconTheme" = "material-icon-theme";
            };
        };
    };
}