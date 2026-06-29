# Empirical Economics Workflow Template

Status: APPROVED

## Approach

Refocus the documentation and agent instructions from a general academic
AI-assisted template into an empirical economics workflow template. Keep
advanced Claude/Codex configuration intact and avoid changing `.codex/`,
`.agents/`, or other tool configuration directories.

## Files To Modify

- `README.md`: describe the repo as an empirical economics workflow centered on
  Make, R, Stata, reproducible data cleaning, sample construction, estimation,
  robustness checks, tables, figures, and dynamic manuscript numbers.
- `AGENTS.md`: keep this file focused on workflow rules for AI agents and point
  agents to the actual `knowledge/` files before non-trivial tasks.
- `code/AGENTS.md`: keep language, path, and Makefile conventions here, with
  R/Stata/Makefile as the default empirical workflow and Julia/MATLAB as
  optional support.
- `knowledge/README.md`, `knowledge/project.md`, `knowledge/findings.md`:
  normalize the knowledge folder as the home for project-specific empirical
  context and cumulative findings.

## Verification

- Search for stale required references to nonexistent knowledge files.
- Search for overly broad general-template phrasing that conflicts with the
  empirical economics framing.
- Run `make -n` from the repo root to confirm documentation edits did not
  disturb the build graph.

## Notes

- This pass updates documentation and agent instructions only.
- It does not restructure code directories or create empirical task folders.
- It does not modify `.codex/`, `.agents/`, or advanced Claude/Codex
  configuration files.
