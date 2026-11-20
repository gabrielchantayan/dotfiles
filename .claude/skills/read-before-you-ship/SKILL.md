---
name: read-before-you-ship
description: Use before presenting, committing, or reporting any code you did not write line by line yourself, including subagent output, generated code, and large refactors. Defines what to read, how much, and what counts as verified.
---

# Read before you ship

## Objective

No code reaches the owner or the repository before a person, meaning you, has read a representative sample against the acceptance bar.

## Why this exists

Gates prove the floor: it compiles, it lints, the tests pass. They do not prove that a comment tells a story, that a function re-checks its own types, that a helper wraps one line, or that a name means nothing. The first reader finds those. Make sure the first reader is you.

## What to read

For a delivery of N files, open at least:

- Every file the brief called the center of the work (the service, the engine, the main component).
- One file from each folder touched.
- The largest file.
- Any file whose name you would not have chosen.
- Every test file, in full.

Read the files, not the diff. A diff hides what surrounds it.

## What to look for

| Look for | Fail if |
| --- | --- |
| Comments | Any comment explains a reason, a history, or a design. Any comment restates the name. |
| Checks | A function checks a property its parameter type already guarantees. |
| Abstractions | An interface with one implementation. An option no caller passes. A helper used once wrapping one expression. |
| Size | A function you must scroll. A file over the cap after formatting. |
| Names | Any identifier you would need the author to explain. Any legacy identifier ported as-is. |
| Tests | Any test outside the agreed list. Any test that pins an implementation detail. |
| Reports | Any claim in the report you cannot see in the code. |

## What "verified" means

You may say a thing is verified only when:

- You ran the gate command yourself and saw the output, or
- You opened the file and read the lines in question.

Otherwise say "the agent reports" and name what you did not check.

## Cost

Reading a wave takes twenty minutes. Rewriting a wave takes a night. Read.

## Checklist

- [ ] Gate run by me, output seen by me, zero violations.
- [ ] Center files read in full.
- [ ] One file per folder read.
- [ ] Largest file read.
- [ ] Every test file read.
- [ ] Anything I did not read is named in the report as unread.
