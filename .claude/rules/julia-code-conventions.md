---
paths:
  - "**/*.jl"
  - "code/**/*.jl"
---

# Julia Code Standards

**Standard:** Senior Principal Computational Scientist + PhD researcher quality

---

## 1. Reproducibility

- `Random.seed!(YYYYMMDD)` called ONCE at top (YYYYMMDD format) **ONCE CHOOSING A SEED DO NOT CHANGE IT AGAIN**
- All dependencies loaded at top via `using` or `import`
- All paths relative to repository root using `joinpath()`
- Rely on the Makefile to make directories

## 2. Function Design

- `snake_case` for functions and variables, `CamelCase` for types and modules
- Verb-noun pattern (e.g., `run_simulation`, `generate_dgp`, `compute_effect`)
- Triple-quoted docstrings:
  ```julia
  """
      compute_effect(y, d, x; method=:ols)

  Estimate the treatment effect of `d` on `y` controlling for `x`.

  # Arguments
  - `y::Vector{Float64}`: outcome variable
  - `d::Vector{Float64}`: treatment indicator
  - `x::Matrix{Float64}`: control variables
  - `method::Symbol`: estimation method (default `:ols`)

  # Returns
  `NamedTuple` with fields `coef`, `se`, `ci`
  """
  ```
- Default parameters for all tuning values, no magic numbers
- Return `NamedTuple` or custom `struct` (not bare tuples)

## 3. Domain Correctness

<!-- Customize for your field's known pitfalls -->
- Verify estimator implementations match paper formulas (see `latex/manuscript.tex`) if there is an estimation component
- Verify solution algorithm implementation matches paper description (see `latex/manuscript.tex`) if there is a simulation component
- Check known package bugs (document below in Common Pitfalls)
- Be aware of Float64 precision differences vs R (e.g., edge cases in matrix inversions, cumulative sums over long series)

## 4. Output Paths & Data Persistence

All code outputs go to canonical subdirectories under `output/`:

```julia
# Figures
savefig(joinpath("output", "figures", "my_plot.pdf"))

# Tables / data
CSV.write(joinpath("output", "tables", "my_results.csv"), df)

# Inline numbers for manuscript (\newcommand .txt files)
open(joinpath("output", "numbers", "my_estimate.txt"), "w") do io
    println(io, "\\newcommand{\\myEstimate}{2.31}")
end
```

**Heavy computations saved to disk; downstream scripts load pre-computed data.**

```julia
using JLD2

# Save
jldsave(joinpath("output", "tables", "descriptive_name.jld2"); result, summary_table)

# Load
data = load(joinpath("output", "tables", "descriptive_name.jld2"))
```

Prefer JLD2 for Julia-native objects. Use `Serialization.serialize`/`deserialize` only as a fallback for objects JLD2 cannot handle.

```julia
using DelimitedFiles

# Save
writedlm(joinpath("output", "tables", "descriptive_name.csv"), data, ',')

# Load
data = readdlm(joinpath("output", "tables", "descriptive_name.csv"), ',')
```

Prefer CSV for model output. When saving results for simulations with different parameter values (e.g. `\alpha = 5` `\beta = 2`), have these values in the file name and ensure the file name is ASCII standard (e.g. strip hats). For example:

```julia
# Save specific scenario
scenario = "alpha_$(α)_beta_$(β)"
writedlm(joinpath("output", "tables", "$(scenario)_descriptive_name.csv"), data, ',')
```

## 5. Common Pitfalls

<!-- Add your field-specific pitfalls here -->
| Pitfall | Impact | Prevention |
|---------|--------|------------|
| Global variables in hot loops | Severe performance regression | Pass as arguments or use `const` |
| Abstract-typed struct fields | Type instability, slow dispatch | Always annotate fields with concrete types |
| `1:length(x)` instead of `eachindex(x)` | Off-by-one risk with OffsetArrays, less idiomatic | Use `eachindex(x)` or `axes(x, dim)` |
| Unfused broadcasts (`sin.(x) .+ cos.(x)`) | Allocates intermediates | Use `@.` macro: `@. sin(x) + cos(x)` |
| Missing `@views` on slices | Allocates copies | Wrap in `@views` or use `@view` per slice |
| Hardcoded paths | Breaks on other machines | Use `joinpath()` with relative paths |

## 6. Line Length & Mathematical Exceptions

**Standard:** Keep lines <= 92 characters (Julia community convention).

**Exception: Mathematical Formulas** — lines may exceed 92 chars **if and only if:**

1. Breaking the line would harm readability of the math (influence functions, matrix ops, finite-difference approximations, formula implementations matching paper equations)
2. An inline comment explains the mathematical operation:
   ```julia
   # Sieve projection: inner product of residuals onto basis functions P_k
   alpha_k = sum(r_i .* basis[:, k]) / sum(basis[:, k] .^ 2)
   ```
3. The line is in a numerically intensive section (simulation loops, estimation routines, inference calculations)

**Quality Gate Impact:**
- Long lines in non-mathematical code: minor penalty (-1 to -2 per line)
- Long lines in documented mathematical sections: no penalty

## 7. Type Stability & Performance

- Run `@code_warntype` on hot functions during development
- Struct fields must have concrete types (no `Any`, no abstract types):
  ```julia
  # Bad
  struct Result
      coef       # implicitly Any
      vcov::AbstractMatrix  # abstract
  end

  # Good
  struct Result
      coef::Vector{Float64}
      vcov::Matrix{Float64}
  end
  ```
- Use `const` for module-level constants (e.g., `const N_SIM = 1000`)
- Use `@views` to avoid allocating array slices in loops
- Pre-allocate output arrays when size is known ahead of time:
  ```julia
  results = Matrix{Float64}(undef, n_sim, n_params)
  for i in 1:n_sim
      results[i, :] .= run_one_sim(i)
  end
  ```

## 8. Broadcasting & Fusion

Broadcasting and fusion are **the primary performance lever** in Julia numerical code.

- Prefer dot syntax over manual element-wise loops:
  ```julia
  # Bad: manual loop
  for i in eachindex(x)
      y[i] = sin(x[i]) + cos(x[i])
  end

  # Good: fused broadcast (single pass, no intermediates)
  @. y = sin(x) + cos(x)
  ```
- Use `@.` macro for multi-operation expressions (fuses the entire RHS)
- Use `map` / `reduce` / comprehensions for non-broadcastable transforms
- Avoid allocating intermediate arrays — fused broadcasts handle this automatically

## 9. Code Quality Checklist

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
