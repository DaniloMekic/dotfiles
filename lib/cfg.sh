################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_CFG_SOURCED:-}" ]]; then
    return
fi
_LIB_CFG_SOURCED=true

################################################################################

# Symlink a file from cfg/ to a full destination path
# Creates the parent directory and uses sudo for paths outside $HOME
# Option --no-dereference prevents following of an existing symlink if it points to a directory
# Usage: cfg::link <path relative to cfg/> <destination path>
cfg::link() {
    local src="$DOTFILES_HOME/cfg/$1" dest="$2"
    local -a run=()
    [[ "link_name" != "$HOME"/* ]] && run=(sudo)

    "${run[@]}" mkdir -p "$(dirname "$dest")"
    "${run[@]}" ln -sfv --no-dereference "$src" "$dest"
}

# Copy a file from cfg/ to a full destination path
# For configs that can't be symlinks, e.g. when the service can't read $HOME
# Uses sudo for paths outside $HOME
# Usage: cfg::copy <path relative to cfg/> <destination path>
cfg::copy() {
    local src="$DOTFILES_HOME/cfg/$1" dest="$2"
    local -a run=()
    [[ "link_name" != "$HOME"/* ]] && run=(sudo)

    # install -D creates the parent directory, -mode=644 sets permission mode (as in chmod)
    "${run[@]}" install -D --mode=644 --verbose "$src" "$dest"
}

cfg::deploy() {
    log::info "Deploying configs"

    cfg::link "Neovim" "$CONFIG_HOME/nvim"
    cfg::link "Bash/bashrc" "$HOME/.bashrc"
    cfg::link "Bash/bash_profile" "$HOME/.bash_profile"
    cfg::link "Vim/config.vim" "$HOME/.vimrc"
    cfg::link "curl/curlrc" "$HOME/.curlrc"
    cfg::link "tmux/tmux.conf" "$HOME/.tmux.conf"
    cfg::link "Git/.gitconfig" "$HOME/.gitconfig"

    # Return early if it's WSL environment
    if sys::is_wsl; then
        return
    fi

    cfg::link "Niri/niri/config.kdl" "$CONFIG_HOME/niri/config.kdl"
    cfg::link "mpv/input.conf" "$CONFIG_HOME/mpv/input.conf"
    cfg::link "mpv/mpv.conf" "$CONFIG_HOME/mpv/mpv.conf"
    cfg::link "Waybar/config.jsonc" "$CONFIG_HOME/waybar/config.jsonc"
    cfg::link "Waybar/style.css" "$CONFIG_HOME/waybar/style.css"
    # cfg::link "rofi.rasi" "$CONFIG_HOME/rofi/config.rasi"

    # Terminal Emulators
    cfg::link "Alacritty/alacritty.toml" "$CONFIG_HOME/alacritty/alacritty.toml"
    cfg::link "Ghostty/config.ghostty" "$CONFIG_HOME/ghostty/config.ghostty"
    cfg::link "foot/foot.ini" "$CONFIG_HOME/foot/foot.ini"

    # System configs
    cfg::link "LogiOps/logid.cfg" "/etc/logid.cfg"
    cfg::link "keyd/default.conf" "/etc/keyd/default.conf"
    # iwd.service runs with ProtectHome=yes, so symlink can't be used
    cfg::copy "iwd/main.conf" "/etc/iwd/main.conf"

    log::info "Configs deployed"
}
