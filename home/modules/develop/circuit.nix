{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    kicad-small
    surfer
  ];

  xdg.desktopEntries.surfer = {
    name = "Surfer";
    genericName = "Waveform Viewer";
    exec = "surfer %f";
    icon = "utilities-system-monitor";
    terminal = false;
    categories = [ "Development" "Engineering" ];
    mimeType = [ "application/vnd.gtkwave-vcd" "application/octet-stream" ];
  };
}
