################################################################################
# Include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_ICON_SOURCED:-}" ]]; then
    return
fi
_LIB_ICON_SOURCED=true

################################################################################
# DESCRIPTION
#
# Library for stuff related to system icons and freedesktop.org "Icon Theme Specification"
#
# Icons live in `/usr/share/icons/` (system-wide) or `~/.local/share/icons/` (user only).
# System always has an active theme, and if nothing is chosen, "hicolor" (high color) is the default fallback theme.
#
# Icons are identified by short strings, and loaded by resolution and usage context:
# `icons/<theme>/<resolution>/<usage>/<icon-name>.<icon-extension>
# For example: `icons/hicolor/128x128/apps/nvim.png`
#
################################################################################
# REFERENCES
#
# https://wiki.archlinux.org/title/Icons
# https://specifications.freedesktop.org/icon-theme/latest/

################################################################################
# VARIABLES
ICONS_HOME="$DATA_HOME"/icons

################################################################################
# FUNCTIONS

# Copy icons into the user's icon directory (ICONS_HOME)
# pkg::_install_icons and appimage::install_icons extract an icon tree and pass it here
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

    # foo.ext
    local icon_name
    # /some/path/icons/<theme>/<resolution>/<usage>/foo.ext
    local icon_file_path
    # <theme>/<resolution>/<usage>/foo.ext
    local icon_file_path_relative
    # <theme>
    local icon_theme
    local -i count
    local -a installed=()
    # Theme directories that received files: [theme]=1
    # Associative array instead of regular array, since regular ones use numeric indexes and each iteration would add duplicates
    local -A themes=()

    # shift has removed source directory argument, so "$@" contains only icon names
    for icon_name in "$@"; do
        # Reset per-icon count
        count=0

        # find options:
        #   -L                          : Follow symlinks, since icon themes often alias names to each other
        #                               : An absolute symlink inside the tree (/usr/share/...)
        #                               : resolves to a file on THIS system, not one in the archive
        #   -print0                     : Delimit paths with NUL character (U+0000)
        #
        # read options:
        #   -r                          : Raw mode, prevents backslashes (\) from acting as escape characters
        #   -d ''                       : Delimiting with empty string sets NUL byte as delimiter ('\0')
        #                               : Used in conjunction with find's -print0
        while IFS= read -r -d '' icon_file_path; do
            icon_file_path_relative="${icon_file_path#"$icons_dir"/}"
            # Check explicitly instead of relying on set -e
            # Bash turns errexit OFF for a whole function called as an if/&&/|| condition,
            # and callers do call this one as a condition
            if ! run::cmd install -D --mode=644 -- "$icon_file_path" "$ICONS_HOME/$icon_file_path_relative"; then
                log::error "Failed to copy $icon_file_path"
                return 1
            fi
            # <theme>/<resolution>/<usage>/foo.ext becomes <theme>
            icon_theme="${icon_file_path_relative%%/*}"
            themes["$icon_theme"]=1

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

################################################################################
# HELPERS

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
