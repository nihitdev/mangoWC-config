#!/usr/bin/env bash
set -euo pipefail

MANGO="$HOME/.config/mango"
CURRENT="$MANGO/current-wallpaper"
CACHE="$HOME/.cache/current-wallpaper"
FALLBACK="$HOME/.config/hypr/current-wallpaper"
TEMPLATE="$HOME/.config/hyprlock/hyprlock.template.conf"
CONFIG="$MANGO/hyprlock.conf"

pgrep -u "$(id -u)" -x hyprlock >/dev/null && exit 0

wall=""
if [[ -f "$CURRENT" ]]; then
    wall="$(realpath -- "$CURRENT")"
elif [[ -r "$CACHE" ]]; then
    IFS= read -r wall < "$CACHE" || true
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
