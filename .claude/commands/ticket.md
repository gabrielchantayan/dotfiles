---
description: Implement a Linear ticket end-to-end in an isolated worktree, commit, push, and cleanup
argument-hint: <linear-ticket-id-or-url>
allowed-tools: Bash(git:*), Bash(gh:*), Bash(ls:*), Bash(cd:*), Bash(npm:*), Bash(pnpm:*), Bash(yarn:*), Bash(cargo:*), Bash(pytest:*), Bash(go:*), Bash(make:*), Skill(commit), Skill(superpowers:using-git-worktrees), Skill(superpowers:test-driven-development), Skill(superpowers:systematic-debugging), Skill(superpowers:verification-before-completion), mcp__claude_ai_Linear__get_issue, mcp__claude_ai_Linear__list_comments, mcp__claude_ai_Linear__save_comment, Read, Write, Edit, Glob, Grep
model: opus
---

## Context

- Ticket: $ARGUMENTS
- Current repo root: !`git rev-parse --show-toplevel 2>/dev/null || echo "NOT_A_REPO"`
- Current branch: !`git branch --show-current 2>/dev/null`
- Default branch: !`git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main"`
- Working tree status: !`git status --short 2>/dev/null | head -20`
- Existing worktrees: !`git worktree list 2>/dev/null`

## Task

Implement the Linear ticket from start to finish in an isolated worktree.

### Step 1: Fetch the ticket

1. Parse `$ARGUMENTS` to extract the Linear issue identifier (e.g., `NG-123`). Accept raw IDs, URLs (`https://linear.app/.../issue/NG-123/...`), or branch-style slugs.
2. Call `mcp__claude_ai_Linear__get_issue` to load full ticket details (title, description, state, assignee, labels, priority, suggested branch name).
3. Call `mcp__claude_ai_Linear__list_comments` for additional context.
4. Summarize what's being implemented in 2–3 sentences. If the ticket is ambiguous, has unresolved questions, or lacks acceptance criteria, **STOP** and ask Spingle before touching code.

### Step 2: Create the worktree

Use the `superpowers:using-git-worktrees` skill. Use Linear's `branchName` field as the branch name. Verify the worktree directory is gitignored before creating.

`cd` into the worktree path for all subsequent steps. Confirm baseline tests pass before implementing.

### Step 3: Implement the ticket

1. Use `superpowers:test-driven-development` for any new behavior—write the failing test first, then implement.
2. If something breaks unexpectedly, switch to `superpowers:systematic-debugging`. Do **not** suppress errors, swallow exceptions, or `try/except: pass` your way out. Fix the root cause.
3. Honor existing project conventions—read neighbors before inventing patterns.
4. Run lint/typecheck/tests after each meaningful change. No "I'll fix it later" energy.

### Step 4: Verify before claiming done

Use `superpowers:verification-before-completion`:
- Full test suite passes
- Lint and typecheck clean
- Manually exercise UI changes in a browser if applicable; if you can't, say so explicitly
- Re-read the ticket's acceptance criteria and confirm each one

If anything fails, fix it. Do not proceed to commit with a broken build.

### Step 5: Commit

Invoke the `commit` skill. The commit message body should reference the Linear ticket ID (e.g., `Closes NG-123`) so Linear auto-links the commit.

### Step 6: Push the branch

```bash
git push -u origin <branch-name>
```

If push fails (auth, protected branch, hook rejection), report the exact error to Spingle and stop. Do **not** force-push.

### Step 7: Post a Linear comment

Add a brief comment on the ticket via `mcp__claude_ai_Linear__save_comment` linking the pushed branch and noting that work is ready for review/PR. Keep it short—commit SHAs and branch name.

### Step 8: Tear down the worktree

1. `cd` back to the original repo root (the value captured in Context above).
2. Confirm there are no uncommitted or untracked files in the worktree: `git -C <worktree-path> status --short`. If anything remains, **STOP** and surface it—do not delete unsaved work.
3. Remove the worktree: `git worktree remove <worktree-path>`.
4. Do **not** delete the local branch—Spingle may want it for the PR review cycle. The remote branch stays on origin.
5. Run `git worktree list` and confirm the worktree is gone.

### Step 9: Final report

Tell Spingle:
- Linear ticket ID and title
- Branch name and remote URL (`gh browse --no-browser --branch <branch>` if available, else construct from `git remote get-url origin`)
- Commit SHAs created
- Worktree path that was removed
- Suggested next step (usually: run `/pr` to open a pull request)

## Rules

- **Never** force-push, `git reset --hard` shared refs, or skip hooks (`--no-verify`).
- **Never** suppress errors or warnings to make the build "pass." Fix them.
- **Never** remove a worktree with uncommitted changes—stop and report.
- **Never** include "Generated with Claude Code" or any AI attribution in commits, comments, or PRs.
- If any step fails irrecoverably, leave the worktree intact so Spingle can inspect it, and report the failure clearly.
