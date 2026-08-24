---
name: paper
description: Records completed work and actionable friction. Use during software work to log cuts immediately and meaningful outcomes at completion.
---

# Paper

Paper is the durable work and friction log. Use it without interrupting the task.

## Before Working

Run `paper cuts --format json` to learn whether relevant friction is already known.

## Record Friction Immediately

When a tool call dead-ends, a link is broken, documentation misleads, a command fails unexpectedly, or the environment or workflow creates avoidable friction:

1. Check `paper cuts --format json` for an existing matching cut.
2. If none exists, run `paper cut --summary "..." --description "..." --kind KIND --agent AGENT`. Valid kinds are tool-call, broken-link, command, documentation, environment, workflow, other.
3. Include the attempted action, impact, workaround, evidence, or suggested fix when known.
4. Continue the original task. Logging a cut is not a substitute for finishing the work.

Do not log routine failures caused by your own typo, expected exploratory dead ends, or duplicates.

## Record Completed Work

After completing meaningful work, write one concise outcome with `paper log --summary "..." --agent AGENT`. Use `--details` when the summary cannot explain the result and verification. Do not log every command or intermediate action.

Use `claude-code` as AGENT in Claude Code and `opencode` in OpenCode.
