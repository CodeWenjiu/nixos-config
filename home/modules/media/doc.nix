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

  # Craft 系列：用 nix-craftapps 跟上游 release（nixpkgs 里的 deckcraft 还停在 0.6.1）。
  # 想装整套把 enableAll 打开即可。
  programs.craftapps = {
    enable = true;
    apps = {
      deckcraft.enable = true;
      pdfcraft.enable = true;
      wordcraft.enable = true;
      gridcraft.enable = true;
    };
  };
}
