{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    nixd # Nix LSP
    nixpkgs-fmt # Nix formatter
  ];
}
