---
name: refactor
description: Verify-refactor-verify loop for safe code style changes. Records baseline checksums, applies style-only transformations, then verifies identical output.
workflow_stage: implementation
compatibility:
  - codex
  - claude-code
version: 1.0.0
tags:
  - refactoring
  - verification
  - code-style
---

# Refactor Code (Verify-Refactor-Verify)

Safe refactoring with automatic output verification.

## Steps

### 1. Establish baseline

Run `/verify-outputs [target] baseline` to record output checksums before changes.

### 2. Read conventions

Read the applicable language convention rules:
- R: `.claude/rules/r-code-conventions.md` or R section of `code/AGENTS.md`
- Julia: `.claude/rules/julia-code-conventions.md` or Julia section of `code/AGENTS.md`
- MATLAB: `.claude/rules/matlab-code-conventions.md` or MATLAB section of `code/AGENTS.md`

Read the refactoring protocol (`.claude/rules/refactoring-protocol.md` or the Refactoring Protocol section of `AGENTS.md`).

### 3. Apply transformations

Apply ONLY approved transformations:
- Comment style (headers, borders, docstrings)
- Whitespace and indentation
- Variable grouping and section organization
- Adding missing documentation
- Language-specific style conventions

Do NOT change logic, tolerances, function signatures, or remove dead code.

### 4. Verify outputs

Run `/verify-outputs [target]` to compare against baseline.

### 5. Present results

- **Match:** Present diff, report "Refactoring verified: identical outputs"
- **Mismatch:** Revert ALL changes, report what broke

### 6. Review

Run the appropriate review skill (`/review-r`, `/review-julia`, `/review-matlab`).

## Important

- The ONLY acceptable outcome is identical output
- Dead code: flag, do NOT remove
- Revert everything on any output mismatch
