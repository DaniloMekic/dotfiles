################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_APPIMAGE_SOURCED:-}" ]]; then
    return
fi
_LIB_APPIMAGE_SOURCED=true

################################################################################

APPIMAGES_HOME="$HOME/AppImages"

# Download an AppImage, install its icons, and link it into ~/.local/bin
# Usage: appimage::install <url> <bin-name>
appimage::install() {
    local url="$1"
    local appimage_file_path="$APPIMAGES_HOME/${url##*/}"
    local bin_name="$2"

    if run::is_dry; then
        log::info "[dry-run] install AppImage $url as $HOME/.local/bin/$bin_name"
        return
    fi

    net::download "$url" "$appimage_file_path"
    chmod +x -- "$appimage_file_path"

    # A missing icon shouldn't stop the AppImage from being linked
    appimage::install_icons "$appimage_file_path" \
        || log::error "No icon installed from $appimage_file_path, continuing without it"

    fs::symlink "$appimage_file_path" "$HOME/.local/bin/$bin_name"

    log::info "AppImage deployed: $appimage_file_path"
}

# Install icons from an AppImage, without running the app
#
# NOTE: --appimage-extract doesn't start the app, but it DOES run the AppImage's
# embedded runtime as your user. It's not a passive archive read, so only use
# this on AppImages you trust
#
# Usage: appimage::install_icons <executable-appimage>
#
# Body in ( ... ) instead of { ... }: it runs in a subshell, so cd, shopt,
# and the EXIT trap are local to this function. The trap fires on every
# way out, including a set -e abort
appimage::install_icons() (
    local appimage
    appimage="$(realpath -- "$1")" || return 1

    # Don't change the caller's file, appimage::install already made it executable
    if [[ ! -f "$appimage" || ! -x "$appimage" ]]; then
        log::error "$appimage is not an executable file"
        return 1
    fi

    local tmp
    tmp="$(mktemp -d)" || return 1
    # Single quotes: $tmp expands when the trap fires, inside this subshell
    trap 'rm -rf -- "$tmp"' EXIT

    # https://docs.appimage.org/user-guide/run-appimages.html#extract-the-contents-of-an-appimage
    #
    # ./<file>.AppImage --appimage-help
    # AppImage options:
    #   --appimage-extract [<pattern>]  Extract content from embedded filesystem image
    #                                   If pattern is passed, only extract matching files
    #   --appimage-help                 Print this help
    #
    #   `--appimage-extract` writes to `./squashfs-root` in the CWD
    #   The cd is local to this subshell
    cd -- "$tmp" || return 1
    "$appimage" --appimage-extract 'usr/share/icons/*' >/dev/null || return 1
    "$appimage" --appimage-extract '*.desktop' >/dev/null || return 1
    "$appimage" --appimage-extract 'usr/share/applications/*.desktop' >/dev/null || return 1

    local root="$tmp/squashfs-root"

    # The .desktop file usually sits at the AppImage root, some ship it in usr/share/applications
    # nullglob: a pattern without a match disappears, instead of reaching sed as a literal path
    shopt -s nullglob
    local -a desktop_files=("$root"/*.desktop "$root"/usr/share/applications/*.desktop)
    if ((${#desktop_files[@]} == 0)); then
        log::error "No .desktop file in $appimage"
        return 1
    fi

    local -a icon_names
    mapfile -t icon_names < <(xdg::desktop_icon_names "${desktop_files[@]}")
    if ((${#icon_names[@]} == 0)); then
        log::error "No Icon= key in the .desktop files of $appimage"
        return 1
    fi

    icon::install "$root/usr/share/icons" "${icon_names[@]}" || {
        log::error "None of the icons (${icon_names[*]}) found in $appimage"
        return 1
    }
)
