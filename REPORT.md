# Codex CLI Integration Report

## Summary

Added OpenAI Codex CLI support to the academic project template, mirroring the existing Claude Code workflow.

## New Files Created (16 total)

### Foundation (`.codex/`)
| File | Purpose |
|------|---------|
| `.codex/config.toml` | Project-level Codex config (model, sandbox, approval policy) |
| `.codex/rules/default.rules` | Starlark command execution permissions matching `.claude/settings.json` |

### AGENTS.md Hierarchy
| File | Size | Purpose |
|------|------|---------|
| `AGENTS.md` (root) | 15KB | Core instructions + all workflow rules (orchestrator, plan-first, quality gates, verification, session logging, command conventions, replication) |
| `code/AGENTS.md` | 9KB | R code conventions, Julia code conventions, Makefile conventions |
| `latex/AGENTS.md` | 3KB | LaTeX verification, Makefile pattern, dynamic numbers |

### Skills (`.agents/skills/`)
| Skill | Source | Adaptation |
|-------|--------|------------|
| `commit` | `.claude/skills/commit/` | Removed `allowed-tools`, `disable-model-invocation`. Added Codex frontmatter. |
| `data-analysis` | `.claude/skills/data-analysis/` | Removed Claude-specific references. Adapted review delegation to use `/review-r` skill instead of agent. |
| `review-r` | `.claude/skills/review-r/` + `.claude/agents/r-reviewer.md` | Full r-reviewer protocol inlined (10 review categories, report format, severity levels). |
| `review-julia` | `.claude/skills/review-julia/` + `.claude/agents/julia-reviewer.md` | Full julia-reviewer protocol inlined (12 review categories). |
| `review-tex` | `.claude/skills/review-tex/` + `.claude/agents/tex-reviewer.md` | Full tex-reviewer protocol inlined (Phase 1 detection + Phase 2 auto-fix). |
| `review-comments` | `.claude/skills/review-comments/` | Minimal adaptation. Already had cross-tool compatibility. |
| `review-pr` | `.claude/skills/review-pr/` | Adapted agent delegation to inline orchestrator mini-loop. |
| `matlab-optim-derivatives` | `.claude/skills/matlab-optim-derivatives/` | Minimal adaptation. Already had cross-tool compatibility. |

### Modified Files
| File | Change |
|------|--------|
| `.gitignore` | Added negation patterns to track `.codex/config.toml` and `.codex/rules/default.rules` while ignoring other `.codex/` state |
| `README.md` | Updated title, added Codex CLI Quick Start section, added comparison table, documented hook limitations, added Codex config to "What's Included" |
| `CLAUDE.md` | Added `.codex/` and `.agents/` to folder structure diagram |

## Architecture Decisions

1. **Hierarchical AGENTS.md**: Used Codex's directory-based merging to stay under 32KB. Root file has workflow rules; `code/AGENTS.md` has language conventions; `latex/AGENTS.md` has LaTeX conventions. Worst-case merge (working in `code/`): 15KB + 9KB = 24KB.

2. **Agent protocols inlined into skills**: Codex has no separate agent files. The r-reviewer, julia-reviewer, and tex-reviewer agent content was merged into the corresponding review skills, making each skill self-contained.

3. **No hooks**: Codex CLI has no hook system. This is documented as a known limitation in the README. Session logging discipline is emphasized in AGENTS.md instead.

4. **Starlark rules**: Permission patterns map 1:1 from Claude's glob format to Codex's `prefix_rule()` Starlark format. Environment variable prefixes (`TEXINPUTS=*`) are covered by the `bash` prefix rule.

## Verification Checklist

- [x] All 16 new files created
- [x] `.gitignore` negation works (`git add --dry-run` succeeds for `.codex/` files)
- [x] AGENTS.md files under 32KB (15KB, 9KB, 3KB)
- [x] No Claude-specific tool references in Codex files (grep for `EnterPlanMode`, `Task tool`, `allowed-tools`, `disable-model-invocation` = 0 matches)
- [x] README documents both tools with comparison table
- [x] Skills have proper Codex YAML frontmatter (name, description, workflow_stage, compatibility, version, tags)

## Review Request

Please review the following for correctness and completeness:

1. **`AGENTS.md` (root)**: Does the workflow rule content faithfully represent the Claude rules? Any missing sections?
2. **`code/AGENTS.md`**: Are R, Julia, and Makefile conventions complete and accurate?
3. **`.codex/rules/default.rules`**: Are the Starlark rules correct syntax? Any missing permissions?
4. **`.agents/skills/*/SKILL.md`**: Do the inlined agent protocols preserve all review categories? Is the YAML frontmatter correct?
5. **`README.md`**: Is the Codex section clear and accurate? Any misleading claims?
6. **`.gitignore`**: Is the negation pattern correct for both new and existing repos?
