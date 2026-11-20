---
name: writing-safe-migrations
description: Use when writing a Postgres migration in a shared migrations repo, an Atlas migration in a Go service, or an in-app Drizzle migration, especially one that adds a constraint, foreign key, index, NOT NULL column, or backfill.
---

# Writing Safe Migrations

## Overview

Reviewers blocked migrations that would take an `ACCESS EXCLUSIVE` lock on a busy table, add a constraint that existing rows violate, or read a schema in a different RDS instance. A migration runs once against production data, so it must be safe on the first try.

## Rules

**Bound every lock.**
```sql
SET lock_timeout = '5s';
```
Put this at the top of any migration that alters an existing table. Without it, a waiting `ALTER` blocks every reader and writer queued behind it.

**Add constraints in two steps.**
```sql
ALTER TABLE app.x ADD CONSTRAINT x_y_fk FOREIGN KEY (y_id) REFERENCES app.y(id) NOT VALID;
-- then, in the same file or a later one:
ALTER TABLE app.x VALIDATE CONSTRAINT x_y_fk;
```
The same applies to `CHECK` constraints.

**Build indexes concurrently.** Use `CREATE INDEX CONCURRENTLY`, in its own migration file, because it cannot run inside a transaction.

**Add columns nullable first.** Add the column as nullable, backfill it, then set `NOT NULL` in a later migration. Set `NOT NULL` where the domain requires a value. Do not leave it nullable forever.

**Prove the data precondition.** If a constraint, unique index, or `NOT NULL` needs existing rows to comply, write the read-only pre-flight `SELECT` that must return 0. Put it in the PR body with its result from production.

**Stay in your database.** A migration can only touch schemas in the RDS instance it runs against. `auth."user"` lives in a separate instance. A backfill that needs it belongs in an application job, not a migration.

**One concern per migration.** Do not add an unrelated FK change or cleanup to the file.

**Use composite keys for polymorphic sources.** A unique index or primary key on source rows uses `(source_type, source_id)`.

**Follow the repo mechanics.** Migrations are forward-only. Run `atlas migrate hash` after every edit. Do not commit Drizzle snapshots or generated migrations unless the PR is for them.

## Red flags

- `ALTER TABLE` with no `lock_timeout`
- `ADD CONSTRAINT ... FOREIGN KEY` without `NOT VALID` on a table with data
- `CREATE INDEX` without `CONCURRENTLY` on an existing table
- `ADD COLUMN ... NOT NULL` without a default on a table with data
- A reference to a schema this database does not own
