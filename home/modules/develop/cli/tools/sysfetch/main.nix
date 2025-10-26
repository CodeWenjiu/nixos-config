{
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
}
