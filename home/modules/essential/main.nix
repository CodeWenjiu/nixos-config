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
    ./font.nix
    ./file_manager.nix
  ];
}
