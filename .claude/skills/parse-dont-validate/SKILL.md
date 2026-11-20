---
name: parse-dont-validate
description: Use when handling any input that enters the system (CSV, API body, env var, model answer, external API response, file contents) or when tempted to add a check "just in case". Defines the one-boundary rule, evidence-carrying types, and how to recognize shotgun parsing.
---

# Parse, don't validate

## Objective

Every input crosses one boundary and becomes a domain type there. Core code takes typed values and has no error path for malformed data, because malformed data cannot reach it.

## The rules

1. **One boundary.** The CSV row, the HTTP body, the env, the model's JSON, the third-party response: each is parsed once, at the edge, into a type. Nothing downstream re-checks.
2. **A check must produce evidence.** If you verify a property, capture it in the returned type. Verifying and returning the same type you were given is validation, and the next function cannot tell it happened.
3. **Prefer types that cannot be wrong.** An enum over a validated string. A parsed `EmailAddress` over `string`. A non-empty list type over a list plus an emptiness check. A discriminated union over a kind field plus optional payloads.
4. **No shotgun parsing.** Never check a bit, act a bit, check a bit. Parse the whole input into a valid structure before any effect. A failure halfway with partial effects is the worst outcome.
5. **Failure lives at the boundary.** That is where the context to report it well exists. Downstream code does not handle malformed data because it never sees any.

## Recognizing the smell

You are about to write one of these:

```ts
if (!env.API_KEY) throw new Error('API_KEY missing');      // env was already parsed by a schema
if (!company.website) return error('no website');          // engine.requires already filtered rows
const n = Number(row.limit); if (Number.isNaN(n)) ...       // zod already coerced it
if (typeof record !== 'object' || record === null) ...     // the schema said it is an object
```

Each one means a type upstream is too weak, or the boundary already did this and you did not trust it. Fix the type or delete the check. Do not add the check.

## The pattern

```ts
// Boundary: parse once, return the rich type.
export const parseCompanyRows = (csv: string): ParsedCompanies =>
    parsedCompaniesSchema.parse(parseCsv(csv));

// Core: take the rich type, assume it is well-formed.
export const matchOne = (company: CompanyRow, engine: MatcherEngine) => { ... };
```

The core signature is the contract. If `CompanyRow` can have no website, the type says `website?: string` and the caller that needs one filters before calling. The callee never checks.

## Evidence-carrying returns

```ts
// Wrong: verifies, returns the same type. The caller cannot tell.
const checkQuote = (quote: string, record: Record): string => { ...; return quote; };

// Right: the return type is the evidence.
type Grounding = { kind: 'verbatim'; quote: string } | { kind: 'repaired'; quote: string; from: string } | { kind: 'not_in_record' };
const groundEvidence = (quote: string, record: Record): Grounding => { ... };
```

## Where `null` and `any` are allowed

Only at the boundary files that talk to the outside: repository rows, database schemas, request schemas, test fixtures. Everywhere else, `undefined` and a real type.

## Checklist

- [ ] Every external input has exactly one schema, at the edge.
- [ ] No function re-checks a property its parameter type guarantees.
- [ ] Every check returns a richer type than it received.
- [ ] No effect runs before the whole input is parsed.
- [ ] No `null` or `any` outside boundary files.
