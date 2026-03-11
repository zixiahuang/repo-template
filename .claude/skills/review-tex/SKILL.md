---
name: review-tex
description: Run the LaTeX review protocol on manuscript and slides. Checks for hardcoded numbers, citation consistency, and compilation issues. Produces a report without editing files.
disable-model-invocation: true
argument-hint: "[filename or 'all']"
allowed-tools: ["Read", "Grep", "Glob", "Write", "Task"]
---

# Review LaTeX Files

Run the comprehensive LaTeX review protocol.

## Steps

1. **Identify files to review:**
   - If `$ARGUMENTS` is a specific `.tex` filename: review that file only
   - If `$ARGUMENTS` is `all`: review all `.tex` files in `latex/`

2. **For each file, launch the `tex-reviewer` agent** with instructions to:
   - Follow the full protocol in the agent instructions
   - Check for hardcoded numbers that should use `\input` from `output/numbers/`
   - Check citation consistency against `latex/references/references.bib`
   - Save report to `quality_reports/[FILENAME_WITHOUT_EXT]_tex_review.md`

3. **After all reviews complete**, present a summary:
   - Total issues found per file
   - Breakdown by severity (Critical / High / Medium / Low)
   - Top 3 most critical issues

4. **IMPORTANT: Do NOT edit any LaTeX source files.**
   Only produce reports. Fixes are applied after user review.
