---
name: drawing-codebase-flow-maps
description: Use when the user asks for a visual, isometric, or interactive diagram of a codebase or system - a flow map, architecture map, "turn this repo into a diagram", moving data packets to click, or drill-down into processes.
---

# Drawing codebase flow maps

## Objective

A flow map is one HTML page that shows a system as blocks on an isometric floor. Lines connect the blocks. Dots move along the lines, and each dot is one real row of data. The reader clicks a block, a line or a dot to read it, and double-clicks a block to see its steps.

The reader uses the map to discuss the codebase. Thus each word on the map must be a fact about the code.

You write one data file. A script checks the data file and builds the page. You do not write HTML, CSS or drawing code.

## Files of this skill

| File | Use |
| --- | --- |
| `assets/engine.html` | The page: style, drawing code and controls. Do not edit it for one map. |
| `assets/minimal-data.js` | The smallest valid data file. Copy it to start. |
| `scripts/build.mjs` | Checks a data file and writes the page. |
| `references/data-model.md` | Each field of the data file. Read it before you write data. |
| `references/layout-and-routing.md` | Where to put blocks and how to route lines. Read it before you set coordinates. |
| `references/writing-ste100.md` | How to write each text field in ASD-STE100. Read it before you write text. |
| `references/visual-language.md` | What each style means and what the page does. Read it if the user asks about the look. |

## Procedure

Do the steps in this order. Do not write coordinates before the list of blocks and lines is complete.

### 1. Read the system

1. Read the architecture documents, the README and each process entrypoint. If the repository has a `.codegraph/` directory, use CodeGraph first.
2. Write these five lists as working notes. They are not a deliverable. Each item needs a file path in this repository as evidence. For an outside service, the evidence is the file that calls it.
   - **Processes:** each operating system process, and the code that it runs.
   - **Stages:** each part of the main path of the data, in order.
   - **Shared systems:** queues, schedulers, tables, object stores, health checks, recovery code.
   - **Outside services:** each service that a different party operates.
   - **Connections:** each pair of items that exchange data, the direction, and the data.
3. Find the one subject that you can follow from the start of the main path to the end: one order, one file, one request. The dots follow this subject.

### 2. Select the blocks

1. Use 6 to 12 blocks for one small service, and 10 to 25 blocks for a system of 2 or more processes. A map with more than 25 blocks is not readable. Merge items that have the same connections. Do not divide one part into 2 blocks to get a larger number.
2. Give each block one kind from the table in "Kinds and styles". The kind sets the style. Do not select a style directly.
3. Give each block a name of 1 to 3 words. Use the name that the code uses: a package name, a type name or a stage name. If two things have the same name in the code, add the owner to the name. If the code has no name for the thing, use the name of its type.
4. A system can have 2 data paths, for example a write path and a read path. The blocks of the second path are also `stage` blocks. Give the second path its own group.
5. Put each block in a group for the block list: a data path, the shared systems, or the outside services.

### 3. Collect the packets

A packet is the content of one dot: a real row or a real message.

1. Read the data store of the local development environment in a read-only transaction. Do not read a production store unless the user tells you to.
2. Follow the one subject from step 1. Get one row for each connection on the main path.
3. Shorten long values and long arrays. Mark a shortened array with `"…+3"`.
4. Remove each credential, token and private key. Replace the project part of an internal host name with `PROJECT`. Do not include personal data of a private person.
5. If a connection has no row for the subject, use a row of a different subject. Say this in the `src` text of the packet.
6. If the system has no data store that you can read, use rows from test fixtures and set `META.snapshot` to `test fixtures`. If there are no fixtures, make a map with no packets.
7. The target is one packet for each line of the main path. 30 packets is the maximum. A map with 2 packets is correct if the system has only 2 real examples.
8. A packet can be a message that is not a database row: an HTTP request, a queue message, a log record. Use the real field names of the message. Set `table` to the route or the message name.
9. A placeholder value in a fixture, such as `aaa.bbb.ccc` in the position of a token, is not a credential. Keep it.
10. Put a packet key in `TRACE` only if the packet is from the main subject. If no packet is from the main subject, set `TRACE` to `[]`. Then the page hides the button "Trace one step", and `META.trace` is not necessary.

Do not invent a row. An invented row that looks real is a false statement about the system.

### 4. Write the steps of each block

Each block that is not an outside service needs 2 to 8 steps in execution order. A step has a name, a description (`d`), a reason (`why`) and one file path. Write only the steps that the code has. Do not add a step to get a larger number.

The reason is the most important text on the map. A reader who does not know the term "verify digest" must understand from `d` what the step does, and from `why` what fails without it. See `references/writing-ste100.md` for the pattern and examples.

### 5. Put the blocks on the floor and route the lines

Read `references/layout-and-routing.md`. The short rules:

1. The main path goes left to right in one row. Outside services are behind it. Shared systems are in front of it.
2. Put the blocks where the data flow needs them. Then draw a process floor around the blocks of each process, where they are. Do not move blocks to get one floor for each process.
3. Each connection is one line with its own track. No two lines share a segment.
4. Each line starts and ends on the edge of its block.
5. Two-way data between two blocks is one line with two packets (`pk` and `rk`).
6. If a row rule gives a crossing and a different position gives none, use the position with no crossing. Fewer crossings is more important than the row of a block.

### 6. Write the text

Read `references/writing-ste100.md`. All text on the map is ASD-STE100: short sentences, active voice, present tense, one term for one thing. The build script refuses a data file that breaks the rules it can measure.

### 7. Build and correct

```sh
node ~/.claude/skills/drawing-codebase-flow-maps/scripts/build.mjs <map-data.js> <out.html> --repo <repository directory>
```

With `--repo`, the script makes sure that each file path in the data file exists. Always give it.

1. Correct each `ERROR` line. The script writes the page only when there are no errors.
2. Read each `warning` line. Correct it, or decide that it is acceptable. A crossing of two lines is acceptable if a different route makes more crossings. Possible passive voice is acceptable if the word is an adjective.
3. Do not change `scripts/build.mjs` or `assets/engine.html` to remove an error.
4. The script cannot examine the meaning of the data. A build with 0 errors can show a false statement. Do step 8 before you report.

### 8. Look at the page

If a headless browser is available, make two screenshots and read them: the full map, and the inside view of one block.

```sh
# A Playwright browser is frequently in ~/Library/Caches/ms-playwright/ (macOS) or ~/.cache/ms-playwright/ (Linux).
B=$(find ~/Library/Caches/ms-playwright ~/.cache/ms-playwright -type f -name '*headless*shell*' -perm -u+x 2>/dev/null | head -1)
"$B" --no-sandbox --hide-scrollbars --window-size=1800,1100 --virtual-time-budget=2000 --screenshot=map.png "file://$PWD/out.html"
```

Examine these points in the screenshots:

- Each block name is readable and is on its block.
- Each line goes to the block that the data says. No line ends behind a block.
- No label is below a block or a line.
- In the inside view, each dot moves between two steps that exchange that data.

For the inside view, make a copy of the page that opens one block: add `state.scene = '<block id>'; build(); setVB(home);` before the last `</script>` of the copy.

If no browser is available, do not look for a different method. Say in the report that nobody saw the page.

### 9. Publish and report

1. If the Artifact tool is available, publish the page with the icon `map`. Give the link.
2. Tell the user which checks ran: the build, the file paths, the screenshots. If you did not see the page, say that.
3. List each packet that is not from the main subject, and each warning that you accepted.
4. Keep the data file. The user will ask for changes, and each change is an edit of the data file and a new build.

## Kinds and styles

| Kind | Use it for | Style on the map | Usual size (w × d × h) |
| --- | --- | --- | --- |
| `stage` | One part of a data path | Hatched block | 4 × 4 × 1.2 to 1.6 |
| `child` | Isolated code that a stage starts: child process, sandbox | Hatched block | 3 × 3 × 1 |
| `support` | Engine code that helps the stages: recovery, health checks | Block with horizontal lines | 3 × 3 × 1 |
| `table` | Data in a database | Stack of rounded slabs | 3 × 3 × 1.26 |
| `state` | State that the process holds in memory: a registry, a cache, a connection map | Stack of rounded slabs | 3 × 3 × 1.26 |
| `store` | A bucket or a file store | Stack of rounded slabs | 5 × 4 × 1.26 |
| `queue` | A work queue | Block of stacked plates | 6 × 4.5 × 1.2 |
| `scheduler` | Code that runs on a timer | Block of stacked plates | 3 × 3 × 1.2 |
| `ui` | Pages that a person uses | Dotted slab | 3 × 3 × 0.4 |
| `external` | Each system whose code is not in this repository: a service of a different party, a client, a service of a different team | Steel block | 4 × 4 × 0.6 |
| `model` | An AI model provider | Steel block | 3 × 2.5 × 0.8 |

A process is not a block. A process is a dashed floor outline (a zone) around its blocks.

The legend of the page names each kind that the map uses: "A hatched block is a pipeline stage or a child process." Thus the kind must be true for the block. If no kind is true, use the nearest kind and say the difference in the first paragraph of `does`.

A block of kind `external` or `model` has no steps. Its `files` are the files of this repository that call it or configure it.

A queue or a table that the data goes through can be in the main row. The row of a block follows its position in the data flow, not its kind.

## Rules that the user set

Each rule came from a correction. Obey each one.

| Rule | Reason |
| --- | --- |
| No taglines, no subtitles, no story text. | The reader wants facts. |
| No numbers that change while the system runs: row counts, queue lengths, "right now" tables. | The page is a map, not a monitor. The numbers are wrong one minute later. |
| The top bar holds only the repository, the stack and constants of the design. | Same reason. |
| The block name is on the block, horizontal. | Angled text is hard to read. |
| Each line ends on a block. No line ends in open floor. | A line that stops in open floor looks like an error. |
| No two lines share a track. Think of a circuit board. | Shared tracks hide which block talks to which. |
| Each block that is not an outside service has steps. | The reader double-clicks each block and expects to enter it. |
| Each step says what it does and why it exists. | The step name alone means nothing to a new reader. |
| The inside view of a block shows where its data comes from and where it goes. | The reader follows data across blocks. |
| Different kinds of block look different. | The reader must see a table, a stage and an outside service at once. |
| A packet is real data. | The reader inspects it to learn the real shape of the data. |
| All text is ASD-STE100. | One plain style for each map. |

## Common mistakes

| Mistake | Correction |
| --- | --- |
| Coordinates first, connections later | Complete the list of lines first. The lines decide the layout. |
| A line that goes behind a tall block | Lower the block, or move the line. The script reports this. |
| A pad in the middle of the back face of a block | Put a back-face pad near the right corner. See the layout reference. |
| One block for each source folder | A block is a part of the system that the user talks about, not a folder. |
| A step description that repeats the step name | Say what goes in, what comes out, and what the code examines. |
| A `why` that says "for safety" or "for performance" | Name the failure that the step prevents. |
| Text about the history of the code | Describe only the present state. |
| The same thing with two names | Select one term. Use it in each block, step, line and packet. |
| A change to `engine.html` for one map | Change only the data file. Change the engine only when the user changes the visual language for all maps. |
| "Done" with no statement of what you verified | Say which checks ran and that the page was not seen, if that is true. |
| A step packet on the step that receives it | `pk` of a step is the data that leaves the step. The dot moves from that step to the next step. |
| A middle step that calls a neighbour block, with no text about it | The inside view connects each input to step 1 and each output to the last step. Say in `d` of the middle step which block it calls. |

## Checklist before you report

- [ ] `build.mjs` ran with `--repo` and wrote the page with 0 errors.
- [ ] You read a screenshot of the full map and of one inside view, or the report says that nobody saw the page.
- [ ] Each warning is corrected or accepted with a reason.
- [ ] Each block has a kind, a name on the block that fits, and steps (if it is not an outside service).
- [ ] Each step has `d`, `why` and a file path that exists.
- [ ] Each line has a `what` sentence. Each main-path line has a packet, if a real example of its data exists.
- [ ] Each packet is a real row, with no credential in it.
- [ ] `TRACE` lists the packets of the main subject in the order of the data flow, or is `[]`.
- [ ] No text has a count of rows, a status of today, or a tagline.
