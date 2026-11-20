---
name: scoping-by-tenant-and-user
description: Use when writing a query that fetches rows by id or id list, a React Query or other client cache key, an auth or permission check, a service-to-service call, or code that acts with a cached token or impersonation grant.
---

# Scoping by Tenant and User

## Overview

Reviewers found cross-tenant leaks in three forms. A query fetched signals by id with no owner filter. A query key had no user or org id, so user B saw user A's cached permissions after sign-in. A tool kept a cached token after the grant was revoked. Every read and every cache entry must carry the identity it belongs to.

## Rules

**Every query by id also filters by owner.**
```go
// bad
Where(sq.Eq{"s.id": ids})
// good
Where(sq.Eq{"s.id": ids, "s.institution_id": pl.InstitutionID})
```
An id from a request, a job payload, or a model tool call is input. It does not prove access.

**Every cache key includes the identity the data depends on.**
```ts
// bad: survives sign-out and org switch
useQuery({ queryKey: ['org-permissions'], queryFn });
// good
useQuery({
  queryKey: ['org-permissions', userId, orgId],
  queryFn,
  enabled: Boolean(userId && orgId),
});
```
The default `staleTime` in `nationgraph-ui` is long. A missing key segment shows stale data from another account for many minutes. An action on "the current org" (checkout, add credits) must use the org id from the same place the UI shows, not from a separate cache.

**Reuse the existing auth dependency.** Do not hardcode a service name, subject, or scope list in a route. Find the existing permission dependency in the repo (`rg -n 'Depends\(' app/dependencies`) and use it.

**Keep scopes on every path.** A fallback path (owner token, service token) must check the same scopes as the main path. A broader role must not bypass a narrower scope.

**Re-check revocable grants at use time.** If a session, grant, or impersonation can be revoked, check it before each write, not only when the token was cached.

**Joins that can produce NULL.** `LEFT JOIN` to a users table makes `banned` NULL for deleted users, and `banned IS NOT TRUE` then passes. Filter out the NULL rows explicitly.

## Red flags

- `WHERE id = ANY($1)` with nothing else
- A query key array with only a string literal
- A string literal of a service name in an auth check
- "The caller already checked access."
