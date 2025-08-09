{ config, pkgs, ... }:
{
  home.username = "wenjiu";
  home.homeDirectory = "/home/wenjiu";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    zip
  ];

  imports = [
    ./modules/browser.nix
    ./modules/chat.nix
    ./modules/editor.nix
    ./modules/tools.nix
    ./modules/vcs.nix
  ];

  # 环境变量配置
  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
    sysfetch = "macchina";
  };

  programs.zsh = { 
    enable = true; 
    enableCompletion = true; 
    syntaxHighlighting.enable = true; 
    oh-my-zsh.enable = true; 
    oh-my-zsh.theme = "robbyrussell"; 
    oh-my-zsh.plugins = [ "git" ]; 
    initContent = ''
      function yy() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d ''' cwd < "$tmp"
        [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
        rm -f -- "$tmp"
      }
    '';
  };

  programs.bash.enable = false;
}