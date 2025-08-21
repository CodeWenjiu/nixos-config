{
  pkgs,
  ...
}:
let
  jdk21_warp = pkgs.jdk21.overrideAttrs (old: {
    meta = old.meta // {
      priority = 5;
    };
  });
  jdk17_warp = pkgs.jdk17.overrideAttrs (old: {
    meta = old.meta // {
      priority = 10;
    };
  });
in
{
  home.packages = with pkgs; [
    # minecraft
    modrinth-app
    cacert # TLS
    jdk21_warp
    jdk17_warp
  ];
}
