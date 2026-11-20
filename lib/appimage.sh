################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_APPIMAGE_SOURCED:-}" ]]; then
    return
fi
_LIB_APPIMAGE_SOURCED=true

################################################################################

# Usage: appimage::_install <file-path> <bin-name>
appimage::_install() {
    local appimage_path_canonical
    appimage_path_canonical="$(realpath "$1")"

    local appimage_file_name
    appimage_file_name="$(basename "$1")"

    local appimage_bin_name
    appimage_bin_name="$2"

    if ! [[ "$(dirname "$appimage_path_canonical")" -ef "$APPIMAGES_HOME" ]]; then
        mkdir -p "$APPIMAGES_HOME" && mv -- "$appimage_path_canonical" "$APPIMAGES_HOME/"
    fi

    appimage_path_canonical="$APPIMAGES_HOME/$appimage_file_name"
    chmod +x -- "$appimage_path_canonical"

    fs::symlink "$appimage_path_canonical" "$HOME/.local/bin/$appimage_bin_name"

    log::info "AppImage $appimage_path_canonical deployed"
}

appimage::qbittorrent() {
    local repo_full_name="qbittorrent/qBittorrent"
    local version="5.2.4"
    local tag="release-$version"
    local asset_label="Linux AppImage (libtorrent 1.2.x)"
    local download_location="$APPIMAGES_HOME/qBittorrent-$version.AppImage"

    # If file already exists, don't download again
    [[ -f "$download_location" ]] || github::download_tag_asset "$repo_full_name" "$tag" "$asset_label" "$download_location"

    appimage::_install "$download_location" "qbittorrent"
    cfg::desktop "$DOTFILES_HOME/cfg/qBittorrent/org.qbittorrent.qBittorrent.desktop"
}
