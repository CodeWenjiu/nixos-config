{ lib, ... }:
{
  # 原文件已备份到 ~/.config/mimeapps.list.before-craft-20261104
  xdg.configFile."mimeapps.list".force = true;

  xdg.mimeApps = {
    enable = true;

    defaultApplications =
      {
        # ── Craft 系列 ─────────────────────────────────────────────
        # PDF：PdfCraft
        "application/pdf" = "ai.storyteller.pdfcraft.desktop";

        # 演示文稿：DeckCraft（旧版 .ppt 不映射，仍走 WPS）
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" =
          "ai.storyteller.deckcraft.desktop";
        "application/vnd.openxmlformats-officedocument.presentationml.template" =
          "ai.storyteller.deckcraft.desktop";
        "application/vnd.openxmlformats-officedocument.presentationml.slideshow" =
          "ai.storyteller.deckcraft.desktop";
        "application/x-deckcraft" = "ai.storyteller.deckcraft.desktop";
        "application/wps-office.pptx" = "ai.storyteller.deckcraft.desktop";
        "application/wps-office.potx" = "ai.storyteller.deckcraft.desktop";

        # 文档：WordCraft（不抢 .md/.html/.tex）
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" =
          "ai.storyteller.wordcraft.desktop";
        "application/vnd.openxmlformats-officedocument.wordprocessingml.template" =
          "ai.storyteller.wordcraft.desktop";
        "application/vnd.ms-word.document.macroEnabled.12" =
          "ai.storyteller.wordcraft.desktop";
        "application/vnd.ms-word.template.macroEnabled.12" =
          "ai.storyteller.wordcraft.desktop";
        "application/msword" = "ai.storyteller.wordcraft.desktop";
        "application/msword-template" = "ai.storyteller.wordcraft.desktop";
        "application/vnd.oasis.opendocument.text" =
          "ai.storyteller.wordcraft.desktop";
        "application/rtf" = "ai.storyteller.wordcraft.desktop";
        "text/rtf" = "ai.storyteller.wordcraft.desktop";
        "application/wps-office.docx" = "ai.storyteller.wordcraft.desktop";
        "application/wps-office.dotx" = "ai.storyteller.wordcraft.desktop";

        # 表格：GridCraft（不抢 .csv/.tsv）
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" =
          "ai.storyteller.gridcraft.desktop";
        "application/vnd.ms-excel.sheet.macroEnabled.12" =
          "ai.storyteller.gridcraft.desktop";
        "application/vnd.ms-excel.sheet.binary.macroEnabled.12" =
          "ai.storyteller.gridcraft.desktop";
        "application/vnd.oasis.opendocument.spreadsheet" =
          "ai.storyteller.gridcraft.desktop";
        "application/wps-office.xlsx" = "ai.storyteller.gridcraft.desktop";
        "application/wps-office.xltx" = "ai.storyteller.gridcraft.desktop";

        # ── 原有 scheme handler ────────────────────────────────────
        "x-scheme-handler/clash" = "clash-verge.desktop";
        "x-scheme-handler/clash-verge" = "clash-verge.desktop";
        "x-scheme-handler/bilipc" = "bilibili.desktop";
        "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
        "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
      }
      // lib.genAttrs [
        # WPS 专用格式：仍用 WPS 统一启动器兜底
        "application/wps-office.ppt"
        "application/wps-office.pot"
        "application/wps-office.dps"
        "application/wps-office.dpt"
        "application/wps-office.dpss"
        "application/wps-office.dpso"
        "application/wps-office.xls"
        "application/wps-office.xlt"
        "application/wps-office.et"
        "application/wps-office.ett"
        "application/wps-office.ets"
        "application/wps-office.eto"
        "application/wps-office.doc"
        "application/wps-office.dot"
        "application/wps-office.wps"
        "application/wps-office.wpss"
        "application/wps-office.wpso"
        "application/wps-office.wpt"
      ] (_: "wps-office-prometheus.desktop");
  };
}