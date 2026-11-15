{ lib, ... }:
{
  # 原文件已备份到 ~/.config/mimeapps.list.before-craft-20261104
  xdg.configFile."mimeapps.list".force = true;

  xdg.mimeApps = {
    enable = true;

    defaultApplications =
      {
        # ── Ely Office ─────────────────────────────────────────────
        # 只映射各 app 自己声明的 MimeType（见各自的 .desktop）。模板、宏、
        # WPS 专用容器它不声明，交给下面的 WPS 兜底，免得默认 handler 指向
        # 一个打不开它们的程序。
        "application/pdf" = "ely-pdf.desktop";

        "application/vnd.openxmlformats-officedocument.presentationml.presentation" =
          "ely-show.desktop";
        "application/vnd.oasis.opendocument.presentation" = "ely-show.desktop";
        "application/vnd.ms-powerpoint" = "ely-show.desktop";

        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" =
          "ely-doc.desktop";
        "application/vnd.oasis.opendocument.text" = "ely-doc.desktop";
        "application/msword" = "ely-doc.desktop";
        "application/rtf" = "ely-doc.desktop";
        "text/rtf" = "ely-doc.desktop";

        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" =
          "ely-table.desktop";
        "application/vnd.oasis.opendocument.spreadsheet" = "ely-table.desktop";
        "application/vnd.ms-excel" = "ely-table.desktop";

        # ── 原有 scheme handler ────────────────────────────────────
        "x-scheme-handler/clash" = "clash-verge.desktop";
        "x-scheme-handler/clash-verge" = "clash-verge.desktop";
        "x-scheme-handler/bilipc" = "bilibili.desktop";
        "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
        "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
      }
      // lib.genAttrs [
        # 模板 / 宏：Ely Office 不声明这些，仍交给 WPS
        "application/vnd.openxmlformats-officedocument.presentationml.template"
        "application/vnd.openxmlformats-officedocument.presentationml.slideshow"
        "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
        "application/vnd.ms-word.document.macroEnabled.12"
        "application/vnd.ms-word.template.macroEnabled.12"
        "application/msword-template"
        "application/vnd.ms-excel.sheet.macroEnabled.12"
        "application/vnd.ms-excel.sheet.binary.macroEnabled.12"
        "application/wps-office.docx"
        "application/wps-office.dotx"
        "application/wps-office.pptx"
        "application/wps-office.potx"
        "application/wps-office.xlsx"
        "application/wps-office.xltx"

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