{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    prettierd # JavaScript/TypeScript formatter
  ];
}
