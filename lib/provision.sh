################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_INSTALL_SOURCED:-}" ]]; then
    return
fi
_LIB_INSTALL_SOURCED=true

################################################################################

# System Dependencies
provision::userland() {
    log::info "Provisioning userland"

    log::info "Installing userland packages from the Arch Linux official repositories"
    # noto-fonts-emoji                  : Noto Color Emoji for Waybar
    # ttf-jetbrains-mono-nerd           : JetBrainsMono Nerd Font for Neovim
    # wl-clipboard                      : Clipboard CLI tools for Wayland compositors
    local -a pacman_pkgs=(
        7zip
        fastfetch
        ghostty
        git tig lazygit
        jq jless
        keyd
        mpv
        niri fuzzel mako
        noto-fonts-emoji
        ripgrep
        tmux
        ttf-jetbrains-mono-nerd
        vim neovim
        wl-clipboard
    )
    sudo pacman -S --needed --noconfirm --disable-download-timeout "${pacman_pkgs[@]}"
    log::info "Userland packages from the Arch Linux official repositories installed: ${pacman_pkgs[*]}"

    if ! command -v "$AUR_HELPER" &>/dev/null; then
        pkg::get_aur_helper
    fi

    toolchain::rust

    # Return early if it's WSL environment
    if sys::is_wsl; then
        return
    fi

    log::info "Installing userland packages from the Arch User Repository (AUR)"
    # AUR packages:
    #   logiops                         : Unofficial userspace driver for HID++ Logitech devices
    #   sourcegit-bin                   : Git GUI client
    #   wlogout                         : Wayland based logout menu
    local -a aur_pkgs=(
        logiops
        sourcegit-bin
        wlogout
    )
    "$AUR_HELPER" -S "${AUR_HELPER_OPTS[@]}" "${aur_pkgs[@]}"
    log::info "Userland packages from the Arch User Repository (AUR) installed: ${aur_pkgs[*]}"

    local response
    read -rp "Enable services? [Y/n] " response
    # test -z option catches empty response (just pressing Enter)
    if [[ -z "$response" || "${response,,}" == yes || "${response,,}" == y ]]; then
        sys::enable_services
    fi

    log::info "Userland provisioned"
}

# Neovim
provision::nvim() {
    log::info "Provisioning Neovim"

    toolchain::java
    sudo archlinux-java set java-21-openjdk

    log::info "Installing packages for Neovim from the Arch Linux official repositories"
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
    local -a pacman_pkgs=(
        bash-language-server
        eslint_d
        fzf
        gcc
        git
        go
        harper
        jq
        kdlfmt
        lua
        lua-language-server
        maven
        nodejs
        npm
        perl-tidy
        prettier
        python python-pip ruff python-isort python-black
        python-debugpy
        ripgrep
        rumdl
        rust-analyzer
        shellcheck
        shfmt
        stylua
        taplo-cli
        texlab
        tree-sitter-cli
        typescript-language-server
        unzip
        vscode-css-languageserver
        vscode-html-languageserver
        vscode-json-languageserver
        wl-clipboard
        yaml-language-server
        yazi
    )
    sudo pacman -Syu --needed --noconfirm --disable-download-timeout "${pacman_pkgs[@]}"
    log::info "Packages for Neovim from the Arch Linux official repositories installed: ${pacman_pkgs[*]}"

    if ! command -v "$AUR_HELPER" &>/dev/null; then
        pkg::get_aur_helper
    fi

    log::info "Installing packages for Neovim from the Arch User Repository (AUR)"
    # basedpyright-bin                  : Python LSP server
    # google-java-format                : Java code formatter
    # groovy-language-server-git        : Groovy LSP server
    # lemminx                           : XML LSP server
    # powershell-bin                    : Required binaries for the PowerShell Editor Services, an LSP for PowerShell
    # powershell-editor-services-bin    : PowerShell LSP and DAP server
    # prettierd                         : Code formatter
    # sqls                              : SQL LSP server
    local -a aur_pkgs=(
        basedpyright-bin
        google-java-format
        groovy-language-server-git
        lemminx
        powershell-bin powershell-editor-services-bin
        prettierd
        sqls
        vim-language-server
    )
    "$AUR_HELPER" -S "${AUR_HELPER_OPTS[@]}" "${aur_pkgs[@]}"
    log::info "Packages for Neovim from the Arch User Repository (AUR) installed: ${aur_pkgs[*]}"

    log::info "Installing packages for Neovim from the npm"
    local -a npm_pkgs=(npm-groovy-lint)
    sudo npm install -g "${npm_pkgs[@]}"
    log::info "Packages for Neovim from the npm installed: ${npm_pkgs[*]}"

    toolchain::rust

    log::info "Update Rust and install KDL LSP"
    rustup update stable
    rustup component add rustfmt
    cargo install kdl-lsp

    toolchain::tex

    cfg::link "Neovim" "$CONFIG_HOME/nvim"

    log::info "Neovim provisioned"
}
