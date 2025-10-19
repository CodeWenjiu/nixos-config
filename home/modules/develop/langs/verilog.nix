{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    verible
    # waiting for https://github.com/NixOS/nixpkgs/pull/452145 merged
    # veridian
  ];
}
