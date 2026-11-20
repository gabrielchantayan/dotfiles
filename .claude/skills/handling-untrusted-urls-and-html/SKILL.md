---
name: handling-untrusted-urls-and-html
description: Use when checking a URL's host or path, building a redirect or return-to link, stripping or highlighting HTML, building HTML strings, generating passwords or tokens, logging request or connection details, or when CodeQL reports URL sanitization, sanitization, ReDoS, randomness, or clear-text logging.
---

# Handling Untrusted URLs and HTML

## Overview

The same CodeQL alerts kept coming back because authors dismissed them ("the URL comes from our database"). The correct fix is usually one line, and it closes the alert for good. Fix the alert. Do not dismiss it.

## Fixes

| Alert or pattern | Bad | Good |
|---|---|---|
| Incomplete URL substring sanitization | `url.includes('nextrequest.com')` | `const h = new URL(url).hostname; h === 'nextrequest.com' \|\| h.endsWith('.nextrequest.com')` |
| Open redirect | `href.startsWith('/') && !href.startsWith('//')` (allows `/\evil.com`) | `new URL(href, location.origin).origin === location.origin` |
| Incomplete multi-character sanitization | `html.replace(/<[^>]*>/g, '')` | `new DOMParser().parseFromString(html, 'text/html').body.textContent ?? ''` |
| HTML built from strings | `` el.innerHTML = `<mark>${text}</mark>` `` | Create nodes with `document.createElement` and `textContent`, or render React elements. |
| Biased random (modulo) | `bytes[i] % charset.length` | `crypto.randomInt(charset.length)` (Node), `secrets.choice` (Python) |
| ReDoS | Nested quantifiers such as `(a+)+` on user text | Anchor the pattern, remove the nested quantifier, or parse without a regex. |
| Clear-text logging | `log.info("connecting", **conn_kwargs)` | Log the host and the operation only. Never log passwords, tokens, or full connection settings. |
| Double unescape | `unescape(unescape(s))` | Decode once, at the boundary. |
| Object in a query string | `` `?filter=${obj}` `` (`[object Object]`) | `new URLSearchParams({ filter: JSON.stringify(obj) })` |

Also:
- A GitHub Actions workflow declares a `permissions:` block with the least access it needs.
- Before an agent runs a tool the user must approve, show the real target and arguments from the tool call, not a summary.

## Rules

- Treat data from the database as untrusted when a scraper, a user, or a model wrote it.
- If a CodeQL alert is a real false positive, remove the reason for it at the boundary. For example, parse `limit` into a bounded type so the allocation alert cannot apply. Do not reply "not an issue" and leave it open.
