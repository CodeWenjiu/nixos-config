{ pkgs, ... }:
{
  # The in-kernel VT (Ctrl+Alt+F*) only accepts PSF console fonts, and those
  # top out at 512 glyphs — no CJK, no Nerd Font icons. kmscon is a userspace
  # KMS terminal that renders with fontconfig/TrueType, so a single font can
  # cover both Chinese filenames and prompt glyphs.
  services.kmscon = {
    enable = true;
    useXkbConfig = true;
    config = {
      font-name = "Maple Mono NF CN";
      term = "xterm-256color";
    };
  };

  # kmscon renders as root, so the font has to live in the system fontconfig;
  # the fonts in home/modules/essential/font.nix are only visible to the user.
  fonts.packages = [ pkgs.maple-mono.NF-CN ];
}
