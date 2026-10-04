#!/usr/bin/env bash
set -euo pipefail

usage() {
    printf '%s\n' 'Usage: install.sh [--repo URL] [--branch NAME] [--clone-dir PATH] [--check]' \
        'Installs into ~/.config/mango, replacing repository-owned files.' \
        '--check validates and reports dependencies without installing.'
}

repo="${MANGO_REPO_URL:-}"
branch="${MANGO_BRANCH:-main}"
clone_dir="${MANGO_CLONE_DIR:-$HOME/.local/share/mangoWC-config}"
check=0
while (($#)); do
    case "$1" in
        --repo|--branch|--clone-dir)
            (($# >= 2)) || { usage >&2; exit 2; }
            case "$1" in
                --repo) repo="$2" ;;
                --branch) branch="$2" ;;
                --clone-dir) clone_dir="$2" ;;
            esac
            shift 2 ;;
        --check) check=1; shift ;;
        --help|-h) usage; exit 0 ;;
        *) usage >&2; exit 2 ;;
    esac
done

for tool in python3 mango mktemp cp mkdir; do
    command -v "$tool" >/dev/null || { printf 'Required tool missing: %s\n' "$tool" >&2; exit 1; }
done

source_dir=""
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
    source_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
fi
if [[ ! -f "$source_dir/config/layouts.conf" ]]; then
    [[ -n "$repo" ]] || { printf 'Bootstrap requires --repo URL or MANGO_REPO_URL.\n' >&2; exit 2; }
    command -v git >/dev/null || { printf 'Bootstrap requires git.\n' >&2; exit 1; }
    [[ ! -e "$clone_dir" ]] || { printf 'Clone destination already exists: %s\nRun its install.sh directly or choose another --clone-dir.\n' "$clone_dir" >&2; exit 1; }
    mkdir -p -- "$(dirname -- "$clone_dir")"
    git clone --depth 1 --branch "$branch" -- "$repo" "$clone_dir"
    cd -- "$clone_dir"
    args=()
    ((check)) && args+=(--check)
    exec bash ./install.sh "${args[@]}"
fi

target="$HOME/.config/mango"
[[ "$source_dir" != "$target" ]] || { printf 'Run the installer from the repository, not the live config directory.\n' >&2; exit 1; }
stage="$(mktemp -d)"
trap 'rm -rf -- "$stage"' EXIT
cp -R -- "$source_dir/config" "$source_dir/scripts" "$stage/"
cp -- "$source_dir/config.conf" "$source_dir/waybar.jsonc" "$stage/"

for script in "$stage"/scripts/*.sh; do bash -n "$script"; done
if command -v shellcheck >/dev/null; then shellcheck "$stage"/scripts/*.sh; fi
python3 - "$stage" <<'PY'
import json, pathlib, sys
root = pathlib.Path(sys.argv[1])
json.loads((root / 'waybar.jsonc').read_text())
modules = ['env', 'programs', 'appearance', 'animations', 'layouts', 'input', 'binds', 'autostart']
with (root / 'check.conf').open('w') as file:
    for module in modules:
        path = root / 'config' / (module + '.conf')
        if not path.is_file():
            raise SystemExit(f'Missing module: {path}')
        line = f'source={path}'
        if len(line.encode()) > 510:
            raise SystemExit('Configuration path exceeds Mango parser line length')
        file.write(line + '\n')
PY
mango -c "$stage/check.conf" -p

missing=0
for tool in kitty helium-browser dolphin kdenlive nvim rofi cliphist wl-paste wl-copy grim slurp notify-send swaybg hyprlock swaync-client wpctl brightnessctl playerctl waybar mmsg jq; do
    if ! command -v "$tool" >/dev/null; then
        printf 'Workflow dependency missing: %s\n' "$tool" >&2
        missing=1
    fi
done
for relative in rofi/launchers/launcher.sh rofi/clipboard/clipboard.sh rofi/wallpaper/wallpaper.rasi rofi/powermenu/type-2/style-5.rasi hypr/scripts/screenshot.sh hyprlock/hyprlock.template.conf waybar/style.css waybar/scripts/skull.sh waybar/scripts/catloop.sh waybar/scripts/tui.sh waybar/scripts/notifications.sh; do
    if [[ ! -r "$HOME/.config/$relative" ]]; then
        printf 'Existing integration missing: ~/.config/%s\n' "$relative" >&2
        missing=1
    fi
done
if [[ ! -x "$HOME/.local/bin/battery-guardian" ]]; then
    printf 'Optional battery helper missing: ~/.local/bin/battery-guardian\n' >&2
fi
((missing == 0)) || printf 'Config validation passed; listed workflows need their existing tools/themes. See README.\n' >&2
if ((check)); then
    printf 'Checks passed; no configuration installed.\n'
    exit 0
fi

mkdir -p -- "$target/config" "$target/scripts"
for file in "$stage"/config/*.conf "$stage"/scripts/*.sh; do
    relative="${file#"$stage/"}"
    cp -- "$file" "$target/$relative"
done
cp -- "$stage/config.conf" "$stage/waybar.jsonc" "$target/"
mango -c "$target/config.conf" -p
printf 'Installed and validated: %s\nNo packages installed; other app configs unchanged.\nLog into Mango or use Super+Ctrl+Alt+R to reload.\n' "$target"
