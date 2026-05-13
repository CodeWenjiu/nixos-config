{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    onefetch
    bottom
    sx-go
  ];

  programs.nushell.shellAliases = {
    gitfetch = "onefetch";
    systop = "btm";
    webdevfetch = "sx-go arp 192.168.0.1/24";
  };
}
