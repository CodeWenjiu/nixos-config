{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    zip
    unzip
  ];

  imports = [
    ./keyring.nix
    ./disk.nix
    ./rime.nix
  ];
}
