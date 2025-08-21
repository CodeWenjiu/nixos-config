{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    dust
    duf

    qdiskinfo # sudo -E qdiskinfo
  ];
}
