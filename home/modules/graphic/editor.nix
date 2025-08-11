{ config, pkgs, ... }:
{
    programs.vscode = {
        enable = true;
        package = pkgs.vscode;

        profiles.default = {
            extensions = with pkgs.vscode-extensions; [
                rust-lang.rust-analyzer
            ];

            keybindings = [
                {
                    "key" = "ctrl+c";
                    "command" = "workbench.action.terminal.copySelection";
                    "when" = "terminalFocus && terminalTextSelected";
                }

                {
                    "key" = "ctrl+v";
                    "command" = "workbench.action.terminal.paste";
                    "when" = "terminalFocus";
                }

                # not work :(
                {
                    "key" = "ctrl+shift+c";
                    "command" = "-";
                    "when" = "terminalFocus && terminalTextSelected";
                }

                {
                    "key" = "ctrl+shift+v";
                    "command" = "-";
                    "when" = "terminalFocus";
                }

                {
                    "key" = "ctrl+space";
                    "command" = "-";
                    "when" = "editorTextFocus";
                }
            ];
        };
    };

    home.packages = with pkgs; [
        zed-editor
    ];
}