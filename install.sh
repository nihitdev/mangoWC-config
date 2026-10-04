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
cp -R -- "$source_dir/config" "$source_dir/scripts" "$source_dir/themes" "$source_dir/wallpapers" "$stage/"
cp -- "$source_dir/config.conf" "$source_dir/waybar.jsonc" "$stage/"

for script in "$stage"/scripts/*.sh "$stage/scripts/cliphist-rofi"; do bash -n "$script"; done
if command -v shellcheck >/dev/null; then shellcheck "$stage"/scripts/*.sh "$stage/scripts/cliphist-rofi"; fi
python3 - "$stage" <<'PY'
import json, pathlib, sys
root = pathlib.Path(sys.argv[1])
json.loads((root / 'waybar.jsonc').read_text())
json.loads((root / 'themes/swaync/config.json').read_text())
for script in (root / 'scripts').glob('*.py'):
    compile(script.read_text(), str(script), 'exec')
required = ['themes/rofi/launcher.rasi', 'themes/rofi/wallpaper.rasi',
            'themes/rofi/power.rasi', 'themes/waybar.css', 'themes/hyprlock.conf',
            'themes/swaync/style.css', 'wallpapers/default.png',
            'scripts/launcher.sh', 'scripts/clipboard.sh', 'scripts/cliphist-rofi',
            'scripts/screenshot.sh', 'scripts/lock.sh', 'scripts/powermenu.sh',
            'scripts/wallpaper-picker.sh', 'scripts/art-animation.py',
            'scripts/skull.sh', 'scripts/catloop.sh', 'scripts/tui.sh',
            'scripts/notifications.sh', 'scripts/battery-guardian.sh']
for relative in required:
    if not (root / relative).is_file():
        raise SystemExit(f'Missing bundled asset: {relative}')
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
for tool in kitty helium-browser dolphin kdenlive nvim rofi cliphist wl-paste wl-copy grim slurp notify-send swaybg hyprlock swaync swaync-client wpctl brightnessctl playerctl waybar mmsg jq; do
    if ! command -v "$tool" >/dev/null; then
        printf 'Workflow dependency missing: %s\n' "$tool" >&2
        missing=1
    fi
done
for tool in btop pulsemixer nmtui bluetui cava calcurse yazi flock fc-match; do
    if ! command -v "$tool" >/dev/null; then
        printf 'Optional bar/helper tool missing: %s\n' "$tool" >&2
    fi
done
((missing == 0)) || printf 'Bundled configuration is valid; listed applications still need to be installed. No packages are installed automatically.\n' >&2
if ((check)); then
    printf 'Checks passed; no configuration installed.\n'
    exit 0
fi

mkdir -p -- "$target"
cp -R -- "$stage/config" "$stage/scripts" "$stage/themes" "$stage/wallpapers" "$target/"
cp -- "$stage/config.conf" "$stage/waybar.jsonc" "$target/"
mango -c "$target/config.conf" -p
printf 'Installed and validated: %s\nNo packages installed; other app configs unchanged.\nLog into Mango or use Super+Ctrl+Alt+R to reload.\n' "$target"
