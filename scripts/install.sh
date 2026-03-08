#!/usr/bin/env bash
# Installs the ai-awesome/.claude repo into ~/.claude.

set -euo pipefail

CLAUDE_DIR="$HOME/.claude"
REPO_URL="git@github.com:ai-awesome/.claude.git"

# Fresh install: clone and exit.
if [ ! -d "$CLAUDE_DIR" ]; then
    git clone --recurse-submodules "$REPO_URL" "$CLAUDE_DIR"
    echo "Installed successfully into $CLAUDE_DIR"
    exit 0
fi

# Existing directory.
cd "$CLAUDE_DIR"

# If already a git repo with the correct remote, just pull.
if [ -d .git ]; then
    existing_remote=$(git remote get-url origin 2>/dev/null || true)
    if [ "$existing_remote" = "$REPO_URL" ]; then
        git pull
        git submodule update --init --recursive
        echo "Updated $CLAUDE_DIR from origin."
        exit 0
    fi
fi

# Initialize and fetch.
git init
git remote add origin "$REPO_URL"
git fetch origin

# Detect conflicting files and directories.
conflicting=()
while IFS= read -r tracked_file; do
    if [ -e "$tracked_file" ]; then
        conflicting+=("$tracked_file")
    fi
done < <(git ls-tree --name-only -r origin/main)

if [ ${#conflicting[@]} -gt 0 ]; then
    echo "The following local files conflict with the repository:"
    for f in "${conflicting[@]}"; do
        echo "  $f"
    done
    echo ""
    read -r -p "Back up conflicting files before installing? [Y/n] " answer
    answer="${answer:-Y}"

    backed_up=false
    if [[ "$answer" =~ ^[Yy]$ ]] || [ -z "$answer" ]; then
        for f in "${conflicting[@]}"; do
            mv "$f" "${f}.bak"
            echo "Backed up $f -> ${f}.bak"
        done
        backed_up=true
    else
        echo "Warning: existing files will be overwritten."
    fi
fi

git checkout -b main origin/main
git submodule update --init --recursive

echo "Installed successfully into $CLAUDE_DIR"
if [ "${backed_up:-false}" = true ]; then
    echo "Remember to merge your backed-up files back (*.bak)."
fi
