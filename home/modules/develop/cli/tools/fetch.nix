{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    onefetch
    bottom
    # btop
    intel-gpu-tools
  ];

  programs.nushell.shellAliases = {
    gitfetch = "onefetch";
    systop = "btm";
    gputop = "intel-gpu-tools";
  };
}
