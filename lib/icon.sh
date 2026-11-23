################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_ICON_SOURCED:-}" ]]; then
    return
fi
_LIB_ICON_SOURCED=true

################################################################################

# https://wiki.archlinux.org/title/Icons
# https://specifications.freedesktop.org/icon-theme/latest/
ICONS_HOME="$HOME/.local/share/icons"

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
    #   p                               : Print
    #   q                               : Quit after printing first match
    icon_name="$(sed -n '/^Icon=/ { s/^Icon=//; p; q; }' "$root"/*.desktop)"
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

# Install icons from an Arch package, without installing the package
# Usage: icon::from_pkg <pkg>
icon::from_pkg() {
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
    else
        # pkg URI, either URL, or file URI scheme
        local uri
        # pkg cache directory
        local cache_dir

        # pacman options:
        # -S                            : Synchronize packages
        #   -p                          : Only print the targets instead of performing the actual operation (sync, remove or upgrade)
        #   -dd                         : Skip all dependency checks
        #   -w                          : Download only, don't install
        uri="$(pacman -Sp -dd -- "$pkg")" || {
            log::error "Package $pkg not found in the repositories"
            return 1
        }
        sudo pacman -Sw -dd --noconfirm -- "$pkg"
        # https://man.archlinux.org/man/pacman.conf.5.en
        # https://man.archlinux.org/man/pacman-conf.8.en
        # CacheDir                      : Default location of the package cache directory
        cache_dir="$(pacman-conf CacheDir | head -n 1)"
        pkg_file="${cache_dir%/}/${uri##*/}"
    fi

    if [[ ! -f "$pkg_file" ]]; then
        log::error "Package file $pkg_file not found"
        return 1
    fi

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
    # The glob has to stay OUTSIDE the quotes; asterisk (*) inside quotes is a literal character
    local -a desktop_files=("$tmp"/usr/share/applications/*.desktop)
    if [[ ! -e "${desktop_files[0]}" ]]; then
        log::error "No .desktop file in $pkg_file"
        return 1
    fi

    # Collect every Icon= value from all .desktop files, one name per array element
    local -a icon_names
    # sed                               : Print only lines that start with Icon=, without the key
    # grep                              : Drop absolute paths, they're files, not theme icon names
    # sort -u                           : Remove duplicates
    # mapfile                           : Read lines into the array, -t strips the trailing newline
    mapfile -t icon_names < <(sed -n 's/^Icon=//p' "${desktop_files[@]}" | grep -v '^/' | sort -u)
    if ((${#icon_names[@]} == 0)); then
        log::error "No Icon= key in the .desktop files of $pkg_file"
        return 1
    fi

    # Install each icon name, and remember which ones were found
    local icon_name
    local -a installed=()
    for icon_name in "${icon_names[@]}"; do
        if icon::_install_tree "$tmp/usr/share/icons" "$icon_name"; then
            installed+=("$icon_name")
        fi
    done

    # Success when at least 1 icon was installed
    if ((${#installed[@]} == 0)); then
        log::error "None of the icons (${icon_names[*]}) found in $pkg_file"
        return 1
    fi

    icon::_refresh
    log::info "Icons ${installed[*]} installed from $pkg_file"
}

########################################
# Helpers

# Copy every <icon-name> from an extracted usr/share/icons tree,
# keeping the <theme>/<size>/<context> layout
# See example at https://specifications.freedesktop.org/icon-theme/latest/#example
#
# Usage: icon::_install_tree <icons-dir> <icon-name>
#   <icons-dir> has to be the directory that holds the theme directory,
#   without trailing forward slash character
icon::_install_tree() {
    local icons_dir="$1"
    local icon_name="$2"

    [[ -d "$icons_dir" ]] || return 1

    local icon_file
    local -i count=0

    while IFS= read -r -d '' icon_file; do
        install -D --mode=644 -- "$icon_file" "$ICONS_HOME/${icon_file#"${icons_dir}"/}"
        count+=1
    done < <(find -L "$icons_dir" -type f \( \
        -name "$icon_name.png" -o \
        -name "$icon_name.svg" -o \
        -name "$icon_name-symbolic.svg" \
        \) -print0)

    ((count > 0))
}

# Update theme directory mtime with the touch command.
# This forces GTK to reload the theme.
#
# Always return 0 to make sure function call always counts as success.
icon::_refresh() {
    [[ -d "$ICONS_HOME/hicolor" ]] && touch -- "$ICONS_HOME/hicolor"
    return 0
}
