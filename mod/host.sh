################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_MOD_HOST_SOURCED:-}" ]]; then
    return
fi
_MOD_HOST_SOURCED=true

################################################################################
# Configuration specific to the primary host
# Everything here needs root: writes to /etc and manages system units
#
# The name comes from the Filesystem Hierarchy Standard (FHS), which describes
# /etc as "Host-specific system configuration"
# https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s07.html
#
# FHS calls such files unshareable: they belong to one host.
# Shareable modules (base, nvim, desktop) work the same on any machine

host::provision() {
    log::info "Provisioning host"

    # keyd                              : Key remapping daemon
    pkg::pacman keyd
    # LogiOps                           : Unofficial userspace driver for HID++ Logitech devices
    pkg::aur logiops

    log::info "Host provisioned"
}

host::deploy() {
    log::info "Deploying host configs"

    # shellcheck disable=SC2034 # Used through a nameref in cfg::link_map
    local -A links=(
        ["keyd/default.conf"]="/etc/keyd/default.conf"
        ["LogiOps/logid.cfg"]="/etc/logid.cfg"
    )
    cfg::link_map links

    # iwd.service runs with ProtectHome=yes, so symlink can't be used
    cfg::copy "iwd/main.conf" "/etc/iwd/main.conf"

    log::info "Host configs deployed"
}

host::enable_services() {
    local -a services=(keyd logid)
    log::info "Enabling system services: ${services[*]}"
    run::cmd sudo systemctl enable --now "${services[@]}"
    log::info "System services enabled"
}
