{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    readest
    obsidian
    feishu
    wpsoffice-cn
    onlyoffice-desktopeditors
  ];
}
