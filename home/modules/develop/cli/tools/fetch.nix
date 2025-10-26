{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    onefetch
    bottom
  ];

  programs.nushell.shellAliases = {
    gitfetch = "onefetch";
    systop = "btm";
  };
}
