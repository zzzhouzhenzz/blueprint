#!/usr/bin/env bash
# Install blueprint slash commands into ~/.claude/commands/
# Symlinks so `git pull` picks up updates automatically.
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)/commands"
DST="${HOME}/.claude/commands"
mkdir -p "$DST"

for f in "$SRC"/*.md; do
  name="$(basename "$f")"
  ln -sfv "$f" "$DST/$name"
done

echo
echo "Installed. In cc, try:  /blueprint-write   /blueprint-build"
