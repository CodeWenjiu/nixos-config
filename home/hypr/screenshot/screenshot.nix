{ screenshot }:
if screenshot == "flameshot" then ''
  # --- Screenshot (Flameshot) --- #
  bind = , PRINT, exec, flameshot gui
  # ------------------------------ #
''
else if screenshot == "grim" then ''
  # --- Screenshot (grim + slurp) --- #
  $screenshot_dir = $HOME/Pictures/Screenshots
  
  # To screenshot_dir
  bind = , PRINT, exec, grim -g "$(slurp)" "$screenshot_dir/$(date +'%Y-%m-%d_%H-%M-%S').png"
  
  # To wl-clipboard
  bind = SHIFT, PRINT, exec, grim -g "$(slurp)" - | wl-copy
  
  # To swappy
  bind = CTRL, PRINT, exec, grim -g "$(slurp)" - | swappy -f -
  # --------------------------------- #
''
else ''''
