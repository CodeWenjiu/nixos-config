{ pkgs, ... }:

# ── How to bump pigma ────────────────────────────────────────────
# 1. Set version and rev to the new tag (e.g. v0.3.0), then set the
#    pigma-src hash to `pkgs.lib.fakeHash` and build once; the error
#    prints the correct hash ("got: sha256-..."). Same trick for y7dl.
# 2. Check whether the y7dl submodule pin moved at the new tag:
#      git clone -q --filter=blob:none --no-checkout --depth 1 \
#        --branch v0.3.0 https://github.com/akirco/pigma.git /tmp/pigma
#      git -C /tmp/pigma ls-tree v0.3.0 crates/y7dl
#      git -C /tmp/pigma show v0.3.0:.gitmodules
#    - same SHA  -> y7dl-src unchanged
#    - new SHA   -> update rev and re-fetch its hash
#    - new submodules -> add another fetch + `cp` in the runCommand below
# 3. Rust deps need no manual hash: cargoLock.lockFile derives everything
#    from the lockfile checksums. If the build fails on a missing system
#    lib, add it to buildInputs (compile-time) and rely on autoPatchelfHook
#    to complain about runtime misses.
let
  pigma-src = pkgs.fetchFromGitHub {
    owner = "akirco";
    repo = "pigma";
    rev = "v0.2.11";
    hash = "sha256-RkLO2LALxIa7nxdEIkE48RkDwNJUXH55QLUGkYVHU30=";
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
    version = "0.2.11";
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
