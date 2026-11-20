---
name: scope-discipline
description: Use when a task is large, time is short, or a piece of the request seems optional, wrong, or too expensive. Defines when scope may change (never silently), how to raise a concern without stopping, and what "build it all" means.
---

# Scope discipline

## Objective

The requested scope is the deliverable. It changes only when the owner changes it.

## The rules

1. **Never narrow silently.** Dropping a feature to save time is the owner's call. If you believe a piece must go, say so in one sentence and keep building everything else while you wait. Do not stop, and do not skip it quietly.
2. **Never widen silently.** Adding a lint rule, a helper library, a config surface, or a "while I was in there" refactor that the owner did not ask for is scope creep. It costs review time and trust.
3. **"Build it all" means all.** When the owner says they need everything by a deadline, the deadline pressure is theirs to trade against scope, not yours. Your job is to sequence so that the most important pieces land first and every piece lands.
4. **Concern, then continue.** The shape of a scope concern is: one sentence stating the problem, one sentence stating what you will do unless told otherwise, then continue doing it. Never a paragraph of options, never a question that blocks work.
5. **Ambiguity resolves the way a careful colleague would resolve it.** Make the routine call, state the assumption, move on. Ask only when different readings lead to materially different work and no assumption is safe.
6. **Finish the whole task before reporting done.** If a piece is blocked, finish every other piece in full and name the blocked one with the reason. Scaling the work down is the owner's decision.

## What triggers the wrong move

You are about to narrow scope when you think:

- "This part is not critical." (Whose judgment?)
- "There is not enough time for this." (Say so; do not decide so.)
- "I will do this in a later pass." (Is there one?)
- "The owner probably does not need this." (Ask, in one line, while building.)

You are about to widen scope when you think:

- "While I am here I should also..."
- "A rule would prevent this in future." (See `responding-to-correction`.)
- "It would be cleaner to refactor this first."

## Sequencing under deadline

When everything must land and time is short:

1. Rank the pieces by what the owner loses if it is missing at the deadline.
2. Build in that order.
3. Report progress by piece, not by percent.
4. At the deadline, everything is either done or named as not done with a reason. Nothing is quietly absent.

## The one-line concern

```
The funnel needs the push and leads services first, so it lands last. I am building it after those, not dropping it.
```

Not:

```
I am scoping the funnel out of this wave to hit the deadline.
```

## Checklist

- [ ] Every requested piece is built or named as not built with a reason.
- [ ] Nothing was added that was not asked for.
- [ ] Every scope concern was one sentence, followed by continued work.
- [ ] No question blocked the work while an assumption was safe.
