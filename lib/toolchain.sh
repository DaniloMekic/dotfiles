################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_SETUP_SOURCED:-}" ]]; then
    return
fi
_LIB_SETUP_SOURCED=true

################################################################################

toolchain::git() {
    log::info "Installing Git toolchain"

    # Arch Linux official repositories
    log::info "Installing Git and related packages from the Arch Linux official repositories"
    local -a pacman_pkgs=(
        git tig lazygit
    )
    sudo pacman -S --needed --noconfirm --disable-download-timeout "${pacman_pkgs[@]}"
    log::info "Git and related packages from the Arch Linux official repositories installed: ${pacman_pkgs[*]}"

    # Arch User Repository (AUR)
    log::info "Installing Git packages from the Arch User Repository (AUR)"
    # AUR packages:
    #   sourcegit-bin                   : Git GUI client
    local -a aur_pkgs=(
        sourcegit-bin
    )
    "$AUR_HELPER" -S "${AUR_HELPER_OPTS[@]}" "${aur_pkgs[@]}"
    log::info "Git packages from the Arch User Repository (AUR) installed: ${aur_pkgs[*]}"
}

# Official toolchain installer and manager for the Rust programming language
# Arch Linux official rust package and rustup conflict because they both provide executables like cargo and rustc
toolchain::rust() {
    log::info "Installing Rust toolchain"

    if ! command -v rustup &>/dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || {
            echo "Failed to fetch rustup installation script" >&2
            return 1
        }
        . "$HOME/.cargo/env"
    fi

    log::info "Rust toolchain installed"
}

# https://wiki.archlinux.org/title/Java
# Get JDK, documentation, and sources for multiple Java versions, including archlinux-java helper script
toolchain::java() {
    log::info "Installing Java toolchain"

    local -a pacman_pkgs=(
        java-runtime-common
        jdk8-openjdk openjdk8-doc openjdk8-src
        jdk11-openjdk openjdk11-doc openjdk11-src
        jdk17-openjdk openjdk17-doc openjdk17-src
        jdk21-openjdk openjdk21-doc openjdk21-src
        jdk25-openjdk openjdk25-doc openjdk25-src
        jdk-openjdk openjdk-doc openjdk-src
    )
    sudo pacman -S --needed --noconfirm --disable-download-timeout "${pacman_pkgs[@]}"

    mkdir -p ~/.config/environment.d

    cat >~/.config/environment.d/java.conf <<EOF
JAVA_HOME=/usr/lib/jvm/default
EOF

    log::info "Java toolchain installed: ${pacman_pkgs[*]}"
}

toolchain::tex() {
    log::info "Installing LaTeX toolchain"

    # tesseract-data-eng                : Tesseract OCR data for English, needed for libmupdf dependency
    local -a pacman_pkgs=(
        biber
        texlive-basic
        texlive-binextra
        texlive-latex
        texlive-latexrecommended
        zathura zathura-pdf-mupdf tesseract-data-eng
    )
    sudo pacman -S --needed --noconfirm --disable-download-timeout "${pacman_pkgs[@]}"

    log::info "LaTeX toolchain installed: ${pacman_pkgs[*]}"
}
