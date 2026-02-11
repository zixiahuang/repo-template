---
paths:
  - "**/*.jl"
  - "code/**/*.R"
  - "code/**/*.jl"
  - "code/**/Makefile"
  - "latex/**/*.tex"
---

# Research Project Orchestrator (Simplified)

**For R/Julia scripts, simulations, and data analysis** -- use this simplified loop instead of the full multi-agent orchestrator.

## The Simple Loop

```
Plan approved → orchestrator activates
  │
  Step 1: IMPLEMENT — Execute plan steps
  │
  Step 2: VERIFY — Run `make -n` to check staleness; build stale targets
  │         If Makefile exists: `make -C code/[dir] [target]` or `make -C latex`
  │         Otherwise: `Rscript` / `julia` / `pdflatex` directly
  │         R scripts: runs without error, outputs created
  │         Julia scripts: runs without error, CSV/JLD2 created
  │         Simulations: set.seed / Random.seed! reproducibility
  │         Plots: PDF/PNG created, correct format
  │         If verification fails → fix → re-verify
  │
  Step 3: SCORE — Apply quality-gates rubric
  │
  └── Score >= 80?
        YES → Done (commit when user signals)
        NO  → Fix blocking issues, re-verify, re-score
```

**No 5-round loops. No multi-agent reviews. Just: write, test, done.**

## Verification Checklist

- [ ] `make -n` shows no stale targets (or targets rebuilt successfully)
- [ ] Script runs without errors (R and/or Julia)
- [ ] All packages loaded at top (R: `library()`, Julia: top-level `using`)
- [ ] No hardcoded absolute paths
- [ ] `set.seed()` / `Random.seed!()` once at top if stochastic
- [ ] Output files created at expected paths
- [ ] Tolerance checks pass (if applicable)
- [ ] No hardcoded computed results in manuscript prose (tex-reviewer)
- [ ] Quality score >= 80
