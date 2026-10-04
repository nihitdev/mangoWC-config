# ARCHNEMESIS · MangoWC

Familiar Hyprland controls. Mango’s native compositor, tags, and layouts.

A compact personal MangoWC configuration with Rose Pine inspired purple and pink accents, rounded borders, a dark desktop, and the existing ARCHNEMESIS application workflows.

![ARCHNEMESIS desktop running MangoWC](screenshots/desktop.png)

## The desktop

- **Seven native layouts**, cycled with **Super + L**: Tile → Scroller → Center Tile → Grid → Deck → Monocle → Vertical Scroller → Tile.
- **Five tags always visible** in Waybar. Tags 6–10 appear when occupied or active.
- **Full layout names** in the bar. Click the name to cycle; right-click for overview.
- **Compact geometry**: 4 px inner gaps, 8 px outer gaps, 2 px borders, 10 px corners.
- **Existing Rofi workflows** for applications, clipboard, wallpapers, and power actions.
- **SwayNC notifications**, PipeWire volume, playerctl media controls, and brightnessctl brightness.
- Mango experiments live under **Super + Ctrl + Alt**, away from everyday shortcuts.

![Top bar with five tags, full layout name, and power button](screenshots/top-bar.png)

These are actual captures of the running desktop. The desktop screenshot uses an empty Center Tile tag to show the wallpaper and bar without exposing open applications. Wallpaper artwork is not bundled separately.

## Structure

```text
.
├── config.conf
├── config/
│   ├── env.conf
│   ├── programs.conf
│   ├── appearance.conf
│   ├── animations.conf
│   ├── layouts.conf
│   ├── input.conf
│   ├── binds.conf
│   └── autostart.conf
├── scripts/
│   ├── wallpaper-picker.sh
│   ├── lock.sh
│   └── powermenu.sh
├── waybar.jsonc
└── screenshots/
    ├── desktop.png
    └── top-bar.png
```

`config.conf` sources the eight modules. Scripts retain the existing themed workflows while keeping Mango-generated lock configuration and wallpaper state inside `~/.config/mango/`.

## Everyday controls

| Keys | Action |
| --- | --- |
| Super + Return | Kitty |
| Super + B | Helium browser |
| Super + E | Dolphin |
| Super + Space | Existing Rofi launcher |
| Super + G | Kdenlive |
| Super + N | Neovim inside Kitty |
| Super + W | Close focused window |
| Super + H / J / K | Focus left / down / up |
| Super + arrows | Directional focus |
| **Super + L** | **Cycle the seven native layouts** |
| Super + left / right mouse drag | Move / resize |
| Super + 1…9 / 0 | View tags 1…9 / 10 |
| Super + Shift + 1…9 / 0 | Move window to tag and follow |
| Super + S / Shift + S | Toggle special tag / send window there |
| Super + mouse wheel | Previous / next occupied tag |
| Three-finger swipe left / right | Next / previous tag |
| Alt + Z or Print | Region screenshot: save, copy, notify |
| Shift + Print | Full screenshot: save, copy, notify |
| Super + V | Rofi + cliphist clipboard |
| Super + Alt + Space | Wallpaper picker |
| Super + Alt + L | Wallpaper-aware Hyprlock |
| Volume / microphone keys | wpctl volume and mute |
| Brightness keys | brightnessctl |
| Media keys | playerctl |

The power icon at the far right opens the existing styled Rofi menu: lock, suspend, logout, reboot, and shutdown. Logout dispatches Mango’s `quit`; other session actions retain confirmation dialogs.

## Optional Mango controls

Every shortcut below starts with **Super + Ctrl + Alt**. “Shift” means adding Shift to that same prefix.

| Additional key | Native action |
| --- | --- |
| 1…7 | Select Tile, Scroller, Center Tile, Grid, Deck, Monocle, Vertical Scroller |
| − / = | Decrease / increase master area |
| Shift + − / = | Decrease / increase master count |
| Return | Promote to master |
| P / Shift + P | Cycle scroller width presets / full width |
| Arrows / Shift + arrows | Scroller stack / exchange neighboring windows |
| H / J / K / L | Join group toward left / down / up / right |
| , / . / Shift + . | Previous group member / next member / leave group |
| Tab / Shift + Tab | Overview / current-tag overview |
| A | Jump mode |
| Q / Shift + Q | Thumbnail switcher next / previous |
| F1…F10 | Toggle tags in the current view |
| Shift + F1…F10 | Toggle focused window’s tag membership |
| Shift + A | View all tags |
| F / Shift + F | Fullscreen / maximize |
| C / O / G | Floating / overlay / global window |
| S | Toggle scratchpad |
| Shift + S / Shift + R | Minimize / restore |
| Backtick | Named scratch Kitty |
| R | Reload Mango configuration |

Try opening several windows and pressing Super + L. Scroller offers horizontal columns; Center Tile puts the master in the middle; Deck and Monocle provide different stacking behaviors. Use the isolated shortcuts to try groups, overview, tag combinations, and scratchpads without changing the familiar controls.

## Requirements and existing integrations

This is a snapshot of a personal setup, **not a standalone dotfiles distribution**. It preserves the current machine’s paths and reuses configurations outside this repository.

Validated with **MangoWC 0.17.5** and **Waybar 0.15.0**. Waybar needs `ext/workspaces` support; layout names use Mango IPC through `mmsg` and `jq`.

Required tools for the configured workflows include Kitty, Helium (`helium-browser`), Dolphin, Kdenlive, Neovim, Rofi, cliphist, wl-clipboard, grim, slurp, libnotify (`notify-send`), swaybg, Hyprlock, SwayNC, WirePlumber (`wpctl`), brightnessctl, playerctl, Bash, and jq. The theme also assumes Bibata-Modern-Ice, qt6ct/Kvantum, and fonts containing the bar and Rofi glyphs.

Existing files used directly:

- `~/.config/rofi/launchers/launcher.sh`
- `~/.config/rofi/clipboard/clipboard.sh`
- `~/.config/rofi/wallpaper/wallpaper.rasi`
- `~/.config/rofi/powermenu/type-2/style-5.rasi`
- `~/.config/hypr/scripts/screenshot.sh`
- `~/.config/hyprlock/hyprlock.template.conf`
- `~/.config/waybar/style.css` and its scripts: `skull.sh`, `catloop.sh`, `tui.sh`, `notifications.sh`
- `~/.local/bin/battery-guardian`

The wallpaper picker reads `~/Pictures/Wallpapers/CozyPixels/Catppuccin/Space & Cosmic`. Startup and locking can fall back to the existing Hyprland wallpaper reference; locking also reads `~/.cache/current-wallpaper`. These external files are referenced, not modified or included here.

SwayNC and audio are managed by existing services. Clipboard startup is guarded against an active service or watcher; Waybar, swaybg, and battery-guardian startup are also guarded. Hypridle is omitted because its existing hooks target Hyprland.

## Use on the original machine

The repository mirrors `~/.config/mango/`; it is not loaded directly from the project directory. To deploy it deliberately:

```sh
mkdir -p ~/.config/mango
cp -r config scripts config.conf waybar.jsonc ~/.config/mango/
mango -c ~/.config/mango/config.conf -p
```

This replaces the corresponding Mango files. On another machine, update the absolute `/home/zei/.config/mango/` source paths in `config.conf`, supply or adapt the external integrations above, and adjust hardware-specific settings such as `intel_backlight`. No package installation or changes to other application configurations are automated.

## Validate

```sh
mango -c ~/.config/mango/config.conf -p
bash -n scripts/*.sh
shellcheck scripts/*.sh
jq empty waybar.jsonc
```

Keep `-c` before `-p`: Mango’s parse check uses the configuration selected at that point. The parser check does not verify that external applications, themes, or services exist. Runtime wallpaper links and generated lock configuration are excluded from Git.
