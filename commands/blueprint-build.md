---
description: Read a blueprint.md and execute it end-to-end to rebuild the project it describes
argument-hint: path-or-url to a blueprint.md (defaults to ./blueprint.md)
---

The user wants you to build a project from a **blueprint** — a single markdown file containing the full spec, file tree, file contents, build steps, and verification checks for a project. Your job is to execute it autonomously. The user is on a coffee break.

## Steps

1. **Resolve the blueprint source.**
   - If $ARGUMENTS is empty, default to `./blueprint.md` in the current working directory.
   - If $ARGUMENTS looks like a URL (`http://` or `https://`), fetch it with WebFetch.
   - If $ARGUMENTS is a filesystem path, read it.
   - If the file doesn't exist or can't be fetched, tell the user and stop.

2. **Read the blueprint in full.** Don't skim. Every section matters. Note the sections: spec (§0), layout (§1), file contents (§2), build steps (§3), verification (§4), handoff (§5).

3. **Confirm target directory.** Decide where the project will live:
   - If the blueprint names the project directory (e.g., "create `lunch-break/`"), create it as a subdirectory of the current cwd unless a directory with that name already exists and is non-empty — in that case ask the user first.
   - If unclear, use `./` (current directory) and warn the user.

4. **Execute the build steps in order.** For each step:
   - Run the commands literally (mkdir, file writes, chmod, git init, dependency install).
   - Write each file's content exactly as embedded in §2 — do not paraphrase, reformat, or "improve" the code. Preserve blank lines and trailing newlines.
   - If a command fails, diagnose and fix before moving on. Do not silently skip.

5. **Run the verification checks in §4.** Execute each check and record the result. For functional checks that require a running cc session (e.g., "type /foo and observe X"), perform them where possible; otherwise mark them as "manual — owner must verify" and list them in the handoff.

6. **If any check fails:** investigate, fix the offending file or step, and re-run the check. Don't declare done with failing checks.

7. **Report back** to the user with:
   - The target directory path
   - What was built (one-line summary from §0)
   - Which verification checks passed automatically
   - Which checks require manual verification (from step 5)
   - The handoff instructions from §5 (repo path, how to invoke, where data lives)
   - Anything in the blueprint that was ambiguous or required a judgment call, with the decision you made

## Rules

- **Do not improvise.** If the blueprint says "create 7 files", create exactly those 7. Don't add a LICENSE, .gitignore, or CI config unless the blueprint says to.
- **Do not substitute dependencies.** If the blueprint specifies a library version or tool, use it. If it's unavailable on this system, tell the user and stop — don't silently swap.
- **Do not skip verification.** The whole point is that the user can take a break and trust the result. If you skip checks, you break that trust.
- **Preserve file contents byte-for-byte.** Especially for markdown-in-markdown (frontmatter, embedded code fences), indentation and fence nesting matter. Check that the written file renders and parses the same as what's embedded in the blueprint.
- **Pause only if truly blocked.** Missing secrets, destructive ops on existing non-empty dirs, or ambiguous target paths are valid reasons to pause. "This design choice seems odd" is not — follow the blueprint.

## When done

End with a short summary: project name, path, command to invoke (if applicable), and any manual verification the user should do. Keep it under 10 lines. The user just got back from coffee — respect their time.

$ARGUMENTS
