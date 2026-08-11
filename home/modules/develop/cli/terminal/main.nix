{
  ...
}:
{
  programs.ghostty.enable = true;

  xdg.configFile."ghostty/config.ghostty" = {
    force = true;
    text = ''
      window-decoration = none
      cursor-style-blink = false
      background-opacity = 0.75
      background-opacity-cells = true

      keybind = ctrl+backspace=text:\x17
      keybind = ctrl+v=paste_from_clipboard

      # ── Splits ──────────────────────────────
      keybind = ctrl+shift+alt+enter=new_split:auto
      keybind = ctrl+shift+alt+h=new_split:left
      keybind = ctrl+shift+alt+j=new_split:down
      keybind = ctrl+shift+alt+k=new_split:up
      keybind = ctrl+shift+alt+l=new_split:right
      keybind = ctrl+shift+alt+q=close_surface

      keybind = shift+alt+h=goto_split:left
      keybind = shift+alt+j=goto_split:down
      keybind = shift+alt+k=goto_split:up
      keybind = shift+alt+l=goto_split:right

      keybind = ctrl+shift+alt+up=resize_split:up,10
      keybind = ctrl+shift+alt+down=resize_split:down,10
      keybind = ctrl+shift+alt+left=resize_split:left,10
      keybind = ctrl+shift+alt+right=resize_split:right,10

      keybind = ctrl+shift+alt+f=toggle_split_zoom

      # ── Tabs ────────────────────────────────
      keybind = ctrl+shift+alt+n=new_tab
      keybind = ctrl+shift+alt+]=next_tab
      keybind = ctrl+shift+alt+[=previous_tab

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
