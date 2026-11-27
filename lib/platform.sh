################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_PLATFORM_SOURCED:-}" ]]; then
    return
fi
_LIB_PLATFORM_SOURCED=true

################################################################################

# Function for detecting WSL environment
#
# grep options:
#   -q                                  : Quiet (silent) mode: suppress output, only set the exit status
#   -i                                  : Case-insensitive search
platform::is_wsl() {
    [[ -n "${WSL_DISTRO_NAME:-}" ]] \
        || [[ -n "${WSL_INTEROP:-}" ]] \
        || grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null
}
