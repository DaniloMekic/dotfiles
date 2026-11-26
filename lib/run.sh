################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_RUN_SOURCED:-}" ]]; then
    return
fi
_LIB_RUN_SOURCED=true

################################################################################
# Running commands that change the system, with dry run support
#
# A dry run walks through every step without doing any of them,
# and prints what WOULD happen. Bash has no built-in dry run,
# only commands written through run::cmd are covered.
# A command called directly runs for real, even with DRY_RUN set.
# https://en.wikipedia.org/wiki/Dry_run_(testing)
#
# Usage: DRY RUN=1 ./bootstrap <option>

# True when $DRY_RUN is set (see lib/common.sh)
# For steps that can't go through run::cmd, e.g. a pipe,
# or later steps that depend on the result.
# Return early from those instead.
# Usage: if run::is_dry; then ...; fi
run::is_dry() {
    [[ -n "${DRY_RUN:-}" ]]
}

# Run a side-effecting command, or only log it during a dry run
# Commands that only read (command -v, pacman -Q, ...) don't need it
# Usage: run::cmd <comamnd> [args]
run::cmd() {
    if run::dry; then
        log::dry "$*"
    else
        "$@"
    fi
}
