---
name: generate-docs
description: Generate comprehensive technical documentation for a feature/component by analyzing code, APIs, data models, and dependencies
argument-hint: <feature-path-or-name>
---

# Generate Feature Documentation

Automatically generate comprehensive, technical documentation for a feature or component by analyzing its code.

## Arguments

$ARGUMENTS

**Supported input formats:**
- Path-based: `/generate-docs src/features/authentication`
- Feature name: `/generate-docs --name UserAuthentication`
- Interactive: `/generate-docs` (will prompt for feature)

## Workflow

### Step 1: Identify Feature

**If path provided:** Verify the path exists and scan for source files.

**If `--name` provided:** Search the codebase for matching files/folders:
```
Glob: **/*{feature-name}*/**/*
Grep: class.*{FeatureName}|function.*{featureName}|export.*{FeatureName}
```

**If no arguments (interactive mode):**
Use AskUserQuestion to ask: "What feature do you want to document? Provide a path or feature name."

### Step 2: Scan & Analyze Code

Gather all relevant files for the feature. Use Glob and Read tools to:

1. **Find all source files** in the feature directory/matching the feature name
2. **Identify entry points** - main exports, index files, route handlers
3. **Trace dependencies** - imports from other modules
4. **Detect patterns:**
   - API routes (Express: `app.get()`, `router.post()`, FastAPI: `@app.get()`, etc.)
   - Data models (interfaces, types, classes, schemas)
   - Configuration usage (env vars, config files)

### Step 3: Extract Documentation Content

Analyze the code to extract:

**Overview & Components:**
- Feature purpose and main responsibilities
- Identify distinct components/services within the feature
- Write a high-level summary paragraph

**File Structure:**
- Map all relevant files across the codebase (services, APIs, models, repositories)
- Organize files by category (e.g., Core Files, API Files, Models, Repositories)
- Include brief descriptions of each file's purpose
- Use tree-style formatting with `├──` and `└──` characters

**API Endpoints (if applicable):**
For each detected endpoint, document:
- HTTP method and full path with prefix
- Authentication requirements
- All parameters (path, query, body) with types and defaults
- Processing steps (what the endpoint does internally)
- Full JSON response examples with realistic data
- All status codes with meanings (inline format: `200 (success), 400 (invalid), ...`)

**Data Flows:**
- Map the complete flow from user action to database/result
- Use ASCII tree diagrams with `└─>`, `├─`, `│` characters
- Show service calls, sub-steps, and nested operations
- Include column mappings, configuration lookups, and transformations

**Key Classes & Functions:**
- Document each major class/service with file location
- Create tables with Method, Purpose, Key Parameters, Returns columns
- List key validations, features, or behaviors
- For data models, list fields by category and document validators

**Integration Points:**
- Document how the feature connects to other services
- Include job processing, caching, external services
- Map the repository layer and key methods
- Show API router registration with code snippets

**Technical Considerations:**
- Performance & Scalability (rate limits, pagination, concurrency)
- Data Quality (deduplication, normalization, validation)
- Error Handling (retries, failure modes, cleanup)

### Step 4: Generate Documentation

Create a comprehensive Markdown document with this structure:

```markdown
# [Feature Name]

# Comprehensive Analysis of the [Feature Name]

## Overview

[High-level description of the feature's purpose and responsibility. Write 1-2 paragraphs explaining what this feature does and its main components.]

[If there are multiple distinct components/services, list them here:]

1. **[Component 1 Name]** - [Brief description]
2. **[Component 2 Name]** - [Brief description]

---

# 1. FILE STRUCTURE AND ORGANIZATION

## [Section Name, e.g., "Core Files" or "Service Files"]

```
/path/to/feature/
├── file1.ext              (Description of file purpose)
├── file2.ext              (Description of file purpose)
└── subfolder/
    ├── nested_file.ext    (Description)
    └── another_file.ext   (Description)

/related/path/
├── related_file.ext       (Description)
└── another.ext            (Description)
```

[Add additional file structure sections as needed for different areas of the codebase]

---

# 2. API ENDPOINTS

## [Endpoint Group Name] (prefix: `/api/[prefix]`)

### [Endpoint Name]

- **Endpoint:** `[METHOD] /path`
- **Authentication:** [Required/Not required] ([type if applicable])
- **Input Parameters:**
    - `param_name` ([location: query/path/body]): [Description] ([required/optional])
- **Processing:**
    - [Step 1 of what happens]
    - [Step 2]
    - [Step 3]
- **Output Format:**

```json
{
  "success": true,
  "field": "value",
  "nested": {
    "example": "data"
  }
}
```

- **Status Codes:** [code] ([meaning]), [code] ([meaning]), ...

---

### [Next Endpoint Name]

- **Endpoint:** `[METHOD] /path/{path_param}`
- **Authentication:** [Required/Not required]
- **Path Parameters:**
    - `path_param` ([required/optional]): [Description]
- **Query Parameters:**
    - `param_name` ([default: value]): [Description]
- **Request Body:**

```json
{
  "field": "type/example",
  "another_field": "description"
}
```

- **Processing:** [Description of what the endpoint does]
- **Output Format:** [Same as [Other Endpoint] OR show JSON example]
- **Status Codes:** [code] ([meaning]), [code] ([meaning]), ...

---

[Continue with all endpoints in this format]

---

# 3. DATA FLOW

## [Flow Name, e.g., "CSV Upload to Database Flow"]

```
1. [First major step]
   └─> [Action or endpoint]
       ├─ [Sub-step 1]
       ├─ [Sub-step 2]
       │  ├─ [Nested detail]
       │  └─ [Nested detail]
       │
       ├─ [Sub-step 3]
       │  └─> [Service or function call]
       │
       └─ [Final sub-step]

2. [Second major step]
   └─> [Action]
       ├─ [Detail]
       └─ [Detail]

3. [Third major step]
   └─> [Result]:
       ├─ [Outcome 1]
       ├─ [Outcome 2]
       └─ [Outcome 3]
```

## [Additional Context, e.g., "Column Mapping" or "Configuration"]

**[Mapping/Config Name]:**

- "[alias1]" / "[alias2]" → `canonical_name`
- "[alias3]" → `another_name`

**[List Name]:**

field1, field2, field3, field4, field5

## [Another Flow Name]

```
1. [Step description]
   └─> [Action]
       ├─ [Detail]
       ├─ [Detail]
       │
       └─ [Nested process]:
          ├─ [Sub-detail]
          ├─ [Sub-detail]
          └─ [Sub-detail]
```

---

# 4. KEY CLASSES AND FUNCTIONS

## [ClassName or ServiceName]

File: `path/to/file.ext`

| Method | Purpose | Key Parameters | Returns |
| --- | --- | --- | --- |
| `method_name(params)` | [What it does] | `type` param description | `ReturnType` description |
| `another_method(params)` | [What it does] | `type` param | `ReturnType` |

**Key Validations/Features:**

- [Validation or feature 1]
- [Validation or feature 2]
- [Validation or feature 3]

---

## [Another ClassName]

File: `path/to/another_file.ext`

| Method | Purpose | [Custom Column Name] |
| --- | --- | --- |
| `method_name(params)` | [Purpose] | [Details] |
| `another_method(params)` | [Purpose] | [Details] |

---

## [Data Model Name]

File: `path/to/model.ext`

**Key Fields:**

- [Category 1]: field1, field2, field3
- [Category 2]: field4, field5
- [Category 3]: field6, field7, field8

**Key Database Fields (if applicable):**

field1 (type, constraints), field2 (type), field3 (type), ...

**Validators/Config:**

- [Validator or config detail 1]
- [Validator or config detail 2]

---

# 5. INTEGRATION POINTS

## [Integration Name, e.g., "Job Processing Integration"]

Location: `path/to/file.ext`

- [Integration detail 1]
- [Integration detail 2]
- [Integration detail 3]

**[Lifecycle/Process Name]:**

1. [STATE1] → 2. [STATE2] → 3. [STATE3] or [STATE4]
- [Additional detail]
- [Additional detail]

---

## [Another Integration Name]

Service: `path/to/service.ext`

- [Detail]
- [Detail]
- [Detail]

---

## [Third Integration Name]

Location: `path/to/location.ext`

- [Detail 1]
- [Detail 2]
- [Detail 3]

**Related Services:**

- `ServiceName` - [Description]
- `AnotherService` - [Description]

---

## Repository Layer

**Repositories:**

- `RepositoryName` - [Description]
- `AnotherRepository` - [Description]

**Key Repository Methods:**

- `method_name(params)`
- `another_method(params)`

---

## [Registration/Configuration Section, e.g., "API Router Registration"]

File: `path/to/file.ext:line_number`

```python
# or relevant language
example_registration_code()
```

Routes/Resources registered at:

- `/path/to/route1` - [Description]
- `/path/to/route2` - [Description]

---

# Key Technical Considerations

## Performance & Scalability

- **[Consideration 1]:** [Details]
- **[Consideration 2]:** [Details]
- **[Consideration 3]:** [Details]

## Data Quality

- **[Consideration 1]:** [Details]
- **[Consideration 2]:** [Details]
- **[Consideration 3]:** [Details]

## Error Handling

- **[Consideration 1]:** [Details]
- **[Consideration 2]:** [Details]
- **[Consideration 3]:** [Details]
```

### Step 5: Validate Documentation

Compare generated documentation against source code:
- Verify API paths exist in code
- Check data model fields match actual definitions
- Flag any inconsistencies with warnings

If unable to fully analyze something, mark with: "**Note:** Could not fully determine [aspect]. [Ask clarifying question if needed]"

### Step 6: Save Documentation

1. Create `docs/` directory if it doesn't exist
2. Save to `docs/[FeatureName].md`
3. If file exists, overwrite completely (no merging)

### Step 7: Report Results

Display summary:
```
Documentation generated: docs/[FeatureName].md

Documented:
- Overview with [N] components identified
- File structure across [N] directories
- [N] API endpoints with full request/response examples
- [N] data flows mapped
- [N] key classes/services with method tables
- [N] integration points
- Technical considerations (performance, data quality, error handling)

[Any warnings about incomplete analysis]
```

### Step 8: Notion Integration (Optional)

Ask user: "Would you like to add this to Notion? (yes/no)"

**If yes:**
- Check for Notion MCP availability
- Use `mcp__notion__create-page` or similar to create/update page
- API documentation should be in a separate, linked subpage
- Provide link to created or updated main page

**If no:**
- Confirm local save location
- Mention they can manually add later

## Handling Issues

**Feature not found:**
- Error: "Could not locate feature at specified path"
- Suggest similar-looking paths/names found via fuzzy search
- Offer interactive selection

**No APIs detected:**
- Omit API section or note: "No HTTP endpoints detected in this feature"
- Continue documenting other aspects

**Ambiguous data models:**
- Ask user: "Multiple data models detected. Which is the primary one?"
- Document all with user clarification

**Code too complex:**
- Generate partial documentation for what's understood
- List specific questions about unclear parts
- Accept user input to fill gaps

## Important Notes

- Generate comprehensive documentation - don't skip sections unless truly not applicable
- Use ASCII tree diagrams (`├──`, `└──`, `└─>`, `├─`, `│`) for file structures and data flows
- Include realistic, complete JSON examples in API docs (not truncated)
- Use tables for classes/functions with Method, Purpose, Parameters, Returns columns
- Keep tone technical and concise
- Document integration points thoroughly - how this feature connects to the rest of the system
- Include technical considerations (performance, data quality, error handling) at the end
- Always validate against source before finalizing
