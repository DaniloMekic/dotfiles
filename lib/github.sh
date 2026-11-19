################################################################################
# include guard
# https://en.wikipedia.org/wiki/include_guard
if [[ -n "${_LIB_GITHUB_SOURCED:-}" ]]; then
    return
fi
_LIB_GITHUB_SOURCED=true

################################################################################

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

    local asset_url=$(curl --silent --location \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2026-03-10" \
        "https://api.github.com/repos/${repo_full_name}/releases/tags/${tag}" \
        | jq --raw-output ".assets[] | select(.label == \"$asset_label\") | .browser_download_url")

    if [[ -z "$asset_url" ]]; then
        log::error "Asset \"$asset_label\" not found in $repo_full_name tag=\"$tag\""
        return 1
    fi

    # --fail                            : (HTTP) Fail with error code 22 and with no response body output at all for HTTP transfers returning HTTP response codes at 400 or greater
    if ! curl --fail -L --create-dirs --output "$download_location" "$asset_url"; then
        log::error "Failed to download \"$asset_label\" from $asset_url"
        return 1
    fi

    log::info "Downloaded asset \"$asset_label\" from \"$repo_full_name\" repository, tag=\"$tag\", to $download_location"
}
