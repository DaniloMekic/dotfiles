################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_NET_SOURCED:-}" ]]; then
    return
fi
_LIB_NET_SOURCED=true

################################################################################

# Usage: appimage::_download <url> <dest>
net::download() {
    local url="$1"
    local dest="${2:-"/tmp"}"

    # https://curl.se/docs/manpage.html
    # curl options:
    #   --disable                       : Ignore ~/.curlrc (MUST be the first option), so scripts behave the same everywhere
    #   --fail                          : Exit non-zero on HTTP >= 400, instead of saving a 404 page as the "AppImage"
    #   --silent --show-error           : No progress meter, but still print errors
    #   --proto '=https'                : Only allow HTTPS, also for every redirect
    #   --location                      : Follow redirects (asset downloads redirect to objects.githubusercontent.com)
    #   --retry 3                       : Retry transient failures
    #   --create-dirs                   : When used in conjunction with the --output option, curl creates the necessary local directory hierarchy as needed
    #   --remove-on-error               : Remove the output file if an error occurs
    #   --output                        : Write output to the given file instead of stdout
    local curl_opts=(--disable --fail --silent --show-error --location --proto '=https' --retry 3 --create-dirs --remove-on-error --output "$dest")

    if ! curl "${curl_opts[@]}" "$url"; then
        log::error "Failed to download from $url"
        return 1
    fi

    log::info "Successful download from $url to $dest"
}
