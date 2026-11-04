################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_SETUP_SOURCED:-}" ]]; then
    return
fi
_LIB_SETUP_SOURCED=true

################################################################################

# Official toolchain installer and manager for the Rust programming language
# Arch Linux official rust package and rustup conflict because they both provide executables like cargo and rustc
toolchain::rust() {
    if ! command -v rustup &>/dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || {
            echo "Failed to fetch rustup installation script" >&2
            return 1
        }
        . "$HOME/.cargo/env"
    fi
}

# https://wiki.archlinux.org/title/Java
# Get JDK, documentation, and sources for multiple Java versions, including archlinux-java helper script
toolchain::java() {
    sudo pacman -S --needed --noconfirm --disable-download-timeout \
        java-runtime-common \
        jdk8-openjdk openjdk8-doc openjdk8-src \
        jdk11-openjdk openjdk11-doc openjdk11-src \
        jdk17-openjdk openjdk17-doc openjdk17-src \
        jdk21-openjdk openjdk21-doc openjdk21-src \
        jdk25-openjdk openjdk25-doc openjdk25-src \
        jdk-openjdk openjdk-doc openjdk-src

    mkdir -p ~/.config/environment.d

    cat >~/.config/environment.d/java.conf <<EOF
JAVA_HOME=/usr/lib/jvm/default
EOF
}

toolchain::tex() {
    # tesseract-data-eng                : Tesseract OCR data for English, needed for libmupdf dependency
    sudo pacman -S --needed --noconfirm --disable-download-timeout \
        biber \
        texlive-basic \
        texlive-binextra \
        texlive-latex \
        texlive-latexrecommended \
        zathura zathura-pdf-mupdf tesseract-data-eng
}
