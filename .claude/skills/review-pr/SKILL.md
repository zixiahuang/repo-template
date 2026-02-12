---
name: review-pr
description: Review and address unresolved PR comments. Implements fixes, commits modularly, replies with commit hashes, and resolves threads.
disable-model-invocation: true
argument-hint: "<PR number>"
allowed-tools: ["Bash", "Read", "Glob", "Grep", "Edit", "Write", "Task"]
---

# Review and Address PR Comments

Fetch unresolved review threads from a pull request, categorize by confidence, implement fixes via the orchestrator mini-loop, commit modularly, reply with commit hashes, resolve threads, and report uncertain items back to the user.

## Steps

### Step 1 -- Parse PR Reference

Extract the PR number from `$ARGUMENTS`. Error if no argument provided.

Derive owner and repo:

```bash
OWNER_REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner')
OWNER=$(echo "$OWNER_REPO" | cut -d'/' -f1)
REPO=$(echo "$OWNER_REPO" | cut -d'/' -f2)
PR_NUM=$ARGUMENTS
```

### Step 2 -- Check Out the PR Branch

Switch to the PR branch so all commits land there:

```bash
gh pr checkout $PR_NUM
```

Confirm you are NOT on `main`:

```bash
BRANCH=$(git branch --show-current)
# If BRANCH is "main", abort immediately
```

### Step 3 -- Fetch Unresolved Threads via GraphQL

Query all review threads with their comments:

```bash
gh api graphql -f query='
query($owner: String!, $repo: String!, $pr: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $pr) {
      reviewThreads(first: 100) {
        nodes {
          id
          isResolved
          isOutdated
          path
          line
          comments(first: 50) {
            nodes {
              body
              author { login }
              databaseId
              createdAt
            }
          }
        }
      }
    }
  }
}' -F owner="$OWNER" -F repo="$REPO" -F pr=$PR_NUM
```

Parse the JSON output. Each thread has: `id`, `isResolved`, `isOutdated`, `path`, `line`, and nested `comments`.

### Step 4 -- Filter and Categorize

For each thread:

- **Skip** if `isResolved == true`
- **Flag as OUTDATED** if `isOutdated == true` -- report only, do not fix
- **Classify** remaining threads by confidence:

| Confidence | Criteria | Action |
|------------|----------|--------|
| **HIGH** | Clear code fix: typo, bug, missing import, style issue, explicit instruction | Implement + commit + resolve |
| **MEDIUM** | Ambiguous but likely intent discernible; requires interpretation | Implement + stage (do NOT commit). Present interpretation to user |
| **LOW** | Design question, clarification request, or unclear fix path | Do NOT implement. Report with suggestion |

Read the referenced file and surrounding context to determine confidence. Err on the side of caution -- when in doubt, classify as MEDIUM or LOW.

### Step 5 -- Group by File Path

Group all actionable threads (HIGH + MEDIUM) by file path. Each file group becomes one atomic commit. Sort threads within each group by line number.

### Step 6 -- Orchestrator Mini-Loop (per file group)

For each file group, run the orchestrator loop:

**IMPLEMENT:** Read the file and all comment bodies for this group. Apply changes.

**VERIFY:** If a Makefile exists, run `make -n` and build stale targets. Otherwise, run the appropriate compile/render command. Check exit codes. Max 2 retries on failure.

**REVIEW:** If a reviewer agent exists for the file type (e.g., `r-reviewer` for `.R`, `tikz-reviewer` for TikZ), run a quick review pass. Skip if no matching agent.

**SCORE:** Apply quality gates. If score < 80 after 2 fix rounds, skip this group and report it as needing user attention.

**COMMIT** (HIGH-confidence threads only, score >= 80):

```bash
git add <files in group>
git commit -m "$(cat <<'EOF'
<message describing the fix, referencing the comment>
EOF
)"
```

**REPLY + RESOLVE** (HIGH-confidence threads only, after successful commit):

For each thread in the committed group, reply with the commit hash and resolve:

```bash
# Reply to the comment
gh api repos/$OWNER/$REPO/pulls/$PR_NUM/comments/$COMMENT_DB_ID/replies \
  -X POST -f body="Addressed in $(git rev-parse --short HEAD)."

# Resolve the thread
gh api graphql -f query='
mutation($threadId: ID!) {
  resolveReviewThread(input: { threadId: $threadId }) {
    thread { isResolved }
  }
}' -F threadId="$THREAD_ID"
```

For MEDIUM-confidence threads: stage changes but do NOT commit or resolve. These will be presented to the user for approval.

### Step 7 -- Push

After all file groups are processed, push committed changes:

```bash
git push
```

### Step 8 -- Summary Table

Present a summary organized into four sections:

**Addressed (committed + resolved):**

| Thread | File:Line | Comment Summary | Commit |
|--------|-----------|-----------------|--------|
| ... | ... | ... | `abc1234` |

**Needs Approval (MEDIUM -- staged, not committed):**

| Thread | File:Line | Comment | Interpretation |
|--------|-----------|---------|----------------|
| ... | ... | ... | What you chose to do and why |

**Needs User Input (LOW -- not implemented):**

| Thread | File:Line | Comment | Suggestion |
|--------|-----------|---------|------------|
| ... | ... | ... | Suggested approach |

**Outdated (informational only):**

| Thread | File:Line | Comment |
|--------|-----------|---------|
| ... | ... | ... |

If there are MEDIUM items, remind the user to review the staged changes (`git diff --cached`) and either commit or discard.

## Important

- **Never commit to main** -- always operate on the PR branch. Abort if checkout lands on main.
- **Never commit if not confident** -- MEDIUM changes are staged but not committed. LOW changes are not implemented.
- **Never resolve without a commit** -- only resolve threads that have a corresponding committed fix.
- **One commit per file group** -- keep changes atomic and modular.
- **Max 2 verification retries** and **max 2 review-fix rounds** per file group.
- **Do not stage** `settings.local.json`, `.env`, or any files containing secrets.
- **Outdated threads** are reported but never fixed -- the code they reference may have moved.
- **Commit messages** should reference the substance of the reviewer's comment, not just "address review comment".
