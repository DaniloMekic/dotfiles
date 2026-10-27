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

# Used for symlinking configs
DOTFILES_HOME="$(cd -- "$(dirname -- "${BASH_SOURCE[1]}")" &>/dev/null && pwd)"
CONFIG_HOME="$HOME/.config"

source "${LIB_HOME}/ansi.sh"
source "${LIB_HOME}/log.sh"
source "${LIB_HOME}/utils.sh"
