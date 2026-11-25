---
name: writing-race-safe-data-changes
description: Use when code checks whether a row exists or is available and then writes, claims a queued or pending item, calls an external integration after reading state, does several writes that must succeed together, writes an upsert or ON CONFLICT clause, or looks up rows by a polymorphic source id.
---

# Writing Race-Safe Data Changes

## Overview

Two requests can run the same code at the same time. Reviewers found check-then-write races that created duplicate names, double integration writes from one card, `ON CONFLICT` clauses with no matching constraint, and lookups by `source_id` alone that matched other resource types.

## Rules

**Let the database enforce uniqueness.** Do not check first.
```python
# bad
if not await repo.name_exists(name):
    await repo.create(name)
# good: unique index on the normalized name
try:
    await repo.create(name)
except IntegrityError:
    raise NameTakenError(name)   # the route maps this to 409
```

**Claim with a conditional update.** The state in the `WHERE` clause is the lock.
```sql
UPDATE app.tasks SET stage = 'executing'
WHERE id = $1 AND stage = 'queued'
RETURNING id;   -- no row returned: another worker claimed it
```

**Claim before an external side effect.** Persist `running` or `claimed` before you call Slack, HubSpot, email, or an LLM. If you call first and write the state later, two requests both call.

**One unit of work, one commit.** Writes that must succeed together share one session or transaction and commit once, in the service. Repositories do not commit on their own.

**An upsert needs a real constraint.** `ON CONFLICT (a, b)` requires a unique index on exactly `(a, b)`. If the function is named `bulk_upsert`, it must upsert. Check the migration.

**Polymorphic identity is composite.** A row keyed by a source has the identity `(source_type, source_id)`. Every lookup, delete, upsert, primary key, and unique index uses both columns.

**Never pick `[0]`.** If a query can return more than one match, either the key is wrong or the code must choose by an explicit rule. `existing[0]` is the oldest row by accident, not by intent.

## Red flags

- `exists()` or `find()` followed by `create()` or `update()`
- `SELECT` then `UPDATE` on a `status` or `stage` column without the status in the `WHERE` clause
- `session.commit()` inside a repository method
- `WHERE source_id = ?` without `source_type`
- `rows[0]`, `existing[0]`, `.first()` on a list that can hold two rows
