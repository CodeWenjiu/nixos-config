{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    cargo
    cargo-generate
  ];
}
