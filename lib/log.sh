################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_LOG_SOURCED:-}" ]]; then
    return
fi
_LIB_LOG_SOURCED=true

################################################################################
# Dependencies

# Get absolute path of the lib/ dir
LIB_HOME="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

if [[ -z "${_LIB_ANSI_SOURCED}" ]]; then
    [[ -f "${LIB_HOME}/ansi.sh" && -r "${LIB_HOME}/ansi.sh" ]] && source "${LIB_HOME}/ansi.sh" || {
        echo "ERROR: Failed to source ansi.sh"
        exit 1
    }
fi

################################################################################
# Set log destination and format file path column in the log
log_destination="$BOOTSTRAP_LOG_DESTINATION"
# Bash 4.2 is required for reading arrays via negative indexes
# calling_script="${BASH_SOURCE[-1]}"
calling_script="${BASH_SOURCE[${#BASH_SOURCE[@]} - 1]}"
calling_script_file_path_absolute="$(cd -- "$(dirname -- "${calling_script}")" &>/dev/null && pwd)"/$(basename -- "${calling_script}")

# If path length is longer than max width, truncate it from the left
# Otherwise, apply padding from the left
file_path_width=50
if [[ "${#calling_script_file_path_absolute}" -gt "$file_path_width" ]]; then
    # Prepend long paths with 3 dots
    calling_script_file_path_absolute="...${calling_script_file_path_absolute: -$((file_path_width - 3))}"
fi
left_padded_path=$(printf "%*s" "$file_path_width" "$calling_script_file_path_absolute")

: "${log_destination:?Variable log_destination is not set.}"

################################################################################
# LEVELS
LEVEL_INFO=$(printf "%5s" "INFO")
LEVEL_DEBUG=$(printf "%5s" "DEBUG")
LEVEL_ERROR=$(printf "%5s" "ERROR")

################################################################################
# Print to stdout and append a log file
log::info() {
    echo "[$(date '+%F %T')] [${left_padded_path}] $LEVEL_INFO: $1" | tee -a "${log_destination}"
}

log::debug() {
    echo "[$(date '+%F %T')] [${left_padded_path}] $LEVEL_DEBUG: $1" | tee -a "${log_destination}"
}

log::error() {
    echo "[$(date '+%F %T')] [${left_padded_path}] $LEVEL_ERROR: $1" >>"${log_destination}"
    echo -e "[$(date '+%F %T')] [${left_padded_path}] $(ansi::colorize 39 41 ERROR): $1" >&2
}
