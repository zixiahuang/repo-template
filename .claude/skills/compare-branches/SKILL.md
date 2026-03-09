---
name: compare-branches
description: Compare script outputs between two git branches. Uses worktrees to run scripts on both branches and checksums to detect differences.
disable-model-invocation: true
argument-hint: "[base-branch] [target-branch] [dir-or-script]"
allowed-tools: ["Bash", "Read", "Grep", "Glob", "Write"]
---

# Compare Branch Outputs

Compare script outputs between two branches to verify that changes produce identical results.

## Arguments

- `base-branch`: The reference branch (e.g., `main`)
- `target-branch`: The branch with changes (e.g., `feature/refactor`)
- `dir-or-script`: Directory or specific script to compare (e.g., `code/estimation/`)

## Steps

### 1. Parse arguments

Extract base branch, target branch, and target directory/script from `$ARGUMENTS`.

### 2. Set up worktree for base branch

```bash
git worktree add /tmp/branch-compare-base <base-branch>
```

### 3. Run scripts on base branch

In the worktree:
- If a Makefile exists in the target directory: `make -C <dir> all`
- Otherwise: run scripts directly

Record checksums of all stable-format outputs (CSV, TSV, .tex).

### 4. Run scripts on current branch

On the current branch (target):
- Same execution as step 3
- Record checksums

### 5. Compare

Print a comparison table:

```markdown
## Branch Comparison: [base] vs [target]
**Directory:** [dir-or-script]

| File | Base MD5 | Target MD5 | Status |
|------|----------|------------|--------|
| output/results.csv | abc123... | abc123... | MATCH |
| output/summary.csv | def456... | ghi789... | DIFFER |
```

For small CSVs (<1MB) that differ, show a content diff (first 30 lines).

### 6. Clean up

```bash
git worktree remove /tmp/branch-compare-base
```

### 7. Report

Present the comparison table and any diffs. Note:
- Total files compared
- Files that match
- Files that differ
- Files skipped (binary formats)

## Important

- Follow `verification-formats.md` for which formats to checksum
- Always clean up the worktree, even on failure
- Do NOT modify any files on either branch
- If scripts fail on either branch, report the error and continue with remaining scripts
