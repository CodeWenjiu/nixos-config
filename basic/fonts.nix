{ pkgs, ... }:
{
  # System-level fonts exist for consumers that cannot see the user profile:
  #
  #   * kmscon renders the emergency TTY from this directory (see console.nix);
  #   * the SDDM greeter runs outside the user session and resolves through the
  #     system fontconfig only;
  #   * FHS/AppImage wrappers read /usr/share/fonts directly. The Ely Office
  #     apps do see the home-manager profile through XDG_DATA_DIRS, but that is
  #     not something worth relying on.
  #
  # Everything else on the desktop resolves through fontconfig and
  # home/modules/essential/font.nix. Keep this list small.
  fonts.packages = with pkgs; [
    inter
    source-sans
    # The desktop resolves Chinese through fontconfig and lands on Source Han
    # Sans, which home/modules/essential/font.nix installs into the user
    # profile. The SDDM greeter and the wrappers above cannot see that profile,
    # and the only Chinese in the system directory would otherwise be the Noto
    # Sans CJK collection plus Unifont - so the same text rendered in a
    # different face depending on which window you looked at. Shipping Source
    # Han Sans here too gives them the family the rest of the desktop uses.
    source-han-sans
  ];
}