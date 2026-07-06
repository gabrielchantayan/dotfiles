---
name: writing-plans
description: How to investigate, scope, and write implementation plans — evidence-first planning, plan structure, altitude control, and when to stop planning and act. Use before any multi-step task or when asked to plan.
---

# Writing Plans

## Investigate first, plan second

A plan written before reading the code is fiction. Before writing a single plan step:

- Read the files the change will touch. Not skim — read, until you can name the exact functions/types that change.
- Find the precedent: the last time someone added a similar feature/endpoint/migration, what files did that commit touch? That file list IS your plan skeleton.
- Identify the load-bearing uncertainty: the one thing that, if wrong, invalidates the plan (an API you assume exists, a schema you assume is mutable, a library version). Resolve *that* during planning — run the command, read the dependency, check the version. Everything else can stay an assumption.

## Redesign from first principles before committing to increments

Before writing steps, ask: "if this requirement had existed on day one, what would the design be?" Write that target down in one paragraph. Then choose:

- If the incremental path lands on the target design → plan the increments.
- If the incremental path lands on a bolt-on (a second boolean, a parallel code path, a `V2` suffix) → plan the small refactor that makes the change natural, THEN the change. Two clean steps beat one grafted one.

## Plan structure

A good plan has exactly these parts:

1. **Context** — 2-4 sentences: what exists now, what's wanted, and why the chosen approach over the obvious alternative. If you considered and rejected an approach, one sentence on why (this prevents relitigating it later).
2. **Steps** — each step names the files touched and the observable result when it's done. "Update the parser" is not a step; "`parser.ts`: add `parseCursor()` returning `Cursor | ParseError`; existing callers unchanged" is a step. Steps should be independently verifiable — after each one, the tree compiles and tests pass.
3. **Verification** — the exact commands/actions that prove the whole thing works, decided *now*, not after implementation. If you can't state how you'll verify it, you don't understand the task yet.
4. **Risks** — only real ones with a consequence and a reaction ("if the index rebuild is slow on 14TB, fall back to X"). No ceremonial risk lists.

## Altitude control

- Plan at the altitude of decisions, not keystrokes. Name the files and the shape of the change; don't paste the diff you intend to write into the plan.
- One plan should fit in one screen. If it doesn't, either the task should be split into phases delivered separately, or you're planning at too low an altitude.
- Sequence by risk, not by convenience: the step most likely to reveal a wrong assumption goes FIRST, even if it's not the natural build order. Discover the invalidating fact on step 1, not step 7.

## When to stop planning

- Stop when every remaining unknown is cheaper to resolve by doing than by investigating. Planning past that point is procrastination with structure.
- A one-file, obvious-fix task gets no written plan — a single sentence of intent, then the edit. Ceremony scales with risk and scope, never with habit.
- Mid-execution, when reality contradicts the plan: stop, say so explicitly, amend the plan visibly. Don't silently drift — a plan you're no longer following is worse than no plan, because it *looks* like control.
