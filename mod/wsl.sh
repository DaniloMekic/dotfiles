################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_MOD_WSL_SOURCED:-}" ]]; then
    return
fi
_MOD_WSL_SOURCED=true

################################################################################
# Windows Subsystem for Linux (WSL)

# Function for detecting WSL environment
#
# grep options:
#   -q                                  : Quiet (silent) mode: suppress output, only set the exit status
#   -i                                  : Case-insensitive search
wsl::is_wsl() {
    [[ -n "${WSL_DISTRO_NAME:-}" ]] || grep -qi microsoft /proc/version 2>/dev/null
}

wsl::provision() {
    log::info "Provisioning WSL"
    wsl::set_wslenv
}

wsl::deploy() {
    log::info "Deploying WSL configs"
    fs::symlink "$DOTFILES_HOME/bin/cpw" "$HOME/.local/bin/cpw"
}

# https://devblogs.microsoft.com/commandline/share-environment-vars-between-wsl-and-windows/
# WSLENV is a special Windows environment variable for sharing and translating environment variables between Windows (Win32) and WSL
#
# https://learn.microsoft.com/en-us/windows/deployment/usmt/usmt-recognized-environment-variables
# Shared Windows environment variables:
#       USERPROFILE
wsl::set_wslenv() {
    run::cmd powershell.exe -NoProfile -Command \
        "[Environment]::SetEnvironmentVariable('WSLENV','USERPROFILE/up','User')"

    log::info "Windows \$WSLENV variable is set. WSL restart is required."
}
