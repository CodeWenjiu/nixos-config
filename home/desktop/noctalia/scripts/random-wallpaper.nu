#!/usr/bin/env nu

def main [
    --gif-only(-g)  # Only select GIF files as wallpaper candidates
] {
    const WALLPAPER_DIR = "/mnt/data/wallpapers"

    let supported_formats = if $gif_only {
        [".gif"]
    } else {
        [".jpg", ".jpeg", ".png", ".webp", ".bmp"]
    }

    const CACHE_FILE = "~/.cache/random-wallpaper/current_wallpaper"

    mkdir ~/.cache/random-wallpaper

    def get_current_wallpaper [] {
        try {
            if ($CACHE_FILE | path expand | path exists) {
                open ($CACHE_FILE | path expand) | str trim
            } else {
                null
            }
        } catch {
            null
        }
    }

    def save_current_wallpaper [wallpaper_path: string] {
        try {
            $wallpaper_path | save -f ($CACHE_FILE | path expand)
        } catch {
            print "Warning: Could not save current wallpaper to cache"
        }
    }

    let wallpapers = (
        ls $WALLPAPER_DIR
        | where type == file
        | where {|file|
            $supported_formats | any {|ext|
                ($file.name | str downcase | str ends-with $ext)
            }
        }
        | get name
    )

    if ($wallpapers | is-empty) {
        let file_type = if $gif_only { "GIF" } else { "image" }
        print $"Error: No ($file_type) files found in ($WALLPAPER_DIR)"
        exit 1
    }

    let file_type = if $gif_only { "GIF files only" } else { "image files (excluding GIF)" }
    print $"Found ($wallpapers | length) wallpapers \(($file_type)\)"

    let current_wallpaper = (get_current_wallpaper)

    let available_wallpapers = if ($current_wallpaper != null) {
        $wallpapers | where $it != $current_wallpaper
    } else {
        $wallpapers
    }

    let final_wallpapers = if ($available_wallpapers | is-empty) {
        print "Warning: Only one wallpaper available, will set the same wallpaper"
        $wallpapers
    } else {
        $available_wallpapers
    }

    let random_wallpaper = ($final_wallpapers | shuffle | first)

    if ($current_wallpaper != null) {
        print $"Current wallpaper: ($current_wallpaper | path basename)"
    }
    print $"Setting new wallpaper: ($random_wallpaper | path basename)"

    save_current_wallpaper $random_wallpaper

    swww img $random_wallpaper --transition-type random --transition-fps 60 --transition-step 60

    matugen image $random_wallpaper
}
