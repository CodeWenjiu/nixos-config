{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    metals
    scalafix
  ];
}
