{ pkgs, lib, ... }:
let
  version = "0.1.13";
  base = "https://github.com/ELY-Open-Source/ElyOffice/releases/download/v${version}";

  # 镜像上游 nix/release.json。升级时改 version 和下面的哈希即可
  # （哈希就是 release.json 里对应 app 的 sha256）。
  sources = {
    ely-doc = {
      file = "ElyDoc-${version}-linux-x86_64.AppImage";
      sha256 = "0d746f6d1c4812864aa38617e2c7b1eaa38756803da7be5054dd90a7b60bac2b";
      license = "MIT AND MPL-2.0";
      description = "ElyDoc, word processing (DOCX, ODT)";
    };
    ely-table = {
      file = "ElyTable-${version}-linux-x86_64.AppImage";
      sha256 = "523e7d0c29a3e649074877ab3e39ae068c406d82a1057da08c3fd331d9150f4d";
      license = "MIT AND MPL-2.0";
      description = "ElyTable, spreadsheets (XLSX, ODS, CSV)";
    };
    ely-show = {
      file = "ElyShow-${version}-linux-x86_64.AppImage";
      sha256 = "463e07cf8424a1dc56a2554d7e137c299b5f76851c2f06afafacaecd8c3dacb2";
      license = "MIT AND MPL-2.0";
      description = "ElyShow, presentations (PPTX, ODP)";
    };
    ely-pdf = {
      file = "ElyPDF-${version}-linux-x86_64.AppImage";
      sha256 = "2d5ec4ddb6ff5322f4accd2a63c2cf2ca09bedbe0beda071847db3d14eb16ee8";
      license = "MIT AND AGPL-3.0-or-later";
      description = "ElyPDF, PDF reading and editing, OCR, signatures";
    };
    ely-mail = {
      file = "ElyMail-${version}-linux-x86_64.AppImage";
      sha256 = "f31dc4966b508b8314de7fab451e333465429f18e415a09a6bf1fb247bf734c7";
      license = "MIT";
      description = "ElyMail, mail over IMAP, POP3 and SMTP";
    };
    ely-tree = {
      file = "ElyTree-${version}-linux-x86_64.AppImage";
      sha256 = "48001ba269348dde5358a6cb525ca7a02b34e3193c170f0ab2f69061641c80f5";
      license = "MIT AND GPL-2.0-only";
      description = "ElyTree, Git client";
    };
    ely-mark = {
      file = "ElyMark-${version}-linux-x86_64.AppImage";
      sha256 = "710749a80af6f92518b2f5e30a2fbec870b8365ae1042b01615e51db27a138c8";
      license = "MIT AND AGPL-3.0-or-later AND GPL-2.0-only";
      description = "ElyMark, Markdown";
    };
  };

  # 上游 flake 用 appimageTools.wrapType2 包装官方 AppImage，但 FHS 环境里
  # 没给 libgpg-error，导致 AppRun 直接报 "libgpg-error.so.0: cannot open
  # shared object file"。这里补上，另外加上 GPUI 运行时按名字加载的库。
  wrap =
    slug: info:
    let
      src = pkgs.fetchurl {
        url = "${base}/${info.file}";
        inherit (info) sha256;
      };
      extracted = pkgs.appimageTools.extract {
        pname = slug;
        inherit version src;
      };
    in
    pkgs.appimageTools.wrapType2 {
      pname = slug;
      inherit version src;

      extraPkgs =
        p: with p; [
          vulkan-loader
          wayland
          libxkbcommon
          libgpg-error
        ];

      extraInstallCommands = ''
        install -Dm444 ${extracted}/${slug}.desktop -t $out/share/applications
        install -Dm444 ${extracted}/${slug}.png -t $out/share/icons/hicolor/512x512/apps
      '';

      meta = {
        inherit (info) description;
        homepage = "https://github.com/ELY-Open-Source/ElyOffice";
        license = map lib.getLicenseFromSpdxId (lib.splitString " AND " info.license);
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
        platforms = [ "x86_64-linux" ];
        mainProgram = slug;
      };
    };

  apps = lib.mapAttrs wrap sources;

  # 想装哪个就把名字加进来：ely-doc / ely-table / ely-show / ely-pdf /
  # ely-mail / ely-tree / ely-mark。目前替掉了 Craft 系列的四个。
  enabled = [
    "ely-doc"
    "ely-table"
    "ely-show"
    "ely-pdf"
    "ely-mark"
  ];
in
{
  home.packages = map (name: apps.${name}) enabled;

  # AppImage 自带 desktop 文件，StartupWMClass 就是 slug（如 ely-pdf），
  # 需要窗口规则时按这个匹配。
}
