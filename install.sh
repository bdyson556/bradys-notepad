#!/usr/bin/env bash
# Install the journal tool for the current user.
#
#   1. Copies the process-log skill into ~/.claude/skills/ so Claude Code can
#      use it in every project. Re-run this script after pulling updates.
#   2. Prints the shell lines to add to your ~/.bashrc (or equivalent).
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills"

chmod +x "$REPO_DIR/bin/journal-entry.sh"

mkdir -p "$SKILLS_DIR"
rm -rf "$SKILLS_DIR/process-log"
cp -r "$REPO_DIR/skills/process-log" "$SKILLS_DIR/process-log"
echo "Installed skill: $SKILLS_DIR/process-log"

cat <<EOF

Add these lines to ~/.bashrc if they aren't there yet, then run: source ~/.bashrc

  export NOTES_HOME="/path/to/your/notes"      # folder that holds log/
  export JOURNAL_EDITOR="nano"                 # optional; nano is the default
  alias j="$REPO_DIR/bin/journal-entry.sh"

To start a new notes folder, copy templates/notes-CLAUDE.md into it as CLAUDE.md.
EOF
