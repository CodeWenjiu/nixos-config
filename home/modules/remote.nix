{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    wev
    tailscale
  ];

  programs.nushell.shellAliases = {
    sys_keyscan = "wev";
  };
}
