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

  # programs.bash.bashrcExtra = ''
  #   if ! { [[ -n "''${BASH_EXECUTION_STRING:-}" ]] && ! [[ -t 0 ]]; }; then
  #     eval "$(${pkgs.direnv}/bin/direnv hook bash)"
  #   fi
  # '';

  imports = [
    ./cli/main.nix
    ./editor/main.nix
    ./langs/main.nix
    ./vcs/main.nix
    ./debug.nix
  ];
}
