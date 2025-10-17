{
  ...
}:
{
  # use flatpack instead for now cause: https://github.com/nixos/nixpkgs/issues/441999
  # home.packages = with pkgs; [
  #   wemeet # crush when open camera, see https://github.com/NixOS/nixpkgs/issues/421983
  # ];

  # xdg.desktopEntries.wemeet = {
  #   name = "腾讯会议(Wayland)";
  #   genericName = "Video Conference";
  #   comment = "Tencent Meeting (WeMeet) for Linux (Wayland/XWayland)";
  #   exec = "wemeet-xwayland %U";
  #   icon = "wemeet";
  #   terminal = false;
  #   categories = [
  #     "Network"
  #     "VideoConference"
  #   ];
  # };
}
