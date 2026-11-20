---
name: self-reviewing-before-pr
description: Use before committing, pushing, opening, or updating a pull request, and before telling the user that implementation is done.
---

# Self-Reviewing Before a PR

## Overview

Many rules that reviewers flagged most often were already written in the standards. Thin routes, no casts, no lint suppression, prompts in the prompts folder, and short comments were each flagged 6 to 28 times. Written rules alone did not stop them. This sweep checks them mechanically on your own diff before a human sees it.

## 1. Mechanical sweep

Run from the repo root. Each command prints added lines that break a rule. The output of each must be empty, or you must be able to say why the line is correct. `git add -N .` makes new untracked files visible to `git diff`.

```bash
git fetch -q origin main && git add -N .
BASE=$(git merge-base origin/main HEAD)
ADDED() { git diff "$BASE" -U0 -- "$@" | rg '^\+[^+]'; }

# All repos
ADDED . | rg -n '(eslint|oxlint)-disable|# ?noqa|//nolint|@ts-(ignore|expect-error)'   # suppression
ADDED . | rg -n 'TODO|FIXME' | rg -v '[A-Z]+-[0-9]+'                                    # TODO without a ticket
ADDED . | rg -n '\s—\s'                                                                 # spaced em dash
ADDED . | rg -n -i 'REQ-[0-9]+|AC-[0-9]+|// -{3,}|# -{3,}|section [0-9]+'              # spec IDs and banners in code
ADDED . | rg -n -i 'previously|changed from|used to|no longer|was renamed'               # history comments

# TypeScript
ADDED '*.ts' '*.tsx' | rg -n ' as (unknown|any|[A-Z])|[a-zA-Z)\]]!\.|[a-zA-Z)\]]!\)'     # casts and non-null (not `as const`)
ADDED '*.ts' | rg -n "sql\`|->>|->'"                                                    # raw SQL fragments, JSONB queries
ADDED '*.tsx' | rg -n "\[[0-9.]+(px|%|rem|dvw)\]|style=\{\{|components/ui/|Loader2"     # UI overrides and primitives

# Python
ADDED 'app/services/*' | rg -n 'HTTPException'                                         # HTTP errors in services
ADDED 'app/routes/*' | rg -n 'Repository\('                                             # repos built in routes
ADDED '*.py' | rg -n 'os\.getenv|os\.environ'                                           # config outside config.py

# Go
ADDED '*.go' | rg -n 'map\[string\](any|interface\{\})|godotenv|os\.Getenv|go func\('
```

## 2. Scope sweep

```bash
git diff --stat "$BASE"
```

For each file, name the requirement it serves. Revert files that serve none. **REQUIRED SUB-SKILL:** Use `building-only-what-was-asked`.

For each new exported symbol, run `rg -n '<name>'`. The symbol must have a caller other than its definition and its test.

## 3. Judgment pass

Answer each question for the diff:

1. Does any function do more than one thing, or exceed the lint caps? Extract it.
2. Did I search for an existing helper, type, component, and sibling feature? (`reusing-before-writing`)
3. Did any refactor drop a side effect, or break a caller in another repo? (`preserving-behavior-in-changes`)
4. Can any error path return empty, partial, or default data as success? (`failing-loudly`)
5. Is any check-then-write, claim, or multi-write not atomic? (`writing-race-safe-data-changes`)
6. Does every query by id and every cache key carry its tenant or user? (`scoping-by-tenant-and-user`)
7. Does every new config key reach every deploy path? (`shipping-config-end-to-end`)
8. Do the tests cover behavior a user sees, with no tests for repositories or CRUD?

## 4. Run the repo checks

Run the repo's typecheck, lint, and tests on the final commit. In a stacked PR, run them on each commit of the stack. Run `git fetch origin main` before you rebase, and confirm `origin/main` advanced.

Report what you ran and its output. Do not report "done" with a failing check.
