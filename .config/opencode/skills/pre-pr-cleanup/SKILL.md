---
name: pre-pr-cleanup
description: Deep analysis of code changes against a reference branch to identify cleanup opportunities before creating a PR
---

# Pre-PR Cleanup Analysis

## Core Principle

Before creating a PR, analyze all changes against the reference branch to catch dead code, cleanup artifacts, abstraction opportunities, and quality issues that should be addressed first.

## When to Use

- Before running `/pr` or creating a pull request
- After completing a feature but before requesting review
- When you want to ensure code quality before submission
- To catch debug statements, unused code, and other artifacts

## Reference Branch Detection

1. If argument provided: use `origin/{arg}` or `{arg}` as specified
2. Otherwise auto-detect in order:
   - `origin/staging` (if exists)
   - `origin/dev` (if exists)
   - `origin/main` (if exists)
   - `origin/master` (fallback)

To check which branches exist:
```bash
git branch -r | grep -E 'origin/(staging|dev|main|master)$'
```

## Cleanup Categories

### 1. Dead Code Detection (Critical)

Look for code added in the diff that is never used:

- **Unused imports**: Import statements for modules/symbols not referenced
- **Unused variables/constants**: Declared but never read
- **Unreachable code**: Code after return/throw/break that can't execute
- **Orphaned functions**: Functions defined but never called within the changeset
- **Commented-out code**: Old code that should be deleted, not commented

Detection approach:
- For each new import, grep for its usage in the file
- For each new variable/const, check if it's referenced after declaration
- Look for code blocks after unconditional returns

### 2. Cleanup Artifacts (Critical)

Development artifacts that must not reach production:

- **Debug statements**: `console.log`, `console.debug`, `print()`, `debugger`, `binding.pry`, `pdb.set_trace()`
- **TODO/FIXME in new code**: Comments indicating unfinished work
- **Temporary workarounds**: Comments like "hack", "temporary", "remove later"
- **Test data**: Hardcoded test values, mock data left in production code
- **Disabled code**: `if (false)`, `if (0)`, feature flags set to always-off

Detection patterns:
```
console\.(log|debug|info|warn|error)\(
debugger;?
binding\.pry
pdb\.set_trace
# TODO|FIXME|HACK|XXX|TEMP
```

### 3. Abstraction & Reuse Opportunities (Important)

Patterns suggesting code could be cleaner:

- **Duplicate code blocks**: 3+ lines repeated with minor variations
- **Magic numbers/strings**: Hardcoded values that should be named constants
- **Copy-paste patterns**: Similar logic that differs only in variable names
- **Repeated conditionals**: Same condition checked in multiple places
- **Inline complex expressions**: Long expressions that deserve a named variable

Questions to ask:
- "Is this same logic written elsewhere in the diff?"
- "Would a constant make this more readable?"
- "Could this be a helper function?"

### 4. Code Quality Improvements (Important)

Structural issues affecting maintainability:

- **Long functions**: Functions over ~50 lines that could be split
- **Deep nesting**: More than 3-4 levels of indentation
- **Multiple responsibilities**: Functions doing unrelated things
- **Inconsistent naming**: camelCase mixed with snake_case, unclear names
- **Missing type annotations**: In TypeScript projects, untyped parameters/returns
- **Complex conditionals**: Boolean expressions that need simplification

Look for:
- Functions with multiple unrelated code sections
- Nested if/else chains that could use early returns
- Variables named `temp`, `data`, `result`, `x`, `i` (except loop counters)

### 5. Documentation Gaps (Minor)

Missing context for complex or public code:

- **Exported functions without JSDoc/docstrings**: Public API needs documentation
- **Complex algorithms without explanation**: Non-obvious logic needs comments
- **Non-intuitive return values**: Functions returning magic values or complex structures
- **Side effects**: Functions that modify external state without indication
- **Error conditions**: What exceptions/errors can be thrown

Note: Don't over-document. Simple, self-explanatory code doesn't need comments.

## Workflow

### Step 1: Detect Reference Branch

```bash
# Check for staging first, then dev, then main
for branch in staging dev main master; do
  if git rev-parse --verify "origin/$branch" >/dev/null 2>&1; then
    REF_BRANCH="origin/$branch"
    break
  fi
done
```

If user provided argument, use that instead.

### Step 2: Get Changed Files

```bash
git diff $REF_BRANCH...HEAD --name-only --diff-filter=ACMR
```

Only analyze Added, Copied, Modified, Renamed files (not deleted).

### Step 3: Get Diff Content

```bash
git diff $REF_BRANCH...HEAD
```

Focus analysis on lines starting with `+` (additions).

### Step 4: Analyze Each Category

For each changed file:
1. Read the full current file content
2. Identify new code from the diff
3. Check each category's patterns
4. Record findings with file:line references

### Step 5: Generate Report

Create a markdown report organized by priority:

```markdown
# Pre-PR Cleanup Report

**Branch**: feature/my-feature
**Reference**: origin/main
**Files Changed**: 12

## Critical (Must Fix)

### Dead Code
- `src/utils/helper.ts:45` - Unused import `lodash`
- `src/components/Form.tsx:123` - Variable `oldValue` declared but never used

### Cleanup Artifacts
- `src/api/client.ts:67` - Debug statement: `console.log('response:', data)`
- `src/services/auth.ts:89` - TODO comment in new code

## Important (Should Fix)

### Abstraction Opportunities
- `src/handlers/user.ts:34-45` and `src/handlers/admin.ts:56-67` - Duplicate validation logic

### Code Quality
- `src/utils/parser.ts:parseData` - Function is 78 lines, consider splitting

## Minor (Nice to Fix)

### Documentation
- `src/api/endpoints.ts:fetchUser` - Exported function lacks JSDoc
```

### Step 6: Create TodoWrite Items

After generating the report, create TodoWrite items for actionable fixes:

```
- Fix: Remove unused import 'lodash' in helper.ts
- Fix: Remove console.log in client.ts:67
- Fix: Address TODO in auth.ts:89 or remove
- Consider: Extract duplicate validation logic to shared function
- Consider: Split parseData function in parser.ts
```

## Output Format

Always produce:
1. **Markdown report** - Displayed to user with full context
2. **TodoWrite items** - For tracking fixes (Critical items as todos, others as considerations)

## Priority Levels

| Priority | Category | Action |
|----------|----------|--------|
| Critical | Dead Code, Cleanup Artifacts | Must fix before PR |
| Important | Abstraction, Quality | Should fix if time permits |
| Minor | Documentation | Nice to have |

## Red Flags

If you find any of these, always flag them:

- `console.log` or `debugger` in production code
- Passwords, API keys, or secrets in code
- `any` type in TypeScript where a proper type exists
- Empty catch blocks that swallow errors
- Disabled tests (`it.skip`, `@pytest.mark.skip`)
- Large commented-out code blocks (>5 lines)

## Example Session

```
User: /pre-pr-cleanup

Assistant: I'll analyze your changes against the reference branch for cleanup opportunities.

[Detects origin/main as reference branch]
[Gets diff: 5 files changed]
[Analyzes each file for all categories]

# Pre-PR Cleanup Report

**Branch**: feature/user-settings
**Reference**: origin/main
**Files Changed**: 5

## Critical (Must Fix)

### Cleanup Artifacts
- `src/api/settings.ts:34` - Debug statement: `console.log('settings:', data)`

## Important (Should Fix)

### Code Quality
- `src/utils/validate.ts:validateForm` - Function has 62 lines, consider extracting validation rules

## Minor (Nice to Fix)

No issues found.

---

I've created TodoWrite items for the critical fix. Would you like me to address these issues?
```
