################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_GITHUB_SOURCED:-}" ]]; then
    return
fi
_LIB_GITHUB_SOURCED=true

################################################################################

GITHUB_API_BASE_URL="https://api.github.com"

# https://curl.se/docs/manpage.html
# curl options:
#   --disable                           : Ignore ~/.curlrc (MUST be the first option), so scripts behave the same everywhere
#   --fail                              : Exit non-zero on HTTP >= 400, instead of saving a 404 page as the "AppImage"
#   --silent --show-error               : No progress meter, but still print errors
#   --proto '=https'                    : Only allow HTTPS, also for every redirect
#   --location                          : Follow redirects (asset downloads redirect to objects.githubusercontent.com)
#   --retry 3                           : Retry transient failures
#   --create-dirs                       : When used in conjunction with the --output option, curl creates the necessary local directory hierarchy as needed
#   --remove-on-error                   : Remove the output file if an error occurs
GITHUB_CURL_OPTS=(--disable --fail --silent --show-error --location --proto '=https' --retry 3 --create-dirs --remove-on-error)

# https://docs.github.com/en/rest/repos/repos?apiVersion=2026-03-10
# https://docs.github.com/en/rest/releases/releases?apiVersion=2026-03-10#get-a-release-by-tag-name
#
# Usage: github::download_tag_asset <repo-full-name> <tag> <asset-label> <file-path>
github::download_tag_asset() {
    local repo_full_name="$1"
    local tag="$2"
    local asset_label="$3"
    local download_location="$4"

    if [[ -z "$repo_full_name" || -z "$tag" || -z "$asset_label" || -z "$download_location" ]]; then
        log::error "${FUNCNAME[0]} is missing required arguments"
        log::error "Usage: ${FUNCNAME[0]} <repo-full-name> <tag> <asset-label> <file-path>"
        return 1
    fi

    local path="repos/${repo_full_name}/releases/tags/${tag}"
    local github_tag_url="https://github.com/$repo_full_name/releases/tag/$tag"

    local -a headers=(
        -H "Accept: application/vnd.github+json"
        -H "X-GitHub-Api-Version: 2026-03-10"
    )

    # https://docs.github.com/en/rest/authentication/authenticating-to-the-rest-api?apiVersion=2026-03-10
    if [[ -n "${GITHUB_TOKEN:-}" ]]; then
        headers+=(-H "Authorization: Bearer $GITHUB_TOKEN")
    fi

    local asset_url
    asset_url=$(curl "${GITHUB_CURL_OPTS[@]}" "${headers[@]}" "${GITHUB_API_BASE_URL}/${path}" \
        | jq --raw-output ".assets[] | select(.label == \"$asset_label\") | .browser_download_url")

    if [[ -z "$asset_url" ]]; then
        log::error "Asset \"$asset_label\" not found at ${github_tag_url}"
        return 1
    fi

    if ! curl "${GITHUB_CURL_OPTS[@]}" --output "$download_location" "$asset_url"; then
        log::error "Failed to download \"$asset_label\" from $asset_url"
        return 1
    fi

    log::info "Downloaded asset \"$asset_label\" from $github_tag_url, to $download_location"
}
