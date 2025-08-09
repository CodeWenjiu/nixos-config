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

  programs.zsh = { 
    enable = true; 
    enableCompletion = true; 
    syntaxHighlighting.enable = true; 
    oh-my-zsh.enable = true; 
    oh-my-zsh.theme = "robbyrussell"; 
    oh-my-zsh.plugins = [ "git" ]; 
    initContent = ''
      alias c='clear'
      alias cd..='cd ..'
    '';
  };

  programs.bash.enable = false;
}