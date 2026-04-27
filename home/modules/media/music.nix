{
  pkgs,
  ...
}:
let
  cnmplayer = pkgs.rustPlatform.buildRustPackage rec {
    pname = "cnmplayer";
    version = "0.4.0";

    src = pkgs.fetchFromGitHub {
      owner = "professor-lee";
      repo = "CNMPlayer";
      rev = "v${version}";
      hash = "sha256-EB9WWHwdSdGJnAyzSwNc8APpG+j5/z/ttjnDPDe5zCg=";
    };

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
    };

    nativeBuildInputs = with pkgs; [
      pkg-config
    ];

    buildInputs = with pkgs; [
      alsa-lib
      dbus
      chromaprint
      chafa
      glib
    ];

    doCheck = false;
  };
in
{
  home.packages = with pkgs; [
    netease-cloud-music-gtk
    pavucontrol
    cnmplayer
  ];
}
