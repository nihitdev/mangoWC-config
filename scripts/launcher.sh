#!/usr/bin/env bash
set -euo pipefail

exec rofi -no-config \
    -show drun \
    -theme "$HOME/.config/mango/themes/rofi/launcher.rasi"
