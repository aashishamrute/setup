#!/usr/bin/env bash

set -euo pipefail

REPO_URL="${SETUP_REPO_URL:-https://github.com/aashishamrute/setup.git}"

case "$(uname -s)" in
    Darwin)
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

        brew install git

        GITWS_DIR="$HOME/personal/gitws"
        mkdir -p "$GITWS_DIR"

        if [[ ! -d "$GITWS_DIR/setup" ]]; then
            git clone "$REPO_URL" "$GITWS_DIR/setup"
        else
            echo "setup repo already cloned at $GITWS_DIR/setup"
        fi

        "$GITWS_DIR/setup/macos/setup.sh"
        ;;
    *)
        echo "Platform not yet supported."
        exit 1
        ;;
esac
