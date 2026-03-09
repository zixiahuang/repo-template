---
name: review-matlab
description: Run the MATLAB code review protocol on MATLAB scripts. Checks code quality, solver configuration, derivative correctness, and optimization patterns. Produces a report without editing files.
disable-model-invocation: true
argument-hint: "[filename or 'all']"
allowed-tools: ["Read", "Grep", "Glob", "Write", "Task"]
---

# Review MATLAB Scripts

Run the comprehensive MATLAB code review protocol.

## Steps

1. **Identify scripts to review:**
   - If `$ARGUMENTS` is a specific `.m` filename: review that file only
   - If `$ARGUMENTS` is `all`: review all MATLAB scripts in `code/` (exclude `code/unit_tests/` and `code/hpc/`)

2. **For each script, launch the `matlab-reviewer` agent** with instructions to:
   - Follow the full protocol in the agent instructions
   - Read `.claude/rules/matlab-code-conventions.md` for current standards
   - Save report to `quality_reports/[script_name]_matlab_review.md`

3. **After all reviews complete**, present a summary:
   - Total issues found per script
   - Breakdown by severity (Critical / High / Medium / Low)
   - Top 3 most critical issues

4. **IMPORTANT: Do NOT edit any MATLAB source files.**
   Only produce reports. Fixes are applied after user review.
