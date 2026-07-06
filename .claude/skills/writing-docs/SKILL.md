---
name: writing-docs
description: How to write documentation, summaries, READMEs, handoffs, and PR descriptions — audience-first structure, lead with the outcome, prose over fragments. Use whenever producing text a human will read later.
---

# Writing Documentation

## The reader is a teammate who stepped away

Every document — README, PR description, handoff, incident note, code walkthrough — is written for someone who was NOT watching you work. They don't know your shorthand, the codenames you invented mid-task, or the dead ends you explored. Concretely:

- Never reference your own process ("as discovered in step 3", "the second approach"). State the fact directly.
- Expand every internal label on first use. If you called something "the fallback path" while working, the doc says what it actually is: "the retry that re-reads from the replica when the primary times out."
- Convert relative time to absolute ("2026-07-06", not "today" or "last week").

## Lead with the outcome

The first sentence answers the question the reader would ask if they said "just give me the TLDR":

- PR description: what the change does and why, one sentence, before any file list.
- Investigation writeup: the conclusion ("the leak is in X, caused by Y"), then the evidence.
- README: what the thing IS and when you'd use it, before install instructions.
- Handoff: current state and the single next action, before the history.

Supporting detail follows for readers who want it. Nobody should have to read paragraph three to learn what happened.

## Readable beats concise

Compression that costs a re-read saves nothing. The rules:

- Complete sentences. No fragment chains, no `A → B → fails` arrows, no invented abbreviations. Cut *content* that doesn't change what the reader does next; never cut *grammar*.
- Spell out technical terms; don't make the reader cross-reference numbering or labels defined elsewhere in the doc.
- Tables only for short enumerable facts (versions, hosts, flags). Explanations live in prose around the table, never crammed into cells.
- Headers/sections only when the document is genuinely multi-topic. A simple answer is a paragraph, not a formatted report. Ceremony signals importance — false ceremony teaches readers to skim you.

## Document decisions, not just facts

The most valuable line in any doc is the one that prevents a future re-litigation: *why* this approach and what was rejected. One sentence each:

- "NFS re-export of the FUSE mount doesn't work (kernel limitation), hence the direct sshfs on the consumer."
- "Chose polling over webhooks because the upstream API's webhooks fire at-most-once."

Without the why, the next person (or the next model) "fixes" the design back to the broken obvious version.

## Keep docs adjacent to what they describe

- Behavior documentation lives closest to the code that implements it (doc comment > module README > repo README > wiki, in order of preference).
- A doc that duplicates what the code plainly says will rot; document the contract and the constraints, not the implementation line-by-line.
- When you change behavior, grep for docs that mention the old behavior in the same change. A stale doc is worse than no doc.

## Faithfulness

Report reality, not the flattering summary of it. If tests fail, the doc says which and shows the output. If a step was skipped, the doc says so. If something is verified, state it plainly without hedging; if it is NOT verified, never imply it is. The reader makes decisions based on this text — an optimistic doc is a trap you set for a colleague.
