################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_FS_SOURCED:-}" ]]; then
    return
fi
_LIB_FS_SOURCED=true

################################################################################

# Creates the parent directory and uses sudo for paths outside $HOME
# Option --no-dereference prevents following of an existing symlink if it points to a directory
# Usage: fs::symlink <source-path> <destination-path>
fs::symlink() {
    local src="$1" dest="$2"

    # If symlink destination (LINK_NAME) is outside of $HOME,
    # run with sudo
    local -a run=()
    [[ "$dest" != "$HOME"/* ]] && run=(sudo)

    "${run[@]}" mkdir -p "$(dirname "$dest")"

    "${run[@]}" ln -sf --no-dereference "$src" "$dest"
    log::info "Linked $src --> $dest"
}

# For files that can't be symlinks, e.g. when the service can't read $HOME
# Uses sudo for paths outside $HOME
# Usage: fs::copy <source-path> <destination-path>
fs::copy() {
    local src="$1" dest="$2"

    # If destination is outside of $HOME,
    # run with sudo
    local -a run=()
    [[ "$dest" != "$HOME"/* ]] && run=(sudo)

    # install -D creates the parent directory, -mode=644 sets permission mode (as in chmod)
    "${run[@]}" install -D --mode=644 "$src" "$dest"
    log::info "Copied $src --> $dest"
}
