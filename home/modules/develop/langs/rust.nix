{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # cargo
    # cargo-generate

    rust-analyzer # Rust LSP
  ];
}
