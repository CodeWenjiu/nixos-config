{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    onefetch
    gource
    bottom
    intel-gpu-tools
  ];

  programs.nushell.shellAliases = {
    gitfetch = "onefetch";
    systop = "btm";
    gputop = "intel-gpu-tools";
  };
}
