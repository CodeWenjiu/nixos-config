{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    vscode
  ];

  imports = [
    ./file_manager.nix
    ./editor/main.nix
  ];
}
