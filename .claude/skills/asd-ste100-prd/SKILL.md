---
name: asd-ste100-prd
description: Use when writing or rewriting PRDs, technical specifications, implementation plans, or acceptance criteria. Apply ASD-STE100 controlled technical English principles. PRDs use hierarchical § section numbers, a table of contents, REQ-xxx requirements, a phased implementation plan, and AC-xxx acceptance tables.
---

# ASD-STE100 Product Documents

Write clear, testable product and engineering documents. Apply ASD-STE100 controlled technical English principles without copying or reconstructing the ASD-STE100 dictionary.

## Scope And Caveat

Use this skill for PRDs, technical specifications, implementation plans, and acceptance criteria. Preserve the author's intent and the system's actual behavior.

This skill applies ASD-STE100 principles. It cannot claim formal ASD-STE100 conformance without the licensed specification, the licensed dictionary, and a formal checker.

## Workflow

### Write A New Document

1. Identify the document type, audience, scope, and decision owner.
2. Collect the problem, user need, constraints, dependencies, risks, and evidence.
3. Separate confirmed facts from assumptions and open questions.
4. Define important terms before you write requirements.
5. Create the minimum structure that the document needs. For a PRD, apply the required format below.
6. Write each requirement as one testable statement with a stable `REQ-xxx` identifier.
7. Add a phased implementation plan and an `AC-xxx` acceptance table.
8. Check section numbering, the table of contents, requirement coverage, ambiguity, and the self-review checklist.

Every PRD must include a table of contents, product requirements, an implementation plan, and acceptance criteria. Add the following sections when they provide information:

- Summary
- Problem
- Goals
- Non-goals
- Users and use cases
- Requirements
- Technical design
- Data and interfaces
- Dependencies and risks
- Implementation plan
- Acceptance criteria
- Open questions

### Rewrite An Existing Document

1. Read the complete source before you edit it.
2. Extract all requirements, decisions, constraints, and unresolved questions.
3. Preserve technical meaning, requirement strength, identifiers, values, and boundaries.
4. Build or update the terminology table.
5. Split long sentences and mixed requirements.
6. Replace vague words with measurable conditions.
7. Change passive constructions to active voice when the actor is known.
8. Keep uncertainty explicit when evidence is missing.
9. Apply the PRD format below. Preserve existing requirement and acceptance IDs. Compare the rewrite with the source for omissions and semantic changes.
10. Report material ambiguities instead of inventing decisions.

## Required PRD Format

### Notion Destination

- Create a Notion PRD as a private workspace-level page: call `notion-create-pages` with `creation_mode: "draft"` and no `parent`.
- Do not create a PRD in a shared database or teamspace page (for example, the Engineering "Resources" database), even when earlier PRDs live there.
- Use a shared destination only when the user names it in the current request.

### Section Numbers And Table Of Contents

- Number every body heading with `§` and its hierarchical section number: `§1`, `§1.2`, `§1.2.4`.
- Match the number depth to the heading depth. Start child counters at 1 under each parent. Do not skip a heading level.
- Keep the page title and the table of contents outside the section sequence.
- In Notion, use native heading blocks and a native table of contents near the top of the page. Do not substitute a manually maintained list.
- In Markdown, use linked table-of-contents entries that match the numbered headings.
- Use numbered cross-references, such as `§10.1 Data Model`. After a structural edit, update the section numbers, cross-references, and any manual table of contents together.
- Section numbers express document structure. `REQ-xxx` and `AC-xxx` identify requirements and acceptance cases independently of that structure.
- Do not add empty sections, decorative callouts, or status metadata only to fill a template.

Example body headings:

```markdown
# §1 Summary
# §2 Product Requirements
## §2.1 Access Controls
### §2.1.1 Session Expiry
# §3 Implementation Plan
## §3.1 Phase 1: Access Controls
# §4 Acceptance Criteria
```

### Product Requirements

- Put requirements in a dedicated Product Requirements section. Group related requirements under numbered subsections.
- Give every requirement a unique, stable, zero-padded ID: `REQ-001`, `REQ-002`, and so on.
- Start each requirement with its ID, for example: `**REQ-001:** The service must reject an expired session.`
- State one testable behavior per requirement. Name its actor and relevant condition, boundary, and observable result.
- Preserve existing IDs during revisions. Do not renumber them when sections move. Do not reuse an ID for a different requirement.
- Keep background evidence, design rationale, and open questions separate from requirements.

### Implementation Plan

- Include a dedicated Implementation Plan section with numbered phase subsections.
- Order phases by real dependencies. Within each phase, use numbered imperative steps.
- Identify concrete deliverables and completion checks. Include migration, cutover, and rollback steps when the change needs them.
- Reference relevant `REQ-xxx` and `AC-xxx` IDs where the reference clarifies scope or verification.
- Do not invent dates, owners, estimates, or additional work. Do not describe planned work as implemented or verified.

### Acceptance Criteria

- Include a dedicated Acceptance Criteria section with a table.
- Use these columns: `ID`, `Condition`, `Action`, and `Expected result`.
- Give every case a unique, stable, zero-padded ID: `AC-001`, `AC-002`, and so on.
- Preserve existing acceptance IDs during revisions. Do not reuse an ID for a different case.
- State an observable pass or fail result. Include relevant failures, boundaries, and state transitions, not only successful execution.
- Cover each requirement's observable behavior. Add requirement references when they clarify coverage.
- Use native header-row tables in Notion. Keep each row concise; put extended reasoning outside the table.

## Terminology

Create a terminology table near the start of a long document. Use one preferred term for each concept.

| Concept | Preferred term | Avoid | Definition |
| --- | --- | --- | --- |
| Person who uses the product | user | customer, operator, end user | Use the role that the product model defines. |
| Required behavior | must | should, needs to, is expected to | The behavior is mandatory. |
| Prohibited behavior | must not | should not, may not | The behavior is prohibited. |
| Permitted behavior or capability | can | may, is able to | The behavior is permitted or possible. |
| Unresolved item | open question | TBD, unclear | A decision that has an owner or needs an owner. |

Do not reproduce an ASD-STE100 approved-word dictionary. Prefer common, concrete words. Use a specialized term only when it is necessary. Define that term at its first use or in the terminology table.

Do not change technical identifiers. Preserve API names, code symbols, database fields, command names, file paths, event names, protocol terms, branded terms, and literal UI text exactly. Put identifiers and literals in code formatting or quotation marks when useful.

## Controlled Language Rules

### Words And Terms

- Use one term for one concept.
- Use one meaning for each term.
- Prefer approved common words when you know them.
- Do not claim that a word is ASD-STE100-approved unless you checked the licensed dictionary.
- Avoid idioms, slang, metaphors, and decorative language.
- Define abbreviations at first use unless the audience always knows them.
- Avoid noun clusters when a short phrase is clearer.

### Sentences And Paragraphs

- Write one instruction or requirement in each sentence.
- Keep sentences short enough to parse on the first reading.
- Put the actor before the action.
- Use active voice when the actor is known.
- Use positive instructions unless a prohibition is necessary.
- Put conditions before the required action.
- Use a list when three or more parallel items occur.
- Keep one topic in each paragraph.
- Start a paragraph with its main point.
- Prefer direct technical statements over narrative introductions or repeated summaries.
- Separate observed current behavior from proposed behavior and unresolved decisions.
- Do not add unrequested mechanisms, candidate work, or arbitrary limits to make a document appear complete.
- Do not hide requirements in background paragraphs.

### Procedures

- Use the imperative form for procedural steps.
- Put one action in each numbered step.
- State prerequisites before the procedure.
- State the expected result after a step when verification is necessary.
- Put warnings before the action that can cause harm or data loss.

### Modal Requirements

- Use `must` for a mandatory requirement.
- Use `must not` for a prohibition.
- Use `can` for permission, capability, or a possible result.
- Do not use `should` for a requirement.
- Do not use `may` when `can` states the intended meaning.
- Use present tense for facts and system behavior.
- Do not weaken or strengthen a source requirement during a rewrite.

## Requirements And Tables

Every PRD requirement must have a stable `REQ-xxx` identifier. For other document types, add identifiers when traceability is needed. Use this pattern:

`REQ-001: When <condition>, <actor> must <observable behavior> within <limit>.`

Use tables for comparable facts. Do not put multi-paragraph reasoning in a table. Give each row one subject and each column one data type.

Every PRD must have an `AC-xxx` acceptance table. Write acceptance criteria as observable pass or fail conditions. Include the initial state, action or event, expected result, and limit when each element is relevant. Use only source-supported limits.

| ID | Condition | Action | Expected result |
| --- | --- | --- | --- |
| AC-001 | The user's session has expired. | The user submits a save request. | The service must reject the request as unauthenticated and leave the record unchanged. |

Do not use acceptance criteria such as "works correctly," "is user-friendly," or "handles errors." Name the exact behavior, error, state, quantity, or time limit.

## Ambiguity Checks

Check each sentence for these defects:

- An omitted actor
- An unclear pronoun such as `it`, `this`, or `they`
- A vague quantity such as `some`, `many`, `fast`, or `large`
- An undefined frequency such as `usually` or `periodically`
- An open boundary such as `etc.` or `and so on`
- A hidden option in `and/or`
- A weak requirement such as `should`, `ideally`, or `where possible`
- More than one requirement in one sentence
- A condition with no result
- An exception with no boundary
- A requirement that cannot be tested
- A term that has multiple names

If the source is ambiguous, preserve the known facts and add an open question. Do not guess.

## Before And After

**Before:** The system should quickly process uploads and notify users if they fail.

**After:** The upload service must process a file of 10 MB or less within 5 seconds. If processing fails, the upload service must show the user the error code and a recovery action.

**Before:** Once the settings have been changed, it can be restarted.

**After:** After the administrator changes the settings, the administrator can restart the service.

**Before:** Validate and save the form, then send an email.

**After:**

1. Validate the form.
2. Save the form.
3. Send the confirmation email.

## Final Self-Review

- [ ] The document states its audience, scope, goals, and non-goals.
- [ ] The terminology table defines necessary domain terms.
- [ ] One preferred term identifies each concept.
- [ ] Technical identifiers and literal values are unchanged.
- [ ] Each sentence contains one instruction or requirement.
- [ ] Known actors perform actions in active voice.
- [ ] Procedures use imperative steps with one action per step.
- [ ] `must`, `must not`, and `can` have consistent meanings.
- [ ] Every requirement is necessary, unambiguous, and testable.
- [ ] Acceptance criteria state observable pass or fail results.
- [ ] Every PRD body heading has a hierarchical `§` number that matches its depth.
- [ ] The PRD has a table of contents near the top. Its entries and section references match the current headings.
- [ ] Every PRD requirement has a unique, stable `REQ-xxx` ID.
- [ ] The implementation plan has ordered phases, concrete steps, and completion checks.
- [ ] The acceptance table uses `AC-xxx` IDs and the Condition, Action, and Expected result columns.
- [ ] Acceptance cases cover the observable requirements and relevant failure conditions.
- [ ] Current facts, proposed behavior, and open questions remain distinct.
- [ ] Tables contain comparable data and clear headings.
- [ ] Quantities, limits, time periods, and error states are explicit.
- [ ] Assumptions and open questions are visible.
- [ ] The rewrite preserves all source decisions and requirement strength.
- [ ] The document does not claim formal ASD-STE100 conformance.
