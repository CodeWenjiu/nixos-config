{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # readest
    obsidian
    feishu
    wpsoffice-cn
    # onlyoffice-desktopeditors
  ];

  # Ely Office 见同目录的 elyoffice.nix。
}
