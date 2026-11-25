#!/usr/bin/env bash
# Add a timestamped entry to today's journal log and open it for editing.
#
# Usage: journal-entry.sh [notes-dir]
#
# The notes folder is, in order of preference:
#   1. the first argument
#   2. $NOTES_HOME
# Entries go in <notes-dir>/log/YYYY-MM-DD.md under a "## HH:MM" heading.
#
# The editor is $JOURNAL_EDITOR, or nano if unset. nano (and vi/vim) are
# opened on the new entry's line; other editors just open the file.
set -euo pipefail

NOTES_DIR="${1:-${NOTES_HOME:-}}"
if [[ -z "$NOTES_DIR" ]]; then
    echo "Error: no notes folder. Pass one as an argument or set NOTES_HOME." >&2
    exit 1
fi
if [[ ! -d "$NOTES_DIR" ]]; then
    echo "Error: notes folder not found: $NOTES_DIR" >&2
    exit 1
fi

LOG_DIR="$NOTES_DIR/log"
mkdir -p "$LOG_DIR"

FILE="$LOG_DIR/$(date +%Y-%m-%d).md"
HEADER="## $(date +%H:%M)"

if [[ -f "$FILE" ]]; then
    printf '\n%s\n\n\n' "$HEADER" >> "$FILE"
else
    printf '%s\n\n\n' "$HEADER" > "$FILE"
fi

LAST_LINE="$(wc -l < "$FILE")"
EDITOR_CMD="${JOURNAL_EDITOR:-nano}"

case "$(basename "$EDITOR_CMD")" in
    nano|vi|vim|nvim) "$EDITOR_CMD" "+$LAST_LINE" "$FILE" ;;
    code)             "$EDITOR_CMD" --goto "$FILE:$LAST_LINE" ;;
    *)                "$EDITOR_CMD" "$FILE" ;;
esac
