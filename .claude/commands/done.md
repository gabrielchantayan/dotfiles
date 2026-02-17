---
description: Create a handoff document summarizing this session and save to Obsidian
allowed-tools: Bash(git:*), Bash(mkdir:*), Write
model: opus
---

## Context

- Working directory: !`pwd`
- Git branch: !`git branch --show-current 2>/dev/null || echo "N/A"`
- Git status: !`git status --short 2>/dev/null || echo "N/A"`
- Files changed: !`git diff --name-only HEAD~1 2>/dev/null || git diff --name-only 2>/dev/null || echo "N/A"`
- Project name: !`basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"`
- Date: !`date +%Y-%m-%d`

## Task

Generate a handoff document summarizing this session and save it to the Obsidian vault.

### Step 1: Generate Title

Infer a 2-4 word kebab-case title from the conversation (e.g., `auth-refactor`, `fix-deploy-pipeline`). This should capture the primary theme of the session.

### Step 2: Synthesize Handoff Document

Review the full conversation and produce a markdown document with this structure:

```markdown
# {Title in Title Case}

**Date:** YYYY-MM-DD
**Working Directory:** /path/to/project
**Git Branch:** feature/branch-name

## Summary

1-3 paragraph overview of what was accomplished and why.

## Key Decisions

- Decision 1 and rationale
- Decision 2 and rationale

## What Changed

- List of files modified/created with brief description of each change
- Organized by logical grouping if many files

## Follow-ups

- [ ] Action item 1
- [ ] Action item 2

## Open Questions

- Unresolved question 1
- Unresolved question 2

## Notes

Any additional context, gotchas, or things the next session should know.
```

**Omit any section that would be empty.** Do not include placeholder text like "None" or "N/A". The Summary, Key Decisions, and What Changed sections are always present.

Include links to PRs or issues if they were created during the session.

### Step 3: Save the File

1. Determine the output path:
   ```
   /Users/gabe/Documents/Obsidian Vault/handoffs/{project-name}/YYYY-MM-DD {Title in Title Case}.md
   ```
   - `{project-name}` comes from the git repo root directory name, or the current directory name if not in a repo
   - Create the subfolder with `mkdir -p` if it doesn't exist

2. If a file with the same date and title already exists, append a number: `2026-02-17 Auth Refactor 2.md`

3. Write the file using the Write tool.

### Step 4: Confirm

Print the saved file path and a 1-2 sentence summary of what was captured.

## Rules

- Omit empty sections entirely
- Keep the summary concise but informative — this is a reference doc, not a transcript
- Use Obsidian-compatible markdown (standard markdown, `- [ ]` checkboxes)
- Do NOT include AI attribution
