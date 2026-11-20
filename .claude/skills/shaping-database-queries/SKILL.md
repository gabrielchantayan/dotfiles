---
name: shaping-database-queries
description: Use when writing a Drizzle, SQLModel, SQLAlchemy, or squirrel query, a repository method, a loop that reads or writes rows, a filter on a JSON or JSONB column, a `sql` template fragment, or code that can touch thousands of rows.
---

# Shaping Database Queries

## Overview

Reviewers flagged query shape in every backend repo. The frequent problems were JSONB used as a query key, selecting every column, one update per row in a loop, unindexed lookup keys, and repository methods that hide business logic behind vague names. Performance concerns at NationGraph scale are real. Tables reach tens of thousands of rows.

## Rules

| Problem | Rule |
|---|---|
| Filter on a JSONB field (`metadata->>'action'`) | Never query by JSONB. Promote the field to a real column or an event type. Never create a JSON index as a workaround. |
| Inline `sql` fragment (`sql\`lower(trim(${c}))\``, `::date`) | Use the query builder operator. A raw fragment is raw SQL even when it is not `db.execute`. |
| `SELECT *` or a full model load to read two fields | Select only the columns the caller uses. |
| Hydrating rows to count them | Use `COUNT(*)` in SQL. |
| `for row in rows: await update(row)` | Batch it: one `UPDATE ... FROM (VALUES ...)` or bulk insert per chunk of about 500. |
| Reading an unbounded set | Paginate or chunk (about 2k per page). Large `IN (...)` lists hit the bind-parameter limit, so chunk them too. |
| `flush()` inside a loop | Flush once after the loop. |
| A new lookup or join key | Confirm an index exists on it, or add one in a migration. |
| Two nested loops over the same result | Build a map once, then look up. |

## Repository methods

- The name shows I/O: `get_`, `find_`, `fetch_`, `list_`, `count_`. A reader must know a call hits the database.
- The name tells the truth: `_by_institution_ids` takes a list, not one id.
- Parameterize. Do not hardcode business values: `get_signal_settings_by_status(user_id, status)`, not `user_has_active_signal_setting(user_id)`.
- No business logic. A repository reads and writes. The service decides what an empty list means.

```python
# bad
async def user_has_active_signal_setting(self, user_id) -> bool: ...
# good
async def get_signal_settings_by_status(self, user_id: UUID, status: SettingStatus) -> list[SignalSetting]: ...
```

## Red flags

- `->>`, `->`, `jsonb_` inside a query
- `sql\`` inside a repository for something the builder supports
- `await` on a write inside a `for` loop
- A method name with no verb, like `count_filtered` or `active_settings`
