---
name: comment-budget
description: Use when writing, reviewing, or cleaning up code comments and doc comments (JSDoc, docstrings). Defines the manual-entry style, the measurable budget, the banned words, and the bad-to-good rewrite pattern. Applies to every language.
---

# Comment budget

## Objective

A comment is a manual entry. It says what a thing is, or what it returns. It never says why, how it came to be, or what it used to be.

## The test for every comment

Delete the comment. Does the name already say it? Then the comment stays deleted. If not, can you rename the thing so the name says it? Then rename and stay deleted. Only if neither works, write one sentence that states what the thing is.

## The measurable budget

Enforce these with a script that fails the build. Prose rules alone do not survive contact with a long task.

| Property | Limit |
| --- | --- |
| Doc comment | 1 to 2 lines |
| Inline comment | 1 to 2 lines |
| Inline comments per file | 3 |
| Comment lines per file | 15 percent |
| Words per sentence | 20 |
| Tense | Present |
| Person | None. No `we`, `our`, `I`. |

Banned words and phrases, because each one signals history, opinion, or story: `was`, `were`, `had`, `previously`, `no longer`, `used to`, `replaces`, `originally`, `we`, `our`, `I`, `actually`, `simply`, `just`, `whatever`, `nobody`, `the point`, `on purpose`, `worth`, `matters`, `honest`, `silently`, `quietly`, `the whole`.

## What a comment can say

- What a constant is, when the name does not say it: `/** Phrases that show the buyer is unhappy with its current vendor. */`
- A measured threshold with its number: `/** A repair needs 2 shared content words and a similarity ratio of 0.12. */`
- What a function returns, when the signature does not say it: `/** Returns the span of a passage that holds the quote, ignoring case. */`
- What a field holds, when the type does not say it: `/** NationGraph's typed id, such as `city_550213830`. */`

## What a comment must never say

- Why the design is this way.
- What the code did before.
- What someone learned or measured to arrive here.
- A metaphor, a quip, a lesson, a warning to future readers.
- Anything the name or the type already says.

## Bad to good

```
// Bad: story, reason, history
/** On-record dissatisfaction with the incumbent, as a board actually says it. */
/** Eight months put the floor in the previous year and made "recent" untrue. */
/** A new person owns the function that buys this. New leaders reopen specifications. */
// Tuned on the legacy run so a wall never counts as a miss.

// Good: manual entry
/** Phrases that show the buyer is unhappy with its current vendor. */
/** The lookback window is 6 months. */
/** Phrases that show a new leader in the function that buys. */
(deleted; the name `wallIsNotMiss` says it)
```

## Metric versus intent

A comment can be short and still be a story. "Tuned on live data" is four words of history. The checker catches length and banned words. The exemplar file and the review catch intent. Use both.

## When porting legacy code

Legacy comments are the worst source of story. Read them for the number, keep the number, drop everything else.
