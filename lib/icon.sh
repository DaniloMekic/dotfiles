################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_ICON_SOURCED:-}" ]]; then
    return
fi
_LIB_ICON_SOURCED=true

################################################################################

# Install icons from an AppImage, without running the app
# Usage: icon::from_appimage <appimage>
icon::from_appimage() {
    local appimage
    appimage="$(realpath -- "$1")"

    local tmp
    tmp="$(mktemp -d)"
    # https://www.gnu.org/software/bash/manual/html_node/Bourne-Shell-Builtins.html#index-trap
    # Remove $tmp when this function returns, on every return path
    # Double quotes on purpose: $tmp expands now, when the trap is set, so the trap
    # stores the literal path and doesn't depend on $tmp still being set when it fires
    #
    # Single quotes inside keep the path one argument to rm, even with spaces
    # The RETURN trap is global to the shell, so `trap - RETURN` removes it after
    # it runs once. Otherwise it would fire on every later function return
    # shellcheck disable=SC2064 # Intended: expand $tmp now, not when the trap fires
    trap "rm -rf -- '$tmp'; trap - RETURN" RETURN

    if [[ ! -x "$appimage" ]]; then
        chmod +x -- "$appimage"
    fi

    # https://docs.appimage.org/user-guide/run-appimages.html#extract-the-contents-of-an-appimage
    #
    # ./<file>.AppImage --appimage-help
    # AppImage options:
    #   --appimage-extract [<pattern>]  Extract content from embedded filesystem image
    #                                   If pattern is passed, only extract matching files
    #   --appimage-help                 Print this help
    #
    #   Since `--appimage-extract` writes to `./squashfs-root` in the CWD,
    #   extract in the subshell
    (cd -- "$tmp" && "$appimage" --appimage-extract 'usr/share/icons/*' >/dev/null \
        && "$appimage" --appimage-extract '*.desktop' >/dev/null \
        && "$appimage" --appimage-extract 'usr/share/applications/*.desktop' >/dev/null)

    local root="$tmp/squashfs-root"
    # The .desktop file sits at the AppImage root
    # Icon key provides name of the icon that will be used to display this entry
    local icon_name
    # Keep only value of the Icon key, and return only first match
    # sed options:
    #   -n                              : Supress automatic printing of input lines
    # sed commands:
    #   s                               : Substitute "^Icon=" with empty string
    #   p                               : Print
    #   q                               : Quit after printing first match
    icon_name="$(
        sed -n '/^Icon=/ {
                            s/^Icon=//;
                            p;
                            q;
                         }' "$root"/*.desktop
    )"
    [[ -n "$icon_name" ]] || {
        log::error "No Icon= key in the .desktop file of $appimage"
        return 1
    }

    if icon::_install_tree "$root/usr/share/icons" "$icon_name"; then
        icon::_refresh
        log::info "Icon $icon_name installed from $appimage"
        return
    else
        log::error "No icon named $icon_name found in $appimage"
        return 1
    fi
}

########################################
# Docs:
# https://wiki.archlinux.org/title/Icons
# https://specifications.freedesktop.org/icon-theme/latest/
ICONS_HOME="$HOME/.local/share/icons"

# Copy icons into the user's icon directory
# pkg::install_icons and appimage::install_icons extract an icon tree and pass it here
#
# Copy every <icon-name> from an extracted usr/share/icons tree,
# keeping the <theme>/<size>/<context> layout, then refresh each theme it changed
# See example at https://specifications.freedesktop.org/icon-theme/latest/#example
#
# Succeeds when at least one icon was installed
#
# Usage:
# icon::install <icons-dir> <icon-name>...
icon::install() {
    local icons_dir="${1%/}"
    shift

    [[ -d "$icons_dir" ]] || return 1

    local icon_name icon_file rel
    local -i count
    local -a installed=()
    # Theme directories that received files: [theme]=1
    local -A themes=()

    for icon_name in "$@"; do
        count=0

        # find options:
        #   -L                          : Follow symlinks, since icon themes often alias names to each other
        #                               : An absolute symlink inside the tree (/usr/share/...),
        #                               : resolves to a file on THIS system, not one in the archive
        while IFS= read -r -d '' icon_file; do
            rel="${icon_file#"$icons_dir"/}"
            # Check explicitly instead of relying on set -e
            # Bash turns errexit OFF for a whole function called as an if/&&/|| condition,
            # and callers do call this on as a condition
            if ! run::cmd install -D --mode=644 -- "$icon_file" "$ICONS_HOME/$rel"; then
                log::error "Failed to copy $icon_file"
                return 1
            fi
            themes["${rel%%/*}"]=1
            count+=1
        done < <(find -L "$icons_dir" -type f \( \
            -name "$icon_name.png" -o \
            -name "$icon_name.svg" -o \
            -name "$icon_name-symbolic.svg" \
            \) -print0)

        ((count > 0)) && installed+=("$icon_name")
    done

    if ((${#installed[@]} == 0)); then
        return 1
    fi

    local theme
    for theme in "${!themes[@]}"; do
        icon::_refresh "$ICONS_HOME/$theme"
    done

    log::info "Icons installed: ${installed[*]}"
}

########################################
# Helpers

# Update theme directory mtime with the touch command.
# This forces GTK to reload the theme.
#
# Always return 0, a failed refresh only means a reload may be needed
#
# Usage:
# icon::_refresh <theme-dir>
icon::_refresh() {
    [[ -d "$1" ]] && run::cmd touch -- "$1"
    return 0
}
