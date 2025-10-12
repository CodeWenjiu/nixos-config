{
  ...
}:
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
      bindkey "^H" backward-delete-word
      alias rgl='rg --no-heading --line-number'
    '';
  };
}
