---
description: Commit the current changes with an auto-generated message
argument-hint: [optional message or context]
allowed-tools: Bash(git:*)
---

## Context

- User's notes: $ARGUMENTS
- Current branch: !`git branch --show-current`
- Git status: !`git status --short`
- Staged changes: !`git diff --cached --stat`
- Unstaged changes: !`git diff --stat`
- Untracked files: !`git ls-files --others --exclude-standard`
- Recent commits (for style reference): !`git log -5 --oneline`

## Task

Create git commit(s) for the current changes, intelligently splitting large changesets into multiple semantic commits when appropriate.

### Step 1: Assess Changes

1. Check what files have changed using the context above
2. If there are no changes to commit, inform the user and stop
3. If there are unstaged or untracked changes, stage everything with `git add -A`
4. Calculate metrics:
   - Total file count (staged files)
   - Total line count: `git diff --cached --numstat | awk '{sum+=$1+$2} END {print sum}'`

### Step 2: Determine Mode

**SIMPLE mode** (single commit): Use when ALL of these are true:
- Less than 5 files changed
- Less than 150 lines changed
- Changes appear to be a single logical unit

**MULTI mode** (split commits): Use when ANY of these are true:
- 5 or more files changed
- 150 or more lines changed
- Changes span multiple concerns (e.g., feat + fix, or multiple unrelated features)

### Step 3a: SIMPLE Mode

Generate a single commit message following conventional commit format:

```
type(scope): brief description

Optional longer explanation if the changes are complex.
```

**Types**: feat, fix, refactor, test, docs, chore, perf, style, build, ci

Then execute: `git commit -m "message"`

### Step 3b: MULTI Mode

#### 3b.1: Categorize Changes

For each changed file, determine:
- **Type**: feat, fix, refactor, test, docs, chore, perf, style, build, ci
- **Scope**: The component/module/area affected

#### 3b.2: Group into Logical Commits

Create commit groups ordered by dependency (earlier commits should not depend on later ones):

1. **Infrastructure/config** - build configs, CI, tooling
2. **Data models/types** - schemas, type definitions, interfaces
3. **Core logic/services** - business logic, utilities, shared code
4. **API/handlers** - endpoints, controllers, route handlers
5. **UI components** - frontend components, views, styles
6. **Tests** - test files (unless tightly coupled to implementation)
7. **Docs** - documentation, README updates
8. **Chores** - misc cleanup, formatting, dependency updates

Combine groups if they form a single logical unit. Skip empty groups.

**Completeness invariant**: Every file in `git diff --cached --name-only` must appear in exactly one commit group. After grouping, compare the full staged file list against the grouped file list. If any file is missing from all groups, add it to the most relevant group or create a final `chore: commit remaining changes` group. Show both lists side-by-side before previewing.

#### 3b.3: Preview Commit Plan

Present the plan to the user:

```
Proposed commits (in order):

1. feat(auth): add user authentication types
   - src/types/auth.ts
   - src/types/user.ts

2. feat(auth): implement auth service
   - src/services/auth.ts
   - src/utils/token.ts

3. test(auth): add auth service tests
   - tests/auth.test.ts

Options:
- yes     : execute all commits as shown
- merge N M : combine commits N and M, then re-preview
- abort   : cancel (changes remain staged)
```

Wait for user response.

#### 3b.4: Handle User Response

- **yes**: Execute commits sequentially (see 3b.5)
- **merge N M**: Combine the specified commits and show preview again
- **abort**: Stop without committing, inform user changes are still staged

#### 3b.5: Execute Commits

For each commit in order:
1. Unstage all files: `git reset HEAD`
2. Stage only files for this commit: `git add <files>`
3. Create the commit:
   - **Intermediate commits**: Use `git commit --no-verify` to skip hooks
   - **Final commit**: Use `git commit` (allows hooks to run)

If any commit fails, stop and report the error. Do not continue with remaining commits.

#### 3b.6: Post-Execution Verification

After all commits are executed, run `git status --short`. If any changes remain uncommitted (staged or unstaged), immediately commit them with `chore: commit remaining changes` rather than leaving them behind.

## Rules

Do NOT:
- Push to remote (user will do this separately)
- Use `--amend` unless explicitly requested
- Commit files that look like secrets (.env, credentials, API keys)
- Include "Generated with Claude Code", "Co-Authored-By: Claude", or any AI attribution

## Commit Message Guidelines

- Keep the first line under 72 characters
- Use imperative mood ("add feature" not "added feature")
- Reference the user's notes if provided
- Be specific about what changed and why

If a commit fails due to pre-commit hooks, fix the issues and try again.
