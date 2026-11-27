################################################################################
# Include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_PKG_SOURCED:-}" ]]; then
    return
fi
_LIB_PKG_SOURCED=true

################################################################################
# DESCRIPTION
#
# Library for stuff related to system packages
# The pacman databases are normally located at `/var/lib/pacman/sync`.
# For each repository specified in `/etc/pacman.conf`, there will be a corresponding database file located there.
# Database files are gzipped tar archives containing one directory for each package.

################################################################################
# REFERENCES
#
# https://wiki.archlinux.org/title/Arch_package_guidelines
# https://wiki.archlinux.org/title/Pacman

################################################################################
# VARIABLES

# https://wiki.archlinux.org/title/Pacman
# https://man.archlinux.org/man/pacman.8
# pacman options:
#   -S                                  : Synchronize packages
#   --needed                            : Do not reinstall the targets that are already up-to-date
#   --noconfirm                         : Bypass any and all "Are you sure?" messages
#   --disable-download-timeout          : Disable defaults for low speed limit and timeout on downloads
PACMAN_OPTS=(-S --needed --noconfirm --disable-download-timeout)

# https://wiki.archlinux.org/title/AUR_helpers
AUR_HELPER="yay"
# https://jguer.github.io/yay/man.html
# yay options:
#   --needed                            : Only install packages that are not already installed
#   --noconfirm                         : Automatically answer "yes" to all confirmation prompts
#   --answerdiff None                   : Suppress the prompt to view the changes (diff) between the current PKGBUILD and the previously cached one
#   --answerclean All                   : Clean build files from Yay's cache
#   --sudoloop                          : Prevent sudo from timing out during long builds
AUR_HELPER_OPTS=(--needed --noconfirm --answerdiff None --answerclean All --sudoloop)

################################################################################
# FUNCTIONS

# Sync repository databases and upgrade the system
# https://man.archlinux.org/man/pacman.8.en.html#SYNC_OPTIONS_(APPLY_TO_-S)
pkg::sync_refresh_upgrade() {
    log::info "**************************************************"
    log::info "Initiating FULL system upgrade"
    # -S                                : Synchronize packages using the local sync databases (/var/lib/pacman/sync/*.db)
    # -y                                : Refresh the local sync databases from the mirrors
    # -u                                : Upgrade ALL packages that are out-of-date
    run::cmd sudo pacman -Syu --disable-download-timeout

    log::info "FULL system upgrade finished"
    log::info "**************************************************"
}

# Install from the Arch Linux official repositories
#
# USAGE:
# pkg::pacman <pkg> ...
pkg::pacman() {
    log::info "pacman: installing $*"
    run::cmd sudo pacman "${PACMAN_OPTS[@]}" "$@"
}

# Install from the Arch User Repository (AUR)
# Build AUR helper first if missing
#
# USAGE:
# pkg::aur <pkg>...
pkg::aur() {
    pkg::_ensure_aur_helper
    log::info "$AUR_HELPER: installing $*"
    run::cmd "$AUR_HELPER" -S "${AUR_HELPER_OPTS[@]}" "$@"
}

################################################################################
# HELPERS

# Build the AUR helper, unless it's already on PATH
pkg::_ensure_aur_helper() {
    command -v "$AUR_HELPER" &>/dev/null && return

    if run::is_dry; then
        log::dry "Build AUR helper: $AUR_HELPER"
        return
    fi

    pkg::_get_aur_helper
}

# https://wiki.archlinux.org/title/AUR_helpers
pkg::_get_aur_helper() {
    log::info "Installing AUR helper: $AUR_HELPER"

    # Build requirements, installed here so the caller does not have to:
    #   git                             : `git clone` below
    #   base-devel                      : makepkg
    #
    # Use pkg::pacman, NOT toolchain::git, because toolchain::git installs
    # an AUR package and would recurse back here
    pkg::pacman git base-devel

    # Separate declaration with 'local' Bash builtin from the assignment,
    # since local masks the exit status of the substituted command.
    # A plain assignment does NOT mask the exit code.
    # See https://www.shellcheck.net/wiki/SC2155
    local build_dir
    build_dir=$(mktemp -d)

    # Upstream sources for the build
    # https://github.com/Jguer/yay
    # https://github.com/morganamilo/paru
    declare -A upstream_sources
    upstream_sources[yay]="https://aur.archlinux.org/yay-bin.git"
    upstream_sources[paru]="https://aur.archlinux.org/paru.git"

    # Validate upstream URL
    if [[ -z "${upstream_sources[$AUR_HELPER]:-}" ]]; then
        rm -rf -- "$build_dir"
        log::error "Unsupported AUR helper: '$AUR_HELPER'"
        return 1
    fi

    if git clone "${upstream_sources[$AUR_HELPER]}" "$build_dir" \
        && (cd "$build_dir" && makepkg -si --noconfirm); then
        rm -rf -- "$build_dir"
    else
        rm -rf -- "$build_dir"

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

# Function prints the path of a package archive in the pacman cache, <pkgname>-<pkgver>-<pkgrel>-<arch>.pkg.tar.zst.
# For example: `file:///var/cache/pacman/pkg/neovim-0.12.6-1-x86_64.pkg.tar.zst`
# Pacman stores its downloaded packages in /var/cache/pacman/pkg/
# https://wiki.archlinux.org/title/Pacman
#
# If file is not in the cache, download the package, without installing it.
#
# The caller captures the function's output
# pkg_file="$(pkg::_get_cached_archive_path "<pkg>")" || return 1
#
# https://wiki.archlinux.org/title/Creating_packages#Overview
#
# USAGE:
# pkg::_get_cached_archive_path <pkg>
pkg::_get_cached_archive_path() {
    local pkg="$1"
    # pkg URI, either URL, or `file` URI scheme
    local uri

    # pacman options:
    # -S                                : Synchronize packages
    #   -p                              : Only print the targets instead of performing the actual operation (sync, remove or upgrade)
    #   -dd                             : Skip all dependency checks
    #   -w                              : Download only, don't install
    uri="$(pacman -Sp -dd -- "$pkg")" || {
        log::error "Package $pkg not found in the repositories"
        return 1
    }
    # Remove everything up to and including the last forward slash, to get the package file name
    # For example: file:///var/cache/pacman/pkg/neovim-0.12.6-1-x86_64.pkg.tar.zst --> neovim-0.12.6-1-x86_64.pkg.tar.zst
    local pkg_file_name="${uri##*/}"

    # Download package into the cache, without installing it
    # If file is already in the cache, pacman does nothing
    #
    # stdout carries only the final result (value), everything else goes to stderr
    sudo pacman -Sw -dd --noconfirm -- "$pkg" >&2 || return 1

    # https://man.archlinux.org/man/pacman.conf.5.en
    # https://man.archlinux.org/man/pacman-conf.8.en
    # pacman-conf can list more than 1 CacheDir
    #
    # CacheDir                          : Default location of the package cache directory
    local cache_dir
    while IFS= read -r cache_dir; do
        # Check if file actually exists
        # Print the path and return
        if [[ -f "${cache_dir%/}/${pkg_file_name}" ]]; then
            printf '%s\n' "${cache_dir%/}/${pkg_file_name}"
            return
        fi
    done < <(pacman-conf CacheDir)

    log::error "Package file ${pkg_file_name} not found in any cache directory"
    return 1
}

# Install icons from an Arch package, without installing the package
#
# USAGE:
# pkg::_install_icons <pkg>|<archive>
#
# Body in ( ... ) instead of { ... }: it runs in a subshell, so shopt and the
# EXIT trap are local to this function. The trap fires on every way out,
# including a set -e abort
pkg::_install_icons() {
    local pkg="$1"
    local pkg_file

    if [[ -f "$pkg" ]]; then
        pkg_file="$pkg"
    # pacman options:
    # -Q                                : query the package database
    #   -q, --quiet                     : Show less information for certain query operations
    elif pacman -Qq -- "$pkg" &>/dev/null; then
        log::info "Package $pkg is installed, its icons are already in /usr/share/icons"
        return
    elif run::is_dry; then
        log::dry "Install icons from package $pkg"
        return
    else
        pkg_file="$(pkg::_get_cached_archive_path "$pkg")" || return 1
    fi

    local tmp
    tmp="$(mktemp -d)" || return 1
    # https://www.gnu.org/software/bash/manual/html_node/Bourne-Shell-Builtins.html#index-trap
    # Remove $tmp when this function returns, on every return path
    # Double quotes on purpose: $tmp expands now, when the trap is set, so the trap
    # stores the literal path and doesn't depend on $tmp still being set when it fires
    #
    # Single quotes inside keep the path one argument to rm, even with spaces
    # The RETURN trap is global to the shell, so `trap - RETURN` removes it after
    # it runs once. Otherwise it would fire on every later function return
    # shellcheck disable=SC2064 # Intended: expand $tmp now, not when the trap fires
    trap "rm -rf -- '$tmp'" EXIT

    # https://man7.org/linux/man-pages/man1/tar.1.html
    # -C                                : Change to DIR before performing any operations
    # --wildcards                       : Let * in member names match, they're literal otherwise
    #
    # tar exits 2 with "Not found in archive" when either pattern has no match, but still extracts what it found
    # The checks below report what's actually missing
    tar -x -f "$pkg_file" -C "$tmp" --wildcards \
        'usr/share/icons/*' \
        'usr/share/applications/*.desktop' 2>/dev/null || true

    # A package can ship several .desktop files, each with its own Icon= name
    # nullglob: a pattern without a match disappears, instead of staying a literal path
    shopt -s nullglob
    local -a desktop_files=("$tmp"/usr/share/applications/*.desktop)
    if ((${#desktop_files[@]} == 0)); then
        log::error "No .desktop file in $pkg_file"
        return 1
    fi

    # Collect every Icon= value from all .desktop files, one name per array element
    local -a icon_names
    # mapfile                           : Read lines into the array, -t strips the trailing newline
    mapfile -t icon_names < <(xdg::desktop_icon_names "${desktop_files[@]}")
    if ((${#icon_names[@]} == 0)); then
        log::error "No Icon= key in the .desktop files of $pkg_file"
        return 1
    fi

    icon::install "$tmp/usr/share/icons" "${icon_names[@]}" || {
        log::error "None of the icons (${icon_names[*]}) installed from $pkg_file"
        return 1
    }

    log::info "Icons installed from $pkg_file"
}
