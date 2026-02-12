# Code Pipeline Conventions

These conventions apply to all scripts in `code/` and its subdirectories.

---

## R Code Standards

**Standard:** Senior Principal Data Engineer + PhD researcher quality

### 1. Reproducibility

- `set.seed()` called ONCE at top (YYYYMMDD format)
- All packages loaded at top via `library()` (not `require()`)
- All paths relative to repository root
- Rely on the Makefile to make directories

### 2. Function Design

- `snake_case` naming, verb-noun pattern
- Roxygen-style documentation
- Default parameters, no magic numbers
- Named return values (lists or tibbles)

### 3. Domain Correctness

<!-- Customize for your field's known pitfalls -->
- Verify estimator implementations match paper formulas (`latex/manuscript.tex`)
- Check known package bugs (document below in Common Pitfalls)

### 4. Visual Identity

```r
# --- Your institutional palette ---
plot_blue = "#4575b4"
plot_mid = "#ffffdf"
plot_red = "#d73027"
plot_purple = "#c51b7d"
plot_green = "#3a7813"
```

#### Fonts
```
sysfonts::font_add_google("Lato")
sysfonts::font_add_google("Fira Sans")
```

#### Custom Themes
```r
# Regular plots
main_theme <-
  theme_classic() +
  theme(
    legend.position = "none",
    title = element_text(size = 24),
    text = element_text(family = font_choice),
    axis.text.x = element_text(size = 30), axis.text.y = element_text(size = 30),
    axis.title.x = element_text(size = 30), axis.title.y = element_text(size = 30),
    panel.grid.minor.x = element_blank(), panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(), panel.grid.major.x = element_blank(),
    axis.line = element_line(colour = "black"), axis.ticks = element_line(colour = "black"),
    plot.background = element_rect(fill = "#ffffff")
  )

# Maps
map_theme <-
  theme_void() +
  theme(
    legend.position = "bottom",
    legend.key.height = unit(.35, "cm"),
    legend.key.width = unit(.6, "cm"),
    legend.text = element_text(size = 8),
    text = element_text(family = "Lato"),
  )
```

#### Figure Dimensions (for slides template)
```r
# Maps
ggsave(filepath, width = 8, height = 4, bg = "transparent")
# Figures
ggsave(filepath, width = 8, height = 8, bg = "transparent")
```

### 5. Output Paths

All code outputs go to canonical subdirectories under `output/`:

```r
# Figures
ggsave(file.path("output", "figures", "my_plot.pdf"), width = 8, height = 8, bg = "transparent")

# Tables / RDS
saveRDS(result, file.path("output", "tables", "my_results.rds"))

# Inline numbers for manuscript (\newcommand .txt files)
writeLines("\\newcommand{\\myEstimate}{2.31}",
           file.path("output", "numbers", "my_estimate.txt"))
```

**Heavy computations saved as RDS; slide rendering loads pre-computed data.**

### 6. Common Pitfalls

<!-- Add your field-specific pitfalls here -->
| Pitfall | Impact | Prevention |
|---------|--------|------------|
| Missing `bg = "transparent"` | White boxes on slides | Always include in ggsave() |
| Hardcoded paths | Breaks on other machines | Use relative paths |

### 7. Line Length & Mathematical Exceptions

**Standard:** Keep lines <= 120 characters.

**Exception:** Mathematical formulas may exceed 120 chars if breaking the line would harm readability, an inline comment explains the operation, and the line is in a numerically intensive section.

### 8. Code Quality Checklist

```
[ ] Packages at top via library()
[ ] set.seed() once at top
[ ] All paths relative
[ ] Functions documented (Roxygen)
[ ] Figures: transparent bg, explicit dimensions
[ ] RDS: every computed object saved
[ ] Comments explain WHY not WHAT
```

---

## Julia Code Standards

**Standard:** Senior Principal Computational Scientist + PhD researcher quality

### 1. Reproducibility

- `Random.seed!(YYYYMMDD)` called ONCE at top (YYYYMMDD format) **ONCE CHOOSING A SEED DO NOT CHANGE IT AGAIN**
- All dependencies loaded at top via `using` or `import`
- All paths relative to repository root using `joinpath()`
- Rely on the Makefile to make directories

### 2. Function Design

- `snake_case` for functions and variables, `CamelCase` for types and modules
- Verb-noun pattern (e.g., `run_simulation`, `generate_dgp`, `compute_effect`)
- Triple-quoted docstrings with signature, arguments, and return type
- Default parameters for all tuning values, no magic numbers
- Return `NamedTuple` or custom `struct` (not bare tuples)

### 3. Domain Correctness

<!-- Customize for your field's known pitfalls -->
- Verify estimator/simulation implementations match paper formulas (`latex/manuscript.tex`)
- Check known package bugs
- Be aware of Float64 precision differences vs R

### 4. Output Paths & Data Persistence

```julia
# Figures
savefig(joinpath("output", "figures", "my_plot.pdf"))

# Tables / data
CSV.write(joinpath("output", "tables", "my_results.csv"), df)

# Inline numbers for manuscript
open(joinpath("output", "numbers", "my_estimate.txt"), "w") do io
    println(io, "\\newcommand{\\myEstimate}{2.31}")
end
```

**Heavy computations saved to disk; downstream scripts load pre-computed data.**

Prefer JLD2 for Julia-native objects. Use CSV for model output. When saving parameterized results, include parameter values in filenames (ASCII only, strip hats).

### 5. Common Pitfalls

| Pitfall | Impact | Prevention |
|---------|--------|------------|
| Global variables in hot loops | Severe performance regression | Pass as arguments or use `const` |
| Abstract-typed struct fields | Type instability, slow dispatch | Always annotate fields with concrete types |
| `1:length(x)` instead of `eachindex(x)` | Off-by-one risk with OffsetArrays | Use `eachindex(x)` or `axes(x, dim)` |
| Unfused broadcasts | Allocates intermediates | Use `@.` macro |
| Missing `@views` on slices | Allocates copies | Wrap in `@views` |
| Hardcoded paths | Breaks on other machines | Use `joinpath()` with relative paths |

### 6. Line Length

**Standard:** Keep lines <= 92 characters (Julia community convention). Mathematical formulas may exceed 92 chars under the same conditions as R.

### 7. Type Stability & Performance

- Run `@code_warntype` on hot functions during development
- Struct fields must have concrete types (no `Any`, no abstract types)
- Use `const` for module-level constants
- Use `@views` to avoid allocating array slices in loops
- Pre-allocate output arrays when size is known

### 8. Broadcasting & Fusion

- Prefer `@.` macro for multi-operation broadcast expressions
- Use `map` / `reduce` / comprehensions for non-broadcastable transforms
- Avoid allocating intermediate arrays where fused broadcasts suffice

### 9. Code Quality Checklist

```
[ ] Dependencies loaded at top via using/import
[ ] Random.seed!() once at top
[ ] All paths relative via joinpath()
[ ] Functions documented (triple-quoted docstrings)
[ ] JLD2: every computed object saved
[ ] Comments explain WHY not WHAT
[ ] Struct fields have concrete types
[ ] Hot loops use @views and pre-allocation
[ ] Broadcasts fused with @. where applicable
```

---

## Makefile Conventions

### Structure

- Every Makefile has `all` and `clean` as `.PHONY` targets
- `all` is the default (first) target and builds everything in that directory
- `clean` removes all generated outputs
- Root Makefile delegates to sub-Makefiles with a `$(MAKE) -C` loop

### Directory Creation

Use order-only prerequisites for output subdirectories:

```make
output/tables/results.csv: code/analysis.R | output/tables
output/figures/plot.pdf: code/figures.R | output/figures
output/numbers/estimate.txt: code/analysis.R | output/numbers

output/tables output/figures output/numbers:
	mkdir -p $@
```

Scripts must NOT create directories themselves. The Makefile owns all directory creation.

### Cross-Makefile Dependencies

```make
../sibling_dir/output.csv:
	$(MAKE) -C ../sibling_dir output.csv
```

### Expensive Intermediates

Mark expensive-to-produce files as `.PRECIOUS` so Make does not delete them on interruption.

### Pattern Rules

```make
output/tables/%.rds: code/%.R | output/tables
	Rscript $<

output/tables/%.csv: code/%.jl | output/tables
	julia $<
```

### Joint Production

When a single script produces multiple outputs, declare one primary target with the recipe and secondary targets with an empty recipe (`;`).

### Recipe Conventions

- R scripts: `Rscript $<`
- Julia scripts: `julia $<`
- Always use `$<` (first prerequisite) and `$@` (target) automatic variables
- Never use absolute paths

### Validation

- `make -n` (dry-run) must produce a valid plan
- Every `.R` and `.jl` file under `code/` should appear as a prerequisite in some Makefile target -- orphaned scripts are a warning sign
