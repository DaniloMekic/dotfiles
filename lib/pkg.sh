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
    # -S                                : Synchronize packages using the local sync databases (/var/lib/pacman/sync/*.db)
    # -y                                : Refresh the local sync databases from the mirrors
    # -u                                : Upgrade ALL packages that are out-of-date
    sudo pacman -Syu --disable-download-timeout
}

pkg::get_aur_helper() {
    echo "Installing AUR helper: $AUR_HELPER"

    # Separate declaration with 'local' Bash builtin from the assignment,
    # since local masks the exit status of the substituted command.
    # A plain assignment does NOT mask the exit code.
    # See https://www.shellcheck.net/wiki/SC2155
    local build_dir
    build_dir=$(mktemp -d)

    if sudo pacman -S --needed --noconfirm --disable-download-timeout git base-devel \
        && git clone https://aur.archlinux.org/yay-bin.git "$build_dir" \
        && (cd "$build_dir" && makepkg -si --noconfirm); then

        rm -rf "$build_dir"
        echo "$AUR_HELPER installed successfully"
    else
        rm -rf "$build_dir"
        echo "Failed to install $AUR_HELPER" >&2

        exit 1
    fi
}
