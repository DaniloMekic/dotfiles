# Setup
```shell
chmod +x bootstrap
./bootstrap --help
```

# Desktop Environment
## Wayland Compositor
**Niri**:
- https://github.com/niri-wm/niri
- https://wiki.archlinux.org/title/Niri

From TTY, launch Niri with `niri-session`. This creates `niri.service` managed by `systemd`.

## App Launcher
**Fuzzel**, default app launcher for Niri:
- https://codeberg.org/dnkl/fuzzel
- https://archlinux.org/packages/extra/x86_64/fuzzel/

## Status Bar
**Waybar**:
- https://waybar.org/
- https://github.com/alexays/waybar
- https://wiki.archlinux.org/title/Waybar

# Keybindings

| Keys | Action |
| --- | --- |
| `Meta-d` | Launch `fuzzel` |
| `Meta` + `hjkl` | Change window focus |
| `Meta-f` | Toggle window fullscreen |
| `Meta` + `Thumb wheel` | Horizontall scrolling |

