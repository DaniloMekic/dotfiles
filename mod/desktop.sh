################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_MOD_DESKTOP_SOURCED:-}" ]]; then
    return
fi
_MOD_DESKTOP_SOURCED=true

################################################################################
# Niri Wayland session and graphical applications
#
# Everything here lives in $HOME
# Root owned files belong in mod/host.sh

desktop::provision() {
    log::info "Provisioning desktop"

    # Swaylock                          : Screen locker; see Niri/config.kdl
    # Waybar                            : Status bar; see Niri/config.kdl
    # brightnessctl                     : Read and control device brightness
    # desktop-file-utils                : Utilities for working with desktop entries
    # noto-fonts-emoji                  : Noto Color Emoji for Waybar
    # playerctl                         : For controlling MPRIS-enabled media players
    # ttf-jetbrains-mono-nerd           : JetBrainsMono Nerd Font for Neovim
    # wl-clipboard                      : Clipboard CLI tools for Wayland compositors
    pkg::pacman \
        niri \
        fuzzel \
        mako \
        waybar \
        swaylock \
        ghostty \
        mpv \
        noto-fonts-emoji \
        ttf-jetbrains-mono-nerd \
        wl-clipboard \
        desktop-file-utils \
        playerctl \
        brightnessctl

    # wlogout                           : Wayland based logout menu
    pkg::aur wlogout

    desktop::qbittorrent

    log::info "Desktop provisioned"
}

desktop::deploy() {
    log::info "Deploying desktop configs"

    # Alacritty and foot configs moved to Unused/, since neither is installed
    # shellcheck disable=SC2034 # Used through a nameref in cfg::link_map
    local -A links=(
        ["Niri/config.kdl"]="$CONFIG_HOME/niri/config.kdl"
        ["Waybar/config.jsonc"]="$CONFIG_HOME/waybar/config.jsonc"
        ["Waybar/style.css"]="$CONFIG_HOME/waybar/style.css"
        ["Ghostty/config.ghostty"]="$CONFIG_HOME/ghostty/config.ghostty"
        ["mpv/input.conf"]="$CONFIG_HOME/mpv/input.conf"
        ["mpv/mpv.conf"]="$CONFIG_HOME/mpv/mpv.conf"
    )
    cfg::link_map links

    cfg::desktop_entries \
        "qBittorrent/org.qbittorrent.qBittorrent.desktop"

    log::info "Desktop configs deployed"
}

# https://github.com/qbittorrent/qBittorrent
desktop::qbittorrent() {
    appimage::install \
        "https://github.com/qbittorrent/qBittorrent/releases/download/release-5.2.4/qbittorrent-5.2.4_x86_64.AppImage" \
        "qbittorrent"
}
