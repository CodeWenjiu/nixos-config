{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    wemeet
  ];

  xdg.desktopEntries.wemeet = {
    name = "腾讯会议(Wayland)";
    genericName = "Video Conference";
    comment = "Tencent Meeting (WeMeet) for Linux (Wayland/XWayland)";
    exec = "wemeet-xwayland %U";
    icon = "wemeet";
    terminal = false;
    categories = [
      "Network"
      "VideoConference"
    ];
  };
}
