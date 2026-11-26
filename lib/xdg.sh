################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_XDG_SOURCED:-}" ]]; then
    return
fi
_LIB_XDG_SOURCED=true

################################################################################
# freedesktop.org (fd.o), formerly X Desktop Group (XDG), file formats

# Print every distinct Icon= name from .desktop files, one per line
# Absolute paths are dropped, they're files, not theme icon names
# https://specifications.freedesktop.org/basedir/latest/
#
# Usage: xdg::desktop_icon_names <desktop-file>
xdg::desktop_icon_names() {
    # sed                               : Print only lines that start with Icon=, without the key
    # grep                              : Drop absolute paths; `-v` inverts matches; `|| true` because no match is not an error
    # sort -u                           : Remove duplicates
    sed -n 's/^Icon=//p' "$@" \
        | { grep -v '^/' || true; } \
        | sort -u
}
