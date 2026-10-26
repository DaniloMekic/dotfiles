# https://en.wikipedia.org/wiki/ANSI_escape_code

################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_ANSI_SOURCED:-}" ]]; then
    return
fi
_LIB_ANSI_SOURCED=true

################################################################################
ESC="\033"
# Control Sequence Introducer
CSI="${ESC}["

# Select Graphic Rendition (SGR): CSI n m
# Sets colors and style of the characters following this sequence
FINAL_BYTE_SGR="m"
# SGR parameters (n)
PARAM_SGR_RESET="0"
PARAM_SGR_COLOR_FG_RED="31"
PARAM_SGR_COLOR_FG_DEFAULT="39"
PARAM_SGR_COLOR_BG_RED="41"
PARAM_SGR_COLOR_BG_DEFAULT="49"
PARAM_SGR_COLOR_FG_GREEN="32"

################################################################################
# Escape Sequences
ES_SGR_RESET="${CSI}${PARAM_SGR_RESET}${FINAL_BYTE_SGR}"

################################################################################
# FUNCTIONS
# ANSI SGR Control Sequences
ansi::cs_sgr() {
    # Attributes in the same sequence are separated by semicolons
    # Utilize $IFS for this
    local IFS=";"
    local sgr_params="$*"

    echo -e "${CSI}${sgr_params}${FINAL_BYTE_SGR}"
}

ansi::colorize() {
    local color_fg="${1,,}"
    local color_bg="${2,,}"
    local text_to_colorize="$3"

    echo -e "$(ansi::cs_sgr $color_fg $color_bg)${text_to_colorize}${ES_SGR_RESET}"
}
