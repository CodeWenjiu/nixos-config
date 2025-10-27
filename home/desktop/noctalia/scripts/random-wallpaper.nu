#!/usr/bin/env nu

# 壁纸目录
const WALLPAPER_DIR = "/mnt/data/wallpapers"

# 支持的图片格式
const SUPPORTED_FORMATS = [".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp"]

# 缓存文件路径
const CACHE_FILE = "~/.cache/random-wallpaper/current_wallpaper"

# 创建缓存目录（如果不存在）
mkdir ~/.cache/random-wallpaper

# 获取当前壁纸路径
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

# 获取所有支持的壁纸文件
let wallpapers = (
    ls $WALLPAPER_DIR
    | where type == file
    | where {|file|
        $SUPPORTED_FORMATS | any {|ext|
            ($file.name | str downcase | str ends-with $ext)
        }
    }
    | get name
)

# 检查是否找到壁纸
if ($wallpapers | is-empty) {
    print $"Error: No wallpapers found in ($WALLPAPER_DIR)"
    exit 1
}

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
let random_wallpaper = ($final_wallpapers | shuffle | first)

# 显示信息
if ($current_wallpaper != null) {
    print $"Current wallpaper: ($current_wallpaper | path basename)"
}
print $"Setting new wallpaper: ($random_wallpaper | path basename)"

# 保存新选择的壁纸到缓存
save_current_wallpaper $random_wallpaper

# 使用 swww 设置壁纸，带过渡效果
swww img $random_wallpaper --transition-type random --transition-fps 60 --transition-step 60

# 生成主题
matugen image $random_wallpaper
