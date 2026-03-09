---
name: review-makefile
description: Run the Makefile review protocol. Checks conventions, dependency correctness, script coverage, and build system quality. Produces a report without editing files.
disable-model-invocation: true
argument-hint: "[path/to/Makefile or 'all']"
allowed-tools: ["Read", "Grep", "Glob", "Write", "Task"]
---

# Review Makefiles

Run the comprehensive Makefile review protocol.

## Steps

1. **Identify Makefiles to review:**
   - If `$ARGUMENTS` is a specific Makefile path: review that file only
   - If `$ARGUMENTS` is `all`: review all Makefiles in the project (root, `code/`, `code/*/`, `latex/`)

2. **For each Makefile, launch the `makefile-reviewer` agent** with instructions to:
   - Follow the full protocol in the agent instructions
   - Read `.claude/rules/makefile-conventions.md` for current standards
   - Scan all scripts in the same directory for coverage checking
   - Save report to `quality_reports/[dir_name]_makefile_review.md`

3. **After all reviews complete**, present a summary:
   - Total issues found per Makefile
   - Breakdown by severity (Critical / High / Medium / Low)
   - Orphaned scripts (scripts with no Makefile target)

4. **IMPORTANT: Do NOT edit any Makefiles.**
   Only produce reports. Fixes are applied after user review.
