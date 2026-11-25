# Data model

The data file is plain JavaScript. It declares nine constants with these exact names. `scripts/build.mjs` reads them, checks them and puts the file into the page.

```js
const META = { … };      // header and legend values
const PK = { … };        // packets: the content of the dots
const GROUPS = [ … ];    // the sections of the block list
const NODES = [ … ];     // blocks
const STEPS = { … };     // the steps inside each block
const FLOWS = [ … ];     // lines
const TRACE = [ … ];     // the order of "Trace one step"
const ZONES = [ … ];     // process floors
const OVERVIEW = { … };  // the first panel
```

You can declare helper constants for values that repeat, such as a long URL. Text fields can contain `<code>` for a symbol, a path, a table name or a literal value. Use no other HTML in a text field, except in `OVERVIEW.built`. Write `&lt;`, `&gt;` and `&amp;` for the characters `<`, `>` and `&` in a text field. The semicolon of an entity is permitted.

Start from `assets/minimal-data.js`. The examples in this file come from it.

## META

```js
const META = {
  title: 'Thumbnail Flow Map',                      // 2 to 4 words. The name of the page.
  repo: 'thumbnailer · main',                       // repository and branch
  facts: [['Stack', 'Go 1.24 · PostgreSQL 17'], ['Stages', '2']],
  snapshot: 'test fixtures',                        // where the packets come from, and the date
  trace: 'one uploaded image',                      // completes: Click "Trace one step" to follow …  Not necessary if TRACE is [].
};
```

`facts` is for constants of the design only: the stack, the number of stages, the number of processes. Do not put a number there that changes while the system runs. Use 0 to 3 facts.

## GROUPS

```js
const GROUPS = [['pipe', 'The pipeline'], ['sup', 'Supporting the pipeline'], ['out', 'Outside the service']];
```

Each block names one group in its `g` field. The block list on the left of the page shows the groups in this order. Use 2 to 4 groups.

## NODES

One object for each block.

```js
{ id: 'resize', name: 'Resize worker', g: 'pipe', kind: 'stage', x: 14, y: 3, w: 4, d: 4, h: 1.4, proc: 'worker', pk: 'job',
  does: ['The resize worker makes one thumbnail for each requested width.',
         'The worker reads the original image from the bucket and writes each thumbnail to the bucket.'],
  built: ['The worker claims one job at a time. A lease has a duration of 30 seconds.',
          'The output format is WebP. The widths are 320 and 1280 pixels.'],
  files: ['internal/resize/worker.go', 'internal/resize/store.go'] },
```

| Field | Mandatory | Meaning |
| --- | --- | --- |
| `id` | yes | Short unique key. Lines and steps refer to it. |
| `name` | yes | The text on the block. 1 to 3 words. |
| `g` | yes | A group key from `GROUPS`. |
| `kind` | yes | One of `stage`, `child`, `support`, `table`, `store`, `queue`, `scheduler`, `ui`, `external`, `model`. |
| `x`, `y` | yes | The back corner of the footprint, in grid units. |
| `w`, `d`, `h` | yes | Width along x, depth along y, height. |
| `proc` | no | The process that runs the block. It must be the label of the zone around the block. |
| `pk` | no | The packet key that the steps of this block use if a step names none. |
| `does` | yes | Paragraphs for the tab "What it does". The first paragraph defines the block in one sentence. |
| `built` | yes | Paragraphs for the tab "How it's built": stage name, limits, constants, invariants. |
| `files` | yes | The paths a reader opens to see the code. 1 to 8 paths. For an `external` or `model` block: the files of this repository that call it or configure it. |

Do not add a field for counts, status or a tagline. The script refuses `now` and `one`.

## STEPS

One list for each block that is not `external` or `model`. The key is the block id.

```js
const STEPS = {
  api: [
    { n: 'Parse', pk: 'upload', f: 'internal/api/upload.go',
      d: 'This step reads the request into a typed upload: a filename, a content type and a byte stream. It refuses a request of more than 20 MiB.',
      why: 'Each later step assumes a correct upload. Only this step reads the raw request.' },
    …
  ],
};
```

| Field | Mandatory | Meaning |
| --- | --- | --- |
| `n` | yes | The step name. 1 to 4 words. A function name or a message name is a good step name. |
| `d` | yes | What the step does. 1 to 4 sentences. |
| `why` | yes | Why the step exists. 1 to 3 sentences. |
| `f` | yes | One file path, or one directory path that ends with `/`. |
| `pk` | no | The data that leaves this step. The dot moves from this step to the next step. |

The page puts the steps in rows of 4. It numbers them. Do not put a number in `n`.

`pk` is on the step that sends the data, not on the step that receives it:

```js
// Wrong: the dot "Upgrade response" moves from Upgrade to AddConnection. AddConnection does not get the response.
{ n: 'Upgrade', pk: 'response', … }, { n: 'AddConnection', … }
// Correct: the request leaves authenticateUser and goes to Upgrade. The response is on the line to the client block.
{ n: 'authenticateUser', pk: 'request', … }, { n: 'Upgrade', … }, { n: 'AddConnection', … }
```

If no real packet goes between two steps, give the step no `pk`. Then the dot of the block (`pk` of the block) moves there, or no dot if the block has none.

The inside view adds the neighbour blocks automatically: the blocks with a line into this block are on the left, and the blocks with a line out of this block are on the right. You write nothing for them.

Limit: the page connects each input to step 1 and each output to the last step. You cannot connect a neighbour to a middle step. If a middle step calls a neighbour block, say that in `d` of the step.

## FLOWS

One object for each line.

```js
{ id: 'f_claim', what: 'The resize worker claims one job from the job queue.',
  a: 'jobs', b: 'resize', pk: 'job', path: [[14.5, 11.5], [14.5, 7]] },
{ id: 'f_serve', what: 'The CDN reads a thumbnail from the image bucket. It does this only for a thumbnail that is not in its cache.',
  a: 'bucket', b: 'cdn', dash: 1, path: [[26, 6.3], [30, 6.3]] },
```

| Field | Mandatory | Meaning |
| --- | --- | --- |
| `id` | yes | Unique key. Start it with `f_`. |
| `what` | yes | 1 to 3 sentences that say what goes along the line, and when. |
| `a`, `b` | yes | The block id at the start and at the end. `a` is the block that the data of `pk` leaves. `b` is the block that gets it. This is also true when `b` makes the call: for a worker that reads a queue, `a` is the queue. |
| `path` | yes | Grid points from the edge of `a` to the edge of `b`. Each segment is parallel to x or y. |
| `pk` | no | The packet that goes from `a` to `b`. |
| `rk` | no | The packet that goes from `b` to `a` on the same line. |
| `dash` | no | `1` for a conditional connection: one that occurs only in some configurations or some cases. |

The id of the dot for `pk` is the line id. The id of the dot for `rk` is the line id and `~`.

## PK

One object for each packet.

```js
thumb: { title: 'Thumbnail object', table: 'objects',
  src: 'internal/resize/store.go writes one objects row for each size.',
  data: { image_id: 'img_8f2c', width: 320, key: 'thumbs/img_8f2c/320.webp', bytes: 18244, sha256: '9b1d…e07a' } },
```

| Field | Mandatory | Meaning |
| --- | --- | --- |
| `title` | yes | 1 to 4 words. What the row is. |
| `table` | yes | The table, the column, or the message name that the row comes from. If the engine did not send it yet, write `not sent yet`. |
| `src` | yes | 1 to 3 sentences: the code that writes this data. If the row is not from the main subject, the last sentence says so. |
| `data` | yes | The row as an object. The page shows it as JSON. |

A packet that is not a database row uses the real field names of the message. For an HTTP request, the fields are the method, the path, and the headers and the body that the code reads. `table` is then the route or the message name, for example `GET /ws`.

Rules for `data`:

- Copy real values. Shorten a long string with `…`. Shorten a long array to 1 or 2 items and `"…+N"`.
- Keep the real field names and the real types. `null` stays `null`.
- Remove credentials. Replace the project part of an internal host with `PROJECT`.
- 5 to 15 fields is a good size. Remove fields that say nothing.

## TRACE

```js
const TRACE = ['f_upload', 'f_queue', 'f_claim', 'f_thumb'];
```

The dot ids of the main subject, in the order that the data moves. "Trace one step" selects them one at a time. Use `[]` if no packet is from the main subject. Then the page hides the button.

## ZONES

One rectangle on the floor for each area that one process owns.

```js
{ x0: 5.3, y0: 2.3, x1: 10.7, y1: 7.7, label: 'api' },
{ x0: 13.3, y0: 2.3, x1: 18.7, y1: 7.7, label: 'worker', lx: 16.2 },
```

| Field | Mandatory | Meaning |
| --- | --- | --- |
| `x0`, `y0`, `x1`, `y1` | yes | The rectangle. Leave a minimum of 0.5 units between the outline and each block inside. |
| `label` | yes | The process name. It must be the `proc` of each block inside. |
| `lx` | no | The grid x where the label starts. Default: `x0 + 0.3`. Use it to move the label away from a line. |
| `back` | no | `true` puts the label behind the zone, not in front. |

One process can have 2 or more zones. A block is fully inside a zone or fully outside it.

## OVERVIEW

```js
const OVERVIEW = {
  title: 'Thumbnail service',
  pipeline: [
    'The upload API stores the original image and queues one job.',
    'The resize worker makes the thumbnails and writes them to the image bucket.',
  ],
  built: `
  <h2>Structure</h2>
  <p>The service has two processes: <code>api</code> and <code>worker</code>. It uses Go 1.24 and PostgreSQL 17.</p>
  <h2>Stages</h2>
  <table><tr><th>Stage</th><th>Process</th><th>Target</th></tr><tr><td>resize</td><td>worker</td><td>job</td></tr></table>
  <h2>Rules that a test applies</h2>
  <ul><li>Only <code>internal/queue/</code> claims a <code>jobs</code> row.</li></ul>`,
};
```

| Field | Meaning |
| --- | --- |
| `title` | The name of the system. 1 to 3 words. |
| `pipeline` | One sentence for each stage of the main path, in order. Each sentence starts with the stage name. |
| `built` | HTML for the tab "How it's built" of the first panel. Use `<h2>`, `<p>`, `<ul>`, `<table>` and `<code>` only. |

The page adds the legend and the controls. Do not write them.

Good sections for `built`: the structure of the application, a table of stages and processes, the rules that tests enforce, the failure classes, the documents to read next. Use only sections that the repository has facts for.
