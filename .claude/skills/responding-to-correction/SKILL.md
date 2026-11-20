---
name: responding-to-correction
description: Use the moment a user says the work is wrong, too much, too little, or off-style, especially when they are frustrated. Defines the order of response, when a mechanical rule is the right fix and when it is machinery on a judgment problem, and how to avoid flailing.
---

# Responding to correction

## Objective

A correction is fixed at its root, by hand, once. The user sees the fixed thing, not a new process.

## The order of response

1. **Read what they are looking at.** Open the exact file or output they named. Do not respond from memory of what the agent reported.
2. **Name the actual failure in one sentence.** Not the symptom ("comments are long") but the cause ("the agents explained reasons; the brief had no exemplar and no gate").
3. **Fix the instance by hand.** Rewrite the file they pointed at yourself, to the bar. This is the exemplar for everything after.
4. **Fix the cause.** Change the brief, the gate, or the process so the next output does not repeat it.
5. **Show the fixed instance, then the plan.** The user's trust comes back from seeing one file done right, not from hearing about a new rule.

## When a mechanical rule is right

Add a lint rule, a checker, or a gate only when all three hold:

- The property is countable by a machine without judgment (lines, ratio, banned words, file size).
- The user agrees it should be counted, or the project already counts it.
- The rule would have caught the instance they pointed at.

## When a mechanical rule is wrong

- The property is a judgment (how many tests are enough, whether a comment is a story, whether a name is clear). A judgment gets an exemplar and a review, not a counter.
- The user just told you there is too much machinery. Adding machinery is the one response guaranteed to be wrong.
- You are adding it to avoid reading the code. A rule is not a substitute for opening the files.

## Do not flail

Flailing looks like: add a rule, revert the rule, add a different rule, re-run the agents, add another rule. Each move is visible and each one costs trust. If a fix does not hold on the first try, stop, read more code, and find the actual cause before the next move.

## Do not defend

Do not explain why the output happened before fixing it. Do not say the agents were told. Do not point at the brief. The user is looking at the code; the code is the answer.

## Do not oversell the fix

After fixing, report only what you verified: which files you rewrote, which gate you ran, what its output was, what you did not check. "Cleaned up" and "should be better now" are claims. "I rewrote `tags.ts` by hand and the checker passes at zero; I have not yet read the other fourteen domain files" is a report.

## Example

User: "the comments are atrocious, this is slop."

Wrong: launch a cleanup agent with a longer prose brief; report "cleanup running".

Right: open the file they mean, rewrite its comments by hand to manual entries, show it, then add the banned-word and ratio checker because those are countable, then re-brief the agents with that file as the exemplar, then read the results before reporting.

## Checklist

- [ ] I opened the exact thing they pointed at.
- [ ] I fixed that instance by hand first.
- [ ] Any new rule counts something countable and would have caught the instance.
- [ ] No rule was added for a judgment.
- [ ] The report names what I verified and what I did not.
