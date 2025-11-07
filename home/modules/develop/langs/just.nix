{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    just-formatter
    just-lsp
  ];
}
