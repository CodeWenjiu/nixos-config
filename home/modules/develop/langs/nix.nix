{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # Language servers
    nixd # Nix LSP

    # Formatters
    nixpkgs-fmt # Nix formatter
  ];
}
