{
  pkgs,
  ...
}:
{
  # wechat: pinned to the lazily-updated nixpkgs pool (main pool's new
  # versions have flaky download URLs)
  wenjiu.lazyPackages = [ "wechat" "discord" ];

  home.packages = with pkgs; [
    wechat
    discord
    # telegram-desktop
    qq

    guvcview
  ];
}
