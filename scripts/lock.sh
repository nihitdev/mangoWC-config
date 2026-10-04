#!/usr/bin/env bash
set -euo pipefail

MANGO="$HOME/.config/mango"
CURRENT="$MANGO/current-wallpaper"
FALLBACK="$MANGO/wallpapers/default.png"
TEMPLATE="$HOME/.config/mango/themes/hyprlock.conf"
CONFIG="$MANGO/hyprlock.conf"

pgrep -u "$(id -u)" -x hyprlock >/dev/null && exit 0

wall=""
if [[ -f "$CURRENT" ]]; then
    wall="$(realpath -- "$CURRENT")"
fi
if [[ ! -f "$wall" && -f "$FALLBACK" ]]; then
    wall="$(realpath -- "$FALLBACK")"
fi
[[ -f "$wall" ]] || wall=""

escaped="${wall//\\/\\\\}"
escaped="${escaped//&/\\&}"
escaped="${escaped//|/\\|}"
sed "s|__WALLPAPER__|$escaped|g" "$TEMPLATE" > "$CONFIG"

exec hyprlock --config "$CONFIG"
