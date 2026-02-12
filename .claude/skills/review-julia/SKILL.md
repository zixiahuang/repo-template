---
name: review-julia
description: Run the Julia code review protocol on Julia scripts. Checks code quality, type stability, performance, and professional standards. Produces a report without editing files.
disable-model-invocation: true
argument-hint: "[filename or 'all']"
allowed-tools: ["Read", "Grep", "Glob", "Write", "Task"]
---

# Review Julia Scripts

Run the comprehensive Julia code review protocol.

## Steps

1. **Identify scripts to review:**
   - If `$ARGUMENTS` is a specific `.jl` filename: review that file only
   - If `$ARGUMENTS` is `all`: review all Julia scripts in `code/`

2. **For each script, launch the `julia-reviewer` agent** with instructions to:
   - Follow the full protocol in the agent instructions
   - Read `.claude/rules/julia-code-conventions.md` for current standards
   - Save report to `quality_reports/[script_name]_julia_review.md`

3. **After all reviews complete**, present a summary:
   - Total issues found per script
   - Breakdown by severity (Critical / High / Medium / Low)
   - Top 3 most critical issues

4. **IMPORTANT: Do NOT edit any Julia source files.**
   Only produce reports. Fixes are applied after user review.
