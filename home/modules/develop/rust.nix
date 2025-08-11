{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # Rust toolchain
    rustc
    cargo
    clippy
    rustfmt
    rust-analyzer

    # Build tools required for Rust
    gcc
    glibc
    glibc.dev

    # Linker and binutils
    binutils
  ];
}
