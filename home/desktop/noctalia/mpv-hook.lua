-- mpv Lua script to sync video wallpaper to Noctalia native wallpaper
local msg = require 'mp.msg'

local function on_file_loaded()
    local path = mp.get_property("path")
    if not path or path == "" then
        msg.warn("No file path found.")
        return
    end

    local lpath = path:lower()
    if not (lpath:match("%.mp4$") or lpath:match("%.webm$") or lpath:match("%.mkv$") or lpath:match("%.mov$") or lpath:match("%.gif$")) then
        return
    end

    local home = os.getenv("HOME")
    if not home or home == "" then
        msg.error("HOME environment variable is not set.")
        return
    end

    local cache_base = os.getenv("XDG_CACHE_HOME")
    if not cache_base or cache_base == "" then
        cache_base = home .. "/.cache"
    end

    local cache_dir = cache_base .. "/noctalia/mpvpaper"

    local function shell_escape(s)
        return "'" .. string.gsub(s, "'", "'\\''") .. "'"
    end

    local esc_cache_dir = shell_escape(cache_dir)
    local esc_path = shell_escape(path)

    local cmd = string.format([=[
        if ! command -v ffmpeg >/dev/null 2>&1; then
            echo "mpv-hook error: ffmpeg not found in PATH" >&2
            exit 1
        fi
        if ! command -v noctalia >/dev/null 2>&1; then
            echo "mpv-hook error: noctalia not found in PATH" >&2
            exit 1
        fi

        cache_dir=%s
        input_path=%s

        mkdir -p "$cache_dir" || exit 1

        clean_name=$(echo -n "$input_path" | md5sum | awk '{print $1}')
        dest="$cache_dir/${clean_name}.jpg"

        if [ ! -f "$dest" ]; then
            ffmpeg -y -i "$input_path" -ss 00:00:01 -vframes 1 "$dest" >/dev/null 2>&1 || exit 1
        fi

        if [ -f "$dest" ]; then
            noctalia msg wallpaper-set "$dest" >/dev/null 2>&1
        fi
    ]=], esc_cache_dir, esc_path)

    msg.info("Syncing wallpaper colors for: " .. path)
    mp.commandv("run", "sh", "-c", cmd)
end

mp.register_event("file-loaded", on_file_loaded)
