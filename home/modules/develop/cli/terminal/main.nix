{
  ...
}:
{
  programs.ghostty.enable = true;

  xdg.configFile."ghostty/config" = {
    force = true;
    text = ''
      window-decoration = none
      cursor-style-blink = false
      background-opacity = 0.75
      background-opacity-cells = true
      background-blur = true

      keybind = ctrl+backspace=text:\x17
      keybind = ctrl+v=paste_from_clipboard

      copy-on-select = clipboard

      theme = noctalia
      custom-shader = ~/.config/ghostty/shaders/shader.glsl
      custom-shader-animation = true
    '';
  };

  xdg.configFile."ghostty/shaders" = {
    force = true;
    source = ./shaders;
  };
}
