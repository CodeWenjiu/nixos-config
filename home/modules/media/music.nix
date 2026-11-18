{ pkgs, ... }:

# ── How to bump netodia ───────────────────────────────────────────
# 用上游 release 的预编译包,不从源码构建:这是一个 14 crate 的 Rust +
# Slint workspace,编译一次要十几分钟,而它在这里只是"替换 pigma"的成品
# 应用,没必要承担这个成本。
#
# 1. 改 version 为新的 tag。
# 2. 把 hash 设成 pkgs.lib.fakeHash,构建一次,错误里会给出 "got: sha256-..."。
# 3. 如果上游新增了运行时依赖,autoPatchelfHook 会在构建期报出缺哪个 .so,
#    把它加进 buildInputs。
let
  version = "0.1.8";

  # 上游 release 里的 x86_64 tarball。注意它是预编译产物,
  # 所以这个包不可复现到源码级别(sourceProvenance 标了 binaryNativeCode)。
  src = pkgs.fetchurl {
    url = "https://github.com/HELPMEEADICE/Netodia/releases/download/v${version}/netodia-v${version}-x86_64-linux.tar.gz";
    hash = "sha256-danwGv3OlavzVjq6p2/DLeUzv6D4FU0XeE+tIxqD6/k=";
  };

  netodia = pkgs.stdenvNoCC.mkDerivation {
    pname = "netodia";
    inherit version src;

    # 二进制里记着 libasound / libdbus / libEGL / libGL / fontconfig /
    # wayland / xkbcommon / X11 系列;autoPatchelfHook 负责改写它们的
    # RPATH,buildInputs 决定它们指向哪里。
    nativeBuildInputs = [
      pkgs.autoPatchelfHook
      pkgs.makeWrapper
    ];

    buildInputs = with pkgs; [
      alsa-lib
      dbus
      fontconfig
      freetype
      libGL
      libx11
      libxcb
      libxcursor
      libxi
      libxkbcommon
      libxrender
      wayland
      stdenv.cc.cc.lib
    ];

    dontConfigure = true;
    dontBuild = true;

    # winit 把 X11 / Wayland 后端和 glutin 的 EGL/GL 都放在 dlopen 后面（这样
    # 一个二进制能同时跑两种会话），DT_NEEDED 里看不到它们，autoPatchelfHook
    # 也就无从改 RPATH。只能显式把库放进 LD_LIBRARY_PATH。
    postFixup = ''
      wrapProgram $out/bin/Netodia \
        --prefix LD_LIBRARY_PATH : ${
          pkgs.lib.makeLibraryPath [
            pkgs.libGL
            pkgs.wayland
            pkgs.libxkbcommon
            pkgs.libx11
            pkgs.libxcb
            pkgs.libxcursor
            pkgs.libxi
            pkgs.libxrender
            pkgs.fontconfig
            pkgs.freetype
          ]
        }
    '';

    installPhase = ''
      runHook preInstall

      # tarball 里的产物名是 `Netodia`;桌面文件的 Exec 写的是 `netodia`,
      # 所以两个名字都提供。
      install -Dm755 Netodia $out/bin/Netodia
      ln -s Netodia $out/bin/netodia

      install -Dm644 netodia.png \
        $out/share/icons/hicolor/256x256/apps/netodia.png
      install -Dm644 com.github.helpmeeadice.netodia.desktop \
        $out/share/applications/netodia.desktop

      runHook postInstall
    '';

    meta = {
      description = "Third-party NetEase Cloud Music desktop client (Slint + Rust)";
      homepage = "https://github.com/HELPMEEADICE/Netodia";
      license = pkgs.lib.licenses.agpl3Plus;
      sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
      mainProgram = "netodia";
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  home.packages = with pkgs; [
    pwvucontrol
    netodia
  ];
}
