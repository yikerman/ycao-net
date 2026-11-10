#!/usr/bin/env bash
# Fetches the latest IBM Plex webfonts (Latin-1 subset) from npm into static/fonts.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p static/fonts

tgz=$(mktemp)
trap 'rm -f "$tgz"' EXIT

# download <package>: fetches the latest tarball of an npm package
download() {
    local url
    url=$(curl -fsSL "https://registry.npmjs.org/$1/latest" |
        grep -o '"tarball":"[^"]*"' | cut -d'"' -f4)
    echo "$url"
    curl -fsSL -o "$tgz" "$url"
}

# extract <path in package> <output name>: from the last downloaded package
extract() {
    tar -xzOf "$tgz" "package/$1" > "static/fonts/$2"
}

p=fonts/split/woff2

download @ibm/plex-sans
extract $p/IBMPlexSans-Regular-Latin1.woff2    ibm-plex-sans-400-normal.woff2
extract $p/IBMPlexSans-Italic-Latin1.woff2     ibm-plex-sans-400-italic.woff2
extract $p/IBMPlexSans-Bold-Latin1.woff2       ibm-plex-sans-700-normal.woff2
extract $p/IBMPlexSans-BoldItalic-Latin1.woff2 ibm-plex-sans-700-italic.woff2
extract LICENSE.txt                            OFL.txt

download @ibm/plex-mono
extract $p/IBMPlexMono-Regular-Latin1.woff2    ibm-plex-mono-400-normal.woff2
extract $p/IBMPlexMono-Bold-Latin1.woff2       ibm-plex-mono-700-normal.woff2
