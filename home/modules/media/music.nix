{
  pkgs,
  ...
}:
let
  pigma-src = pkgs.fetchFromGitHub {
    owner = "akirco";
    repo = "pigma";
    rev = "v0.2.8";
    hash = "sha256-1IqdnpCFVkOpp2YnjGi0TkZB6ZqDv0ZxPEPSoC83rRA=";
  };

  # crates/y7dl is a git submodule pinned to this commit (gitlink at v0.2.8).
  # fetchFromGitHub tarballs don't include submodules, so fetch it separately
  # and splice it into the source tree below.
  y7dl-src = pkgs.fetchFromGitHub {
    owner = "akirco";
    repo = "y7dl";
    rev = "c9a8599e4b1c29707208ca4c8d3fe393202b8e10";
    hash = "sha256-YRHRAtJkkyrPchML47S0rF8PFyRXmL9ga6z7BU124WU=";
  };

  src = pkgs.runCommand "pigma-src" { } ''
    cp -r ${pigma-src} $out
    chmod -R u+w $out
    rm -rf $out/crates/y7dl
    cp -r ${y7dl-src} $out/crates/y7dl
  '';

  pigma = pkgs.rustPlatform.buildRustPackage {
    pname = "pigma";
    version = "0.2.8";
    inherit src;

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
    };

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      pkg-config
      lld
    ];

    buildInputs = with pkgs; [
      alsa-lib
      stdenv.cc.cc.lib
    ];

    doCheck = false;
  };
in
{
  home.packages = with pkgs; [
    pwvucontrol
    pigma
  ];
}
