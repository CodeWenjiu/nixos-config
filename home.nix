{ config, pkgs, ... }:
{
  home.username = "wenjiu";
  home.homeDirectory = "/home/wenjiu";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    zip
  ];

  programs = {
    git = {
      enable = true;
      userName = "wenjiu";
      userEmail = "2784307979@qq.com";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    # vscode = {
    #   enable = true;
    #   profiles.default = {
    #     extensions = with pkgs.vscode-extensions; [
    #       ms-python.python
    #       rust-lang.rust-analyzer
    #       bradlc.vscode-tailwindcss
    #       
    #       dracula-theme.theme-dracula
    #       pkief.material-icon-theme
    #       
    #       eamodio.gitlens
    #       ms-vscode.hexeditor
    #     ];
    #     userSettings = {
    #       "editor.fontSize" = 14;
    #       "editor.fontFamily" = "'JetBrains Mono', 'Droid Sans Mono', monospace";
    #       "workbench.colorTheme" = "Dracula";
    #       "workbench.iconTheme" = "material-icon-theme";
    #     };
    #   };
    # };

    firefox = {
      enable = true;
      profiles.default = {
        settings = {
          "browser.startup.homepage" = "https://www.google.com";
          "browser.search.defaultenginename" = "Google";
        };
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
  };
}