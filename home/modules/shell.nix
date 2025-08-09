{ config, pkgs, ... }:
{
  programs.zsh = { 
    enable = true; 
    enableCompletion = true; 
    syntaxHighlighting.enable = true; 
    oh-my-zsh.enable = true; 
    oh-my-zsh.theme = "robbyrussell"; 
    oh-my-zsh.plugins = [ 
      "git" 
    ]; 
    initContent = ''
      alias c='clear'
      alias cd..='cd ..'
    '';
  };
}