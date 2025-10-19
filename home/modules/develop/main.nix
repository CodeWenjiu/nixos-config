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
    enableZshIntegration = true;
    nix-direnv.enable = true;
    silent = true;
  };

  imports = [
    ./vcs/main.nix
    ./models.nix
    ./meet.nix
    ./paint.nix
    ./cli/main.nix
    ./editor/main.nix
    ./langs/main.nix
  ];
}
