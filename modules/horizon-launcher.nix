{ pkgs, lib, ... }:
let
  version = "0.2.66";

  src = pkgs.fetchurl {
    url = "https://github.com/horizon-rust/horizon/releases/download/launcher%40${version}/horizon-launcher-linux-x86_64.AppImage";
    # 对应上游同一次 release 里的 SHA256SUMS。
    hash = "sha256-k9sGvQOoTT8v3zcV3vnxQuTE6aW6FZbr86bNKHzTtFQ=";
  };

  extracted = pkgs.appimageTools.extract {
    pname = "horizon-launcher";
    inherit version src;
  };

  # 为什么用官方 AppImage 而不是从源码构建（上游的 flake.nix 就是源码构建）：
  #
  # Microsoft 登录用的 Azure client ID 在编译期通过 option_env! 烤进二进制
  # (launcher/src/account.rs)。上游的 flake 没有传这个变量——它只在
  # .github/workflows/launcher.yml 里从仓库变量 HORIZON_MSA_CLIENT_ID 注入，
  # 所以 flake 构建出来的 launcher 是个「没有登录能力」的版本：点登录按钮
  # 什么都不会发生，CLI 则直接返回
  #   "This build of the launcher has no Microsoft sign-in
  #    (HORIZON_MSA_CLIENT_ID), so it can't start the game."
  #
  # 而 docs/forking.md 明确要求任何派生构建都不得使用 Horizon 的 client ID，
  # 所以正确做法是直接用他们 CI 产出的官方二进制，而不是自己编译或设环境变量。
  # 附带好处：不用每次 `nix flake update` 都重编 8 分钟。
  launcher = pkgs.appimageTools.wrapAppImage {
    pname = "horizon-launcher";
    inherit version src;
    contents = extracted;

    # 与上游 flake 里 horizon-launcher 的 targetPkgs 对齐：窗口/图形/Vulkan、
    # 音频、字体、以及 native mod 要在本地编译时用到的 gcc + glibc 头文件。
    extraPkgs =
      p: with p; [
        vulkan-loader
        libglvnd
        wayland
        libxkbcommon
        libx11
        libxcb
        libxcursor
        libxext
        libxi
        libxrandr
        libxrender
        libxxf86vm

        udev
        udev.dev
        alsa-lib
        alsa-lib.dev

        fontconfig
        freetype
        dbus
        xdg-utils # 登录时用 xdg-open 打开浏览器
        procps

        zlib
        libxtst
        gamemode

        gcc
        glibc.dev
        pkg-config
      ];

    # 二进制在 /nix/store 里是只读的，自我更新必然失败，直接关掉。
    # 游戏本体和版本仍由 launcher 自己下载更新，这里只关掉 launcher 本身。
    profile = ''
      export HORIZON_LAUNCHER_NO_SELF_UPDATE=1
      export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/usr/share/pkgconfig:''${PKG_CONFIG_PATH:-}"
    '';

    extraInstallCommands = ''
      install -Dm444 ${extracted}/horizon-launcher.desktop -t $out/share/applications
      install -Dm444 ${extracted}/horizon.png -t $out/share/icons/hicolor/512x512/apps
    '';

    meta = {
      description = "Launcher for Horizon, Minecraft: Java Edition rewritten in Rust";
      homepage = "https://playhorizon.dev";
      license = lib.licenses.mit;
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
      mainProgram = "horizon-launcher";
    };
  };
in
{
  environment.systemPackages = [ launcher ];
}
