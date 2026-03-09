---
name: compare-branches
description: Compare script outputs between two git branches. Uses worktrees to run scripts on both branches and checksums to detect differences.
workflow_stage: verification
compatibility:
  - codex
  - claude-code
version: 1.0.0
tags:
  - branch-comparison
  - verification
  - checksums
---

# Compare Branch Outputs

Compare script outputs between two branches to verify identical results.

## Arguments

- `base-branch`: Reference branch (e.g., `main`)
- `target-branch`: Branch with changes
- `dir-or-script`: Directory or script to compare

## Steps

### 1. Set up worktree for base branch

```bash
git worktree add /tmp/branch-compare-base <base-branch>
```

### 2. Run scripts on base branch

In the worktree, run via Make or directly. Record checksums of stable-format outputs (CSV, TSV, .tex).

### 3. Run scripts on current branch

Same execution. Record checksums.

### 4. Compare

```
## Branch Comparison: [base] vs [target]
| File | Base MD5 | Target MD5 | Status |
|------|----------|------------|--------|
```

For small CSVs (<1MB) that differ, show content diff.

### 5. Clean up

```bash
git worktree remove /tmp/branch-compare-base
```

## Important

- Follow verification format rules for which formats to checksum
- Always clean up worktree
- Do NOT modify files on either branch
