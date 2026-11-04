################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_PKG_SOURCED:-}" ]]; then
    return
fi
_LIB_PKG_SOURCED=true

################################################################################

# Sync repository databases and upgrade the system
# https://man.archlinux.org/man/pacman.8.en.html#SYNC_OPTIONS_(APPLY_TO_-S)
pkg::sync_refresh_upgrade() {
    log::info "**************************************************"
    log::info "Initiating FULL system upgrade"
    # -S                                : Synchronize packages using the local sync databases (/var/lib/pacman/sync/*.db)
    # -y                                : Refresh the local sync databases from the mirrors
    # -u                                : Upgrade ALL packages that are out-of-date
    sudo pacman -Syu --disable-download-timeout

    log::info "Full system upgrade finished"
    log::info "**************************************************"
}

# https://wiki.archlinux.org/title/AUR_helpers
pkg::get_aur_helper() {
    log::info "Installing AUR helper: $AUR_HELPER"

    # Separate declaration with 'local' Bash builtin from the assignment,
    # since local masks the exit status of the substituted command.
    # A plain assignment does NOT mask the exit code.
    # See https://www.shellcheck.net/wiki/SC2155
    local build_dir
    build_dir=$(mktemp -d)

    # Install required packages for the build
    sudo pacman -S --needed --noconfirm --disable-download-timeout git base-devel || {
        log::error "Failed to install packages: git, base-devel"
        return 1
    }

    # Upstream sources for the build
    # https://github.com/Jguer/yay
    # https://github.com/morganamilo/paru
    declare -A upstream_sources
    upstream_sources[yay]="https://aur.archlinux.org/yay-bin.git"
    upstream_sources[paru]="https://aur.archlinux.org/paru.git"

    # Validate upstream URL
    if [[ -z "${upstream_sources[$AUR_HELPER]:-}" ]]; then
        log::error "Unsupported AUR helper: '$AUR_HELPER'"
        return 1
    fi

    if git clone "${upstream_sources[$AUR_HELPER]}" "$build_dir" \
        && (cd "$build_dir" && makepkg -si --noconfirm); then
        rm -rf "$build_dir"
    else
        rm -rf "$build_dir"

        log::error "Failed to install $AUR_HELPER"
        return 1
    fi

    # Validate installation
    hash -r # clear cache for utility locations
    if ! command -v "$AUR_HELPER" >/dev/null; then
        log::error "$AUR_HELPER not found on PATH after the build"
        return 1
    fi

    log::info "$AUR_HELPER installed successfully"
}
