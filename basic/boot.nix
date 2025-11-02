{ pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  programs.nix-ld.enable = true;
}
