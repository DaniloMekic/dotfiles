################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_MOD_NVIM_SOURCED:-}" ]]; then
    return
fi
_MOD_NVIM_SOURCED=true

################################################################################
# Neovim, its language servers, code formatters, linters, and debug adapters

nvim::provision() {
    log::info "Provisioning Neovim"

    toolchain::git
    toolchain::c
    toolchain::java && sudo archlinux-java set java-21-openjdk
    toolchain::rust
    toolchain::tex

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
    pkg::pacman \
        neovim \
        bash-language-server \
        eslint_d \
        fzf \
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

    # basedpyright-bin                  : Python LSP server
    # google-java-format                : Java code formatter
    # groovy-language-server-git        : Groovy LSP server
    # lemminx                           : XML LSP server
    # powershell-bin                    : Required binaries for the PowerShell Editor Services, an LSP for PowerShell
    # powershell-editor-services-bin    : PowerShell LSP and DAP server
    # prettierd                         : Code formatter
    # sqls                              : SQL LSP server
    pkg::aur \
        basedpyright-bin \
        google-java-format \
        groovy-language-server-git \
        lemminx \
        powershell-bin powershell-editor-services-bin \
        prettierd \
        sqls \
        vim-language-server

    # npm-groovy-lint                   : Groovy linter
    #
    # --prefix installs into ~/.local/bin, which is on PATH (environment.d/10-path.conf),
    # so sudo is not needed as nothing lands in /usr
    log::info "npm: installing npm-groovy-lint"
    run::cmd npm --install --global --prefix "$HOME/.local" npm-groovy-lint

    # kdl-lsp                           : KDL LSP server (Niri config)
    log::info "cargo: installing kdl-lsp"
    run::cmd cargo install --locked kdl-lsp

    log::info "Neovim provisioned"
}

nvim::deploy() {
    log::info "Deploying Neovim config"
    cfg::link "Neovim" "$CONFIG_HOME/nvim"
}
