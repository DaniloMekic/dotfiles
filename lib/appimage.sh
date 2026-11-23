################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_APPIMAGE_SOURCED:-}" ]]; then
    return
fi
_LIB_APPIMAGE_SOURCED=true

################################################################################

APPIMAGES_HOME="$HOME/AppImages"

# Usage: appimage::install <url> <bin-name>
appimage::install() {
    local url="$1"
    local appimage_file_path="$APPIMAGES_HOME/${url##*/}"
    local bin_name="$2"

    net::download "$url" "$appimage_file_path"
    chmod +x -- "$appimage_file_path"

    icon::from_appimage "$appimage_file_path"

    fs::symlink "$appimage_file_path" "$HOME/.local/bin/$bin_name"

    log::info "AppImage deployed: $appimage_file_path"
}

# https://github.com/qbittorrent/qBittorrent
appimage::qbittorrent() {
    appimage::install \
        "https://github.com/qbittorrent/qBittorrent/releases/download/release-5.2.4/qbittorrent-5.2.4_x86_64.AppImage" \
        "qbittorrent"
}
