---
name: building-only-what-was-asked
description: Use when implementing a ticket, spec, or plan in any NationGraph repo, especially when about to add a status column, approval step, lock, tracking field, new table, migration, repository method, test file, or lint-disable comment that the ticket does not name.
---

# Building Only What Was Asked

## Overview

Reviewers delete more agent code than they correct. The most frequent review comment in the last six months was "we don't need this": approval steps, lanes, locks, tracking columns, and repository methods with no caller. Every line in the diff must trace to a requirement in the ticket.

## Rules

| Temptation | Rule |
|---|---|
| New workflow state (`approved_at`, `status: 'draft'`, lanes, queues) | Add it only if the ticket names the state. "Create" and "send" are one step unless the ticket says otherwise. |
| Tracking fields (`slack_ts`, `posted_at`, `message_uid`, `*_by`) | Store only what a named feature reads. |
| A column you can compute (`window_start` from `report_date`) | Compute it. Do not store it. |
| A lock, mutex, or advisory lock "for safety" | Add it only for a real concurrent writer. One service that owns the table does not need a lock. |
| A new table, schema, or migration for a small flag | First check whether an existing column or event type already carries it. |
| A new export, repository method, or helper | It must have a caller in the same diff. Otherwise delete it. |
| A hunk no requirement explains (refactor, rename, changelog edit, dependency bump) | Revert it, or say why in the PR body. Do not edit `CHANGELOG.md` unless asked. |
| `eslint-disable`, `oxlint-disable`, `# noqa`, `//nolint` | Never add one. If a size or complexity cap fires, extract a function. If a rule fires, fix the code. |
| Tests for repositories, CRUD, or edge-case junk | Test behavior that can break in a way a user sees. Put shared fixtures in the repo's support folder (`tests/support/`), not in the test file. |

## Before you open the PR

1. List every file in `git diff --stat origin/main`.
2. For each file, name the ticket requirement it serves. If you cannot, revert that file.
3. For each new export, run `rg -n '<name>'`. If the only hit is its definition, delete it.
4. Run `git diff origin/main | rg '^\+.*(eslint|oxlint)-disable|^\+.*noqa|^\+.*nolint'`. The output must be empty.

## Red flags

- "It will be useful later."
- "A status column makes this future-proof."
- "I added a lock just in case."
- "I disabled max-lines for this one file."
- "I cleaned up this nearby code while I was here."

Each of these means the diff contains something the ticket did not ask for. Remove it.

**REQUIRED:** If the ticket seems to need something it does not name, ask. Do not build it silently.
