---
name: verify-outputs
description: Checksum script outputs before and after changes. Establishes baseline checksums, re-runs scripts, and compares to detect regressions. Uses CSV as the gold standard.
disable-model-invocation: true
argument-hint: "[script-path, dir, or 'baseline']"
allowed-tools: ["Bash", "Read", "Grep", "Glob", "Write"]
---

# Verify Script Outputs

Checksum-based verification of script outputs for detecting regressions.

## Steps

### 1. Identify targets

- If `$ARGUMENTS` is a script path: verify outputs from that script
- If `$ARGUMENTS` is a directory: verify all scripts in that directory
- If `$ARGUMENTS` is `baseline`: record baseline checksums only (no comparison)

### 2. Discover output paths

Scan target script(s) for output write calls:

- **R:** `write.csv`, `write_csv`, `saveRDS`, `ggsave`, `writeLines` (to `output/`)
- **Julia:** `CSV.write`, `jldsave`, `savefig`, `open(..., "w")`
- **MATLAB:** `writetable`, `writematrix`, `save`, `saveas`

Also check Makefile targets if a Makefile exists in the directory.

### 3. Record or compare checksums

**Baseline mode** (`baseline` argument or no prior checksums):
1. Run the script(s) via `make` (preferred) or direct execution
2. Checksum all stable-format outputs per `verification-formats.md`:
   - **Checksum:** CSV, TSV, .tex (generated)
   - **Skip:** RDS, .mat, PDF, PNG (not checksum-stable)
3. Store checksums in `.checksums.json` in the output directory

**Comparison mode** (prior checksums exist):
1. Run the script(s)
2. Checksum outputs
3. Compare against stored `.checksums.json`
4. Print pass/fail table

### 4. Report

```
## Output Verification: [script or directory]
| File | Format | Status | Notes |
|------|--------|--------|-------|
| output/tables/results.csv | CSV | PASS | MD5 match |
| output/figures/plot.pdf | PDF | SKIP | Not checksum-stable |
| output/tables/summary.csv | CSV | FAIL | MD5 mismatch |
```

### 5. On failure

If any CSV/TSV/.tex checksum mismatches:
- Report which files changed
- Show a brief `diff` of the changed CSV files (first 20 lines)
- Do NOT attempt to fix -- report only

## Important

- Follow `verification-formats.md` for which formats to checksum
- CSV is the gold standard -- binary formats are skipped
- Store `.checksums.json` alongside outputs (gitignored)
