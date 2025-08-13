{ wallpaper }:
if wallpaper == "hyprpaper" then
  ''
    # --- Wallpaper (hyprpaper) --- #
    exec-once = uwsm app -- hyprpaper
    # ------------------------------ #
  ''
else if wallpaper == "swww" then
  ''
    # --- Wallpaper (swww) --- #
    exec-once = swww-daemon
    # ------------------------ #
  ''
else
  ''''
