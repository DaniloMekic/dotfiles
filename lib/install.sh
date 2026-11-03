################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_INSTALL_SOURCED:-}" ]]; then
    return
fi
_LIB_INSTALL_SOURCED=true

################################################################################

# System Dependencies
install::system() {
    # noto-fonts-emoji                  : Noto Color Emoji for Waybar
    # ttf-jetbrains-mono-nerd           : JetBrainsMono Nerd Font for Neovim
    # wl-clipboard                      : Clipboard CLI tools for Wayland compositors
    sudo pacman -S --needed --noconfirm --disable-download-timeout \
        7zip \
        fastfetch \
        ghostty \
        git tig lazygit \
        jq jless \
        keyd \
        mpv \
        niri fuzzel mako \
        noto-fonts-emoji \
        ripgrep \
        tmux \
        ttf-jetbrains-mono-nerd \
        vim neovim \
        wl-clipboard

    if ! command -v "$AUR_HELPER" &>/dev/null; then
        pkg::get_aur_helper
    fi

    setup::rust

    # Return early if it's WSL environment
    if sys::is_wsl; then
        return
    fi

    # AUR packages:
    #   logiops                         : Unofficial userspace driver for HID++ Logitech devices
    #   sourcegit-bin                   : Git GUI client
    #   wlogout                         : Wayland based logout menu
    "$AUR_HELPER" -S "${AUR_HELPER_OPTS[@]}" \
        logiops \
        sourcegit-bin \
        wlogout

    local response
    read -rp "Enable services? [Y/n] " response
    # test -z option catches empty response (just pressing Enter)
    if [[ -z "$response" || "${response,,}" == yes || "${response,,}" == y ]]; then
        sys::enable_services
    fi
}

# Neovim
install::nvim() {
    setup::java
    sudo archlinux-java set java-21-openjdk

    # bash-language-server              : Bash LSP server
    # eslint_d                          : JavaScript/TypeScript linter
    # harper                            : Grammar LSP server
    # kdlfmt                            : KDL code formatter
    # lua-language-server               : Lua LSP server
    # prettier                          : Code formatter
    # python-black                      : Python code formatter
    # python-debugpy                    : Python DAP server
    # python-isort                      : Python utility for sorting module import statements
    # ruff                              : Python linter and LSP server
    # rumdl                             : Markdown linter and code formatter
    # shfmt                             : Shell code formatter
    # stylua                            : Lua code formatter
    # taplo-cli                         : TOML LSP server
    # texlab                            : LaTeX LSP server
    # wl-clipboard                      : Clipboard provider
    sudo pacman -Syu --needed --noconfirm --disable-download-timeout \
        bash-language-server \
        eslint_d \
        fzf \
        gcc \
        git \
        go \
        harper \
        jq \
        kdlfmt \
        lua \
        lua-language-server \
        maven \
        nodejs \
        npm \
        perl-tidy \
        prettier \
        python python-pip ruff python-isort python-black \
        python-debugpy \
        ripgrep \
        rumdl \
        rust-analyzer \
        shellcheck \
        shfmt \
        stylua \
        taplo-cli \
        texlab \
        tree-sitter-cli \
        typescript-language-server \
        unzip \
        vscode-css-languageserver \
        vscode-html-languageserver \
        vscode-json-languageserver \
        wl-clipboard \
        yaml-language-server \
        yazi

    if ! command -v "$AUR_HELPER" &>/dev/null; then
        pkg::get_aur_helper
    fi

    # basedpyright-bin                  : Python LSP server
    # google-java-format                : Java code formatter
    # groovy-language-server-git        : Groovy LSP server
    # lemminx                           : XML LSP server
    # powershell-bin                    : Required binaries for the PowerShell Editor Services, an LSP for PowerShell
    # powershell-editor-services-bin    : PowerShell LSP and DAP server
    # prettierd                         : Code formatter
    # sqls                              : SQL LSP server
    "$AUR_HELPER" -S "${AUR_HELPER_OPTS[@]}" \
        basedpyright-bin \
        google-java-format \
        groovy-language-server-git \
        lemminx \
        powershell-bin powershell-editor-services-bin \
        prettierd \
        sqls \
        vim-language-server

    sudo npm install -g npm-groovy-lint

    setup::rust

    # Update Rust and install KDL LSP
    rustup update stable
    rustup component add rustfmt
    cargo install kdl-lsp

    setup::tex

    cfg::link "Neovim" "$CONFIG_HOME/nvim"
}
