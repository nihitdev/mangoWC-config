#!/usr/bin/env python3
"""Exercise deployment and bundled workflows without opening UI or session actions."""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

REPO = Path(__file__).resolve().parents[1]


class StandaloneInstall(unittest.TestCase):
    def test_fresh_home_and_workflows(self):
        with tempfile.TemporaryDirectory(prefix="mango-test.") as temporary:
            home = Path(temporary) / "home with spaces"
            home.mkdir()
            env = dict(os.environ, HOME=str(home))
            target = home / ".config/mango"
            target.mkdir(parents=True)
            (target / "keep.txt").write_text("runtime state")
            (target / "current-wallpaper").symlink_to("/missing-image")
            for _ in range(2):
                subprocess.run(["bash", str(REPO / "install.sh")], env=env,
                               check=True, capture_output=True)
            self.assertEqual((target / "keep.txt").read_text(), "runtime state")
            self.assertTrue((target / "current-wallpaper").is_symlink())
            self.assertEqual(list((home / ".config").iterdir()), [target])
            for directory in ("themes", "scripts", "wallpapers", "config"):
                for source in (REPO / directory).rglob("*"):
                    if source.is_file():
                        self.assertEqual(source.read_bytes(),
                                         (target / source.relative_to(REPO)).read_bytes())

            fakebin = Path(temporary) / "bin"
            fakebin.mkdir()
            env["PATH"] = str(fakebin) + os.pathsep + env["PATH"]
            env["TEST_LOG"] = str(Path(temporary) / "commands.log")

            def stub(command, body):
                path = fakebin / command
                path.write_text("#!/usr/bin/env bash\nset -euo pipefail\n" + body + "\n")
                path.chmod(0o755)

            stub("pgrep", "exit 1")
            stub("rofi", 'printf "%s\\n" "$*" >> "$TEST_LOG"; '
                 '[[ "$*" == *Wallpaper* ]] && printf "default.png\\n"; exit 0')
            stub("hyprlock", 'test -r "$2"; printf "lock\\n" >> "$TEST_LOG"')
            stub("swaybg", 'test -r "$2"; printf "wallpaper\\n" >> "$TEST_LOG"')
            stub("grim", 'printf "image bytes" > "${!#}"')
            stub("wl-copy", 'cat > "$HOME/copied"')
            stub("notify-send", "exit 0")
            stub("cliphist", 'printf "clipboard bytes"')
            stub("fc-match", 'printf "monospace"')
            stub("systemctl", 'printf "unexpected session action\\n" >&2; exit 1')

            for script in ("launcher.sh", "clipboard.sh", "powermenu.sh", "lock.sh",
                           "wallpaper-picker.sh"):
                subprocess.run(["bash", str(target / "scripts" / script)],
                               env=env, check=True, capture_output=True)
            subprocess.run(["bash", str(target / "scripts/screenshot.sh"), "full"],
                           env=env, check=True)
            self.assertEqual((home / "copied").read_text(), "image bytes")
            subprocess.run(["bash", str(target / "scripts/cliphist-rofi"), "item"],
                           env=env, check=True)
            self.assertEqual((home / "copied").read_text(), "clipboard bytes")
            self.assertEqual((target / "current-wallpaper").resolve(),
                             target / "wallpapers/default.png")
            self.assertNotIn("__WALLPAPER__", (target / "hyprlock.conf").read_text())
            log = Path(env["TEST_LOG"]).read_text()
            self.assertIn("mango/themes/rofi/launcher.rasi", log)
            self.assertIn("mango/themes/rofi/power.rasi", log)
            self.assertIn("mango/themes/rofi/wallpaper.rasi", log)
            fallback = subprocess.check_output(
                ["python3", str(target / "scripts/art-animation.py"), "cat"], env=env,
                text=True)
            self.assertEqual(fallback.strip(), "🐈")
            json.loads((target / "themes/swaync/config.json").read_text())


if __name__ == "__main__":
    unittest.main()
