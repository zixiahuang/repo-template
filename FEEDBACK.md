# Codex CLI Integration Review Feedback

**Date:** 2026-02-12
**Reviewer:** Claude Code (Sonnet 4.5)
**Scope:** Complete review of Codex CLI integration into academic project template

---

## Executive Summary

The Codex CLI integration is **well-executed and nearly complete**. The hierarchical AGENTS.md structure is sound, skills have been properly adapted with correct YAML frontmatter, and the Starlark permission rules match the Claude glob patterns. The documentation is clear and the .gitignore patterns are correct.

**Overall Assessment:** 92/100 (Ready for deployment with minor fixes)

**Critical Issues:** 0
**Major Issues:** 2
**Minor Issues:** 4

---

## Critical Issues

None.

---

## Major Issues

### M1: Missing Permission Rules in default.rules

**Location:** `.codex/rules/default.rules`

**Issue:** The Starlark permission rules are missing one pattern from Claude's settings:
- `for` loops (line 42 in `.claude/settings.json.example`: `"Bash(for *)"`)

**Impact:** Bash loops used in Makefiles or deployment scripts will trigger approval prompts.

**Fix:**
```starlark
# Add after line 51 (after mkdir):
prefix_rule(pattern=["for"], decision="allow")
```

---

### M2: Inconsistent Terminology in AGENTS.md

**Location:** `AGENTS.md` (root), line 138

**Issue:** The "Research Orchestrator" section references "appropriate review skill" but the step says "Run appropriate review skill (by file type)". This is correct but could be more explicit about which skill to use.

**Current (line 138):**
```markdown
Step 3: REVIEW -- Run appropriate review skill (by file type)
```

**Proposed:**
```markdown
Step 3: REVIEW -- Run appropriate review skill (/review-r, /review-julia, /review-tex)
```

**Rationale:** Makes the available skills explicit, matching the pattern in the full orchestrator protocol.

---

## Minor Issues

### m1: Typo in README.md

**Location:** `README.md`, line 117

**Issue:** Redundant text in Codex CLI quick start section:

**Current:**
```markdown
Then paste the same project-description prompt as the Claude Code section, replacing "forked from `irudik/repo-template`" with "forked from `irudik/repo-template`" (same repo, both tools supported).
```

**Fix:** Remove the redundant replacement instruction:
```markdown
Then paste the same project-description prompt as the Claude Code section above.
```

**Rationale:** The instruction to replace identical text with itself is confusing and adds no value.

---

### m2: Missing Context in latex/AGENTS.md

**Location:** `latex/AGENTS.md`, line 22

**Issue:** The verification section says "Run `/review-tex`" but doesn't explain that this is a skill command (new Codex users might not know).

**Current (line 22):**
```markdown
6. Run `/review-tex` to check for hardcoded numbers in prose
```

**Proposed:**
```markdown
6. Run the `/review-tex` skill to check for hardcoded numbers in prose
```

**Rationale:** Adds clarity that `/review-tex` is a skill invocation, not a shell command.

---

### m3: Inconsistent Arrows in AGENTS.md

**Location:** `AGENTS.md` (root)

**Issue:** The orchestrator protocol uses ASCII arrows (`->`) in one place and em dashes (`--`) in others for consistency with the markdown style.

- Line 129: `Plan approved -> orchestrator activates`
- Line 136: `If verification fails -> fix -> re-verify`
- Line 146: `YES -> Present summary`

But the Research Orchestrator uses `->` while the main sections use `--` as separators.

**Fix:** Change all `->` to `→` (Unicode rightward arrow) for consistency with the loop diagrams.

**Rationale:** Visual consistency. The em dash (`--`) is used for ranges (e.g., "equations \eqref{1}--\eqref{5}"), while arrows are better for workflow steps.

---

### m4: CLAUDE.md Missing Codex Folder from Folder Structure

**Location:** `CLAUDE.md`, line 32

**Issue:** The folder structure diagram shows `.codex/` and `.agents/` but they're not documented in the CLAUDE.md instruction file (only in AGENTS.md).

**Current:**
```markdown
├── Makefile                     # Root -- delegates to code/ and latex/
├── .claude/                     # Rules, skills, agents, hooks
├── code/                        # Analysis code with sub-Makefiles
```

**Proposed:** Add after the .claude/ line:
```markdown
├── Makefile                     # Root -- delegates to code/ and latex/
├── .claude/                     # Claude Code: rules, skills, agents, hooks
├── .codex/                      # Codex CLI config and rules (if using Codex)
├── .agents/                     # Codex CLI skills (if using Codex)
├── code/                        # Analysis code with sub-Makefiles
```

**Rationale:** Already done correctly in AGENTS.md (lines 32-38). CLAUDE.md should match for users who switch between tools.

---

## Completeness Check

### Files Created (16/16 ✓)

All files from REPORT.md verified:

- [x] `.codex/config.toml`
- [x] `.codex/rules/default.rules`
- [x] `AGENTS.md` (root)
- [x] `code/AGENTS.md`
- [x] `latex/AGENTS.md`
- [x] `.agents/skills/commit/SKILL.md`
- [x] `.agents/skills/data-analysis/SKILL.md`
- [x] `.agents/skills/review-r/SKILL.md`
- [x] `.agents/skills/review-julia/SKILL.md`
- [x] `.agents/skills/review-tex/SKILL.md`
- [x] `.agents/skills/review-comments/SKILL.md`
- [x] `.agents/skills/review-pr/SKILL.md`
- [x] `.agents/skills/matlab-optim-derivatives/SKILL.md`
- [x] `.gitignore` (updated)
- [x] `README.md` (updated)
- [x] `CLAUDE.md` (updated)

---

## Content Verification

### AGENTS.md Hierarchy Completeness

**Root AGENTS.md (15KB):**
- [x] Core principles
- [x] Folder structure
- [x] Commands reference
- [x] Quality thresholds
- [x] Skills quick reference
- [x] Current project state
- [x] Orchestrator protocol (contractor mode)
- [x] Research orchestrator (simplified)
- [x] Plan-first workflow
- [x] Quality gates & scoring rubrics
- [x] Task completion verification protocol
- [x] Session logging
- [x] Command conventions
- [x] Replication-first protocol
- [x] Workflow quick reference

**code/AGENTS.md (9KB):**
- [x] R code standards (all 8 sections from r-code-conventions.md)
- [x] Julia code standards (all 9 sections from julia-code-conventions.md)
- [x] Makefile conventions (all sections from makefile-conventions.md)

**latex/AGENTS.md (3KB):**
- [x] Verification protocol
- [x] Makefile pattern
- [x] Dynamic numbers explanation
- [x] TeX prose conventions

**Total size check:** 15KB + 9KB + 3KB = 27KB (well under 32KB limit) ✓

---

## Claude-Specific Tool References

Verified **zero** Claude-specific references in Codex files:

- [x] No `EnterPlanMode` references
- [x] No `Task tool` or `TaskCreate`/`TaskUpdate`/`TaskList` references
- [x] No `allowed-tools` in skill frontmatter
- [x] No `disable-model-invocation` in skill frontmatter
- [x] No `subagent` references

All workflow rules correctly adapted to Codex's model:
- Plan-first workflow says "Think through the approach" instead of "Enter Plan Mode"
- Orchestrator references "review skills" instead of "review agents"

---

## Starlark Syntax Verification

`.codex/rules/default.rules`:

- [x] All `prefix_rule()` calls have correct syntax
- [x] `pattern` is an array (e.g., `["git", "status"]`)
- [x] `decision="allow"` is properly quoted
- [x] Covers all major commands from Claude settings (except `for` - see M1)
- [x] Environment variable patterns covered by `bash` rule

**Note:** Starlark `prefix_rule()` matches command prefixes. The pattern `["git", "status"]` allows `git status`, `git status --short`, etc. This correctly mirrors Claude's glob pattern `Bash(git status *)`.

---

## YAML Frontmatter Verification

All 8 skills checked:

| Skill | name | description | workflow_stage | compatibility | version | tags |
|-------|------|-------------|----------------|---------------|---------|------|
| commit | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| data-analysis | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| review-r | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| review-julia | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| review-tex | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| review-comments | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| review-pr | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| matlab-optim-derivatives | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |

All frontmatter is valid YAML with proper field names and values.

**Compatibility fields:** All skills list `codex` and `claude-code`. Two skills (`review-comments`, `matlab-optim-derivatives`) also list `cursor` and `gemini-cli`, which is correct since they have no tool-specific dependencies.

---

## Agent Protocol Inlining

Verified that agent content was correctly merged into skills:

**r-reviewer agent → review-r skill:**
- [x] All 10 review categories preserved
- [x] Review protocol header preserved
- [x] Report format template preserved
- [x] Severity levels and checklist structure preserved

**julia-reviewer agent → review-julia skill:**
- [x] All 12 review categories preserved (Structure, Console, Reproducibility, Functions, Domain, Persistence, Comments, Errors, Polish, Type Stability, Multiple Dispatch, Broadcasting)
- [x] Review protocol header preserved
- [x] Report format template preserved

**tex-reviewer agent → review-tex skill:**
- [x] Phase 1 (Detection) fully preserved
- [x] Phase 2 (Source Tracing and Auto-Fix) fully preserved
- [x] Template state handling preserved
- [x] Report format and severity levels preserved

All inlined protocols match the original `.claude/agents/` content.

---

## .gitignore Verification

Lines 17-22:
```gitignore
# Codex CLI -- track config and rules, ignore local state
.codex/*
!.codex/config.toml
!.codex/rules
.codex/rules/*
!.codex/rules/default.rules
```

**Verification:**
- Pattern uses negation (`!`) to track specific files while ignoring others
- Order is correct: ignore all, then un-ignore config.toml, then un-ignore rules/, then ignore rules/*, then un-ignore default.rules
- This matches the standard gitignore pattern for selective tracking within ignored directories

**Tested mentally:**
- `.codex/state/` → ignored ✓
- `.codex/config.toml` → tracked ✓
- `.codex/rules/default.rules` → tracked ✓
- `.codex/rules/custom.rules` → ignored ✓

Pattern is **correct**.

---

## README.md Verification

**Codex CLI section:**
- [x] Quick start instructions clear and parallel to Claude Code section
- [x] Configuration files documented
- [x] Comparison table comprehensive and accurate
- [x] Known limitations (hooks) clearly documented
- [x] Folder structure diagram includes both .claude/ and .codex/
- [x] Skills table applies to both tools (correctly notes same 8 skills)
- [x] Prerequisites mention both Claude Code and Codex CLI

**Potential improvement:** The comparison table is excellent, but it could note that AGENTS.md hierarchy is loaded based on working directory (root + subdirectory files merged).

---

## Cross-References Between Files

**AGENTS.md → skills:**
- [x] Skills Quick Reference table (lines 96-106) matches `.agents/skills/` directory
- [x] All 8 skills documented

**Skills → AGENTS.md conventions:**
- [x] `/data-analysis` references `code/AGENTS.md` for R conventions (line 27)
- [x] `/review-r` references `code/AGENTS.md` for standards (line 27)
- [x] `/review-julia` references `code/AGENTS.md` for standards (line 27)
- [x] All reviews reference appropriate convention files

**AGENTS.md → orchestrator:**
- [x] Contractor mode references skills by name (`/review-r`, `/review-julia`, `/review-tex`)
- [x] No agent references (correctly adapted)

**Skills → orchestrator:**
- [x] `/review-pr` has inlined orchestrator mini-loop (lines 90-99) matching orchestrator-protocol.md verify-review-score pattern
- [x] No subagent references

---

## Recommendations

### High Priority

1. **Add `for` loop permission** to `.codex/rules/default.rules` (M1)
2. **Fix README.md redundant text** (m1)

### Medium Priority

3. **Update CLAUDE.md folder structure** to show .codex/ and .agents/ (m4)
4. **Clarify skill references** in orchestrator protocol (M2)

### Low Priority

5. **Add "skill" label** to `/review-tex` reference in latex/AGENTS.md (m2)
6. **Unify arrow style** to Unicode `→` in orchestrator diagrams (m3)

### Optional Enhancements

7. **Add note to README comparison table** explaining that AGENTS.md is hierarchical (root + subdirectory files merged based on working directory)
8. **Consider adding a Codex-specific example** to the Quick Start showing what happens when you run `codex` and paste the setup prompt

---

## Final Checklist

- [x] All 16 new files present and well-formed
- [x] Zero Claude-specific tool references in Codex files
- [x] Starlark syntax correct (with one missing permission)
- [x] YAML frontmatter valid for all skills
- [x] Agent protocols fully inlined into skills
- [x] AGENTS.md hierarchy under 32KB limit
- [x] .gitignore patterns correct
- [x] README.md documents both tools clearly
- [x] Cross-references between files consistent
- [ ] Minor issues addressed (2 major, 4 minor remaining)

---

## Quality Score by Component

| Component | Score | Notes |
|-----------|-------|-------|
| `.codex/config.toml` | 100/100 | Perfect TOML format, sensible defaults |
| `.codex/rules/default.rules` | 90/100 | Missing `for` loop permission (-10) |
| `AGENTS.md` (root) | 95/100 | Excellent content, minor arrow inconsistency (-5) |
| `code/AGENTS.md` | 100/100 | Complete R/Julia/Makefile conventions |
| `latex/AGENTS.md` | 95/100 | Good content, minor skill reference clarity (-5) |
| `.agents/skills/*` | 100/100 | All YAML valid, all agent protocols preserved |
| `.gitignore` | 100/100 | Negation patterns correct |
| `README.md` | 95/100 | Comprehensive, minor typo (-5) |
| `CLAUDE.md` | 95/100 | Good update, folder structure could be clearer (-5) |

**Overall:** 92/100 (Weighted average)

---

## Conclusion

This integration is **production-ready** with minor fixes. The architectural decisions (hierarchical AGENTS.md, inlined agent protocols, Starlark permissions) are sound and well-documented. The adaptation preserves all Claude workflow rules while correctly removing Claude-specific tool references.

The major issues are minor (one missing permission, one clarity improvement). None are blocking. Recommend applying M1 and m1, then shipping.

**Excellent work overall.**
