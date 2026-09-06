---
name: test-writing
description: Use when selecting, writing, changing, or reviewing automated tests, including unit, integration, component, and end-to-end tests. Also use when deciding test scope, mocks, fixtures, assertions, coverage, or how to test a critical workflow.
---

# Test Writing

## Objective

Write the smallest set of reliable tests that proves important public behavior.

Optimize for signal, not test count. A test adds value when its failure gives strong evidence that user-visible or consumer-visible behavior is broken. A large suite of weak or brittle tests hides failures and reduces trust.

## Select What To Test

Rank candidate behavior by the cost of failure. Test high-impact behavior first.

Give priority to:

1. Workflows whose failure makes the product unusable.
2. Data integrity, authorization, billing, and irreversible operations.
3. Public contracts used by many consumers.
4. Complex boundaries, state transitions, and error handling.
5. Defects that have occurred before.

Do not add a test only because code exists. Do not test incidental UI controls, accessors, framework behavior, or trivial wiring unless their failure breaks an important contract or guards a known regression.

Before writing a test, state:

- the public behavior;
- the failure consequence;
- the plausible defect that the test detects;
- the stable observation that proves the behavior.

If these items are not clear, do not write the test yet.

## Test Through The Public Contract

Test code from the position of its consumer.

- Call the same public API that production consumers call.
- Assert observable results, state changes, emitted messages, or documented errors.
- Keep tests independent of private methods, internal call order, and object structure.
- Do not make a private symbol public only to test it.
- Do not assert that collaborators receive a specific number of calls unless call count is part of the contract, such as retry limits or idempotency.

When an internal implementation changes without a behavior change, its tests must continue to pass.

If internal code seems to require direct tests, first test it through the enclosing public contract. Extract a separate public abstraction only when that abstraction has a real consumer-facing responsibility. A temporary diagnostic test can call internal code, but remove that test after the investigation.

## Choose The Test Level

Use the lowest stable level that proves the behavior. Do not force a workflow into a unit test when the important risk exists at an integration boundary.

| Need | Test level | Observation |
| --- | --- | --- |
| Domain rule or deterministic transformation | Unit | Return value or domain error through the public API |
| Collaboration with a database, queue, filesystem, or service adapter | Integration | Persisted state, message, or adapter result |
| UI behavior with meaningful presentation logic | Component | User-visible state through accessible UI semantics |
| Critical user journey across system boundaries | End-to-end smoke test | Final durable result of the complete workflow |

A critical workflow needs one reliable smoke test before it needs many detailed tests. Build the complete path, including setup and cleanup. Expand the suite only when another test protects a distinct risk.

## Use Dependencies Deliberately

Do not mock a dependency automatically.

Use the real implementation when it is fast, deterministic, local, and safe. Real collaborators often give better evidence with less coupling.

Replace a dependency when it introduces one of these conditions:

- external network access;
- nondeterministic time, randomness, or concurrency;
- destructive or paid side effects;
- slow execution that makes the suite impractical;
- a failure mode that cannot be produced safely with the real dependency.

Prefer a small fake at a stable boundary. Use a mock only when the interaction itself is the public behavior. Do not mock the unit under test.

## Design Scenarios

Write the normal path, then examine the boundaries and failure paths. Most non-trivial contracts have more failure scenarios than success scenarios.

Consider only applicable cases:

- null, absent, empty, malformed, and duplicate input;
- minimum, maximum, zero, negative, and out-of-range values;
- authorization and ownership boundaries;
- invalid state transitions;
- dependency rejection, timeout, and partial failure;
- retry, idempotency, and concurrency behavior;
- cleanup after failure;
- preserved data when an operation fails.

Do not create a combinatorial matrix without a distinct risk for each case. Use one representative from an equivalent class and add boundary values where behavior can change.

## Write Stable Workflow Tests

For a critical workflow:

1. Create deterministic test data.
2. Execute the workflow through the same public entry point that a user or consumer uses.
3. Read the final result from the most stable public interface.
4. Verify the business outcome.
5. Remove all created state.

Prefer an API or persisted-state check for the final business result when the UI changes frequently. Use the UI to prove UI-owned behavior. Do not use volatile layout, CSS classes, DOM shape, or incidental copy to prove a backend result.

Use exact assertions for contract data, identifiers, counts, statuses, and state transitions. Use normalized or semantic matching only when exact presentation text is not part of the contract. A loose match must not allow an incorrect business result to pass.

## Keep Tests Focused

Use Arrange, Act, Assert.

- Arrange only the state required by the scenario.
- Perform one behavioral Act in a unit or integration test.
- Assert one outcome or one coherent set of facts about that outcome.
- A workflow test can contain multiple user steps, but it must prove one named workflow result.

Multiple assertion statements are valid when they describe one result. Split the test when a failure could represent two independent behaviors.

Keep the scenario visible in the test body. Extract repeated or noisy setup into factories, builders, fixtures, or helpers. Do not hide the Act or the important assertion behind a generic helper.

Treat a unit test body longer than approximately 10 lines as a prompt to simplify setup or split behavior. Do not compress a test until it becomes difficult to read. Complete workflow tests can be longer when each step is necessary.

## Name Tests By Behavior

Use the repository's existing naming convention. If none exists, use:

`When<Scenario>_Then<ExpectedOutcome>`

A name must identify the condition and observable result. Do not name a test after a private method or implementation step.

Examples:

- `WhenIndexIsOutOfRange_ThenReturnsIndexError`
- `WhenSignupSucceeds_ThenCreatesAnActiveAccount`
- `WhenCsvUploadContainsInvalidRows_ThenNoRecordsAreCommitted`

## Use Coverage As A Diagnostic

Coverage reveals executed code that lacks scenarios. It does not measure test quality, production quality, or progress.

- Use uncovered branches to find missing behavior and failure cases.
- Do not add assertions-free tests to increase coverage.
- Do not target an arbitrary percentage.
- Do not report coverage as proof that the system works.

The useful target is complete coverage of important behavior, not a percentage of lines.

## Reject Low-Signal Tests

Do not add or keep a test when it primarily:

- duplicates another test's risk;
- verifies private structure or collaborator choreography;
- asserts a mock configuration instead of a result;
- snapshots a large unstable output without a reviewed contract;
- passes when the named behavior is broken;
- fails during harmless refactoring or copy changes;
- depends on execution order, shared mutable state, sleep, or live external data;
- produces an ambiguous failure that requires rerunning or manual interpretation.

Delete obsolete tests. More tests are not automatically safer.

## Verification Workflow

When writing or changing a test:

1. Read the production public contract and nearby test conventions.
2. Identify the behavior and plausible defect.
3. Select the stable test level and observation.
4. Write the minimum setup and scenario.
5. Run the new test in isolation.
6. For a defect, confirm that the test fails against the defective behavior and passes after the fix.
7. Run the relevant existing test group to detect shared-state or fixture problems.
8. Confirm that the test is deterministic and cleans up its state.

A passing test is not sufficient evidence of value. The test must fail when its named behavior is absent or incorrect.

## Review Checklist

- [ ] The test protects a high-value behavior or a distinct known risk.
- [ ] The test uses a public contract.
- [ ] The assertion observes behavior, not implementation structure.
- [ ] The selected test level contains the risk.
- [ ] Real dependencies are used when they are fast, deterministic, local, and safe.
- [ ] Every test double replaces a necessary boundary.
- [ ] The scenario covers a meaningful normal, boundary, or failure path.
- [ ] The test has one behavioral Act and one coherent outcome.
- [ ] The name states the scenario and expected outcome.
- [ ] The test does not depend on order, timing, live data, or unstable presentation details.
- [ ] The test fails for a plausible defect.
- [ ] Setup and cleanup leave no shared state.
