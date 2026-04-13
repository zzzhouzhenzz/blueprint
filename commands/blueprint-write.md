---
description: Analyze the current project and emit a self-contained blueprint.md another cc can execute to rebuild it
argument-hint: (optional: output path, defaults to ./blueprint.md)
---

The user wants a **blueprint** — a single markdown file that contains everything another Claude Code session would need to recreate the current project from scratch. Another cc should be able to open the blueprint, follow it end-to-end, and produce a functionally identical result without asking the user any clarifying questions.

Your deliverable is the blueprint file. Nothing else.

## Steps

1. **Understand the project.** Read the repo: `README.md`, top-level config (`package.json`, `pyproject.toml`, `Cargo.toml`, etc.), directory tree, entry points, and any existing docs. For small projects, read every source file. For large projects, identify the essential surface area (public API, commands, config files) and read those in full.

2. **Identify what the project *is*.** In one paragraph you could put at the top of the blueprint: the problem it solves, the core behavior, the non-goals. This is the spec section.

3. **Decide the build order.** What must exist first (directory scaffold, config files), what depends on what, what's pure boilerplate vs. non-obvious. The blueprint must list steps in an order that works linearly.

4. **Resolve output path.** If $ARGUMENTS is an absolute or relative path, use it. Otherwise default to `./blueprint.md` in the current working directory. If the target already exists, overwrite it (the user invoked this command on purpose).

5. **Write the blueprint** with the exact shape below. Be concrete. Another cc reading this will not have access to this conversation, this codebase, or you — it only has the blueprint. Err on the side of including more detail, especially exact file contents and verification checks.

```markdown
# Blueprint — build `<project-name>` from scratch

<One-paragraph intro telling the reader they are rebuilding <project-name>, that they should follow steps exactly, and should work autonomously.>

---

## 0. Product spec

<What the project is, the problem it solves, the core behavior users see, and explicit non-goals. Enough that a fresh cc understands the *why* before the *how*.>

---

## 1. Repo layout

<ASCII tree of the final project. Every file that must exist should appear here.>

---

## 2. File contents

<For each file in the tree, a subsection with the file's full content in a code fence. Use the language tag that matches the file type. If a file is generated or optional, mark it so. For embedded markdown-in-markdown, indent the inner fence four spaces so it renders correctly.>

### 2.1 `<path/to/file>`

\`\`\`<lang>
<exact file content>
\`\`\`

<repeat for every file>

---

## 3. Build steps

<Ordered, concrete commands. `mkdir`, create files, `chmod +x`, `git init`, dependency install, first build. Each step should be runnable without interpretation.>

---

## 4. Verification

<Explicit checks to run, grouped into: structural (files exist, perms right), install/build (commands succeed), functional (the thing actually works end-to-end), edge cases. Use checklists. Tell the reader not to ship with a failing check.>

---

## 5. Hand off to the user

<What to tell the user when done: repo path, how to invoke the thing, where data lives on disk, caveats.>
```

6. **Include the full content of every source file** in §2. Do not use placeholders like `<your code here>` or `// omitted for brevity`. If a file is long, include it anyway — the whole point is that another cc can rebuild without seeing the original.

7. **Include verification steps** in §4 that are specific to this project, not generic. If the project is a CLI, show expected output for a real invocation. If it's a library, show a minimal usage example that should work. If it has a UI, describe what the user should see.

8. **Confirm to the user** with the path of the generated blueprint and one sentence: "Share this with another cc using `/blueprint-build <path>` (or paste the contents and say 'follow this blueprint')."

## Rules

- Do not invent features that aren't in the current project.
- Do not summarize or abridge file contents — embed them verbatim.
- Do not assume the target cc has context you have. Write as if it has never seen the repo.
- If something in the project is genuinely non-obvious (a workaround, a subtle invariant), add a short note explaining *why* so the rebuilder doesn't "fix" it.
- If you can't determine something (e.g., a secret, an external API key), mark it clearly as a placeholder the user must fill in — don't guess.

$ARGUMENTS
