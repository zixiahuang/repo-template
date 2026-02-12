---
name: review-pr
description: Review and address unresolved PR comments. Implements fixes, commits modularly, replies with commit hashes, and resolves threads.
workflow_stage: deployment
compatibility:
  - codex
  - claude-code
version: 1.0.0
tags:
  - git
  - pull-request
  - code-review
  - github
---

# Review and Address PR Comments

Fetch unresolved review threads from a pull request, categorize by confidence, implement fixes, commit modularly, reply with commit hashes, resolve threads, and report uncertain items back to the user.

## Steps

### Step 1 -- Parse PR Reference

Extract the PR number from the argument. Error if no argument provided.

Derive owner and repo:

```bash
OWNER_REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner')
OWNER=$(echo "$OWNER_REPO" | cut -d'/' -f1)
REPO=$(echo "$OWNER_REPO" | cut -d'/' -f2)
```

### Step 2 -- Check Out the PR Branch

Switch to the PR branch so all commits land there:

```bash
gh pr checkout $PR_NUM
```

Confirm you are NOT on `main`. Abort if on `main`.

### Step 3 -- Fetch Unresolved Threads via GraphQL

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

### Step 4 -- Filter and Categorize

For each thread:
- **Skip** if `isResolved == true`
- **Flag as OUTDATED** if `isOutdated == true` -- report only, do not fix
- **Classify** remaining threads:

| Confidence | Criteria | Action |
|------------|----------|--------|
| **HIGH** | Clear code fix: typo, bug, missing import, style, explicit instruction | Implement + commit + resolve |
| **MEDIUM** | Ambiguous but likely intent discernible | Implement + stage (do NOT commit). Present to user |
| **LOW** | Design question, clarification request | Do NOT implement. Report with suggestion |

### Step 5 -- Group by File Path

Group actionable threads (HIGH + MEDIUM) by file path. Each file group becomes one atomic commit.

### Step 6 -- Implement, Verify, Commit (per file group)

**IMPLEMENT:** Read the file and apply changes for all threads in this group.

**VERIFY:** If a Makefile exists, run `make -n` and build stale targets. Check exit codes. Max 2 retries.

**REVIEW:** Run the appropriate review skill for the file type (e.g., `/review-r` for `.R`). Skip if no matching skill.

**SCORE:** Apply quality gates. If score < 80 after 2 fix rounds, skip and report.

**COMMIT** (HIGH-confidence only, score >= 80):

```bash
git add <files in group>
git commit -m "<message referencing the comment>"
```

**REPLY + RESOLVE** (HIGH-confidence only):

```bash
gh api repos/$OWNER/$REPO/pulls/$PR_NUM/comments/$COMMENT_DB_ID/replies \
  -X POST -f body="Addressed in $(git rev-parse --short HEAD)."

gh api graphql -f query='
mutation($threadId: ID!) {
  resolveReviewThread(input: { threadId: $threadId }) {
    thread { isResolved }
  }
}' -F threadId="$THREAD_ID"
```

### Step 7 -- Push

```bash
git push
```

### Step 8 -- Summary Table

Present four sections:

**Addressed (committed + resolved):**
| Thread | File:Line | Comment Summary | Commit |

**Needs Approval (MEDIUM -- staged, not committed):**
| Thread | File:Line | Comment | Interpretation |

**Needs User Input (LOW -- not implemented):**
| Thread | File:Line | Comment | Suggestion |

**Outdated (informational only):**
| Thread | File:Line | Comment |

## Important

- **Never commit to main** -- always operate on the PR branch
- **Never commit if not confident** -- MEDIUM changes staged only, LOW not implemented
- **Never resolve without a commit** -- only resolve threads with committed fixes
- **One commit per file group** -- atomic and modular
- **Do not stage** sensitive files
- **Outdated threads** are reported but never fixed
