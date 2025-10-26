{
  ...
}:
{
  programs.ghostty = {
    enable = true;
  };

  xdg.configFile."ghostty/config".text = ''
    window-decoration = none
    cursor-style-blink = false
    background-opacity = 0.7
    background-opacity-cells = true
    background-blur = true

    keybind = ctrl+backspace=text:\x17

    custom-shader = ~/.config/ghostty/shaders/shader.glsl
    custom-shader-animation = true
  '';

  xdg.configFile."ghostty/shaders".source = ./shaders;
}
