---
name: handling-llm-output
description: Use when calling Claude, OpenRouter, or Gemini from NationGraph code, parsing model output, defining agent tools or tool results, writing or placing a prompt, or serializing text a model will read or quote back.
---

# Handling LLM Output

## Overview

Model output is external input. Reviewers found JSON that was cut off at the token limit and failed with an opaque parse error, citations that could not match because Go escaped `&` to `&`, a compressor that ate one tool's results because it routed by name prefix, and hand-written normalizers for free text that structured output would have made unnecessary.

## Rules

**Ask for structure. Do not parse prose.** Use tool use or JSON-schema structured output with a typed result. Do not write regex or "normalize" helpers for free-text answers.

**Check why the model stopped before you parse.**
```go
if msg.StopReason == "max_tokens" {
    return fmt.Errorf("%w: output truncated at %d tokens", ErrNonRetryable, maxTokens)
}
```
A truncated answer is a clear error, not a JSON syntax error.

**Parse the result into a type at once.** Validate enums, bounds, and required fields (Zod, Pydantic, or a Go struct plus checks). Model-supplied tool arguments are untrusted input: bound string lengths to what the downstream API accepts (for example `max_length=255`), and validate ids as UUIDs.

**Do not escape text the model reads.**
```go
enc := json.NewEncoder(&buf)
enc.SetEscapeHTML(false) // the model must see "&", not "&", to quote it back
```

**Route tool results by shape, not by name.** Compression, deduplication, and truncation apply to a declared result type. A name-prefix match catches tools it was not written for.

**Prompts live in the prompts folder.** A prompt longer than two lines goes in the repo's prompts module (`backend/src/prompts/` in data-ops-foia-scripts). It does not live inline in a service. Keep prompts short, and match the style of the existing prompts next to it.

**Do not pass executors through layers.** Give the runner one tool executor. Do not thread each tool helper (compressor, dedup) through every function signature.

## Red flags

- `json.Unmarshal` / `JSON.parse` on model text with no stop-reason check
- A `normalize*` function for model output
- `strings.HasPrefix(toolName, ...)` to pick behavior
- A long template literal in a service file
