{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    nil
    nixd # Nix LSP
    alejandra # Nix Formatter
  ];

  imports = [
    ./rust.nix
    # ./rust-env.nix
  ];
}
