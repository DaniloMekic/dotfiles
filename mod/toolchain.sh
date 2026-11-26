################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_MOD_TOOLCHAIN_SOURCED:-}" ]]; then
    return
fi
_MOD_TOOLCHAIN_SOURCED=true

################################################################################
# Language toolchains, called by other modules

toolchain::c() {
    log::info "Installing C toolchain"

    # Arch Linux official repositories
    #   https://archlinux.org/packages/core/any/base-devel/
    #   https://archlinux.org/packages/extra/x86_64/gdb/
    pkg::pacman base-devel gdb

    log::info "C toolchain installed"
}

toolchain::git() {
    log::info "Installing Git toolchain"

    pkg::pacman git tig lazygit

    # sourcegit-bin                     : Git GUI client
    pkg::aur sourcegit-bin

    log::info "Git toolchain installed"
}

# Official toolchain installer and manager for the Rust programming language
# Arch Linux official rust package and rustup conflict because they both provide executables like cargo and rustc
# Installs only the toolchain. Tools built with cargo belong to the module that uses them
toolchain::rust() {
    log::info "Installing Rust toolchain"

    if ! command -v rustup &>/dev/null; then
        if run::is_dry; then
            log::info "Install rustup from https://sh.rustup.rs"
        else
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || {
                log::error "Failed to install rustup"
                return 1
            }
            # shellcheck source=/dev/null # Created by the rustup installer
            . "$HOME/.cargo/env"
        fi
    fi

    run::cmd rustup update stable
    run::cmd rustup component add rustfmt

    log::info "Rust toolchain installed"
}

# https://wiki.archlinux.org/title/Java
# Get JDK, documentation, and sources for multiple Java versions, including archlinux-java helper script
toolchain::java() {
    log::info "Installing Java toolchain"

    pkg::pacman \
        java-runtime-common \
        jdk8-openjdk openjdk8-doc openjdk8-src \
        jdk11-openjdk openjdk11-doc openjdk11-src \
        jdk17-openjdk openjdk17-doc openjdk17-src \
        jdk21-openjdk openjdk21-doc openjdk21-src \
        jdk25-openjdk openjdk25-doc openjdk25-src \
        jdk-openjdk openjdk-doc openjdk-src

    cfg::link "environment.d/20-java.conf" "$CONFIG_HOME/environment.d/20-java.conf"

    log::info "Java toolchain installed"
}

toolchain::tex() {
    log::info "Installing LaTeX toolchain"

    # tesseract-data-eng                : Tesseract OCR data for English, needed for libmupdf dependency
    pkg::pacman \
        biber \
        texlive-basic \
        texlive-binextra \
        texlive-latex \
        texlive-latexrecommended \
        zathura zathura-pdf-mupdf tesseract-data-eng

    log::info "LaTeX toolchain installed"
}
