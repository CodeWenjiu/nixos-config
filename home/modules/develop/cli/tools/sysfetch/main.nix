{
    pkgs,
    ...
}:
let
  sysfetch = "fastfetch";
in
{
  imports = [
    ./${sysfetch}.nix
  ];

  programs.nushell.shellAliases = {
    sysfetch = sysfetch;
  };

  home.packages = with pkgs; [
      hardinfo2
  ];
}
