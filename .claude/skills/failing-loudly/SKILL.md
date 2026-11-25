---
name: failing-loudly
description: Use when writing error handling, catch blocks, retries, fallbacks, defaults, limits, counts, or loading and permission states, and when a function aggregates results from several sources, pages, or items.
---

# Failing Loudly

## Overview

Across every stack, reviewers kept finding failures that looked like success. A per-source error was logged and dropped, so the endpoint returned 200 with zero counts. An export stopped at 100k rows and reported "completed". A catch block never ran because the thunk does not throw. An LLM agent consumes many API responses, and it treats a wrong answer given with confidence as the truth.

## Rules

| Pattern | Rule |
|---|---|
| Log-and-continue over items or sources | Fail the whole call, or return the failures in the result type. Never return partial data as if it were complete. |
| Zero value for "unknown" (`0`, `""`, `false`, missing map key) | Parse into a type that has no "unknown" value at the boundary. An unknown key is an error at config load, not a default priority of `0`. |
| Silent cap (`LIMIT 100000`, `CSV_EXPORT_LIMIT`) | Remove the cap, or fail when the input exceeds it. |
| Silent fallback for bad input (`sort_by` becomes `due_date`, any `sort_order` other than `"desc"` becomes asc) | Type the input as an enum or `Literal`. The framework then returns 422. |
| Raw exceptions from bad input (`UUID(x)`, `entry["id"]`) | Type path params (`account_id: UUID`). Parse JSON into a model at the repo boundary. Bad input returns 4xx with a clear message, never 500. |
| Counts computed before filtering | Count after the last filter or enrichment step. |
| Empty-string pointers in JSON (`"next_cursor": ""`) | Treat empty as absent at the parse step, or pagination loops forever. |
| Unbounded retry predicate | Bound the attempts and retry only transient errors: `retry: (n, e) => n < 3 && e.status >= 500`. |

## UI async paths

```ts
// bad: dispatch never throws, so the catch is dead code
try { await dispatch(pushThunk(args)); } catch { toast.error('Failed'); }
// good
try { await dispatch(pushThunk(args)).unwrap(); } catch { toast.error('Failed'); }
finally { setIsPushing(false); }   // the spinner stops on every path

// bad: a failed lookup looks like "no permission"
if (!isLoading && !data?.canManage) showRequestCredits();
// good
if (isSuccess && !data.canManage) showRequestCredits();
if (isError) showError();
```

Show "not found" only for a 404. Show a real error for every other failure.

## Error layering (API)

Services raise domain errors. Routes map domain errors to HTTP status codes. A service never raises `HTTPException`. Do not wrap every `await` in `try/except`. Catch only where you can map an error to a specific response.

## Red flags

- `catch { continue }` or `except Exception: pass`
- `return nil` after an error in a handler
- `?? 0`, `|| ''`, or `.get(key, 0)` on data that must exist
- A limit constant that nobody sees when it is reached
