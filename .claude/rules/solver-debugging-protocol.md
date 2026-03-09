---
paths:
  - "**/*.m"
  - "**/*.jl"
---

# Solver Debugging Protocol

When debugging numerical solver failures (MATLAB, Julia, Python):

## Diagnostic Checklist (follow in order)

1. **Dimensions first** -- verify all matrices are conformable, vectors are correct length
2. **NaN/Inf trace** -- find the first operation that produces NaN; trace backward
3. **Finite-difference check** -- validate analytic gradients/Hessians before suspecting derivative bugs
4. **Condition number** -- check key matrices (Jacobian, Hessian) for ill-conditioning
5. **Boundary check** -- verify variables respect bounds (non-negative shares, probabilities in [0,1])
6. **Input data** -- confirm data fed to solver contains no NaN/Inf/missing values
7. **Initial guess** -- check that x0 is feasible (satisfies bounds and constraints)

## Do NOT

- Change tolerances or solver options as a diagnostic step
- Change the solver algorithm without explicit approval
- Propose fixes before completing the diagnostic checklist
- Guess at root causes -- show evidence
- Add try/catch blocks to suppress solver errors

## Report Format

Present diagnosis with evidence, then proposed fix. Wait for approval before implementing.

```
## Diagnosis
- **Symptom:** [what failed]
- **First NaN/error at:** [file:line]
- **Root cause:** [with evidence]
- **Checklist completed:** [which steps, what was found]

## Proposed Fix
- [specific change with rationale]
- [expected outcome]
```
