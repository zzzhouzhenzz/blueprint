# blueprint

Two Claude Code slash commands for turning projects into reproducible build instructions — and back again.

## The idea

A **blueprint** is a single `blueprint.md` file that contains everything another cc session needs to rebuild a project from scratch: spec, file tree, full file contents, build steps, verification checks. You hand it to a fresh cc, say "follow this", and take a coffee break.

This plugin gives you the two sides of that workflow:

- `/blueprint-write` — point cc at the current project and it produces a `blueprint.md`.
- `/blueprint-build` — point cc at a `blueprint.md` (local path or URL) and it executes it end-to-end.

## Commands

```
/blueprint-write                 # write ./blueprint.md for the current project
/blueprint-write ./docs/bp.md    # custom output path

/blueprint-build                 # build from ./blueprint.md
/blueprint-build ./docs/bp.md    # from a path
/blueprint-build https://...     # from a URL (raw markdown)
```

## Blueprint shape

`/blueprint-write` emits this structure — and `/blueprint-build` expects it:

```
# Blueprint — build <project> from scratch

## 0. Product spec       (what it is, why, non-goals)
## 1. Repo layout        (ASCII tree of every file)
## 2. File contents      (each file's full content in a code fence)
## 3. Build steps        (ordered shell commands)
## 4. Verification       (structural / install / functional / edge checks)
## 5. Hand off to the user
```

Files are embedded verbatim, no placeholders — the whole point is reproducibility without the original repo.

## Install

```bash
git clone https://github.com/zzzhouzhenzz/blueprint.git ~/code/blueprint
~/code/blueprint/install.sh
```

Symlinks `commands/*.md` into `~/.claude/commands/` so `git pull` picks up updates.

Uninstall: `rm ~/.claude/commands/{blueprint-write,blueprint-build}.md`.

## Design notes

- Pure slash commands. No hooks, no MCP, no plugin wrapper, no namespace prefix in the palette.
- `/blueprint-build` runs verification after writing files; won't declare done with failing checks.
- Built to be boring: if a blueprint says "7 files", it makes exactly 7.
