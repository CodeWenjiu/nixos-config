{ pkgs, ... }:
{
  home.packages = with pkgs; [
    helix
  ];

  programs.nushell.extraConfig = ''
    $env.EDITOR = "hx";
  '';
}
