#!/usr/bin/env bash
set -euo pipefail

WALLDIR="$HOME/Pictures/Wallpapers/CozyPixels/Catppuccin/Space & Cosmic"
CURRENT="$HOME/.config/mango/current-wallpaper"
THEME="$HOME/.config/rofi/wallpaper/wallpaper.rasi"

[[ -d "$WALLDIR" ]] || {
    notify-send -a Wallpaper "Wallpaper directory not found" "$WALLDIR"
    exit 1
}

mapfile -d '' -t walls < <(
    find "$WALLDIR" -type f \
        \( -iname '*.png' \
        -o -iname '*.jpg' \
        -o -iname '*.jpeg' \
        -o -iname '*.webp' \) \
        -print0
)

((${#walls[@]} > 0)) || {
    notify-send -a Wallpaper "No wallpapers found" "$WALLDIR"
    exit 1
}

selection="$(
    for wall in "${walls[@]}"; do
        printf '%s\0icon\x1f%s\n' "$(basename "$wall")" "$wall"
    done |
        rofi -dmenu \
            -i \
            -show-icons \
            -p "󰸉  Wallpaper" \
            -theme "$THEME"
)" || exit 0

[[ -n "$selection" ]] || exit 0

wall=""

for candidate in "${walls[@]}"; do
    if [[ "$(basename "$candidate")" == "$selection" ]]; then
        wall="$candidate"
        break
    fi
done

[[ -n "$wall" ]] || exit 1

while IFS= read -r pid; do
    if grep -zFxq "WAYLAND_DISPLAY=$WAYLAND_DISPLAY" "/proc/$pid/environ" 2>/dev/null; then
        kill "$pid" 2>/dev/null || true
    fi
done < <(pgrep -u "$(id -u)" -x swaybg || true)

ln -sfn -- "$wall" "$CURRENT"
exec swaybg -i "$wall" -m fill -c 191724
