---
name: asd-ste100-prd
description: Use when writing or rewriting product requirement documents (PRDs), technical specifications, implementation plans, acceptance criteria, or other product and engineering requirements with ASD-STE100 controlled technical English principles.
---

# ASD-STE100 Product Documents

Write clear, testable product and engineering documents. Apply ASD-STE100 controlled technical English principles without copying or reconstructing the ASD-STE100 dictionary.

## Scope And Caveat

Use this skill for PRDs, technical specifications, implementation plans, and acceptance criteria. Preserve the author's intent and the system's actual behavior.

This skill applies ASD-STE100 principles.

## Workflow

### Write A New Document

1. Identify the document type, audience, scope, and decision owner.
2. Collect the problem, user need, constraints, dependencies, risks, and evidence.
3. Separate confirmed facts from assumptions and open questions.
4. Define important terms before you write requirements.
5. Create the minimum structure that the document needs.
6. Write each requirement as one testable statement.
7. Add acceptance criteria for each user-visible or system-visible outcome.
8. Run the ambiguity checks and the self-review checklist.

Use these sections when they add information:

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
9. Compare the rewrite with the source for omissions and semantic changes.
10. Report material ambiguities instead of inventing decisions.

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

Give each requirement a stable identifier when the document needs traceability. Use this pattern:

`REQ-001: When <condition>, <actor> must <observable behavior> within <limit>.`

Use tables for comparable facts. Do not put multi-paragraph reasoning in a table. Give each row one subject and each column one data type.

Write acceptance criteria as observable pass or fail conditions. Include the initial state, action or event, expected result, and limit when each element is relevant.

| ID | Initial state or condition | Action or event | Expected result |
| --- | --- | --- | --- |
| AC-001 | The user has a valid session. | The user submits a valid form. | The system must save the record and show its identifier within 2 seconds. |

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
- [ ] Tables contain comparable data and clear headings.
- [ ] Quantities, limits, time periods, and error states are explicit.
- [ ] Assumptions and open questions are visible.
- [ ] The rewrite preserves all source decisions and requirement strength.
