---
name: designing-retryable-jobs
description: Use when writing or changing a nationgraph-worker processor, a Celery task, a scheduled or recurring job, a background goroutine, or any code that publishes status, sends notifications, or writes a terminal state from inside a job that can retry or time out.
---

# Designing Retryable Jobs

## Overview

The worker framework retries a failed job. Reviewers found jobs that published "failed" on every attempt, retried errors that can never succeed, demoted a `Cancelled` row to `Failed` in a recovery `defer`, lost writes when the process timeout cancelled the context, and crashed the whole worker from a goroutine panic. Every job must be correct when it runs twice, stops halfway, or times out.

## Rules

**User-visible effects happen once.** Return the error and let the framework retry quietly. Publish `failed`, send the bell, and write the failed row in `HandleAfterRetriesExhausted` only.
```go
// bad
if err != nil { p.publish(ctx, "failed"); return err }
// good
if err != nil { return fmt.Errorf("render page: %w", err) }
func (p *P) HandleAfterRetriesExhausted(ctx context.Context, job Job) error { return p.publish(ctx, "failed") }
```

**Do not retry what cannot succeed.** Bad input, a missing row, or a budget that is already spent is non-retryable. Parse the payload at the start of the job and return a distinct non-retryable error. Share the same parse function between the enqueuer and the processor.

**Never overwrite a terminal state.** A write in a recovery path must not change `Cancelled` or `Completed`. Put the allowed source states in the `WHERE` clause. Never force it.

**Never `return nil` after a failure.** If a handler gives up, it records a `failed` row. Worker logs alone are not a record.

**Be idempotent across attempts.** Keep checkpoints (turn counters, cursors, processed ids) in storage so attempt 2 resumes. It must not re-pay for LLM calls that attempt 1 already persisted.

**Context budgets.**
```go
persistCtx := context.WithoutCancel(ctx)                       // final writes survive the process timeout
llmCtx, cancel := context.WithTimeout(ctx, cfg.Claude.Timeout) // inner budget < process_timeout
defer cancel()
```
- Do not set `http.Client.Timeout` on a streaming (SSE) client. Use a context deadline.
- Inner timeouts plus `Retry-After` waits must stay below the job's process timeout.
- In a loop over items, check `ctx.Err()` between items.

**Goroutines.** Every `go func()` recovers panics into an error, because a panic in a background goroutine kills every job in the process. Do not publish partial results from a goroutine before the job decides its final outcome.

**Celery** follows the same rules: `autoretry_for` only transient errors, set terminal state in the final failure handler, and make the task idempotent.

## Red flags

- `publish`, `notify`, or `status = failed` next to `return err`
- `forceUpdate=true` in a `defer`
- `return nil` inside `if err != nil`
- `go func()` with no `recover`
