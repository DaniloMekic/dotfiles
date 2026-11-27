################################################################################
# Include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_MOD_WSL_SOURCED:-}" ]]; then
    return
fi
_MOD_WSL_SOURCED=true

################################################################################
# Windows Subsystem for Linux (WSL)

# https://devblogs.microsoft.com/commandline/share-environment-vars-between-wsl-and-windows/
# WSLENV is a special Windows environment variable for sharing and translating environment variables between Windows (Win32) and WSL
#
# https://learn.microsoft.com/en-us/windows/deployment/usmt/usmt-recognized-environment-variables
# Shared Windows environment variables:
#       USERPROFILE
wsl::provision() {
    log::info "Provisioning WSL"
    run::cmd powershell.exe -NoProfile -Command \
        "[Environment]::SetEnvironmentVariable('WSLENV','USERPROFILE/up','User')"
    log::info "WSL provisioned"

    log::info "Windows \$WSLENV variable is set. WSL restart is required."
}

wsl::deploy() {
    log::info "Deploying WSL configs"
    fs::symlink "$DOTFILES_HOME/bin/cpw" "$HOME/.local/bin/cpw"
}
