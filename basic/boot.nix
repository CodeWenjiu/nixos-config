{ pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    git
    stdenv.cc.cc.lib
    zlib
    libGL
    libglvnd
    libxkbcommon
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
  ];
}
