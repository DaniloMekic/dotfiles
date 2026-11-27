################################################################################
# Include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_ICON_SOURCED:-}" ]]; then
    return
fi
_LIB_ICON_SOURCED=true

################################################################################
# Library for stuff related to system icons and freedesktop.org "Icon Theme Specification"
#
# References:
# https://wiki.archlinux.org/title/Icons
# https://specifications.freedesktop.org/icon-theme/latest/

################################################################################

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
        #                               : An absolute symlink inside the tree (/usr/share/...)
        #                               : resolves to a file on THIS system, not one in the archive
        while IFS= read -r -d '' icon_file; do
            rel="${icon_file#"$icons_dir"/}"
            # Check explicitly instead of relying on set -e
            # Bash turns errexit OFF for a whole function called as an if/&&/|| condition,
            # and callers do call this one as a condition
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
