{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bilibili
    bilibili-tui
    # mpv is provided by programs.mpv below (mpv-with-scripts)
  ];

  programs.mpv = {
    enable = true;
    # pkgs.mpv is mpv-with-scripts in nixpkgs by default.

    scripts = with pkgs.mpvScripts; [
      uosc
      thumbfast
    ];

    # uosc + thumbfast default configs are already good.
    # Only override a few things that match this setup.
    scriptOpts = {
      uosc = {
        # Top bar with window title, no visible border
        top_bar = "no-border";
        # Keep animations snappy
        animation_duration = 100;
        # Keep the default full control set (uosc default is already good)
        # controls = "menu,gap,<video,audio>subtitles,...";
      };
    };

    config = {
      # -- Rendering quality --------------------------------------
      # High-quality scaling
      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      dscale = "mitchell";
      # Smooth video playback
      video-sync = "display-resample";
      interpolation = true;
      tscale = "oversample";
      # Smooth seeking
      hr-seek = true;

      # -- Window / UI -------------------------------------------
      # Remember playback position on quit
      save-position-on-quit = true;
      # Don't show big OSD text on volume/seek (cleaner)
      osd-level = 1;

      # -- Subtitles --------------------------------------------
      # Prefer embedded subtitles, fall back to files
      sub-auto = "fuzzy";
    };

    # Uosc replaces the default OSC automatically (it sets osc=no itself),
    # so no need to set osc=false here.

    bindings = {
      # Shift+Right/Left: speed up / slow down playback.
      # Matches uosc's default speed_step of 0.1 (non-factor).
      "Shift+RIGHT" = "add speed 0.1";
      "Shift+LEFT" = "add speed -0.1";
    };
  };
}
