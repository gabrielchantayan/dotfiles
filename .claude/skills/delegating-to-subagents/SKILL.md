---
name: delegating-to-subagents
description: Use before launching any subagent to write or change code, especially when fanning out several agents in parallel. Covers the pilot slice, the exemplar, the mechanical gate, the brief shape, ownership, and how to treat an agent's report.
---

# Delegating to subagents

## Objective

A subagent produces code that passes the owner's read on the first look. The owner never sees agent output before you have.

## The order of operations

1. **Pilot one slice yourself or with one agent.** Pick the smallest module with a real comment, a real type boundary, and a real function over 20 lines. Get it to the accepted bar. Read every line.
2. **Make the pilot the exemplar.** Name the file in every later brief: "open `<path>` before you write a line; that is the accepted style."
3. **Turn every prose rule into a gate or an exemplar.** If a property matters and no machine checks it and no file shows it, do not delegate it yet.
4. **Write the brief.** Size budget first, then ownership, then features, then the report format.
5. **Launch.** Parallel agents only when their file lists do not overlap.
6. **Read the output yourself before anything else happens.** See `read-before-you-ship`.

## The brief

Open with the size budget, not the feature list:

```
SIMPLICITY FIRST. Write the least code that does the job. Parse each input once
at the boundary; never check it again. No abstraction with one use. No option
nobody passes. If a paragraph below needs more than a screen of code, build the
smallest version that satisfies it and stop. Simple beats complete.
```

Then, in this order:

- **Read first:** the exemplar file(s), the relevant `CLAUDE.md` files, the gate script.
- **You own:** an explicit file list. Nothing else.
- **Shared files:** which ones, and the re-read-before-edit rule.
- **Features:** what to build, with the legacy source to read.
- **Tests:** the exact count and names allowed, or "none".
- **Report:** the exact commands to run and paste, the file list, what is unfinished. "Do not commit."

## What a brief must never do

- State a quality rule in prose only ("keep comments short") with no number, no gate, and no exemplar.
- List every legacy behavior without saying which to drop when the size budget bites.
- Leave test count to the agent.
- Leave file ownership implicit.
- Ask for "complete" anything. Ask for "the smallest version that satisfies."

## Treating the report

An agent's report is a claim. Read it for two things only: the file list and the exact gate output. "All gates green" without pasted output is not a result. "I verified" without the command is not verification. Never relay a claim to the owner as your finding.

## Model and scale

Use the strongest model available for anything that touches style, because style is where weaker models drift. More agents is not faster if you cannot read their output before the owner does. Four agents you read beat eight you skim.

## Checklist before launch

- [ ] One pilot slice passed my own read.
- [ ] Every quality rule has a gate or an exemplar.
- [ ] Brief opens with the size budget.
- [ ] Explicit file list per agent; shared-file protocol written.
- [ ] Test budget stated as a number.
- [ ] Report format demands pasted command output.
