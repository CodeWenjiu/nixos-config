{
  ...
}:
{
  programs.ghostty = {
    enable = true;
  };

  xdg.configFile."ghostty/config".text = ''
    cursor-style-blink = false
    background-opacity = 0.5
    background-opacity-cells = true
    background-blur = true
  '';
}
