---
name: create-issues
description: Parse a spec (Notion URL or local file) and create Linear issues with priorities, tags, and blocking relationships
argument-hint: <spec-source> <project>
---

# Create Issues from Specification

Parse a feature specification and create well-structured Linear issues with priorities, tags, blocking relationships, and full context.

## Arguments

This command takes arguments: `$ARGUMENTS`

Expected format: `<spec-source> <project>`

| Parameter | Required | Description |
|-----------|----------|-------------|
| `spec-source` | Yes | Notion URL or local file path (.md, .txt) |
| `project` | Yes | Linear project name or ID |

**Examples:**
```
/create-issues https://www.notion.so/Feature-Spec-2d813b4e... "Eye of Sauron"
/create-issues ./specs/auth-flow.md "Auth Improvements"
/create-issues SPEC.md "Q1 Features"
```

## Workflow

Execute these steps in order:

### Step 1: Ingest Spec

**Notion URL:**
```
mcp__notion__notion-fetch(url: "<notion-url>")
```
Parse markdown content including tables, code blocks, nested structure, callouts, warnings.

**Local File:**
Use `Read` tool to get file contents.

### Step 2: Resolve Project & Team

```
mcp__linear-server__list_projects()
```
Find project by name/ID. Get associated team (issues inherit team). Fail with clear error if not found - suggest similar project names.

### Step 3: Discover Existing Tags

```
mcp__linear-server__list_issue_labels()
```
Build tag index for fuzzy matching. **Never create new tags** - only apply existing ones.

### Step 4: Generate Issues

Analyze the spec to generate 10-20 issues (adjust based on spec complexity). For each issue determine:

**Title:** Descriptive, natural phrasing. AI decides best format per issue.

**Description:** Extract full context:
- Core requirements from relevant spec sections
- Technical implementation notes/hints
- Warnings/notes from spec (colored callouts)
- Acceptance criteria as checkboxes where applicable
- Non-goal context affecting implementation
- Sub-tasks as checkboxes within issue

**Priority:** Infer from context:
- Look for explicit markers ("High priority", "P1", "critical", "must have")
- Consider position in spec (core requirements vs later sections)
- Map to: 1=Urgent, 2=High, 3=Normal, 4=Low

**Tags:** Fuzzy match against existing workspace tags:
- Case-insensitive
- Ignore hyphens/spaces/underscores (`back-end` = `backend`)
- 80% similarity threshold
- Skip if no good match (don't guess wrong tag)

**Blocking Relationships:**
- Infer from structure: data model -> API endpoints, infrastructure -> features
- Look for "requires", "depends on" language
- Scan for Linear issue references (e.g., SUC-XXX pattern)
- Verify referenced issues exist via `mcp__linear-server__get_issue()`

### Step 5: Check for Duplicates

```
mcp__linear-server__list_issues(projectId: "<project-id>")
```
Search existing issues in target project. Mark potential duplicates with warning.

### Step 6: Show Preview

Display all generated issues in this format:

```
## Preview: 15 issues to create in "Eye of Sauron"

Warning: 2 issues may duplicate existing ones (marked with [!])

### Issue 1: Implement Business and Person data models
Priority: High | Tags: backend, database
Blocked by: (none)
Description:
  Create the core data model entities...
  - [ ] Create Business entity with all fields
  - [ ] Create Person entity with all fields
  ...

### Issue 2: [!] Build LinkedIn scraper infrastructure
Priority: Normal | Tags: backend, scraping
Blocked by: Issue 1, SUC-290
Description:
  ...
```

### Step 7: User Approval

Prompt user:
```
Approve all issues? Or list issue numbers to modify/remove (e.g., "modify 3, remove 7"):
```

**Modification options:**
- Edit title, description, priority
- Add/remove tags
- Change blocking relationships
- Remove issue entirely

**Cannot add new issues** - only modify/remove proposed ones.

### Step 8: Create Issues

Create in dependency order:
1. Issues with no blockers first
2. Then issues blocked only by already-created issues

For each issue:
```
mcp__linear-server__create_issue(
  teamId: "<team-id>",
  projectId: "<project-id>",
  title: "...",
  description: "...",
  priority: 2,
  labelIds: ["label-id-1", "label-id-2"]
)
```

Set initial status to "Backlog". **Continue on errors** - track failures, create remaining issues.

### Step 9: Report Results

```
Done: 14 issues created successfully
Failed: 1 issue failed: "Build LinkedIn scraper" - API rate limit exceeded
```

## Preference Persistence

Store learned preferences in `.claude/create-issues-config.json`:

```json
{
  "tagMappings": {
    "scraping": "backend",
    "api": "backend"
  },
  "priorityTendencies": {
    "dataModel": "high",
    "documentation": "low"
  },
  "defaultBlockingPatterns": [
    "dataModel -> api",
    "infrastructure -> features"
  ]
}
```

After user edits during preview, analyze changes and update preferences for future runs.

## Error Handling

| Error | Action |
|-------|--------|
| Notion URL inaccessible | Clear error with URL |
| File not found | Clear error with path |
| Empty spec | Error "Spec appears to be empty" |
| Project not found | List similar project names as suggestions |
| Issue creation fails | Continue with remaining issues, report failures at end |
| No matching tag | Skip silently (don't apply incorrect tag) |

## What NOT to Do

- Do NOT assign users to issues
- Do NOT assign cycles/sprints
- Do NOT assign milestones
- Do NOT create new tags - only use existing ones
