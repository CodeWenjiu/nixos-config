{ pkgs, ... }:
#
# Comprehensive Multi‑Script Font Fallback & Fontconfig Setup (Home-Manager module)
#
# This module installs a curated set of open / redistributable fonts and defines
# carefully ordered fallback chains for:
#  - Latin (UI + body)
#  - CJK (SC / TC / JP / KR)
#  - Other major scripts (Arabic, Hebrew, Devanagari, Thai, Cyrillic, Greek ...)
#  - Math symbols
#  - Emoji (color)
#  - Programming monospace
#  - Optional icon fonts (Material Design, Twemoji Color as alternate emoji glyph set)
#
# Notes:
# 1. Apple Color Emoji / Segoe UI Emoji are not shipped due to licensing; we rely on
#    Noto Color Emoji + Twemoji.
# 2. Source Sans 3 is packaged as `source-sans` in nixpkgs (the current package name).
# 3. Source Han (Pan-CJK) provides region-specific face names (e.g. "Source Han Sans SC").
# 4. Inter package contains the variable font; keep it early for UI consistency.
# 5. If some packages are missing in your channel, remove or replace them (check via `nix search`).
#
# Extend or trim as you discover actual language/script usage; less-used scripts can
# be deferred or removed for profile size minimization.
#
{
  home.packages = with pkgs; [
    # Core UI / Latin
    inter
    roboto
    source-sans
    source-serif

    # Pan-CJK (Sans + Serif)
    source-han-sans
    source-han-serif
    noto-fonts-cjk-sans

    # Broad Unicode coverage (Noto core & extras)
    noto-fonts

    # Emoji (Color)
    noto-fonts-color-emoji
    twemoji-color-font

    # Math
    stix-two

    # Programming mono
    jetbrains-mono
    fira-code
    source-code-pro

    # Icons (optional)
    material-design-icons
  ];

  fonts.fontconfig = {
    enable = true;

    # Provide high-level default families (fontconfig will expand these first)
    defaultFonts = {
      serif = [
        "Source Serif 4"
        "Source Han Serif SC"
        "Source Han Serif TC"
        "Source Han Serif JP"
        "Source Han Serif KR"
        "Noto Serif"
        "STIX Two Math"
        "Noto Color Emoji"
        "Twemoji Color Emoji"
      ];
      sansSerif = [
        "Inter"
        "Source Sans 3"
        "Source Han Sans SC"
        "Source Han Sans TC"
        "Source Han Sans JP"
        "Source Han Sans KR"
        "Noto Sans"
        "STIX Two Math"
        "Noto Color Emoji"
        "Twemoji Color Emoji"
      ];
      monospace = [
        "JetBrains Mono"
        "Fira Code"
        "Source Code Pro"
        "Noto Sans Mono"
        "Noto Color Emoji"
        "Twemoji Color Emoji"
      ];
      emoji = [
        "Noto Color Emoji"
        "Twemoji Color Emoji"
      ];
    };
  };
}
