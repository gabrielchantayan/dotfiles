---
name: reusing-before-writing
description: Use when about to write a new helper, type, enum, constant, hook, component, repository, endpoint, prompt string, or email or CSV builder, or when deciding which folder a new file belongs in.
---

# Reusing Before Writing

## Overview

"This already exists" and "this goes in the X folder" were the second-largest group of review comments in every repo. The rules were written down. Agents did not search before they wrote code. Searching is a required step, not a guideline.

## Required search

Before you create a symbol, run two searches:

```bash
rg -n -i '<likely name>|<synonym>' <repo>/src   # e.g. 'pluralize|plural', 'debounce', 'escapeRegex|escape'
rg -n '<distinctive literal or shape>' <repo>    # e.g. the enum values, the URL path, the column name
```

Then find the sibling feature: the existing feature closest to yours (another email body, another CSV export, another integration, another paginated list). Open its files and copy its structure: base class, pagination style, component, folder. If a sibling exists and you do not follow it, say why in the PR body.

Do not add a new dependency (for example `lodash`) for something a helper in the repo already does.

## Where things go

Follow the existing layout of the repo. This table shows a typical layout for each stack.

| Stack | Types, enums | Shared helpers | Constants and config | Other |
|---|---|---|---|---|
| Python API | `app/types/` | `app/utils/` | `app/config.py` | Logic lives in `app/services/`. Routes parse input and call one service. |
| TypeScript backend | `src/types/` | `src/utils/<domain>/` | config module | Prompt text lives in `src/prompts/`. Repositories extend the shared base repository. |
| React UI | next to the feature, or `src/types/` if shared | `src/lib/`, `src/hooks/` | feature constants file | UI primitives come from the shared component library. |
| Go services | `internal/types` | `internal/utils` (package funcs) | `config.yaml` via viper | Construction lives in the owning package. Dev and eval tools live under `cmd/<tool>/`. |

Additional rules:

- A type used by two features lives in the shared types folder, not in one feature's folder.
- A low-level package must not import or name its callers.
- A model or schema does not live inside a client or service file.
- A prompt longer than two lines never lives inline in a service.

## Red flags

- "I'll write a quick helper."
- "It's only a few lines, so duplication is fine." Reviewers flag three copies of 25 lines.
- "I didn't see a component for this." (You did not search the shared component library.)
- An inline template literal of ten lines or more inside a service.
