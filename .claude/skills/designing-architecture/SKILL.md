---
name: designing-architecture
description: How to make architecture and design decisions — first-principles redesign, boundary placement, type-driven design, choosing between refactor and bolt-on, and resisting speculative abstraction. Use when a change affects system structure, module boundaries, or data flow.
---

# Designing Architecture

## The foundational-assumption test

For every structural change, run this test before designing anything: **"If this requirement had existed on day one, what would the system look like?"** Sketch that answer honestly — ignore the current code while sketching. Then compare:

- If the current system is close to the sketch, make the incremental change.
- If the current system fights the sketch, the real task is a refactor toward the sketch followed by a now-trivial change. Estimate both paths; the refactor path usually wins on the second occurrence of the requirement, and there is almost always a second occurrence.
- The tell for bolt-on drift: a new boolean flag threaded through five layers, a `handleSpecialCase` branch, parallel `V2` functions, or config that only one caller reads. Each of these means the change contradicts a design assumption — surface that instead of grafting.

## Boundaries do the work

Architecture is mostly deciding where boundaries go and what crosses them:

- **Everything crossing a boundary gets parsed at the boundary.** A module's public functions accept domain types, never raw strings/dicts/JSON. If a module's internals check the validity of their inputs, the boundary is in the wrong place or leaking.
- **Dependencies point inward.** Domain logic imports nothing about transport, storage, or UI. The HTTP handler knows about the domain; the domain doesn't know HTTP exists. When this inverts, testing dies first and flexibility second.
- **One owner per fact.** Every piece of state, config, and derived value has exactly one authoritative home; everything else reads or subscribes. Two sources of truth is one lie waiting to be told.
- Boundaries should sit where change is likely, not where the framework suggests. Ask "which of these two things will change without the other?" — that's where the seam goes.

## Type-driven design (architecture-level parse-don't-validate)

- Design the domain types FIRST, before functions. If the types are right, most functions write themselves; if functions are awkward, suspect the types.
- Make illegal states unrepresentable at the model level: a `Connection` that can't exist unauthenticated beats an `isAuthenticated` flag; a state machine as a union of state-specific types beats a status enum plus nullable fields that "only apply in some states."
- Nullable fields that are "only null before X happens" are two types wearing one name — split them (`DraftOrder` / `PlacedOrder`).
- The compiler is the cheapest reviewer you will ever have; move every invariant you can from runtime checks and docs into types.

## Abstraction discipline

- **Rule of three.** Don't build the general mechanism for the second case; build it when the third arrives and you can see the true axis of variation. Wrong abstractions cost more than duplication — duplication is annoying, a wrong abstraction is load-bearing wrongness.
- No speculative extension points: no plugin systems with one plugin, no interfaces with one implementation, no config for values nobody has asked to configure. YAGNI is an architecture principle, not just a code one.
- When you DO abstract, abstract over the axis that actually varied — not the superficial similarity. Two functions that look alike but change for different reasons must stay separate.
- Prefer boring: the well-known pattern the next reader recognizes beats the clever structure that needs a tour guide. Novelty budget is spent on the problem domain, not the plumbing.

## Deciding under uncertainty

- Enumerate at most 2-3 real options; pick one and say why in one or two sentences. An exhaustive option survey is analysis theater — the decision doc records the road taken and the strongest rejected alternative, nothing else.
- Optimize for reversibility when uncertain: choose the option that's cheapest to walk back, not the one that's best if all assumptions hold.
- Design for deletion. The best measure of a module boundary: how hard would it be to delete this module entirely? If deleting a feature means surgery across ten files, the boundaries failed.
- Validate the riskiest assumption with the smallest possible probe (a spike script, a benchmark on real data, one end-to-end slice) before committing the full design to it.
