################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_LINK_SOURCED:-}" ]]; then
    return
fi
_LIB_LINK_SOURCED=true

################################################################################

link::nvim_config() {
    ln -sfv --no-dereference "$DOTFILES_HOME/cfg/Neovim" "$CONFIG_HOME/nvim" # Option --no-dereference prevents following of an existing symlink if it points to a directory
}

link::all_configs() {
    link::nvim_config

    ln -sfv "$DOTFILES_HOME/cfg/Bash/bashrc" "$HOME/.bashrc"
    ln -sfv "$DOTFILES_HOME/cfg/Bash/bash_profile" "$HOME/.bash_profile"
    ln -sfv "$DOTFILES_HOME/cfg/Vim/config.vim" "$HOME/.vimrc"
    ln -sfv "$DOTFILES_HOME/cfg/curl/curlrc" "$HOME/.curlrc"
    ln -sfv "$DOTFILES_HOME/cfg/tmux/tmux.conf" "$HOME/.tmux.conf"
    ln -sfv "$DOTFILES_HOME/cfg/Git/.gitconfig" "$HOME"

    # Return early if it's WSL environment
    if sys::is_wsl; then
        return
    fi

    mkdir -p "$CONFIG_HOME/niri" && ln -sfv "$DOTFILES_HOME/cfg/Niri/config.kdl" "$_/config.kdl"
    mkdir -p "$CONFIG_HOME/mpv" && ln -sfv "$DOTFILES_HOME/cfg/mpv/input.conf" "$_"
    ln -sfv "$DOTFILES_HOME/cfg/mpv/mpv.conf" "$CONFIG_HOME/mpv/"
    sudo ln -sfv "$DOTFILES_HOME/cfg/LogiOps/logid.cfg" "/etc/"
    sudo mkdir -p "/etc/keyd" && sudo ln -sfv "$DOTFILES_HOME/cfg/keyd/default.conf" "$_"
    mkdir -p "$CONFIG_HOME/waybar" && ln -sfv "$DOTFILES_HOME/cfg/Waybar/config.jsonc" "$_" && ln -sfv "$DOTFILES_HOME/cfg/Waybar/style.css" "$_"
    # mkdir -p "$CONFIG_HOME/rofi" && ln -sfv "$DOTFILES_HOME/rofi.rasi" "$_/config.rasi"
    # Terminal Emulators
    mkdir -p "$CONFIG_HOME/alacritty" && ln -sfv "$DOTFILES_HOME/cfg/Alacritty/alacritty.toml" "$_"
    mkdir -p "$CONFIG_HOME/ghostty" && ln -sfv "$DOTFILES_HOME/cfg/Ghostty/ghostty.conf" "$_/config"
    mkdir -p "$CONFIG_HOME/foot" && ln -sfv "$DOTFILES_HOME/cfg/foot/foot.ini" "$_"
}
