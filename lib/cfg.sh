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

    log::info "Linking $src --> $dest"
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

    log::info "Copying $src --> $dest"
    # install -D creates the parent directory, -mode=644 sets permission mode (as in chmod)
    "${run[@]}" install -D --mode=644 --verbose "$src" "$dest"
}

cfg::deploy() {
    log::info "Deploying configs"

    local -A links=(
        ["Neovim"]="$CONFIG_HOME/nvim"
        ["Bash/bashrc"]="$HOME/.bashrc"
        ["Bash/bash_profile"]="$HOME/.bash_profile"
        ["Vim/config.vim"]="$HOME/.vimrc"
        ["curl/curlrc"]="$HOME/.curlrc"
        ["tmux/tmux.conf"]="$HOME/.tmux.conf"
        ["Git/.gitconfig"]="$HOME/.gitconfig"
    )

    local src dest
    for src in "${!links[@]}"; do
        dest="${links[$src]}"
        cfg::link "$src" "$dest"
    done

    # Return early if it's WSL environment
    if sys::is_wsl; then
        log::info "WSL environment detected"

        return
    fi

    links=(
        ["Niri/niri/config.kdl"]="$CONFIG_HOME/niri/config.kdl"
        ["mpv/input.conf"]="$CONFIG_HOME/mpv/input.conf"
        ["mpv/mpv.conf"]="$CONFIG_HOME/mpv/mpv.conf"
        ["Waybar/config.jsonc"]="$CONFIG_HOME/waybar/config.jsonc"
        ["Waybar/style.css"]="$CONFIG_HOME/waybar/style.css"
        ["Alacritty/alacritty.toml"]="$CONFIG_HOME/alacritty/alacritty.toml"
        ["Ghostty/config.ghostty"]="$CONFIG_HOME/ghostty/config.ghostty"
        ["foot/foot.ini"]="$CONFIG_HOME/foot/foot.ini"
        ["LogiOps/logid.cfg"]="/etc/logid.cfg"
        ["keyd/default.conf"]="/etc/keyd/default.conf"
    )

    for src in "${!links[@]}"; do
        dest="${links[$src]}"
        cfg::link "$src" "$dest"
    done

    # iwd.service runs with ProtectHome=yes, so symlink can't be used
    cfg::copy "iwd/main.conf" "/etc/iwd/main.conf"

    log::info "Configs deployed"
}
