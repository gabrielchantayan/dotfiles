---
name: writing-code
description: How to write, edit, and structure code — read-first discipline, parse-don't-validate, extraction, comments, error handling, and verification. Use before implementing any feature, fix, or refactor.
---

# Writing Code

## The order of operations is non-negotiable

1. **Read before you write.** Never edit a file you haven't read. Never call a function whose signature you're guessing at. Before implementing, read: the file you're changing, its immediate callers, one or two sibling files that solve a similar problem. The siblings tell you the house style; the callers tell you the real contract.
2. **Find the existing pattern.** Almost every change has a precedent in the codebase — an existing endpoint, an existing component, an existing migration. Clone the pattern's *shape*, not its bugs. If your change looks structurally alien next to its neighbors, you did it wrong even if it works.
3. **Write the least code that solves the problem correctly.** Not the least code that compiles — the least code that is *correct*, including edge cases the types can't rule out. Minimal ≠ lazy. Minimal means every line earns its place.
4. **Verify before claiming done.** Run the tests. Run the linter. Run the type checker. If none exist, execute the code path by hand (a scratch script, a curl, a REPL). "It should work" is not a state of the world; it's a confession.

## Parse, don't validate (the operational version)

The principle is in CLAUDE.md; here is how to actually apply it while coding:

- The moment data crosses a boundary (HTTP handler, file read, env var, CLI arg, DB row → domain), convert it to a domain type in ONE place. That function's return type is the evidence the check happened: `parseEmail(s: string): EmailAddress | ParseError`, never `isValidEmail(s: string): boolean`.
- If you catch yourself writing `if (!x) throw` deep inside domain logic, stop. That's not a fix, that's a symptom. Walk the value back to where it entered the system and strengthen the type there. The deep check then becomes unreachable and you delete it.
- Prefer constructions that make the illegal state unrepresentable over checks that reject it:
  - status string → union/enum type
  - two booleans that can't both be true → one three-variant union
  - list that must be non-empty → `[T, ...T[]]` / `NonEmptyList<T>`
  - "id that must exist in the map" → hold the value, not the id
- Parse *completely* before acting. If step 3 of processing can fail on malformed input, steps 1–2 should never have run. Structure: `parse(input) → Domain` then `execute(domain)`, never interleaved.

## Extraction and structure

- Extract when a unit accrues a second responsibility, not at a line count. A 60-line function doing one thing is fine; a 15-line function doing two things gets split.
- The extracted unit gets a name that states *what it computes*, not *where it's used* (`formatMoney`, not `renderInvoiceTotalHelper`).
- Placement rule: if the helper mentions nothing feature-specific, it goes in the shared utility module immediately — not "later." Feature-coupled helpers stay next to the feature.
- React: state lives in the container; children are controlled and presentational. If a child owns state that a sibling needs, lift it *now* — this refactor only gets more expensive.

## Comments

- Write a comment only for what the code cannot say: an invariant, a non-obvious constraint, a "this looks wrong but isn't, because…". Never narrate ("increment the counter"), never editorialize about the change ("fixed the bug here"), never leave notes to the reviewer in the source.
- Match the file's existing comment density. A heavily-commented codebase expects doc comments on exports; a sparse one reads extra comments as noise.

## Error handling

- Never swallow. No empty catch, no `catch (e) { console.log(e) }` and carry on, no `// eslint-disable` to silence a warning you don't understand. A warning you don't understand is a task, not an obstacle.
- Errors belong at the boundary where context exists to report them well. Domain code that received parsed types should have almost no error paths — if it does, ask what boundary leaked.
- When a tool/test/build fails, report the actual output, not a paraphrase of it, and fix the cause, not the message.

## Editing discipline

- Small, surgical diffs. Don't reformat lines you aren't changing; don't "improve" adjacent code unless asked — mention it instead.
- Never leave the tree in a half-state: if a rename touches 12 call sites, touch all 12 in the same change.
- If a simple fix works, use the simple fix. Reach for abstraction only when the third concrete case appears, not the second.
