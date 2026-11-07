################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_SYS_SOURCED:-}" ]]; then
    return
fi
_LIB_SYS_SOURCED=true

################################################################################

# Function for detecting Windows Subsystem for Linux (WSL) environment
sys::is_wsl() {
    [[ -n "${WSL_DISTRO_NAME:-}" ]] || grep -qi microsoft /proc/version 2>/dev/null
}

sys::enable_services() {
    log::info "Enabling system services"

    declare -a services=(keyd logid)

    echo "Enabling services: ${services[*]}"

    sudo systemctl enable --now "${services[@]}"

    log::info "System services enabled"
}
