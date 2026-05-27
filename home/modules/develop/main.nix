{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    nil
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    silent = true;
  };

  imports = [
    ./cli/main.nix
    ./editor/main.nix
    ./langs/main.nix
    ./vcs/main.nix
    ./debug.nix
  ];
}
