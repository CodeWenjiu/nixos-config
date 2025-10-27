#!/usr/bin/env nu

# 壁纸目录
const WALLPAPER_DIR = "/mnt/data/wallpapers"

# 支持的图片格式
const SUPPORTED_FORMATS = [".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp"]

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

# 随机选择一张壁纸
let random_wallpaper = ($wallpapers | shuffle | first)

print $"Setting wallpaper: ($random_wallpaper)"

# 使用 swww 设置壁纸，带过渡效果
swww img $random_wallpaper --transition-type random --transition-fps 60 --transition-step 60

# 生成主题
matugen image $random_wallpaper
