# Bash Conventions

## One Command Per Bash Call

Never chain commands with `&&` or `;` in a single Bash tool call. The permission glob patterns in `.claude/settings.json` (e.g., `Bash(git add *)`) match individual commands — chained commands won't match and will trigger unnecessary permission prompts.

**Do this:**
```
Bash call 1: git add README.md
Bash call 2: git commit -m "Fix typo"
Bash call 3: git push origin main
```

**Not this:**
```
Bash call 1: git add README.md && git commit -m "Fix typo" && git push origin main
```

## Parallel vs Sequential

- **Independent commands** — issue as parallel Bash calls in a single message (e.g., `git status` and `git diff`)
- **Dependent commands** — issue sequentially, waiting for each result before the next (e.g., `git add` then `git commit`)
