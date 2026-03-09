---
name: setup-makefile
description: Generate a Makefile for a code directory by scanning scripts for output paths and building dependency rules.
workflow_stage: implementation
compatibility:
  - codex
  - claude-code
version: 1.0.0
tags:
  - makefile
  - build-system
  - code-generation
---

# Generate Makefile from Directory Contents

Scan a directory for scripts and generate a Makefile following project conventions.

## Steps

### 1. Scan directory

Glob for `.R`, `.jl`, `.m` files.

### 2. Parse output paths

For each script, scan for write calls:
- **R:** `write.csv`, `write_csv`, `saveRDS`, `ggsave`, `writeLines`
- **Julia:** `CSV.write`, `jldsave`, `savefig`, `open(..., "w")`
- **MATLAB:** `writetable`, `writematrix`, `save`, `saveas`

Also scan for input paths to determine dependencies.

### 3. Generate Makefile

Follow Makefile conventions (from `code/AGENTS.md` or `.claude/rules/makefile-conventions.md`):
- `all` as default target with `.PHONY`
- Order-only prerequisites for directories
- Automatic variables (`$<`, `$@`)
- Joint production for multi-output scripts
- `.PRECIOUS` for expensive intermediates
- `clean` target

### 4. Present for review

Do NOT write directly. Present content and ask for approval.

### 5. Write after approval

Write the Makefile and update parent `code/Makefile` delegation if applicable.

## Important

- Always present for review before writing
- Follow Makefile conventions exactly
- Flag scripts whose outputs cannot be reliably parsed
