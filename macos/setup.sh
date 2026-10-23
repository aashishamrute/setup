#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ "$(uname -m)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew is already installed."
fi

brew bundle --file="$SCRIPT_DIR/Brewfile"

if [[ ! -d "$HOME/.sdkman" ]]; then
    echo "SDKMAN not found. Installing..."
    curl -fsSL "https://get.sdkman.io" | bash
else
    echo "SDKMAN is already installed."
fi
