---
name: naming
description: Use when creating or reviewing any identifier, file name, or fixture name, and especially when porting from a legacy system whose names carry private meaning. Defines self-documenting names and the translate-at-the-boundary rule.
---

# Naming

## Objective

A reader who has never seen the codebase understands every name without a comment and without the author.

## The rules

1. **A name that needs a comment is the wrong name.** Rename until the comment can be deleted.
2. **Legacy identifiers get translated at the boundary.** `camp179-trace.jsonl` means "the trace from campaign 179" to one person. `legacy-run-trace.jsonl` means the same thing to everyone. The translation happens when the file or symbol enters the new system, never later.
3. **Name the thing, not the history.** `newValidator`, `validatorV2`, `legacyParser` describe when it was written. `recordValidator` describes what it is.
4. **Name the value, not the type.** `usersArray` and `configObject` repeat the type. `users` and `config` do not.
5. **Boolean names read as a question with a yes answer.** `isWall`, `hasEmail`, `urlResolves`. Not `wallFlag`, `emailStatus`, `checkUrl`.
6. **Function names are verbs; value names are nouns.** `parseCompanyRows` returns `parsedCompanies`. `groundEvidence` returns a `grounding`.
7. **One term for one concept.** If the domain calls it a `signal`, no file calls it a `match`, a `hit`, or a `lead` for the same thing. Pick once, write it down in the domain `CLAUDE.md`, and hold every agent to it.
8. **Files are kebab-case and say what they hold.** `validate-record-words.ts` holds the word lists for the record validator. `utils.ts` and `helpers.ts` hold nothing anyone can find.
9. **Constants carry their unit.** `SNAPSHOT_TTL_MS`, `MAX_BUDGET_USD`, `KEYWORD_WINDOW_CHARS`. Not `TTL`, `BUDGET`, `WINDOW`.
10. **No abbreviations that are not universal.** `id`, `url`, `csv` yes. `inst`, `cand`, `mtg` no.

## Rename instead of comment

```ts
// Before
const tidy = (s: string) => s.replaceAll(/\s+/g, ' ').trim();   // collapse runs of whitespace
const strip = (line: string) => ...;                              // the comment text without markers

// After
const collapseSpaces = (s: string) => s.replaceAll(/\s+/g, ' ').trim();
const commentText = (line: string) => ...;
```

## When porting

Make a translation table before writing code. Left column: every legacy name that carries private meaning. Right column: the new name. Agents port from the right column. Names not in the table that look opaque get added, not copied.

## Checklist

- [ ] No identifier needs a comment to be understood.
- [ ] No legacy identifier crossed the boundary untranslated.
- [ ] No version, date, or "new"/"old"/"legacy" in a name for a thing that is current.
- [ ] One term per concept, recorded in the domain guide.
- [ ] Every constant with a unit carries it.
