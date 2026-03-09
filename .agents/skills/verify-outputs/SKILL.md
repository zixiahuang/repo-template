---
name: verify-outputs
description: Checksum script outputs before and after changes. Establishes baseline checksums, re-runs scripts, and compares to detect regressions. Uses CSV as the gold standard.
workflow_stage: verification
compatibility:
  - codex
  - claude-code
version: 1.0.0
tags:
  - verification
  - checksums
  - regression-testing
---

# Verify Script Outputs

Checksum-based verification of script outputs for detecting regressions.

## Steps

### 1. Identify targets

- If argument is a script path: verify outputs from that script
- If argument is a directory: verify all scripts in that directory
- If argument is `baseline`: record baseline checksums only (no comparison)

### 2. Discover output paths

Scan target script(s) for output write calls:

- **R:** `write.csv`, `write_csv`, `saveRDS`, `ggsave`, `writeLines` (to `output/`)
- **Julia:** `CSV.write`, `jldsave`, `savefig`, `open(..., "w")`
- **MATLAB:** `writetable`, `writematrix`, `save`, `saveas`

Also check Makefile targets if a Makefile exists in the directory.

### 3. Record or compare checksums

**Baseline mode** (no prior checksums):
1. Run via `make` (preferred) or direct execution
2. Checksum stable-format outputs: CSV, TSV, .tex (generated)
3. Skip: RDS, .mat, PDF, PNG (not checksum-stable)
4. Store in `.checksums.json` alongside outputs

**Comparison mode** (prior checksums exist):
1. Run scripts
2. Checksum outputs
3. Compare against `.checksums.json`
4. Print pass/fail table

### 4. Report

```
## Output Verification: [script or directory]
| File | Format | Status | Notes |
|------|--------|--------|-------|
| output/tables/results.csv | CSV | PASS | MD5 match |
| output/figures/plot.pdf | PDF | SKIP | Not checksum-stable |
```

### 5. On failure

Report mismatches with brief CSV diffs. Do NOT attempt fixes.

## Important

- CSV is the gold standard for checksums
- Binary formats are skipped
- Store `.checksums.json` alongside outputs (gitignored)
