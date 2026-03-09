---
name: setup-makefile
description: Generate a Makefile for a code directory by scanning scripts for output paths and building dependency rules.
disable-model-invocation: true
argument-hint: "[directory]"
allowed-tools: ["Bash", "Read", "Grep", "Glob", "Write"]
---

# Generate Makefile from Directory Contents

Scan a directory for scripts and generate a Makefile following project conventions.

## Steps

### 1. Scan directory

Glob for scripts in `$ARGUMENTS`:
- `.R` files
- `.jl` files
- `.m` files

### 2. Parse output paths

For each script, scan for output write calls:

- **R:** `write.csv`, `write_csv`, `saveRDS`, `ggsave`, `writeLines` (to `output/`)
- **Julia:** `CSV.write`, `jldsave`, `savefig`, `open(..., "w")`
- **MATLAB:** `writetable`, `writematrix`, `save`, `saveas`

Also scan for input paths to determine dependencies:
- **R:** `read.csv`, `read_csv`, `readRDS`, `source`
- **Julia:** `CSV.read`, `jldopen`, `include`
- **MATLAB:** `readtable`, `readmatrix`, `load`

### 3. Generate Makefile

Follow `.claude/rules/makefile-conventions.md`:

```make
# Makefile for [directory name]
# Generated from script analysis -- review before use

# ==============================================================================
# Variables
# ==============================================================================

# [output path variables]

# ==============================================================================
# Targets
# ==============================================================================

.PHONY: all clean

all: [list of all output targets]

# --- Script 1: [description] ---
[output]: [script] [input dependencies] | [output directory]
	[Rscript/julia/matlab -batch] $<

# --- Script 2: [description] ---
# [joint production if multiple outputs from one script]

# ==============================================================================
# Directory creation
# ==============================================================================

[output directories]:
	mkdir -p $@

# ==============================================================================
# Clean
# ==============================================================================

clean:
	rm -f [all output files]
```

Key conventions:
- `all` as default target
- `.PHONY` for non-file targets
- Order-only prerequisites for directories (`| output/dir`)
- `$<` and `$@` automatic variables
- Joint production for multi-output scripts
- `.PRECIOUS` for expensive intermediates
- Script execution: `Rscript $<`, `julia $<`, `matlab -batch "run('$<')"`

### 4. Present for review

**Do NOT write the Makefile directly.** Present the generated content to the user for review:

```
## Generated Makefile for [directory]

Scripts found: N
Targets generated: M
Output directories: K

[full Makefile content]
```

Ask: "Does this look correct? Should I write it to `[directory]/Makefile`?"

### 5. Write (after approval)

Write the Makefile only after user approval.

Also update the parent `code/Makefile` to include the new subdirectory in its delegation list, if applicable.

## Important

- Always present for review before writing
- Follow `makefile-conventions.md` exactly
- If output paths cannot be reliably parsed, flag those scripts and ask the user
- Mark expensive computations with `.PRECIOUS`
