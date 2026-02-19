---
name: spec-interview
description: Use when starting a new feature, refining a rough idea, or needing to extract detailed requirements through structured questioning
argument-hint: <feature-idea, Linear-issue-URL, or spec-file-path>
---

Interview me in depth about this feature or idea using the AskUserQuestion tool. Your goal is to extract a complete, detailed specification through thorough questioning.

## Input

$ARGUMENTS

## Instructions

1. **Start by understanding the input**: It may be a Linear issue ID/link, a rough idea, an existing spec file path, or a brief description.

2. **If a Linear issue is provided**: Fetch the issue details first to understand the context before beginning the interview. Use the Linear MCP.

3. **If a Notion page is provided**: Fetch the page details first to understand the context before beginning the interview. Use the Notion MCP.

4. **If a file path is provided**: Read the file first to understand what exists before interviewing.

5. **Explore the codebase**: Do a deep dive of the codebase. Examine the codebase to understand existing implementations, patterns, and best practices.

6. **Conduct a thorough interview** asking about:
   - Core requirements and goals
   - Technical implementation details
   - UI/UX considerations  
   - Edge cases and error handling
   - Data models and state management
   - API design (if applicable)
   - Performance considerations
   - Security concerns
   - Testing approach
   - Tradeoffs and alternatives considered
   - Dependencies and integrations
   - Migration or rollout strategy
   - Success metrics

7. **Ask non-obvious questions**: Go beyond surface-level requirements. Probe into implications, corner cases, and decisions I may not have considered.

8. **Continue until complete**: Keep asking questions (often 20-40+ for large features) until you have a comprehensive understanding. Don't stop early.

9. **Write the final spec**: Once the interview is complete, generate a detailed specification document and save it to `SPEC.md` in the current directory (or update the provided spec file if one was given).

## Output Format

The final spec should include:
- Overview and goals
- Detailed requirements
- Technical design
- UI/UX specifications  
- Edge cases and error handling
- Testing considerations
- Open questions (if any remain)

Begin the interview now.
