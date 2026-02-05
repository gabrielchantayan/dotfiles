---
description: Reimplement the current branch on a new branch with a clean, narrative-quality git commit history
argument-hint: [new-branch-name] [ref-to-source-branch]
allowed-tools: Bash(git:*), Bash(gh pr create:*)
---

## Context

- Source branch: !`git branch --show-current`
- Git status: !`git status --short`
- Available branches: !`git branch --list dev staging main 2>/dev/null | tr -d ' *'`

**Ref to Source Branch**: Use the second `$ARGUMENTS` if provided, otherwise use `dev` if it exists, otherwise `staging`.

Before proceeding, run `git log <ref>...HEAD --oneline` and `git diff <ref>...HEAD --stat` to gather the commit history and diff.

## Task

Reimplement the current branch on a new branch with a clean, narrative-quality git commit history suitable for reviewer comprehension.

**New Branch Name**: Use `$ARGUMENTS` if provided. If the branch name is `{source_branch}-dirty`, then use `{source_branch}`. Otherwise, use `{source_branch}-clean`.


### Steps

1. **Validate the source branch**
   - Ensure no uncommitted changes or merge conflicts
   - Confirm it is up to date with `ref-to-source-branch`

2. **Analyze the diff**
   - Study all changes between source branch and `ref-to-source-branch`
   - Form a clear understanding of the final intended state

3. **Create the clean branch**
   - Create a new branch off of `ref-to-source-branch` using the new branch name

4. **Plan the commit storyline**
   - Break the implementation into self-contained logical steps
   - Each step should reflect a stage of development—as if writing a tutorial

5. **Reimplement the work**
   - Recreate changes in the clean branch, committing step by step
   - Each commit must:
     - Introduce a single coherent idea
     - Include a clear commit message and description
   - **Use `git commit --no-verify` for all intermediate commits.** Pre-commit hooks check tests, types, and imports that may not pass until the full implementation is complete. Do not waste time fixing issues in intermediate commits that will be resolved by later commits.

6. **Verify correctness**
   - Confirm the final state exactly matches the source branch
   - Formatting differences and HTML class orderings can be fixed with running the approriate formatters
   - Run the final commit **without** `--no-verify` to ensure all checks pass

7. **Open a pull request**
   - Create a PR following the instructions in ~/.claude/commands/pr.md
   - Include a link to the original branch in the PR description
   - Do not mention that it is a cleaned version of a branch, do not mention the original branch 

### Rules

- Never add yourself as an author or contributor
- Never include "Generated with Claude Code" or "Co-Authored-By" lines in commits
- The end state of the clean branch must be identical to the source branch
