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

                # {
                #     "key" = "ctrl+c";
                #     "command" = "workbench.action.terminal.sendSequence";
                #     "args" = { "text" = builtins.charFromInt 3; };
                #     "when" = "terminalFocus && !terminalTextSelected";
                # }
            ];
        };
    };
}