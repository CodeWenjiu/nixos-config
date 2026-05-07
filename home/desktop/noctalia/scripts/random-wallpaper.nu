#!/usr/bin/env nu

def main [
    --gif-only(-g)  # Only select GIF files as wallpaper candidates
    --restore(-r)   # Restore the last used wallpaper from cache
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

    # 保存当前壁纸路径到缓存文件
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

    # 如果是恢复模式，尝试加载缓存中的壁纸
    let selected_wallpaper = if $restore {
        let cached_wallpaper = (get_current_wallpaper)
        if ($cached_wallpaper != null) and ($cached_wallpaper | path exists) {
            print $"Restoring wallpaper: ($cached_wallpaper | path basename)"
            $cached_wallpaper
        } else {
            if ($cached_wallpaper != null) {
                print $"Warning: Cached wallpaper ($cached_wallpaper | path basename) no longer exists"
            } else {
                print "Warning: No cached wallpaper found"
            }
            print "Falling back to random selection..."
            # 回退到随机选择逻辑
            if ($wallpapers | is-empty) {
                let file_type = if $gif_only { "GIF" } else { "image" }
                print $"Error: No ($file_type) files found in ($WALLPAPER_DIR)"
                exit 1
            }
            $wallpapers | shuffle | first
        }
    } else {
        # 正常的随机选择模式
        # 检查是否找到壁纸
        if ($wallpapers | is-empty) {
            let file_type = if $gif_only { "GIF" } else { "image" }
            print $"Error: No ($file_type) files found in ($WALLPAPER_DIR)"
            exit 1
        }

        # 显示找到的壁纸数量和格式信息
        let file_type = if $gif_only { "GIF files only" } else { "image files (excluding GIF)" }
        print $"Found ($wallpapers | length) wallpapers \(($file_type)\)"

        # 获取当前壁纸
        let current_wallpaper = (get_current_wallpaper)

        # 过滤掉当前壁纸，获取可选择的壁纸列表
        let available_wallpapers = if ($current_wallpaper != null) {
            $wallpapers | where $it != $current_wallpaper
        } else {
            $wallpapers
        }

        # 如果过滤后没有可选壁纸（只有一张壁纸的情况），使用原始列表
        let final_wallpapers = if ($available_wallpapers | is-empty) {
            print "Warning: Only one wallpaper available, will set the same wallpaper"
            $wallpapers
        } else {
            $available_wallpapers
        }

        # 随机选择一张壁纸
        $final_wallpapers | shuffle | first
    }

    # 显示信息
    if not $restore {
        let current_wallpaper = (get_current_wallpaper)
        if ($current_wallpaper != null) {
            print $"Current wallpaper: ($current_wallpaper | path basename)"
        }
    }
    print $"Setting wallpaper: ($selected_wallpaper | path basename)"

    # 保存新选择的壁纸到缓存
    save_current_wallpaper $selected_wallpaper

    # 使用 awww 设置壁纸，带过渡效果
    awww img $selected_wallpaper --transition-type random --transition-fps 60 --transition-step 60

    # 生成主题 (--source-color-index 0 跳过 matugen 4.0 的交互式选色)
    matugen image $selected_wallpaper --source-color-index 0
}
