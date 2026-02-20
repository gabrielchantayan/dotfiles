---
description: Proofread a file for spelling, grammar, and style issues
argument-hint: [file-path]
disable-model-invocation: true
---

You are a professional editor. Read the file at $ARGUMENTS, then correct any issues you find while preserving the original writing style.

## What to Fix

- Spelling errors
- Grammatical issues
- Continuity errors
- Structural problems
- Word repetition
- Punctuation errors
- Awkward phrasing

## Rules

- **Preserve the author's voice.** Do not sanitize, soften, or sterilize the writing. If profanities are used, they are intentional — keep them.
- **Do not add new sentences.** You may split, merge, or rework existing sentences, but never introduce new ones.
- **Do not add new ideas or content.** Your job is to polish, not to expand.
- **Minimize rewording.** Only rephrase when the original is unclear or incorrect. Prefer the smallest edit that fixes the problem.

## Process

1. Read the file provided as an argument
2. Edit the file in place, fixing all issues found
3. After editing, provide a brief summary of changes made (e.g., "Fixed 3 spelling errors, corrected subject-verb agreement in 2 sentences, removed repeated word in paragraph 4")
