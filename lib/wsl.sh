################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_WSL_SOURCED:-}" ]]; then
    return
fi
_LIB_WSL_SOURCED=true

################################################################################

# Function for detecting Windows Subsystem for Linux (WSL) environment
wsl::is_wsl() {
    [[ -n "${WSL_DISTRO_NAME:-}" ]] || grep -qi microsoft /proc/version 2>/dev/null
}

# https://devblogs.microsoft.com/commandline/share-environment-vars-between-wsl-and-windows/
# WSLENV is a special Windows environment variable for sharing and translating environment variables between Windows (Win32) and the Windows Subsystem for Linux (WSL)
#
# https://learn.microsoft.com/en-us/windows/deployment/usmt/usmt-recognized-environment-variables
# Shared Windows environment variables:
#       USERPROFILE
wsl::set_wslenv() {
    powershell.exe -NoProfile -Command \
        "[Environment]::SetEnvironmentVariable('WSLENV','USERPROFILE/up','User')"

    log::info "Windows \$WSLENV variable is set. WSL restart is required."
}

wsl::deploy() {
    mkdir -p "$HOME/.local/bin" && ln -sf "$DOTFILES_HOME/bin/cpw" "$HOME/.local/bin"
    log::info "Linked $DOTFILES_HOME/bin/cpw --> $HOME/.local/bin/cpw"
}
