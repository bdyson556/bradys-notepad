---
name: process-log
description: Process a journal log (a notes folder with log/YYYY-MM-DD.md daily entries) into structured records of people, organizations, initiatives, places, relationships, and tasks, each fact sourced to its log entry. Use when the user asks to "process the log", "harvest the journal", "update my notes from the log", or asks follow-up, trip-prep, introduction, or lead questions answered from those records.
---

# Process a journal log

A notes folder holds a daily log of rough notes and the records kept up to date from it. This skill describes the generic format and how to process it. **The notes folder's own `CLAUDE.md` takes precedence**: it may add entity types, fields, or enum values, route some facts to other places in its project, and add privacy rules. Read it before doing anything else.

## Finding the notes folder

Use the folder the user names. Otherwise use `$NOTES_HOME` (check it with `echo "$NOTES_HOME"`). Otherwise look for a folder in the current project that contains a `log/` folder of `YYYY-MM-DD.md` files. If more than one fits, ask which one.

## Files

- `log/YYYY-MM-DD.md`: the raw record, one file per day, in the user's own words, newest entry at the bottom. Each entry starts with a `## HH:MM` heading, optionally followed by a short title (`## 16:51 - Spencer office visit`). **Never rewrite past entries.** A correction is added as a new entry.
- `people.json`, `organizations.json`, `initiatives.json`, `places.json`: one record per entity, kept up to date from the log.
- `relationships.json`: links between entities.
- `TASKS.md` (optional): a to-do list, one checkbox item per task, each with a pointer to the log entry it came from.

Create any of these files the first time it's needed. Start entity files as `{}`, `relationships.json` as `[]`.

## Processing the log

1. Read the notes folder's `CLAUDE.md`.
2. Work out what's new. Find the most recent `sources` pointer across the JSON files and `TASKS.md`. Every log entry after it is unprocessed. If nothing has been processed yet, start from the first log file. Tell the user which range you're processing.
3. For each entry, update the records. Every changed fact gets a `source` pointer to its entry: the day's file plus the entry's time, e.g. `log/2026-10-08.md#16:51`. An entry with no time heading points to the file alone (`log/2026-10-08.md`). **Never add a fact without a source.**
4. Add follow-ups and to-dos to `TASKS.md` if the folder uses one, each with its log pointer. Add progress on an existing task as an indented sub-item with its own pointer. Don't duplicate a task that's already there.
5. When an entry is unclear, for example a first name that could be either of two people, **ask instead of guessing.**
6. Finish with a short summary: records created, records changed, tasks added, and anything you skipped or need answered.

## IDs

- IDs are `<type>:<slug>`, lowercase with hyphens: `person:jane-doe`, `org:county-sart`, `init:clinic-expansion`, `place:clay-co`.
- An ID never changes after it is created, even if the name does. Change the `name` field instead.
- Records point to other records only by ID. Before creating a new record, search for an existing one under another name or spelling.

## Schemas

Each entity file is an object keyed by ID. Use `""`, `null`, or `[]` for unknown values instead of leaving keys out. Every record has `notes` (free text) and `sources` (log pointers). The notes folder's `CLAUDE.md` may add fields or replace the enum lists below.

**people.json**
```json
"person:jane-doe": {
  "name": "", "title": "", "org": "",
  "contact": { "email": "", "phone": "" },
  "places": [], "interests": [], "how_met": "",
  "last_contact": "", "follow_up": { "date": "", "about": "" },
  "notes": "", "sources": []
}
```
- `interests`: what this person cares about or is working on. Use it to suggest what to bring up next time.
- `contact`: work contact details. When sources disagree on a name, email, phone or role, don't ask and don't resolve it. Record each value and who gave it in `notes`, and put a value in `contact` only if most sources agree on it.
- `follow_up.date` is empty when nothing is pending.

**organizations.json**
```json
"org:county-sart": {
  "name": "", "type": "", "places": [], "relationship": "",
  "agreements": [], "notes": "", "sources": []
}
```
- `type` default list: `law_enforcement`, `prosecution`, `court`, `medical`, `school`, `government`, `coalition`, `nonprofit`, `faith`, `business`, `funder`, `other`.
- `agreements`: MOUs and other formal arrangements, as short descriptions with dates. Point to the source document if one exists.

**initiatives.json**
```json
"init:clinic-expansion": {
  "name": "", "status": "idea", "lead": "", "places": [],
  "summary": "", "needs": [], "possible_funders": [],
  "notes": "", "sources": []
}
```
- `status` is one of: `idea`, `planning`, `active`, `paused`, `done`.
- `needs`: gaps that funding or partners could fill. These are where leads come from.

**places.json**
```json
"place:clay-co": {
  "name": "", "kind": "county", "presence": "",
  "day_to_day": "", "notes": "", "sources": []
}
```
- `kind` default list: `county`, `city`, `office`, `region`, `other`.
- `presence`: the user's organization's footprint there. `day_to_day`: what actually happens there.

**relationships.json** is an array of links:
```json
{ "from": "person:jane-doe", "to": "org:county-sart", "type": "member_of",
  "since": "", "strength": "active", "context": "", "sources": [] }
```
- `type` is one of: `member_of`, `works_with`, `knows`, `leads`, `partners_with`, `funds`, `refers_to`, `serves`. Add a new type to the notes folder's `CLAUDE.md` before using it.
- `strength` is one of: `strong`, `active`, `occasional`, `dormant`, `unknown`.
- Where a person works is the `org` field on their record and isn't repeated here.

## Typical questions

- **Follow-ups:** due or overdue `follow_up.date` values, plus people whose `last_contact` is over 60 days old and who have a `strong` or `active` link to a current initiative. Suggest what to talk about based on `interests` and recent log entries.
- **Trip prep:** for a place, the people, organizations, and initiatives connected to it.
- **Introductions:** paths through `relationships.json` from the user to a target person or organization.
- **Leads:** initiatives whose `needs` match open opportunities.

## Rules that always apply

- **Colleagues and contacts:** record professional facts only: role, connections, interests, and work. No opinions, personal matters, or anything you wouldn't want the person to read.
- If a note contains information the notes folder's `CLAUDE.md` says to keep out, flag it to the user and leave it out of the records.
- Notes folders are private. Never commit one to a shared repository, and never copy its contents into the journal tool's own repo.
