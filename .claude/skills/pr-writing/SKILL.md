---
name: pr-writing
description: Use when you write or update a pull request title or body, or when a command needs PR description content.
---

# PR Writing

Write the PR title and body in ASD-STE100 (Simplified Technical English). Keep the body short. State what the change does, then state what changed.

If the repository has a PR template, fill that template. Apply the language rules below to every field you write.

## Title

```
<type>(<scope>): <description>
```

- `type` is one of `feat`, `fix`, `docs`, `refactor`, `perf`, `test`, `chore`.
- `scope` is optional. Use a noun for the affected area.
- Write `description` in sentence case and in the imperative form.

Example: `fix(arrows): correct the binding for rotated shapes`

## Body

```md
## What it does

<One to three sentences. Present tense. State the behavior after the merge.>

## What changed

- `path/or/Symbol` — <one sentence>
```

- Write **What it does** as the current behavior of the system, not as a story of the work.
- Write one **What changed** bullet for each meaningful change. Name the file, module, or symbol in code formatting.
- Omit a section that adds no information.
- Link the issue or ticket on its own line. Do not require the reader to open it.

## Language rules

- Put one fact in each sentence.
- Write short sentences.
- Use the active voice and the present tense. Put the actor before the action.
- Put the condition before the action.
- Use one term for one concept.
- Use `must` for a mandatory behavior, `must not` for a prohibition, and `can` for a capability. Do not use `should` or `may`.
- Do not use idioms, metaphors, or decorative language.
- Write code symbols, paths, and table names exactly, in code formatting.

## Do not write

- History. Do not write "previously", "used to", "this replaces". Git holds the history.
- A line-by-line restatement of the diff.
- Vague value claims such as "improves the user experience" or "cleans things up".
- Title case, emoji, or a motivational summary.
- A "Generated with Claude Code" line or a Claude co-author trailer, unless the PR changes Claude Code itself.

## Example

**Bad**

> This PR is a big refactor that improves how we handle uploads. Previously the
> code was pretty messy and would sometimes fail silently, so I cleaned it up and
> also fixed a few other things along the way. Should be much better now! 🚀

**Good**

> ## What it does
>
> The upload service validates a file before it writes the file to storage. If
> validation fails, the service returns the error code to the caller.
>
> ## What changed
>
> - `src/upload/parse.ts` — parses the request into an `UploadRequest` at the boundary.
> - `src/upload/service.ts` — accepts `UploadRequest` and removes the internal checks.

## Checklist

- [ ] The title uses the conventional format and sentence case.
- [ ] **What it does** states behavior in the present tense.
- [ ] Each **What changed** bullet names a real file, module, or symbol.
- [ ] The body contains no history and no vague value claims.
- [ ] Each sentence contains one fact.
