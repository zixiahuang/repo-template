---
paths:
  - "**/*.R"
  - "**/*.jl"
  - "**/*.m"
---

# Refactoring Protocol

## Constraints

- NEVER change solver tolerances, options, or convergence criteria
- NEVER rename variables in numerical/hot-loop code
- NEVER change function signatures without explicit approval
- NEVER remove dead code unless explicitly instructed (flag it in section headers instead)
- The ONLY acceptable refactoring outcome is identical output

## Verify-Refactor-Verify Loop

1. Run target script, record output checksums (CSV only -- skip binary formats like RDS, .mat, PDF)
2. Apply style changes per language convention rules
3. Re-run, compare checksums
4. If mismatch: revert and report -- do not attempt to fix the mismatch

## Approved Transformations

- Comment style (headers, borders, docstrings)
- Whitespace and indentation
- Variable grouping and section organization
- Adding missing documentation
- Applying language-specific style conventions (pipe style, assignment operator, etc.)

## Prohibited Transformations (without explicit approval)

- Changing algorithm logic or control flow
- Renaming function parameters or return values
- Modifying solver configuration or tolerances
- Removing or restructuring error handling
- Changing data types or precision
- Refactoring loops into vectorized form (or vice versa) in numerical code

## When in doubt, ask before changing.
