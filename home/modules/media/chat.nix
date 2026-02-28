{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    wechat-uos
    # discord
    telegram-desktop
    qq

    guvcview
  ];
}
