{
  pkgs,
  ...
}:
let
  # Not in nixpkgs yet; pinned to the latest master commit. niri-zoom is a
  # Ctrl+scroll magnifier that draws itself into a fullscreen wlr-layer-shell
  # overlay surface, so unlike a normal magnifier window it sits above
  # everything and never becomes part of the layout.
  # To update: bump version/rev and rebuild; nix prints the replacement hash
  # for src and cargoHash on mismatch.
  niri-zoom = pkgs.rustPlatform.buildRustPackage rec {
    pname = "niri-zoom";
    version = "0.1.0-unstable-2026-09-03";

    src = pkgs.fetchFromGitHub {
      owner = "Ahmedhossamdev";
      repo = "niri-zoom";
      rev = "94f24aaa026b49961ba8768ae838d130d62d84b6";
      hash = "sha256-3n6xsFFX96KnpNym8DdgnfPGXEi30F77KJCMlBON3ms=";
    };

    cargoHash = "sha256-ISKNipvoRpaZ9mx6J9XUialXwuTrpRlNb+0Y5DaNIxY=";

    meta = {
      description = "External Ctrl+scroll magnifier/zoom overlay for niri";
      homepage = "https://github.com/Ahmedhossamdev/niri-zoom";
      license = pkgs.lib.licenses.mit;
      mainProgram = "niri-zoomd";
      platforms = pkgs.lib.platforms.linux;
    };
  };
in
{
  home.packages = [ niri-zoom ];

  # The daemon needs the niri session environment and should stay alive for
  # the whole session, so run it as a user service instead of spawning it from
  # within niri. niri-zoomctl (driven by the Ctrl+scroll binds in
  # ../desktop/noctalia/niri-config.kdl) talks to it over a socket.
  systemd.user.services.niri-zoom = {
    Unit = {
      Description = "niri-zoom magnifier daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${niri-zoom}/bin/niri-zoomd";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
