################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_LOG_SOURCED:-}" ]]; then
    return
fi
_LIB_LOG_SOURCED=true

################################################################################

if [[ -z "${_LIB_ANSI_SOURCED:-}" ]]; then
    [[ -f "${LIB_HOME}/ansi.sh" && -r "${LIB_HOME}/ansi.sh" ]] && source "${LIB_HOME}/ansi.sh" || {
        echo "ERROR: Failed to source ansi.sh" >&2
        exit 1
    }
fi

################################################################################
# Set log destination and format file path column in the log
log_destination="$BOOTSTRAP_LOG_DESTINATION"
: "${log_destination:?Variable log_destination is not set}"

file_path_width=25

################################################################################
# LEVELS
LEVEL_INFO=$(printf "%5s" "INFO")
LEVEL_DEBUG=$(printf "%5s" "DEBUG")
LEVEL_ERROR=$(printf "%5s" "ERROR")

# Print "<path of calling file relative to bootstrap><line", left-padded or truncated to $file_path_width
# This helper function is meant to be called only within functions defined in this file
#
# Call stack when invoked from log::info:
#       [0] log::_caller    (defined here)
#       [1] log::info       (defined here)
#       [2] <caller>        (defined elsewhere)
log::_caller() {
    local src="${BASH_SOURCE[2]}"
    local line="${BASH_LINENO[1]}"
    local path

    # Canonicalize path
    path="$(cd -- "$(dirname -- "$src")" &>/dev/null && pwd)/$(basename -- "$src")"
    # Make relative to bootstrap's directory
    path="${path#"$DOTFILES_HOME"/}:$line"

    # If path is longer than max width, truncate it from the left
    if ((${#path} > file_path_width)); then
        path="...${path: -$((file_path_width - 3))}"
    fi

    # Left-pad to fix width
    printf "%*s" "$file_path_width" "$path"
}

################################################################################
# Print to stdout and append a log file
log::info() {
    echo "[$(date '+%F %T')] [$(log::_caller)] $LEVEL_INFO: $1" | tee -a "${log_destination}"
}

log::debug() {
    echo "[$(date '+%F %T')] [$(log::_caller)] $LEVEL_DEBUG: $1" | tee -a "${log_destination}"
}

log::error() {
    local caller
    caller="$(log::_caller)"
    echo "[$(date '+%F %T')] [${caller}] $LEVEL_ERROR: $1" >>"${log_destination}"
    echo -e "[$(date '+%F %T')] [${caller}] $(ansi::colorize 39 41 ERROR): $1" >&2
}
