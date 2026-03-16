---
paths:
  - "**/*.R"
  - "code/**/*.R"
---

# R Code Standards

**Standard:** Senior Principal Data Engineer + PhD researcher quality

---

## 1. Reproducibility

- `set.seed()` called ONCE at top (YYYYMMDD format)
- All packages loaded at top via `library()` (not `require()`)
- All paths relative to the script working directory (usually `code/[task_group]/`)
- Use forward slashes in any literal filepath; never write Windows-style backslashes
- Rely on the Makefile to make directories

## 2. Function Design

- `snake_case` naming, verb-noun pattern
- Roxygen-style documentation
- Default parameters, no magic numbers
- Named return values (lists or tibbles)

## 3. Domain Correctness

<!-- Customize for your field's known pitfalls -->
- Verify estimator implementations match paper formulas (`latex/manuscript.tex`)
- Check known package bugs (document below in Common Pitfalls)

## 4. Visual Identity

```r
# --- Your institutional palette ---
plot_blue = "#4575b4"
plot_mid = "#ffffdf"
plot_red = "#d73027"
plot_purple = "#c51b7d"
plot_green = "#3a7813"
```

### Fonts
```
sysfonts::font_add_google("Lato")
sysfonts::font_add_google("Fira Sans")
```

### Custom Themes
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

### Figure Dimensions (for slides template)
```r
# Maps
ggsave(filepath, width = 8, height = 4, bg = "transparent")
# Figures
ggsave(filepath, width = 8, height = 8, bg = "transparent")
```

## 5. Output Paths

Task-group scripts usually run from `code/[task_group]/`, so paths are
relative to that working directory. In the standard layout, define
`output_root` once and write into the canonical subdirectories under the
repo-root `output/` directory:

```r
output_root = file.path("..", "..", "output")

# Figures
ggsave(file.path(output_root, "figures", "my_plot.pdf"), width = 8, height = 8, bg = "transparent")

# Tables / RDS
saveRDS(result, file.path(output_root, "tables", "my_results.rds"))

# Inline numbers for manuscript (\newcommand .txt files)
writeLines("\\newcommand{\\myEstimate}{2.31}",
           file.path(output_root, "numbers", "my_estimate.txt"))
```

**Heavy computations saved as RDS; slide rendering loads pre-computed data.**

```r
output_root = file.path("..", "..", "output")
saveRDS(result, file.path(output_root, "tables", "descriptive_name.rds"))
```

## 6. Common Pitfalls

<!-- Add your field-specific pitfalls here -->
| Pitfall | Impact | Prevention |
|---------|--------|------------|
| Missing `bg = "transparent"` | White boxes on slides | Always include in ggsave() |
| Hardcoded paths | Breaks on other machines | Use relative paths |

## 7. Line Length & Mathematical Exceptions

**Standard:** Keep lines <= 120 characters.

**Exception: Mathematical Formulas** -- lines may exceed 120 chars **if and only if:**

1. Breaking the line would harm readability of the math (influence functions, matrix ops, finite-difference approximations, formula implementations matching paper equations)
2. An inline comment explains the mathematical operation:
   ```r
   # Sieve projection: inner product of residuals onto basis functions P_k
   alpha_k <- sum(r_i * basis[, k]) / sum(basis[, k]^2)
   ```
3. The line is in a numerically intensive section (simulation loops, estimation routines, inference calculations)

**Quality Gate Impact:**
- Long lines in non-mathematical code: minor penalty (-1 to -2 per line)
- Long lines in documented mathematical sections: no penalty

## 8. Code Quality Checklist

```
[ ] Packages at top via library()
[ ] set.seed() once at top
[ ] All paths relative
[ ] Functions documented (Roxygen)
[ ] Figures: transparent bg, explicit dimensions
[ ] RDS: every computed object saved
[ ] Comments explain WHY not WHAT
```
