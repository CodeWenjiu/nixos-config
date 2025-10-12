{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    ripgrep

    wget
    nettools

    tree
  ];

  programs.ghostty = {
    enable = true;
  };

  xdg.configFile."ghostty/config".text = ''
    cursor-style-blink = false
    background-opacity = 0.5
    background-opacity-cells = true
    background-blur = true
    theme = noctalia
  '';

  programs.zsh.initContent = ''
    bindkey "^H" backward-delete-word
    alias rgl='rg --no-heading --line-number'
  '';

  imports = [
    ./editor.nix
    ./shell.nix
    ./fetch.nix
    ./file_manager.nix
  ];
}
