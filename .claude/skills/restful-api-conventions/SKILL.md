---
name: restful-api-conventions
description: Use when designing, reviewing, or implementing HTTP/REST API endpoints—choosing resource URIs, HTTP methods, status codes, pagination, filtering, PATCH formats, versioning, long-running/async operations, or multitenant routing.
---

# RESTful API Conventions

## Overview

Conventions for RESTful web API design, distilled from Microsoft's [Azure API design best practices](https://learn.microsoft.com/en-us/azure/architecture/best-practices/api-design). Follow these when defining endpoints so every API in the codebase makes the same choices. Core principle: model business entities as resources, use the uniform HTTP interface, keep requests stateless.

## Resource URIs

- Nouns, never verbs: `/orders`, not `/create-order`. The HTTP method is the verb.
- Plural nouns for collections; hierarchy for items: `/customers` → `/customers/5`.
- Relationships one level deep: `/customers/5/orders` is fine. **Never nest deeper than collection/item/collection.** For `/customers/1/orders/99/products`, split into `/customers/1/orders` then `/orders/99/products`, or return HATEOAS links instead.
- Do not mirror database tables as resources. The API is an abstraction over the data model; add a mapping layer if needed. Exposing tables increases attack surface and leaks schema changes to clients.
- Avoid chatty APIs (many small resources requiring many round trips). Denormalize into larger resources—but balance against returning data clients don't need.
- Non-resource operations (e.g. `/add?operand1=99&operand2=1`) are allowed sparingly as pseudo-resources with query-string parameters.

## Methods by resource type

| Resource | POST | GET | PUT | DELETE |
|---|---|---|---|---|
| `/customers` | Create new customer | Retrieve all | Bulk update | Remove all |
| `/customers/1` | **Error** | Retrieve customer 1 | Update 1 if exists | Remove 1 |
| `/customers/1/orders` | Create order for 1 | Retrieve 1's orders | Bulk update 1's orders | Remove 1's orders |

- POST creates under a collection URI; **the server assigns the new URI** and returns it in the `Location` header. A client that POSTs to a specific item URI to pick its own URI gets 400; a POST to a URI that doesn't support POST gets 405.
- PUT sends a **complete** representation and **must be idempotent**. Applied to items, not collections (bulk PUT on a collection is allowed to reduce chattiness). Support create-via-PUT only when clients can reliably assign URIs; otherwise create with POST, update with PUT/PATCH.
- PATCH sends only the changes (a patch document). POST and PATCH are not guaranteed idempotent.

## Status codes by method

| Method | Success | Errors |
|---|---|---|
| GET | 200; 204 if the body has no content (e.g. empty search) | 404 not found |
| POST | 201 + `Location` header + representation; 200 processing without resource creation; 204 no body | 400 invalid data; 405 POST not supported at this URI |
| PUT | 200; 201 if created; 204 no body | 409 conflict with current resource state |
| PATCH | 200 | 400 malformed patch document; 409 valid patch, unapplicable state; 415 unsupported patch format |
| DELETE | 204, no body | 404 doesn't exist |

## Media types and content negotiation

- Request/response format is declared by `Content-Type`; the client's acceptable formats by `Accept`.
- Server can't handle the request's `Content-Type` → **415 Unsupported Media Type**.
- Server can't produce any format in `Accept` → **406 Not Acceptable**.

## PATCH document formats

| Format | Media type | Semantics | Limits |
|---|---|---|---|
| JSON merge patch (RFC 7396) | `application/merge-patch+json` | Body mirrors the resource with only changed/added fields; `null` deletes a field | Cannot set explicit `null` values; no ordering |
| JSON patch (RFC 6902) | `application/json-patch+json` | Ordered operation list: add, remove, replace, copy, test | More verbose |

Use merge patch by default; use JSON patch when the resource has meaningful `null`s or operation order matters.

## Long-running (async) operations

When POST/PUT/PATCH/DELETE processing takes too long for a synchronous reply:

1. Return **202 Accepted** with a `Location` header pointing to a **status endpoint**.
2. Client polls the status endpoint; GET returns 200 with current status (optionally an ETA and a cancel link).
3. When the operation has created a resource, the status endpoint returns **303 See Other** with `Location` set to the new resource's URI.

## Pagination, filtering, sorting, field selection

- Paginate collections with `limit` and `offset`; give meaningful defaults (`limit=25`, `offset=0`).
- **Impose a server-side max limit** (DoS guard). Over-limit requests either clamp or return 400—document which.
- Filter via query string: `GET /orders?minCost=100&status=shipped`.
- Sort via `sort=price`. Caveat: query strings form part of cache keys, so sorting fragments caches.
- Field selection via `fields=id,name`. **Validate requested fields**—never expose fields the client isn't allowed to access.

## Partial responses for large binaries

- Support `Accept-Ranges: bytes` on GET for large binary resources; clients fetch chunks with `Range: bytes=0-2499`.
- Partial replies use **206 Partial Content** with `Content-Range: bytes 0-2499/4580` (`Content-Length` = bytes in this response, not total size).
- Support HEAD so clients can read size (`Content-Length`) and range support before fetching.

## HATEOAS

Include a `links` array in representations so clients navigate without prior URI knowledge. Each link carries `rel` (e.g. `customer`, `self`), `href`, `action` (HTTP method), and supported `types`. The link set can vary with resource state. No universal standard exists—define one shape and use it consistently.

## Versioning

Adding fields is usually non-breaking (clients must ignore unknown fields). For breaking changes (field removal/rename, restructure), pick one:

| Approach | Example | Trade-offs |
|---|---|---|
| None | — | Only for internal APIs with additive-only change |
| URI | `/v2/customers/3` | Simple, cache-friendly; URI proliferation, complicates HATEOAS links |
| Query string | `/customers/3?version=2` | Same URI for the resource; some older proxies/browsers won't cache query-string URLs |
| Header | `Custom-Header: api-version=2` | Clean URIs; needs header-inspection logic, fragments server caches |
| Media type | `Accept: application/vnd.contoso.v1+json` | Fits content negotiation and HATEOAS best; needs Accept-parsing logic, fragments caches |

Query-string and header versions must default to a meaningful version (e.g. 1) when omitted. URI and query-string versioning are the cache-friendly options.

## Multitenancy

Decide tenant identification up front—retrofitting isolation is expensive:

| Strategy | Example | Notes |
|---|---|---|
| Subdomain (DNS) | `adventureworks.api.contoso.com` | Wildcard or custom domains; preserve hostname through proxies; supports data residency |
| Header | `X-Tenant-ID: adventureworks` or JWT claim | Cleanest RESTful URIs; requires L7 gateway; caches keyed on URI alone risk cross-tenant leakage |
| URI path | `/tenants/adventureworks/orders/3` | Explicit and routable; complicates routing logic and dilutes resource-oriented design |

## Observability

Accept and echo a correlation header (`Correlation-ID`, `X-Request-ID`, or `X-Trace-ID`) on every request/response to enable distributed tracing across services.

## Maturity target

Richardson Maturity Model: L0 single URI/POST → L1 per-resource URIs → L2 HTTP methods + status codes → L3 HATEOAS. Target L2 minimum; L3 where clients benefit from navigation.

Prefer contract-first with OpenAPI: design the spec, then implement to it; generate clients/docs from the contract.

## Common mistakes

| Mistake | Fix |
|---|---|
| Verbs in URIs (`/create-order`) | Noun resource + HTTP method (`POST /orders`) |
| Client picks the new resource's URI via POST | POST to the collection; server assigns URI, returns `Location` |
| Deep nesting (`/a/1/b/2/c`) | Cap at collection/item/collection; link the rest |
| Non-idempotent PUT | PUT replaces with a complete representation, same result on retry |
| Unbounded `limit` parameter | Enforce a server-side maximum |
| `fields=` projection without authorization check | Validate every requested field |
| Blocking on long operations | 202 + status endpoint + 303 on completion |
| One-table-one-endpoint API | Model business entities; map internally |
