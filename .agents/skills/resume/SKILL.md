---
name: resume
description: Recover context after compression or a new session. Reads MEMORY.md, recent plans, session logs, and git state to reconstruct working context.
workflow_stage: planning
compatibility:
  - codex
  - claude-code
version: 1.0.0
tags:
  - context-recovery
  - session-management
---

# Resume Session Context

Recover context after context compression or starting a new session.

## Steps

### 1. Read persistent context

1. Read `MEMORY.md` for `[LEARN]` entries and project state
2. Read `AGENTS.md` (or `CLAUDE.md`) for project instructions

### 2. Find most recent plan

1. List files in `quality_reports/plans/` sorted by date
2. Read the most recent plan file
3. Note its status (DRAFT / APPROVED / COMPLETED)

### 3. Find most recent session log

1. List files in `quality_reports/session_logs/` sorted by date
2. Read the most recent session log

### 4. Check git state

```bash
git log --oneline -10
git diff --stat
git status
git branch --show-current
```

### 5. Present structured summary

```
## Session Recovery

**Current branch:** [branch name]
**Current task:** [from plan/session log]
**Plan status:** [status] -- [file path]
**Last completed step:** [from session log]
**Next step:** [inferred]

### Uncommitted changes
[output or "None"]

### Recent commits
[git log]

### Open questions / blockers
[from session log or "None noted"]
```

### 6. Confirm

Ask: "Is this correct? Should I continue with [next step]?"

## Important

- Read-only -- does not modify files
- If no plan/session log exists, say so explicitly
