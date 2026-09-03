---
name: test-budget
description: Use when deciding what to test, when a brief or agent might add tests, or when a suite has grown by module instead of by risk. Defines the budget, how to pick the tests that stay, and why test count is never enforced by tooling.
---

# Test budget

## Objective

A handful of tests on the behaviors whose failure costs money, sends email, leaks a secret, or corrupts data. Nothing else, unless the owner asks.

## The rule

Tests are budgeted like lines. Before any code is written, the brief names the tests that may exist, by name and by what each proves. An agent that wants another test asks; it does not write one.

## How to pick the tests that stay

Ask, for each candidate: if this behavior broke in production, what would it cost? Keep the tests where the answer is one of:

- **Money.** A call that bills an account. Example: the API key never reaches the child process that should run on the subscription.
- **Outbound effect.** Anything that sends, posts, patches, or deletes on a system you do not own. Example: a plan writes nothing; the client has no method that can launch a campaign.
- **Trust.** A claim shown to a human or a customer that must be true. Example: a quoted sentence that is not in the record is refused; a number not in the record is refused.
- **Compatibility with a known-good corpus.** A recorded run that must still parse the same way. Example: a legacy trace replays to the same hits.

Drop the tests where the answer is "a developer notices in five minutes". Types, lint, and the boundary schema already cover those.

## What a test must never do

- Pin an implementation detail (a private helper, a call order, an internal shape).
- Exist because a module exists. Modules do not get tests; risks do.
- Require a fixture larger than the behavior it proves.
- Require a fake with more logic than the code under test.

## Fixtures and fakes

One small committed fixtures folder. One small support file with the fakes. No fixture with real email addresses, real names, or real keys. Redact at copy time, never later.

## Never enforce count with tooling

A lint rule that counts tests is machinery on a judgment problem. The count is set by a person, written in the project's `CLAUDE.md` as a list of names, and enforced by reading. When someone adds a test, the review asks which line of the list it belongs to.

## The frozen list

Write it where every agent reads it:

```
Tests: exactly these, nothing else without the owner's approval.
- verify: a quote not in the record is refused; a number not in the record is refused.
- bison: the client has no method that can launch a campaign.
- push: a plan writes nothing to Bison.
- agent-sdk: the API key never reaches the child process.
- legacy-trace-replay: the recorded run parses to the same hits.
```

## Checklist

- [ ] Brief names every allowed test.
- [ ] Every kept test maps to money, outbound effect, trust, or a known-good corpus.
- [ ] No test pins an internal.
- [ ] No fixture holds a real address or key.
- [ ] No tooling counts tests.
