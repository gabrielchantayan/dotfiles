---
name: parallel-agent-ownership
description: Use when two or more agents (or an agent and you) edit the same repository at the same time, or when resuming an agent after the tree changed. Defines file ownership, the shared-file protocol, the frozen-set rule, and what a resumed agent must be told.
---

# Parallel agent ownership

## Objective

No agent edits a file it does not own. No agent undoes work it did not see happen. Shared files change by the smallest additive edit after a fresh read.

## Ownership

Every brief carries an explicit file list under "You own". Anything not on the list is read-only for that agent. "Additive changes to shared/*" is not a file list; name the files.

Two agents never own the same file. If a feature needs a file another agent owns, the second agent writes against the shape the first agent's brief describes and notes the dependency in its report.

## Shared files

Some files every workstream touches: the composition root, the barrel export, the route mount, the package scripts, the schema index. For each one:

1. Name it in every brief as shared.
2. Rule: re-read the file immediately before every edit. Not at the start of the task; immediately before.
3. Rule: smallest additive edit. Append your lines. Never reorder, never rename, never replace another agent's block.
4. Rule: if the file has no section for you yet, add only your own lines and say so in the report.

## The frozen set

When you have hand-fixed something during a wave (a test list, an exemplar file, a renamed fixture), it is frozen. Write it in the project's `CLAUDE.md` before the next agent launches, and name it in the brief: "The test set is frozen at these five files. Do not add, edit, or delete a test."

An agent with "clean up tests" in its brief and no frozen list will recreate the tests you deleted.

## Resumed agents

An agent resumed after the tree changed has a stale picture. Before you resume it, tell it in the message:

- Which files changed since it stopped, and by whom.
- Which things are now frozen.
- Which of its earlier intentions are now void.

If you cannot list those, do not resume it; start a fresh agent with a current brief.

## Sequencing versus parallelism

Run in parallel only the agents whose file lists do not intersect and whose work does not depend on the other's output. A depends on B means A starts after B reports, or A codes against B's declared shape and says so.

## Detecting collisions

After each wave, before reading for quality, run the gate. A collision shows as a duplicate export, a missing member, or a type mismatch in a shared file. Fix the shared file yourself; do not send two agents back at it.

## Checklist

- [ ] Every brief has an explicit "You own" file list.
- [ ] Shared files are named with the re-read-before-edit rule.
- [ ] Every hand-fixed set is written down as frozen before the next launch.
- [ ] No resumed agent runs without a "what changed" message.
- [ ] Parallel agents have disjoint file lists.
