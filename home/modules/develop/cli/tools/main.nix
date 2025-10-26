{
  pkgs,
  ...
}:
{
  imports = [
    ./fetch.nix
    ./yazi/main.nix
  ];

  home.packages = with pkgs; [
    ripgrep

    wget
    nettools

    tree
  ];
}
