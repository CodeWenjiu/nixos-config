{ pkgs, ... }:
{
  # System-level fonts exist for consumers that read the font *directory*
  # instead of going through fontconfig:
  #
  #   * kmscon renders the emergency TTY from this directory (see console.nix);
  #   * the Craft apps scan /usr/share/fonts, which programs.craftapps.linkFonts
  #     points at exactly this directory, and never look at the per-user
  #     ~/.local/share/fonts where home/modules/essential/font.nix installs
  #     things.
  #
  # That is why the Craft UI ignored the Inter preference set in the home
  # module and fell back to DejaVu Sans - Inter simply was not in the directory
  # they read. Keep this list to the fonts those two need; everything else on
  # the desktop resolves through fontconfig and the home module.
  fonts.packages = with pkgs; [
    inter
    source-sans
    # The desktop resolves Chinese through fontconfig and lands on Source Han
    # Sans, which home/modules/essential/font.nix installs into the user
    # profile. The Craft apps cannot see that profile, and the only Chinese
    # they found in this directory were the Noto Sans CJK collection plus
    # Unifont - so the same text rendered in a different face depending on
    # which window you looked at. Shipping Source Han Sans here too gives them
    # the family the rest of the desktop uses.
    source-han-sans
  ];
}