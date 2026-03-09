---
name: refactor
description: Verify-refactor-verify loop for safe code style changes. Records baseline checksums, applies style-only transformations, then verifies identical output.
disable-model-invocation: true
argument-hint: "[file or directory]"
allowed-tools: ["Bash", "Read", "Grep", "Glob", "Write", "Edit", "Task"]
---

# Refactor Code (Verify-Refactor-Verify)

Safe refactoring with automatic output verification.

## Steps

### 1. Establish baseline

Call `/verify-outputs $ARGUMENTS baseline` to record output checksums before changes.

If the script has no checksum-stable outputs (only PDFs, .mat files, etc.), warn the user that verification will be limited.

### 2. Read conventions

Read the applicable language convention rules:
- R: `.claude/rules/r-code-conventions.md`
- Julia: `.claude/rules/julia-code-conventions.md`
- MATLAB: `.claude/rules/matlab-code-conventions.md`

Read `.claude/rules/refactoring-protocol.md` for constraints.

### 3. Apply transformations

Apply ONLY approved transformations from `refactoring-protocol.md`:
- Comment style (headers, borders, docstrings)
- Whitespace and indentation
- Variable grouping and section organization
- Adding missing documentation
- Language-specific style conventions

Do NOT:
- Change algorithm logic or control flow
- Rename function parameters or return values
- Modify solver configuration or tolerances
- Remove dead code (flag it instead)
- Change data types or precision

### 4. Verify outputs

Call `/verify-outputs $ARGUMENTS` to compare against baseline checksums.

### 5. Present results

**If all checksums match:**
- Present the diff of changes made
- Report "Refactoring verified: identical outputs"

**If any checksum mismatches:**
- Immediately revert ALL changes: `git checkout -- [files]`
- Report which outputs changed
- Report "Refactoring reverted: output mismatch detected"
- Do NOT attempt to fix the mismatch

### 6. Review

After successful verification, run the appropriate review skill:
- R: `/review-r`
- Julia: `/review-julia`
- MATLAB: `/review-matlab`

Present review summary alongside the refactoring diff.

## Important

- The ONLY acceptable outcome is identical output
- When in doubt about a transformation, skip it
- Dead code: flag in section headers, do NOT remove
- Revert everything on any output mismatch
