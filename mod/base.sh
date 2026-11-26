################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_MOD_BASE_SOURCED:-}" ]]; then
    return
fi
_MOD_BASE_SOURCED=true

################################################################################
# CLI userland, on every machine: bare metal and WSL

base::provision() {
    log::info "Provisioning base userland"

    toolchain::git
    pkg::pacman \
        7zip \
        fastfetch \
        jq jless \
        ripgre \
        tmux \
        vim

    log::info "Base userland provisioned"
}

base::deploy() {
    log::info "Deploying base configs"

    # For `~/.config/environment.d/*.conf` files, see:
    #   https://wiki.archlinux.org/title/Environment_variables#Per_user
    #   https://wiki.archlinux.org/title/Systemd/User#Environment_variables
    # shellcheck disable=SC2034 # Used through a nameref in cfg::link_map
    local -A links=(
        ["environment.d/10-path.conf"]="$CONFIG_HOME/environment.d/10-path.conf"
        ["Bash/bashrc.sh"]="$HOME/.bashrc"
        ["Bash/bash_profile.sh"]="$HOME/.bash_profile"
        ["Vim/config.vim"]="$HOME/.vimrc"
        ["curl/curlrc"]="$HOME/.curlrc"
        ["tmux/tmux.conf"]="$HOME/.tmux.conf"
        ["Git/.gitconfig"]="$HOME/.gitconfig"
    )
    cfg::link_map links

    log::info "Base configs deployed"
}
