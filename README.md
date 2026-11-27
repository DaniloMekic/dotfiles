# Arch Linux Dotfiles

## Design

Repository follows the [separation of design and policy](https://en.wikipedia.org/wiki/Separation_of_mechanism_and_policy) design principle, where `lib/` holds mechanisms, and `mod/` holds policies. `bootstrap` executable sits on top and only composes modules that deal with configs inside `cfg/` directory.

Mechanisms:

- `run`: the dry-run boundary, proxy for `pacman`. Every command that changes the system goes through `run::cmd`, so `DRY_RUN=1` prints it instead of running it.
- `log`, `ansi`: timestamped, color-tagged logging to the terminal and the file (`/tmp/bootstrap.log`).
- `fs`, `cfg`: symlink or copy files, link a map of `cfg/` paths, and validate and register desktop entries.
- `pkg`, `net`, `appimage`: installation from Arch Linux official repositories and the AUR, HTTPS downloads, and AppImage installation into `~/.local/bin`.
- `icon`, `xdg`: install themed icons from an extracted tree, and read freedesktop.org files such as `Icon=` names in desktop entries.

Policies:

- `base`: the command-line userland every machine gets, bare metal or WSL.
- `toolchain`: language toolchains (C, Git, Rust via `rustup`, Java, LaTeX) that other modules call.
- `nvim`: Neovim with its language servers, linters, debuggers, code formatters, and its config.
- `desktop`: the Niri Wayland session and graphical apps.
- `host`: configuration for the primary machine, including configuration of peripherals and their services.
- `wsl`: Windows Subsystem for Linux (WSL) integration.

```text
.
├── bin/
├── cfg/
│   ├── Bash/
│   ├── curl/
│   ├── environment.d/
│   ├── Ghostty/
│   ├── Git/
│   ├── iwd/
│   ├── keyd/
│   ├── LogiOps/
│   ├── mpv/
│   ├── Neovim/
│   ├── Niri/
│   ├── qBittorrent/
│   ├── tmux/
│   ├── Vim/
│   └── Waybar/
├── lib/
│   ├── ansi.sh
│   ├── appimage.sh
│   ├── cfg.sh
│   ├── common.sh
│   ├── fs.sh
│   ├── icon.sh
│   ├── log.sh
│   ├── net.sh
│   ├── pkg.sh
│   ├── run.sh
│   └── xdg.sh
├── mod/
│   ├── base.sh
│   ├── desktop.sh
│   ├── host.sh
│   ├── nvim.sh
│   ├── toolchain.sh
│   └── wsl.sh
└── bootstrap
```

## Setup

```shell
chmod +x bootstrap
./bootstrap --help
```

## Core System Services

### Wireless Network

#### iwd (iNet Wireless Daemon)

- <https://archive.kernel.org/oldwiki/iwd.wiki.kernel.org/>
- <https://wiki.archlinux.org/title/Iwd>

[systemd-resolved](https://wiki.archlinux.org/title/Systemd-resolved) is used as DNS manager.

## Desktop Environment

### Wayland Compositor

**Niri**:

- <https://github.com/niri-wm/niri>
- <https://wiki.archlinux.org/title/Niri>

From TTY, launch Niri with `niri-session`. This creates `niri.service` managed by `systemd`.

### App Launcher

**Fuzzel**, default app launcher for Niri:

- <https://codeberg.org/dnkl/fuzzel>
- <https://archlinux.org/packages/extra/x86_64/fuzzel/>

### Status Bar

**Waybar**:

- <https://waybar.org/>
- <https://github.com/alexays/waybar>
- <https://wiki.archlinux.org/title/Waybar>

## Keybindings

| Keys | Action |
| --- | --- |
| `Meta-d` | Launch `fuzzel` |
| `Meta` + `hjkl` | Change window focus |
| `Meta-f` | Toggle window fullscreen |
| `Meta` + `Thumb wheel` | Horizontall scrolling |
