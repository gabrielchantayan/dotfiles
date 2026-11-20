---
name: preserving-behavior-in-changes
description: Use when extracting, rewriting, or moving existing code, when replacing a component or form element, when removing or reshaping a field, route, type, or task, or when a fix touches a code path other callers share.
---

# Preserving Behavior in Changes

## Overview

The highest-severity review findings were silent regressions. An extraction dropped an action log. A rewrite lost Enter-to-submit. An export ignored the role filter. A removed field was still read by the worker. The code compiled and the tests passed. Behavior the old code had just disappeared.

## Side-effect inventory

Before you change a code path, list everything it does besides returning a value:

- Logs and analytics: action logs, PostHog events, audit rows.
- Cache and state: `invalidateQueries`, Redux dispatches, URL or query-param writes, pagination resets.
- Filters and scoping: role, territory, archived, and saved-view filters that the path applies.
- Native semantics: `<form>` submit on Enter, links that open in a new tab, focus handling.
- Data written: every column the old path set, including the ones merged from existing rows (a JSONB merge that keeps classifier fields).
- Downstream: queue jobs enqueued, notifications, webhooks.

After the change, check each item against the new path. Each item must still happen, or the PR body must say why it was removed.

## Caller contracts

Before you remove or reshape a field, type, route, enum value, or task name:

```bash
rg -n '<name>' <repo> <other-repo> …   # each repo that can produce or consume the name
```

- A route or task name has a producer and a consumer. If you add a task type in the API, the worker must have a processor for it.
- A response field can have a caller in another repo. If one exists, keep the field or change that caller in a linked PR.
- A shared type can be sent to customers. Do not change its shape for one caller.

## Replay the ticket

Run the exact repro path from the ticket, not a nearby path. If the ticket says "from the breadcrumbs", navigate from the breadcrumbs. If the ticket says "users who already have duplicates", test with existing duplicates, not only new rows.

## Red flags

- "It's a pure refactor, so behavior is the same."
- "The types still compile."
- "I tested the main path."
- "Nothing else uses that field." (You did not `rg` for it.)
