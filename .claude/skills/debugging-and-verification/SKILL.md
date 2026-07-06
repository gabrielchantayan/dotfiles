---
name: debugging-and-verification
description: How to debug failures and verify work — evidence before hypotheses, one-variable changes, reproduce-first discipline, and the verification standard required before claiming anything works. Use for any bug, test failure, unexpected behavior, or before declaring work done.
---

# Debugging and Verification

## Debugging: evidence before hypotheses

1. **Reproduce first.** Before theorizing, make the failure happen on demand with the smallest trigger you can find. A bug you can't reproduce is a bug you can't prove you fixed. If it's intermittent, first invest in making it deterministic (fixed seed, forced timing, captured input) — that's progress, even though it feels like a detour.
2. **Read the actual error.** The full text, the full stack, the first error in the log (not the last — cascading failures bury the cause under consequences). Most debugging time is wasted on a paraphrase of the error rather than the error.
3. **Locate before you fix.** Form a hypothesis that names a specific line/function/state, then design the cheapest observation that would DISPROVE it (a log line, a breakpoint, a bisect, a git bisect, commenting out one path). A hypothesis you can't test is a guess; a fix based on a guess is a coin flip that also edits your code.
4. **Change one variable at a time.** If you changed three things and it works, you've learned nothing and shipped two superstitions. Back out the two that weren't the fix.
5. **Pattern-match with suspicion.** A signal that looks like a known failure may have a different cause — before any state-changing remediation (restart, delete, config edit), confirm the evidence supports *that specific* diagnosis, not just the familiar shape of it.
6. **Fix the cause, then explain the symptom.** A correct fix makes the original symptom's mechanism obvious in hindsight. If you can't narrate *why* the bug produced exactly that behavior, you probably fixed a co-incident, not the cause — keep looking.
7. When stuck: re-read the code you're SURE is fine (the bug lives in an assumption, and assumptions live where you stopped looking), diff against the last known-good state, and shrink the reproduction further.

## Verification: the standard for "done"

"It should work" is not a state of the world. Before claiming complete, fixed, or passing:

- **Run the thing.** Tests, type checker, linter, build — whichever exist. For behavior changes, exercise the actual behavior at least once (run the app, hit the endpoint, execute the script) — a green unit suite doesn't prove the wiring.
- **Verify the failure mode too.** If the task was "reject invalid input", show it rejecting invalid input, not just accepting valid input.
- **Check for collateral damage** proportional to the blast radius: a shared helper change means running the callers' tests, not just the new one.
- **Evidence in the report.** State what command was run and what it output ("`pytest tests/parser` — 42 passed"), not an adjective ("tests pass"). If a check was skipped or can't be run in this environment, say so explicitly rather than letting silence imply coverage.
- Verification criteria are decided when the work is planned, not improvised after — if you finish and don't know how to verify, that's a planning defect worth noting.

## Reporting failures

If it's broken, say broken, with the output attached. Never soften a red result into "mostly working" and never bury the failure in paragraph four. The person reading acts on your report; an optimistic report converts your bug into their incident.
