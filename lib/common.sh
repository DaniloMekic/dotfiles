set -euo pipefail

################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_COMMON_SOURCED:-}" ]]; then
    return
fi
_LIB_COMMON_SOURCED=true

################################################################################

LIB_HOME="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Used by logging functions in lib/log.sh
BOOTSTRAP_LOG_DESTINATION="/tmp/bootstrap.log"

AUR_HELPER="yay"
# https://jguer.github.io/yay/man.html
# yay options:
#   --needed                        : Only install packages that are not already installed
#   --noconfirm                     : Automatically answer "yes" to all confirmation prompts
#   --answerdiff None               : Suppress the prompt to view the changes (diff) between the current PKGBUILD and the previously cached one
#   --answerclean All               : Clean build files from Yay's cache
#   --sudoloop                      : prevent sudo from timing out during long builds
AUR_HELPER_OPTS=(--needed --noconfirm --answerdiff None --answerclean All --sudoloop)

# Used for symlinking configs
DOTFILES_HOME="$(cd -- "$(dirname -- "${BASH_SOURCE[1]}")" &>/dev/null && pwd)"
CONFIG_HOME="$HOME/.config"

source "${LIB_HOME}/ansi.sh"
source "${LIB_HOME}/log.sh"
source "${LIB_HOME}/utils.sh"
