# journal

A plain-text work journal plus a Claude Code skill that turns it into structured, sourced records.

- **Write:** `j` opens today's log file (`log/YYYY-MM-DD.md`) in your notes folder with a new `## HH:MM` heading, ready to type.
- **Process:** ask Claude Code to "process the log". The `process-log` skill reads the new entries and updates `people.json`, `organizations.json`, `initiatives.json`, `places.json`, `relationships.json` and `TASKS.md`. Every fact points back to the log entry it came from.
- **Ask:** who to follow up with, who to see on a trip to a given place, how to get an introduction, which initiatives need funding or partners.

This repo holds only the tool. **Notes never go in it.** Each notes folder lives with its own project (or anywhere), stays out of version control, and is backed up separately.

## Install

```bash
git clone <this repo> ~/journal      # or wherever you keep tools
~/journal/install.sh
```

`install.sh` copies the skill into `~/.claude/skills/process-log/` and prints the lines to add to `~/.bashrc`:

```bash
export NOTES_HOME="/path/to/your/notes"
export JOURNAL_EDITOR="nano"          # optional; nano is the default
alias j="$HOME/journal/bin/journal-entry.sh"
```

Requires Bash (Git Bash on Windows) and an editor. After pulling updates, run `install.sh` again to refresh the installed skill.

## Start a notes folder

1. Make the folder and point `NOTES_HOME` at it, or pass it to the script: `journal-entry.sh /path/to/notes`.
2. Copy `templates/notes-CLAUDE.md` into it as `CLAUDE.md` and fill in what's specific to that project: extra fields, where some facts belong instead, and what must never be recorded.
3. If the folder sits inside a Git repo, add it to that repo's `.gitignore`.

## Layout

```
bin/journal-entry.sh             entry script
skills/process-log/SKILL.md      generic processing rules and schemas
templates/notes-CLAUDE.md        starter file for a new notes folder
install.sh                       installer
```

## Editors

`JOURNAL_EDITOR` picks the editor. `nano`, `vi`, `vim` and `nvim` open on the new entry's line, `code` uses `--goto`, and anything else just opens the file. The script deliberately ignores `EDITOR`, so a GUI default such as VS Code doesn't take over terminal journaling.
