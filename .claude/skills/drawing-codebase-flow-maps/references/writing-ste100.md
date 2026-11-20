# Writing the map text in ASD-STE100

All text on a flow map is ASD-STE100 (Simplified Technical English). The reader is an engineer who does not know this codebase. The reader reads one panel at a time, in any order. Thus each text must be complete without the other texts.

## The rules

| # | Rule | Wrong | Correct |
| --- | --- | --- | --- |
| 1 | One fact in each sentence. Maximum 25 words. Aim for 12 to 18. | The worker reads the original image, writing each thumbnail that may be needed, but it does not keep the original. | The worker reads the original image. It writes each thumbnail that the job names. It does not keep the original. |
| 2 | Active voice. Put the actor before the action. | The checkpoint is parsed before the handler runs. | The dispatcher parses the checkpoint before the handler runs. |
| 3 | Present tense. | The worker will claim the row. | The worker claims the row. |
| 4 | Put the condition before the action. | The request is conditional if the last fetch has a validator. | If the last fetch has a validator, the request is conditional. |
| 5 | One term for one thing. No synonyms. | The engine stores the file. … The document goes to the bucket. | The engine stores the file. … The file goes to the bucket. |
| 6 | `must` for a mandatory behavior. `must not` for a prohibition. `can` for a capability. No `should`, `may`, `might`. | A retry should use the same samples. | A retry must use the same samples. |
| 7 | No idioms, no metaphors, no decorative words. | The limits stop one bad site from burning money. | The limits control the spend on one site. |
| 8 | Code symbols, table names, paths and literal values exactly, in `<code>`. | the state becomes queued | the state becomes `<code>queued</code>` |
| 9 | Digits for each number. Give the unit. | a minute-long lease | a lease of 60 seconds |
| 10 | No semicolon. No dash between clauses. No brackets for a second thought. | The child has no database access; the parent writes the events. | The child has no database access. The parent writes the events. |
| 11 | No contractions. | It doesn't retry. | It does not retry. |
| 12 | Describe the present state only. No history, no plans. | This replaces the old polling loop. | Do not write this sentence. |
| 13 | No variable state. | 18,608 work items are queued. | Do not write this sentence. |
| 14 | Use `Thus` to show a consequence. Start a new sentence. | …, so two collectors never sweep at once. | Thus two collectors do not run sweeps at the same time. |
| 15 | Use the article. Do not write in telegram style. | Queue claims row, sets lease. | The queue claims a row and sets its lease. |

The build script gives an error for: a sentence of more than 25 words, a semicolon, a dash between clauses, a contraction, a text with no full stop at the end, and these words: `should`, `may`, `might`, `utilize`, `leverage`, `via`, `just`, `simply`, `basically`, `very`, `really`, `easily`, `seamlessly`, `robust`, `currently`, `right now`, `at the moment`, `in order to`, `due to`, `e.g.`, `i.e.`, `etc`, `previously`, `formerly`, `no longer`, `used to`.

The script gives a warning for a possible passive verb. Correct the sentence if the verb is an action. Keep the sentence if the word is an adjective, as in "the evidence is unresolved".

## Words

Prefer the word on the left.

| Use | Do not use |
| --- | --- |
| use | utilize, leverage, employ |
| make sure that | ensure, verify (as a general verb), double-check |
| examine | check out, look at, inspect |
| get | fetch (as a general verb), retrieve, obtain, grab |
| send | ship, fire, dispatch (unless it is the code term) |
| start, stop | kick off, spin up, kill, tear down, shut down |
| start again | restart (as a verb), reboot |
| change | modify, mutate, tweak, alter |
| show | reveal, surface, expose |
| prevent | guard against, protect from |
| a maximum of | at most, up to, no more than |
| a minimum of | at least |
| each | every (when you mean each one) |
| one time, two times | once, twice |
| if | when (for a condition), in case |
| because | since, as (for a reason) |
| thus | so, hence, therefore, as a result |
| through | via |
| before, after | prior to, following |
| a different | another (when you mean not the same one) |
| sufficient | enough |
| approximately | about, around, roughly |
| is not | isn't |
| cannot | can't, is unable to |

If the code has a term, the code term wins. If the code says `dispatch`, `fetches` or `verify digest`, use that term in `<code>` or as the step name, and then explain it with the plain words.

## Terms of the map

Use these words for the parts of the map. Do not use a synonym.

| Thing | Term |
| --- | --- |
| A box on the floor | block |
| The inside view of a block | steps |
| A connection | line |
| A moving diamond | dot (in text for the reader), packet (in the data file) |
| A dashed floor outline | process floor |

Before you write, make a term list for the system: one word for each thing in the domain. Example for a thumbnail service: `upload`, `original`, `thumbnail`, `width`, `job`, `lease`, `object`. Use the list in each field.

## The pattern for each field

### Block: `does`

- Paragraph 1: one sentence that defines the block. "`<Name>` + verb + object."
- Then 1 to 4 paragraphs: what goes in, what the block does with it, what comes out, the outcomes.
- 1 to 3 sentences in each paragraph.

```js
does: ['The resize worker makes one thumbnail for each requested width.',
       'One job is one original image and its list of widths.',
       'If the bucket has a thumbnail of a width, the worker does not make it again.',
       'An image of more than 100 megapixels gives the reason <code>too_large</code>. Each other failure gives the reason <code>decode</code>.'],
```

### Block: `built`

Facts of the implementation that the reader cannot see in `does`: the stage name and its target, the default worker count, each limit with its number, the transaction boundaries, the invariants that a test enforces.

```js
built: ['The stage is <code>resize</code>. Its target is a job. The default is 4 workers.',
        'A lease has a duration of 30 seconds. A job has a maximum of 3 attempts.',
        'A decode failure has no result write. Thus it records no <code>objects</code> row.'],
```

Limits and defaults from the code are facts of the design. Write them. Counts of rows in a database are not. Do not write them.

### Step: `d` (what it does)

1 to 4 sentences. Say what goes in, what the code does, and what comes out. If the step name is a term that a new reader does not know, the first sentence defines the term.

Start with "This step …", or with the function or the actor as the subject.

### Step: `why` (why it exists)

1 to 3 sentences. Name the failure that occurs without this step, or the property that the step gives the system. A good test: delete the step in your mind. What goes wrong, and for whom?

| Weak `why` | Strong `why` |
| --- | --- |
| For data integrity. | A reader can compare the bytes with the SHA-256 and find a damaged object. |
| To improve performance. | The engine can find a change in a stored file and not download the file again. |
| For safety. | A page must not use the browser to get access to internal services. |
| It is needed by the next step. | Each later step assumes a correct `Upload`. Thus a request that is too large stops here, and not during the resize. |
| Best practice. | No database transaction stays open during a slow network call. |

Complete step examples:

```js
{ n: 'Decode', pk: 'job', f: 'internal/resize/worker.go',
  d: 'This step reads the original image from the bucket and decodes it. It refuses an image of more than 100 megapixels.',
  why: 'An image of that size can use all the memory of the worker.' },

{ n: 'Renew the lease', pk: 'job', f: 'internal/queue/queue.go',
  d: 'A running lease renews itself 3 times in each lease of 30 seconds. It uses a separate connection pool. A worker that loses its lease stops its resize.',
  why: 'If a worker stops, a different worker can claim its job in 30 seconds. The separate pool prevents a wait behind work transactions.' },

{ n: 'Queue job', pk: 'job', f: 'internal/api/upload.go',
  d: 'One transaction writes the <code>images</code> row and one <code>jobs</code> row with the state <code>queued</code>.',
  why: 'If the transaction fails, there is no image with no job and no job with no image.' },
```

### Line: `what`

1 to 3 sentences. The subject of the first sentence is the block that acts: the block that sends, or the block that claims or reads. Add the condition if the line is dashed. Add a limit if the line has one.

```js
what: 'The resize worker claims one job from the job queue. A job has a maximum of 3 attempts.'
what: 'The CDN reads a thumbnail from the image bucket. It does this only for a thumbnail that is not in its cache.'
what: 'The upload API sends the original image to the bucket. The bucket returns its SHA-256.'   // a line with pk and rk
```

### Packet: `src`

1 to 3 sentences: the file and the function that write the row. If the row is not from the main subject, say so in the last sentence.

```js
src: 'internal/resize/store.go writes one objects row for each size.'
src: 'internal/api/upload.go writes one jobs row for each stored original. This row is from a different upload.'
```

Paths in `src` are plain text, not `<code>`.

### `OVERVIEW.pipeline`

One sentence for each stage. The stage name is the subject.

```js
'The resize worker makes the thumbnails and writes them to the image bucket.'
```

### Names

Block names, step names, packet titles and table headings are labels, not sentences. They have no full stop. Use the name from the code.

## What does not go on the map

- A tagline or a subtitle below a name.
- A comment on how interesting, important or elegant a part is.
- A number that changes while the system runs.
- A status of this machine or of today, unless it explains a dashed line. Put that in the `what` of the line.
- The history of the code.
- A recommendation to the reader.

## Example rewrites

| First version | Problem | Final version |
| --- | --- | --- |
| Parse: request → `Upload`. | Telegram style. No reason. | `d`: This step reads the request into a typed `Upload`: a filename, a content type and a byte stream. It refuses a request of more than 20 MiB. `why`: Each later step assumes a correct `Upload`. Only this step reads the raw request. |
| The heavy lifting happens once, in the worker. | Decorative. Not a precise fact. | The API does not decode the image. |
| 2.4 MB in, 18 KB out, in 140 milliseconds. | Story text about one row. | Deleted. The row shows the numbers. |
| A hung parser can only be stopped by killing its process. | Passive voice. Idiom. | Only SIGKILL can stop a blocked parser. |
| The worker only has to make the thumbnails. Limits keep a huge image from blowing up memory. | Idiom. | The worker must only make the thumbnails. The limits prevent a large image from using all the memory. |
| Automatic retries that cannot loop forever or spend without limit. | Not a sentence. | Automatic retries must have an end and a spend limit. |
| The engine stops and says so. It does not retry quietly. | Idiom. | The engine stops and shows the stop. It does not try again. |
