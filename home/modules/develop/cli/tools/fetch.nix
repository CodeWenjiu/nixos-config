{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    onefetch
    # bottom
    btop
    intel-gpu-tools
  ];

  programs.nushell.shellAliases = {
    gitfetch = "onefetch";
    systop = "btop";
    gputop = "intel-gpu-tools";
  };
}
