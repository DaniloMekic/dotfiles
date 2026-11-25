# Variables in this file are used by the files this one sources in a glob loop,
# which ShellCheck cannot follow
# shellcheck disable=SC2034

################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_COMMON_SOURCED:-}" ]]; then
    return
fi
_LIB_COMMON_SOURCED=true

################################################################################

# Separation of mechanism and policy
# https://en.wikipedia.org/wiki/Separation_of_mechanism_and_policy
#
# Library (mechanisms)
LIB_HOME="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
# Module (policies)
MOD_HOME="$DOTFILES_HOME/mod"

# Repository root is the parent of lib/
# Derived from THIS file's location, so it doesn't depend on which script sourced common.sh
DOTFILES_HOME="${LIB_HOME%/*}"

# Used by logging functions in lib/log.sh
# Can be overriden from the environment, e.g. for a dry run
BOOTSTRAP_LOG_DESTINATION="${BOOTSTRAP_LOG_DESTINATION:-/tmp/bootstrap.log}"

# Non-empty value: print side-effecting commands instead of running them
# See fs::run in lib/fs.sh
# Usage: DRY_RUN=1 ./bootstrap -c
DRY_RUN="${DRY_RUN:-}"

# https://wiki.archlinux.org/title/Pacman
# https://man.archlinux.org/man/pacman.8
# pacman options:
#   -S                                  : Synchronize packages
#   --needed                            : Do not reinstall the targets that are already up-to-date
#   --noconfirm                         : Bypass any and all "Are you sure?" messages
#   --disable-download-timeout          : Disable defaults for low speed limit and timeout on downloads
PACMAN_OPTS=(-S --needed --noconfirm --disable-download-timeout)

AUR_HELPER="yay"
# https://jguer.github.io/yay/man.html
# yay options:
#   --needed                            : Only install packages that are not already installed
#   --noconfirm                         : Automatically answer "yes" to all confirmation prompts
#   --answerdiff None                   : Suppress the prompt to view the changes (diff) between the current PKGBUILD and the previously cached one
#   --answerclean All                   : Clean build files from Yay's cache
#   --sudoloop                          : prevent sudo from timing out during long builds
AUR_HELPER_OPTS=(--needed --noconfirm --answerdiff None --answerclean All --sudoloop)

# XDG Base Directory Specification
# https://wiki.archlinux.org/title/XDG_Base_Directory
# https://specifications.freedesktop.org/basedir/latest/
CONFIG_HOME="$HOME/.config"
# Location for user-specific data (analogous to /usr/share
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Source lib/ first (mechanisms), then mod/ (policies)
for file in "${LIB_HOME}"/*.sh "$MOD_HOME"/*.sh; do
    [[ "$file" -ef "${BASH_SOURCE[0]}" ]] && continue # skips common.sh itself
    # https://www.shellcheck.net/wiki/SC1090
    # shellcheck disable=SC1090 # Paths come from the globs above
    source "$file"
done
unset file
