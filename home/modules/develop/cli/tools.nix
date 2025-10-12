{
  pkgs,
  ...
}:
let
  macchinaCfg = pkgs.fetchFromGitHub {
    owner = "CodeWenjiu";
    repo = "macchina-config";
    rev = "ddabf53784d21cc45f81357b178ddeca86ff4dfc";
    hash = "sha256-18cVcYuvWnhnQ0DyE/2bAFYxH/7L4zSbcVHIvSg/Kpg=";
  };
in
{
  home.packages = with pkgs; [
    ripgrep

    wget
    nettools

    tree

    vim
    # fetch
    macchina
    onefetch
    bottom

    yazi
  ];

  xdg.configFile."macchina" = {
    source = macchinaCfg;
    recursive = true;
  };

  programs.nushell.shellAliases = {
    sysfetch = "macchina";
    gitfetch = "onefetch";
    systop = "btm";
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };
}
