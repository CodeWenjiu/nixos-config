{
  config,
  pkgs,
  ...
}: let
  macchinaCfg = pkgs.fetchFromGitHub {
    owner = "CodeWenjiu";
    repo = "macchina-config";
    rev = "ddabf53784d21cc45f81357b178ddeca86ff4dfc";
    hash = "sha256-18cVcYuvWnhnQ0DyE/2bAFYxH/7L4zSbcVHIvSg/Kpg=";
  };
in {
  home.packages = with pkgs; [
    # fetch
    macchina
    onefetch
  ];

  xdg.configFile."macchina" = {
    source = macchinaCfg;
    recursive = true;
  };

  programs.zsh.initContent = ''
    alias sysfetch='macchina'
    alias gitfetch='onefetch'
  '';
}
