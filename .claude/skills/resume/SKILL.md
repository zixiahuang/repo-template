---
name: resume
description: Recover context after compression or a new session. Reads MEMORY.md, recent plans, session logs, and git state to reconstruct working context.
disable-model-invocation: true
argument-hint: ""
allowed-tools: ["Bash", "Read", "Grep", "Glob"]
---

# Resume Session Context

Recover context after context compression or starting a new session.

## Steps

### 1. Read persistent context

1. Read `MEMORY.md` for `[LEARN]` entries and project state
2. Read `CLAUDE.md` (or `AGENTS.md`) for project instructions

### 2. Find most recent plan

1. List files in `quality_reports/plans/` sorted by date
2. Read the most recent plan file
3. Note its status (DRAFT / APPROVED / COMPLETED)

### 3. Find most recent session log

1. List files in `quality_reports/session_logs/` sorted by date
2. Read the most recent session log
3. Note last completed step and any open questions

### 4. Check git state

Run:
```bash
git log --oneline -10
git diff --stat
git status
git branch --show-current
```

### 5. Present structured summary

```markdown
## Session Recovery

**Current branch:** [branch name]
**Current task:** [from plan/session log]
**Plan status:** [DRAFT/APPROVED/COMPLETED] -- [plan file path]
**Last completed step:** [from session log]
**Next step:** [inferred from plan + session log]

### Uncommitted changes
[git diff --stat output, or "None"]

### Recent commits
[git log --oneline -5]

### Open questions / blockers
[from session log, or "None noted"]
```

### 6. Ask for confirmation

After presenting the summary, ask: "Is this correct? Should I continue with [next step]?"

## Important

- This skill is read-only -- it does not modify any files
- If no plan or session log exists, say so explicitly
- If the git state suggests work in progress (uncommitted changes), highlight this
