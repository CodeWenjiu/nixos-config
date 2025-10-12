# WeMeet (腾讯会议) XWayland 修復指南

## 問題描述

在 NixOS + niri (純 Wayland compositor) 環境下，執行 `wemeet-xwayland` 時出現：

```
wemeet:WemeetSatrt
[1]    6370 IOT instruction (core dumped)  wemeet-xwayland
```

## 根本原因

1. **缺少 Xwayland 服務**：niri 配置中雖然設置了 `xwayland-satellite.enable = true`，但沒有實際安裝和啟動 `xwayland-satellite` systemd 服務
2. **環境變量衝突**：全局設置的 `NIXOS_OZONE_WL=1` 等 Wayland 變量干擾了 XWayland 應用的 Qt backend 選擇
3. **缺少多媒體依賴**：GStreamer 插件、字體、OpenGL 驅動缺失導致 Qt WebEngine 初