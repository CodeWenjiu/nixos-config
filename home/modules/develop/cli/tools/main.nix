{
  pkgs,
  ...
}:
{
  imports = [
    ./fetch.nix
    ./sysfetch/main.nix
    ./yazi/main.nix
  ];

  home.packages = with pkgs; [
    ripgrep

    wget
    nettools

    tree

    outfieldr
  ];
}
