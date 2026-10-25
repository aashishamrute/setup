#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

inject_managed_block() {
    local src="$1"
    local dest="$2"
    local begin="# >>> setup repo managed >>>"
    local end="# <<< setup repo managed <<<"

    touch "$dest"

    local tmp
    tmp="$(mktemp)"

    if grep -qF "$begin" "$dest"; then
        awk -v b="$begin" -v e="$end" '
            $0 == b { skip=1; next }
            $0 == e { skip=0; next }
            !skip { print }
        ' "$dest" > "$tmp"
        cp "$tmp" "$dest"
        echo "Replacing managed block in $dest"
    fi
    rm -f "$tmp"

    {
        [[ -s "$dest" ]] && echo ""
        echo "$begin"
        printf '[ -f "%s" ] && source "%s"\n' "$src" "$src"
        echo "$end"
    } >> "$dest"
    echo "Managed block injected into $dest"
}

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

FZF_GIT_DIR="$HOME/personal/tool/fzf-git.sh"
if [[ ! -d "$FZF_GIT_DIR" ]]; then
    echo "Cloning fzf-git.sh..."
    mkdir -p "$(dirname "$FZF_GIT_DIR")"
    git clone https://github.com/junegunn/fzf-git.sh.git "$FZF_GIT_DIR"
else
    echo "fzf-git.sh is already installed."
fi

inject_managed_block "$REPO_DIR/dotfiles/zshrc" "$HOME/.zshrc"
