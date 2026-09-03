---
name: minimal-code
description: Use when writing or reviewing any code, and especially when porting a legacy system or building from a long feature brief. Defines what "bare minimum" means in concrete, checkable terms: no defensive checks, no one-use abstractions, no options nobody passes, hard size caps, and extraction rules.
---

# Minimal code

## Objective

Write the least code that solves the problem correctly. Every line must earn its place by doing something a caller needs today.

## The concrete rules

**Never write:**

- An interface with one implementation. Use the class or the function.
- An option, flag, or parameter no caller passes. Add it when a caller appears.
- `readonly` on every field by habit. Use it where mutation would be a bug.
- A helper that wraps one expression used once. Inline it.
- A re-export of a name under a new name.
- A defensive check for a state the type makes impossible. See `parse-dont-validate`.
- A `try/catch` that logs and continues. Let it fail at the boundary that has context.
- A configuration surface for a value that has one setting.
- A "utils" function for a thing one feature does. Keep it in the feature until a second user appears.

**Always:**

- Parse at the boundary, pass typed values, assume them well-formed downstream.
- Prefer a stronger type over a runtime check.
- Prefer a better name over a comment.
- Extract when a unit passes one responsibility, not before.

## Size caps

Enforce with the linter, not with intent:

| Unit | Cap |
| --- | --- |
| Function | 40 lines (60 in UI components) |
| File | 300 lines, measured after the formatter runs |
| Cyclomatic complexity | 10 |
| Nesting depth | 4 |
| Parameters | 5 |

A cap is a signal to extract or to delete, never to compress. Formatter output counts, so a long array written on one line does not buy room.

## Complete versus simple

Given a brief that lists twenty behaviors and says "keep it simple", a builder picks complete, because complete is checkable. Reverse the default: build the smallest version that satisfies the brief, then stop. If a paragraph of the brief needs more than a screen of code, it is either two paragraphs or it is too much.

## When porting legacy code

Legacy code carries the scars of every incident it survived. Port the behavior and the measured numbers. Do not port:

- Guards for inputs the new boundary already rejects.
- Fallbacks for callers that no longer exist.
- Options that were set once and never changed.
- Helper layers that existed because the legacy language lacked a type.

## The review question

For every unit: what breaks if I delete this? If the answer is "nothing today", delete it.

## Checklist

- [ ] No interface with one implementation.
- [ ] No parameter without a caller that passes it.
- [ ] No check on a property the type guarantees.
- [ ] No helper used once for one expression.
- [ ] Every function fits on one screen.
- [ ] Every file under the cap after formatting.
