#!/usr/bin/env bash
set -euo pipefail

exec rofi -no-config \
    -modi "clipboard:bash \"$HOME/.config/mango/scripts/cliphist-rofi\"" \
    -show clipboard \
    -theme "$HOME/.config/mango/themes/rofi/launcher.rasi"
