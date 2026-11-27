################################################################################
# Include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_CFG_SOURCED:-}" ]]; then
    return
fi
_LIB_CFG_SOURCED=true

################################################################################

# Symlink a file from cfg/ to a full destination path
cfg::link() {
    fs::symlink "$DOTFILES_HOME/cfg/$1" "$2"
}

# Copy a file from cfg/ to a full destination path
cfg::copy() {
    fs::copy "$DOTFILES_HOME/cfg/$1" "$2"
}

# Link every entry of an associative array: [path-relative-to-cfg]=destination
#
# Usage:
# cfg::link_map <name-of-associative-array>
#
# `local -n` makes _cfg_map a reference to the caller's array (nameref)
cfg::link_map() {
    local -n _cfg_map="$1"
    local src

    for src in "${!_cfg_map[@]}"; do
        cfg::link "$src" "${_cfg_map[$src]}"
    done
}

# Validate and link desktop entries, then refresh the database once
# https://wiki.archlinux.org/title/Desktop_entries
#
# Usage:
# cfg::desktop_entries <path-relative-to-cfg>...
cfg::desktop_entries() {
    local apps_dir="$DATA_HOME/applications"

    if ! command -v desktop-file-validate &>/dev/null; then
        log::error "desktop-file-validate is not available; install the desktop-file-utils package"
        return 1
    fi

    local rel src
    for rel in "$@"; do
        src="$DOTFILES_HOME/cfg/$rel"
        if ! desktop-file-validate "$src"; then
            log::error "Desktop file $src is not valid"
            return 1
        fi
        fs::symlink "$src" "$apps_dir/${src##*/}"
    done

    run::cmd update-desktop-database "$apps_dir"
}
