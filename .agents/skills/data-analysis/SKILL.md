---
name: data-analysis
description: End-to-end R data analysis workflow from exploration through regression to publication-ready tables and figures
workflow_stage: analysis
compatibility:
  - codex
  - claude-code
version: 1.0.0
tags:
  - R
  - data-analysis
  - regression
  - figures
  - tables
---

# Data Analysis Workflow

Run an end-to-end data analysis in R: load, explore, analyze, and produce publication-ready output.

**Input:** A dataset path (e.g., `data/county_panel.csv`) or a description of the analysis goal.

---

## Constraints

- **Follow R code conventions** in `code/AGENTS.md` (Codex) or `.claude/rules/r-code-conventions.md` (Claude)
- **Save all scripts** to the appropriate `code/[task_group]/` directory
- **Save all outputs** to `output/` (figures, tables, numbers subdirs)
- **Use `saveRDS()`** for every computed object
- **Use project theme** for all figures
- **Run `/review-r`** on the generated script before presenting results

---

## Workflow Phases

### Phase 1: Setup and Data Loading

1. Read code conventions for project standards
2. Create R script with proper header (title, author, purpose, inputs, outputs)
3. Load required packages at top (`library()`, never `require()`)
4. Set seed once at top in YYYYMMDD format: `set.seed(20260211)`
5. Load and inspect the dataset

### Phase 2: Exploratory Data Analysis

Generate diagnostic outputs:
- **Summary statistics:** `summary()`, missingness rates, variable types
- **Distributions:** Histograms for key continuous variables
- **Relationships:** Scatter plots, correlation matrices
- **Time patterns:** If panel data, plot trends over time
- **Group comparisons:** If treatment/control, compare pre-treatment means

Save all diagnostic figures to `output/figures/`.

### Phase 3: Main Analysis

Based on the research question:
- **Regression analysis:** Use `fixest` for panel data, `lm`/`glm` for cross-section
- **Standard errors:** Cluster at the appropriate level (document why)
- **Multiple specifications:** Start simple, progressively add controls
- **Effect sizes:** Report standardized effects alongside raw coefficients

### Phase 4: Publication-Ready Output

**Tables:**
- Use `modelsummary` for regression tables (preferred) or `stargazer`
- Include all standard elements: coefficients, SEs, significance stars, N, R-squared
- Export as `.tex` for LaTeX inclusion and `.html` for quick viewing

**Figures:**
- Use `ggplot2` with project theme
- Set `bg = "transparent"` for LaTeX compatibility
- Include proper axis labels (sentence case, units)
- Export with explicit dimensions: `ggsave(width = X, height = Y)`
- Save as both `.pdf` and `.png`

### Phase 5: Save and Review

1. `saveRDS()` for all key objects
2. Rely on the Makefile for directory creation (do not call `dir.create()` in scripts)
3. Run `/review-r` on the generated script
4. Address any Critical or High issues from the review

---

## Script Structure

```r
# ============================================================
# [Descriptive Title]
# Author: [from project context]
# Purpose: [What this script does]
# Inputs: [Data files]
# Outputs: [Figures, tables, RDS files]
# ============================================================

# 0. Setup ----
library(tidyverse)
library(fixest)
library(modelsummary)

set.seed(20260211)  # YYYYMMDD format

# Note: output directories are created by the Makefile, not the script

# 1. Data Loading ----
# 2. Exploratory Analysis ----
# 3. Main Analysis ----
# 4. Tables and Figures ----
# 5. Export ----
```

---

## Important

- **Reproduce, don't guess.** If the user specifies a regression, run exactly that.
- **Show your work.** Print summary statistics before jumping to regression.
- **Check for issues.** Look for multicollinearity, outliers, perfect prediction.
- **Use relative paths.** All paths relative to repository root.
- **No hardcoded values.** Use variables for sample restrictions, date ranges, etc.
