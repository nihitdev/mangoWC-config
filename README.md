<div align="center">

# ARCHNEMESIS · MangoWC

**Hyprland controls. Mango compositor.**

![MangoWC](https://img.shields.io/badge/MangoWC-0.17.5-c4a7e7?style=flat-square&labelColor=191724)
![Waybar](https://img.shields.io/badge/Waybar-0.15.0-9ccfd8?style=flat-square&labelColor=191724)
![Palette](https://img.shields.io/badge/Palette-Ros%C3%A9_Pine-eb6f92?style=flat-square&labelColor=191724)
![Installer](https://img.shields.io/badge/Installer-Bash-a6da95?style=flat-square&labelColor=191724)

Compact gaps · Rounded borders · Seven native layouts · Familiar shortcuts

</div>

---

## Install

Have **MangoWC, Bash, Python 3, Git, and curl** installed, then run as your desktop user:

```bash
curl -fsSL https://raw.githubusercontent.com/nihitdev/mangoWC-config/main/install.sh | bash -s -- --repo https://github.com/nihitdev/mangoWC-config.git
```

**Clone → validate → install into `~/.config/mango/`.** Themes, scripts, and a wallpaper are included. No old Hyprland configuration is needed.

The installer reports missing applications; it does **not** install packages. It replaces this repo’s Mango files, preserves runtime state, and leaves other application configs alone.

Log into **MangoWC**, or reload with **Super + Ctrl + Alt + R**.

<details>
<summary><b>Local install, updates & installer options</b></summary>

```bash
# From an existing clone:
./install.sh --check
./install.sh

# Update that clone and reinstall:
git pull --ff-only
./install.sh

# See all options:
./install.sh --help
```

| Option | Purpose |
| :--- | :--- |
| `--check` | Validate without deploying; bootstrap still clones |
| `--clone-dir PATH` | Choose the clone location; default `~/.local/share/mangoWC-config` |
| `--branch NAME` | Choose a branch when cloning; default `main` |
| `--repo URL` | Choose a repository; useful for forks |

An existing clone directory is never reset or overwritten. Run its installer directly. `MANGO_REPO_URL`, `MANGO_BRANCH`, and `MANGO_CLONE_DIR` also set bootstrap defaults.

Home paths are portable. The installer creates no backups and does not restart your desktop or bar.

</details>

---

## Preview

![ARCHNEMESIS desktop](screenshots/desktop.png)

![ARCHNEMESIS top bar](screenshots/top-bar.png)

Actual desktop captures, taken on an empty Center Tile tag. The default wallpaper is included.

---

## Desktop

| Feature | Setup |
| :--- | :--- |
| Appearance | Dark Rosé Pine inspired palette; purple/pink accents |
| Geometry | 4 px inner gaps · 8 px outer gaps · 2 px borders · 10 px corners |
| Tags | 1–5 always visible; 6–10 appear when occupied or active |
| Layout label | Full names; click to cycle, right-click for overview |
| Workflows | Rofi launcher, clipboard, wallpapers, and power menu |
| Notifications | SwayNC; existing service takes precedence |
| Hardware | wpctl volume · brightnessctl · playerctl |

### One key, seven layouts

Press **Super + L** to cycle the current tag:

```text
Tile → Scroller → Center Tile → Grid → Deck → Monocle → Vertical Scroller
 ↑__________________________________________________________________|
```

Open a few windows and try the cycle. Use the optional controls below to explore scroller widths, groups, overview, and scratchpads.

---

## Controls

**Super** is your Windows/Meta key. Everyday shortcuts keep the Hyprland muscle memory.

| Keys | Action |
| :--- | :--- |
| **Super + Return** | Kitty |
| **Super + Space** | Rofi launcher |
| **Super + B / E** | Helium / Dolphin |
| **Super + W** | Close window |
| **Super + arrows** | Focus movement |
| **Super + L** | Cycle layouts |
| **Super + 1…0** | Switch tags |
| **Super + Shift + 1…0** | Move window and follow |
| **Super + V** | Clipboard |
| **Alt + Z / Print** | Region screenshot |
| **Super + Alt + Space** | Wallpaper picker |
| **Super + Alt + L** | Lock |

<details>
<summary><b>All everyday bindings</b></summary>

| Keys | Action |
| --- | --- |
| Super + Return | Kitty |
| Super + B | Helium browser |
| Super + E | Dolphin |
| Super + Space | Rofi launcher |
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

The power button at the far right opens **lock · suspend · logout · reboot · shutdown**. Logout targets Mango; session actions other than locking request confirmation.

</details>

<details>
<summary><b>Optional Mango controls — Super + Ctrl + Alt</b></summary>

Every key below adds to **Super + Ctrl + Alt**. “Shift” adds Shift to that same prefix.

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

</details>

---

## Included

```text
mangoWC-config/
├── install.sh
├── config.conf
├── config/                 # Environment, programs, appearance, animations,
│                           # layouts, input, bindings, autostart
├── scripts/                # Launcher, clipboard, screenshot, lock, bar helpers
├── themes/
│   ├── rofi/
│   ├── hyprlock.conf
│   ├── waybar.css
│   └── swaync/
├── wallpapers/default.png
├── waybar.jsonc
├── screenshots/
└── tests/verify_install.py
```

Everything deploys inside `~/.config/mango/`. Existing Rofi, Waybar, SwayNC, and Hyprlock configs stay untouched.

---

## Requirements

Software packages and fonts are separate from the bundled configuration. Tested with **MangoWC 0.17.5** and **Waybar 0.15.0**; Waybar needs `ext/workspaces` support.

<details>
<summary><b>Applications & workflow tools</b></summary>

| Used for | Tools |
| :--- | :--- |
| Applications | Kitty, Helium (`helium-browser`), Dolphin, Kdenlive, Neovim |
| Menus & clipboard | Wayland-enabled Rofi, cliphist, wl-clipboard |
| Screenshots | grim, slurp, libnotify (`notify-send`) |
| Desktop | swaybg, Hyprlock, SwayNC, Waybar |
| Audio & hardware | WirePlumber (`wpctl`), brightnessctl, playerctl |
| Scripts & layout names | Bash, Python 3, jq, `mmsg` |
| Optional bar actions | btop, pulsemixer, nmtui, bluetui, cava, calcurse, yazi |
| Battery notifications | `flock`; battery detected automatically |

Session actions assume systemd and a working user D-Bus session. Audio remains service-managed. Startup guards avoid duplicate clipboard watchers, bars, wallpaper renderers, notification daemons, and battery helpers.

</details>

<details>
<summary><b>Fonts & appearance</b></summary>

- **Typography:** Iosevka, JetBrains Mono, and Space Mono Nerd Fonts, plus icon glyph support.
- **Animated bar art:** Waycat and Skulltype; static cat/skull fallback when unavailable.
- **Optional theme assets:** WhiteSur icons, Bibata-Modern-Ice cursor, qt6ct/Kvantum.

Fonts and these system themes are not redistributed. Their absence can change the appearance.

</details>

<details>
<summary><b>Wallpaper settings</b></summary>

The picker prefers the existing `~/Pictures/Wallpapers/CozyPixels/Catppuccin/Space & Cosmic` collection when present. Otherwise it uses `~/.config/mango/wallpapers/`.

Add images to that directory, or set **`MANGO_WALLPAPER_DIR`** in your session environment. Startup and locking use the current Mango wallpaper, falling back to the bundled default.

The default image comes from the original wallpaper collection; no ownership of third-party artwork or fonts is claimed.

</details>

---

<details>
<summary><b>Validation & tests</b></summary>

```bash
./install.sh --check
python3 tests/verify_install.py
```

The installer checks Mango modules, bundled assets, Bash/Python syntax, and JSON. It runs ShellCheck when available. The standalone test exercises installation and workflows in a fresh home directory, using stubs to avoid opening menus or triggering session actions.

To check the installed compositor config directly:

```bash
mango -c ~/.config/mango/config.conf -p
```

Keep `-c` before `-p`. A parser check does not verify installed applications or services. Generated lock configuration and the current wallpaper link are excluded from Git.

</details>
