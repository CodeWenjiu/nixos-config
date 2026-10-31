# 青简（Qingjian）：候选旁带译词的拼音输入法，上游只提供 Linux 源码安装。
#
# 全部装进用户环境（Home Manager）：
#   - Rust Server 从可执行文件相对路径找 resources；设置程序走 bundled_root()，
#     它认 exe 同级的 data/ 与 assets/，所以在 $out/bin 里链过去；
#   - 设置程序的字体清单写死了发行版路径，构建时替换成 store 里的
#     DejaVu Sans（界面）、Source Han Sans（中文）与 Noto Color Emoji；
#   - addon 加进 i18n.inputMethod.fcitx5.addons，Server 是 systemd 用户服务。
{ lib, pkgs, ... }:
let
  version = "0.3.2";

  src = pkgs.fetchFromGitHub {
    owner = "qingjian-team";
    repo = "qingjian";
    tag = "v${version}";
    hash = "sha256-4aLKJl0NlVGEk7CYtGhxxiLWYuXkx7teU5xJrsnP7TU=";
  };

  # 词库、语言模型与释义表不在 git 仓库里，版本与校验值见上游
  # tools/release/data.lock。
  data = pkgs.fetchurl {
    url = "https://github.com/qingjian-team/qingjian/releases/download/data-v9/qingjian-data.tar.gz";
    sha256 = "bc8dd7f4e283c6b7fa0f38e493ea89e5d874ccf45ff22308ca52f4078df6694b";
  };

  qingjian = pkgs.rustPlatform.buildRustPackage {
    pname = "qingjian";
    inherit version src;

    cargoLock = {
      lockFile = src + "/Cargo.lock";
      outputHashes = {
        "cosmic-text-0.19.0" = "sha256-c7DuyTTF5vkClCeGGIWBX4HAMecA+1RujvVA0fcTQRE=";
      };
    };

    cargoBuildFlags = [
      "-p"
      "qingjian-linux-server"
      "-p"
      "qingjian-settings"
    ];
    doCheck = false;

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      pkg-config
    ];

    buildInputs = with pkgs; [
      libxkbcommon
      openssl
      stdenv.cc.cc.libgcc
      wayland
    ];

    # winit / arboard 在运行时 dlopen X11 与 Wayland 的库，需要显式进 RPATH。
    runtimeDependencies = with pkgs; [
      libX11
      libXcursor
      libXext
      libXi
      libXinerama
      libXrandr
      libXrender
      libxcb
      libxkbcommon
      wayland
    ];

    postPatch = ''
      substituteInPlace crates/bamboo-slip/src/fonts/linux.rs \
        --replace-fail '"/usr/share/fonts/truetype/noto/NotoSans-Regular.ttf",' \
          '"${pkgs.dejavu_fonts}/share/fonts/truetype/DejaVuSans.ttf",' \
        --replace-fail '"/usr/share/fonts/truetype/noto/NotoSans-Bold.ttf",' \
          '"${pkgs.dejavu_fonts}/share/fonts/truetype/DejaVuSans-Bold.ttf",' \
        --replace-fail '"/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc",' \
          '"${pkgs.source-han-sans}/share/fonts/truetype/SourceHanSans.ttc",' \
        --replace-fail '"/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf",' \
          '"${pkgs.noto-fonts-color-emoji}/share/fonts/noto/NotoColorEmoji.ttf",'
    '';

    installPhase = ''
      runHook preInstall

      for bin in qingjian-linux-server qingjian-settings; do
        install -Dm755 target/*/release/"$bin" "$out/bin/$bin"
      done

      resources=$out/share/qingjian/resources
      mkdir -p "$resources/assets" "$resources/data"
      for kind in sample glossary levels emoji; do
        if [ -d "assets/$kind" ]; then
          cp -r "assets/$kind" "$resources/assets/"
        fi
      done

      mkdir -p data-extract
      tar -xzf ${data} -C data-extract
      cp -r data-extract/data/generated "$resources/data/"
      cp -r data-extract/data/models "$resources/data/"

      install -Dm644 apps/settings/linux/qingjian-settings.desktop \
        $out/share/applications/qingjian-settings.desktop
      substituteInPlace $out/share/applications/qingjian-settings.desktop \
        --replace-fail 'Exec=qingjian-settings' "Exec=$out/bin/qingjian-settings"

      for size in 16 22 24 32 48 64 128 256; do
        icon="assets/icon/linux/hicolor/''${size}x''${size}/apps/qingjian.png"
        if [ -f "$icon" ]; then
          install -Dm644 "$icon" \
            "$out/share/icons/hicolor/''${size}x''${size}/apps/qingjian.png"
        fi
      done

      install -Dm644 LICENSE $out/share/licenses/qingjian/LICENSE

      # 设置程序用 bundled_root() 按可执行文件同级找 data/ 与 assets/。
      ln -s ../share/qingjian/resources/data $out/bin/data
      ln -s ../share/qingjian/resources/assets $out/bin/assets

      runHook postInstall
    '';

    meta = {
      description = "Pinyin input method with inline translations (Fcitx5 server)";
      homepage = "https://qingjian.app";
      license = lib.licenses.gpl3Plus;
      platforms = [ "x86_64-linux" ];
      mainProgram = "qingjian-settings";
    };
  };

  qingjian-fcitx5 = pkgs.stdenv.mkDerivation {
    pname = "qingjian-fcitx5";
    inherit version src;

    sourceRoot = "source/apps/linux/fcitx5";
    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      cmake
      pkg-config
    ];

    buildInputs = with pkgs; [
      fcitx5
      nlohmann_json
    ];

    cmakeFlags = [ "-DBUILD_TESTING=OFF" ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/fcitx5 $out/share/fcitx5/addon $out/share/fcitx5/inputmethod
      install -Dm755 "$(find . -name qingjian.so -print -quit)" $out/lib/fcitx5/qingjian.so
      install -Dm644 $src/apps/linux/fcitx5/data/addon/qingjian.conf \
        $out/share/fcitx5/addon/qingjian.conf
      install -Dm644 $src/apps/linux/fcitx5/data/inputmethod/qingjian.conf \
        $out/share/fcitx5/inputmethod/qingjian.conf

      substituteInPlace $out/share/fcitx5/addon/qingjian.conf \
        --replace-fail 'Library=qingjian' "Library=$out/lib/fcitx5/qingjian"

      runHook postInstall
    '';

    meta = {
      description = "Fcitx5 addon for the Qingjian input method";
      homepage = "https://qingjian.app";
      license = lib.licenses.gpl3Plus;
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  home.packages = [ qingjian ];

  i18n.inputMethod.fcitx5.addons = [ qingjian-fcitx5 ];

  systemd.user.services.qingjian-server = {
    Unit = {
      Description = "青简输入法 Server";
      Documentation = [ "https://qingjian.app" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${qingjian}/bin/qingjian-linux-server";
      Environment = "QINGJIAN_RESOURCES=${qingjian}/share/qingjian/resources";
      Restart = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
