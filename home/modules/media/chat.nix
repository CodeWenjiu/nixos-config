{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # wechat
    # discord
    telegram-desktop
    qq

    guvcview
  ];
}
