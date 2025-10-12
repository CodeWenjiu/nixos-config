{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    zip
    unzip
    nautilus
  ];

  imports = [
    ./keyring.nix
    ./disk.nix
    ./font.nix
  ];
}
