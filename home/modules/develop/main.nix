{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    nil
    nixd # Nix LSP
    alejandra
  ];
}
