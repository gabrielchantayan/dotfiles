# Layout and routing

## The floor

The floor is a grid. One grid unit is 24 pixels before zoom.

- `x` increases down and to the right on the screen.
- `y` increases down and to the left on the screen.
- `z` is the height. It goes up on the screen.
- A block at `(x, y)` with size `w × d × h` covers the footprint from `(x, y)` to `(x + w, y + d)`.

A block has four side faces. The viewer sees two of them.

| Face | Position | Visible |
| --- | --- | --- |
| front | `y = n.y + n.d` | yes |
| right | `x = n.x + n.w` | yes |
| back | `y = n.y` | no |
| left | `x = n.x` | no |

The data flow goes in the `+x` direction: from the left of the screen to the right, and down.

## The rows

Use rows of constant `y`. This arrangement gives free lanes between the rows for the lines.

| Row | y range | Contents |
| --- | --- | --- |
| Outside row | −12 to −9 | Outside services and models that the back helpers and the stages call |
| Helper row | −4 to −1 | Child processes and helpers of one stage, each directly behind its stage |
| Main row | 3 to 7 | The stages of the main path, left to right. The start of the path can be a `ui` block at the left. The receiver at the end is an `external` block at the right. |
| Front row | 11.5 to 16 | Shared systems: queue, scheduler, tables, support blocks |

Lanes for lines:

| Lane | y | Use |
| --- | --- | --- |
| Main lane | 6.4 | The line between two neighbour stages. It is near the front edge of the main row, thus the stage on the right hides little of it. |
| Bus tracks | 8.4, 9.2, 10.0 | Lines between the front row and the main row that must go sideways |
| Back lanes | −5.0, −5.5, −6.5 | Lines from the helper row to the outside row that must go sideways |
| Far lanes | 16.5, 17.5, 18.3 | Lines from one front-row block to a different front-row block, around the front |
| Helper lane | 0.8, 1.5 | Lines between the main row and the helper row that must go sideways |

Leave 3 to 4 units between two blocks in a row. A row of 8 stages is approximately 55 units long. That is the maximum that reads well.

If the main path has more than 8 stages, merge stages. Do not make a second main row.

A second data path (for example a client that connects, while the main path sends data to the client) goes in the helper row or the front row, near the block that the two paths share. Put its blocks left to right in the order of its data.

The rows are a start, not a law. If the row of a block gives a crossing and a different row gives none, move the block. A shared block that only one stage uses is frequently better in the helper row behind that stage.

## Block sizes

Use the sizes from the table "Kinds and styles" in `SKILL.md`. Rules:

- The main stages are 4 × 4. Make the 2 or 3 most important stages 0.2 to 0.4 higher than the others.
- No block is higher than 1.6. A high block hides the lines behind it.
- Front-row blocks are 1.2 high or less, because the bus tracks are behind them.
- A `ui` block is a slab: 0.4 high.
- An `external` block that many blocks call can be a long slab, for example 15 × 3 × 0.4.

The name must fit on the top face. One line of the name holds `floor((w × 24 − 8) / 4.9)` characters: 13 for `w = 3`, 17 for `w = 4`. A name can use 2 or 3 lines. The script warns you if one word is too long.

## What a block hides

A block of height `h` hides the floor point `(x, y)` if the point `(x + k, y + k)` is inside the footprint for some `k` between 0 and `h`.

In plain words: a block hides the floor that is behind it and to its left, for a distance equal to its height.

Consequences:

1. A line that leaves the **back** face at pad `x` is hidden for `min(h, n.x + n.w − x)` units. Put a back-face pad 0.5 from the **right** corner.
2. A line that enters the **left** face at pad `y` is hidden for `min(h, n.y + n.d − y)` units. Put a left-face pad 0.5 from the **front** corner. This is why the main lane is at `y = 6.4` for a main row that ends at `y = 7`.
3. A line on the front face or the right face is fully visible. Use these faces when you can.
4. A lane must be more than `h` units behind each block that it passes. The bus track at `y = 9.2` is 2.3 units behind a front row at `y = 11.5`. That is sufficient for a height of 1.2.
5. A line that goes straight back from a block must not have a tall block close on its right.

The script calculates this. It gives an error if a block that is not an end of the line hides more than 0.6 units, and a warning if an end block hides more than 1.3 units.

## Rules for lines

1. A line is a list of grid points. Each segment is parallel to x or y.
2. The first point is on the edge of block `a`. The last point is on the edge of block `b`. The page draws a pad at each end.
3. No two lines share a segment, and no two lines share a pad. Put neighbour tracks and neighbour pads 0.5 to 0.8 units apart. The script gives an error for a shared segment and for a shared pad.
4. A line does not go under a block.
5. Two lines can cross at a right angle. The page draws the later line over the earlier line. Keep crossings to a minimum: 0 to 4 on a map of 30 lines.
6. A block with the `rounded` style (`table`, `store`) has round corners. Put its pads 0.7 units or more from each corner. The middle of a face is the best position.
7. Use `dash: 1` only for a conditional connection.
8. Two-way data between two blocks is one line with `pk` and `rk`. Do not draw two lines.
9. A line with no packet is correct if you have no real row for it.

## How to route without crossings

### Straight first

Put two connected blocks so that one straight segment connects them. A helper sits directly behind its stage, with the pad of the stage near the right corner of its back face:

```js
// The stage: { id: 'prep', x: 14, y: 3, w: 4, d: 4, h: 1.6 }
// The helper: { id: 'trial', x: 15.5, y: -4, w: 3, d: 3, h: 1 }
{ id: 'f_trial', a: 'prep', b: 'trial', path: [[17.5, 3], [17.5, -1]] },   // back face of prep at x = 17.5, front face of trial
```

### Fan-out from one block: nest the tracks

A queue that feeds 5 stages needs 5 lines from one face. Lines to the left and lines to the right nest like the layers of an onion.

Rule: of two lines that turn in the same direction, the line that goes **farther** sideways has its pad **nearer the outside** of the fan and uses the track **nearer the source block**.

```js
// The queue: { id: 'queue', x: 21, y: 11.5, w: 6, d: 4.5 }. Stages on the main row end at y = 7.
{ id: 'f_qdisc',   a: 'queue', b: 'disc',  path: [[22, 11.5],   [22, 9.2],   [9.5, 9.2],  [9.5, 7]] },   // far left: pad 22, track 9.2
{ id: 'f_qprep',   a: 'queue', b: 'prep',  path: [[23, 11.5],   [23, 8.4],   [17.5, 8.4], [17.5, 7]] },  // near left: pad 23, track 8.4
{ id: 'f_wienum',  a: 'queue', b: 'enum',  path: [[25, 11.5],   [25, 7]] },                              // straight
{ id: 'f_widown',  a: 'queue', b: 'down',  path: [[26, 11.5],   [26, 8.4],   [32, 8.4],   [32, 7]] },    // near right: pad 26, track 8.4
{ id: 'f_wideliv', a: 'queue', b: 'deliv', path: [[26.6, 11.5], [26.6, 9.2], [48.5, 9.2], [48.5, 7]] },  // far right: pad 26.6, track 9.2
```

Examine each pair: the horizontal part of one line must not include the `x` of the vertical part of the other line in the same `y` range.

### Fan-in to one block from a column

The same rule applies when 3 lines enter one face from blocks that are in a column. The line from the farthest block turns nearest to the face.

### A line that must go around

Go around the front of the front row on a far lane, or behind the helper row on a back lane. Do not go between two blocks that are less than 2 units apart.

```js
// Recovery (front row, right) sends work to the queue (front row, left). The line goes around the front.
{ id: 'f_recov', a: 'recov', b: 'queue', path: [[42, 15], [42, 17.5], [24, 17.5], [24, 16]] },
```

### When a crossing remains

Try these in order:

1. Exchange the pads of the two lines on the shared block.
2. Move one block along its row.
3. Move a shared block to the other side of the block that it serves.
4. Accept the crossing if each alternative adds a longer line or 2 crossings.

## Zones

1. First put the blocks where the data flow needs them.
2. Then draw one rectangle around each set of neighbour blocks that one process runs.
3. One process can have 2 or 3 zones. That is correct. Do not rearrange the blocks to get one zone for each process. The user compared the two layouts and selected the layout that follows the data flow.
4. A zone outline is a minimum of 0.5 units from each block inside it. If a zone holds 2 rows of different length, one side has more space. That is correct.
5. Tables, object stores and outside services are in no zone, unless the user asks for a database zone.
6. The label lies on the floor in front of the zone. It occupies the area from `y1 + 0.35` to `y1 + 0.75`, and 0.31 units for each character along x from `lx`. The script warns you if a line goes through this area. Use `lx` to move the label along the front edge, or `back: true` to put it behind the zone (from `y0 − 0.75` to `y0 − 0.35`).

## The inside view

You do not lay out the inside view. The page puts the steps in rows of 4 and adds the neighbour blocks on the left and on the right. Because of this:

- 3 to 8 steps give 1 or 2 rows. That reads well.
- The names of neighbour blocks come from `NODES`.
- The packets on the lines to and from the neighbours come from `FLOWS`.

## Messages of the build script

| Message | Correction |
| --- | --- |
| `the start […] is not on the edge of block` | The first or the last point must have `x` or `y` equal to an edge of the footprint, and be inside the range of that edge. |
| `is on a rounded corner` | Move the pad 0.7 or more from each corner of a `table` or `store` block. |
| `segment … is diagonal` | Add a corner point so that each segment changes only `x` or only `y`. |
| `goes under block` | Route the line around the block on a lane. |
| `block X hides N units of the line` | Move the line farther behind the block, lower the block, or use a different lane. |
| `its own block X hides N units` | Move the pad toward the right corner (back face) or the front corner (left face). |
| `share a segment` | Give one of the lines a different track, 0.5 units or more apart. |
| `cross at` | See "When a crossing remains". |
| `blocks overlap` | Move one block. |
| `share the pad` | Move one of the two pads 0.5 units or more along the face. |
| `goes through the label` | Set `lx` of the zone, or set `back: true`. |
| `the path … does not exist` | Correct the path. Do not cite a file that you did not open. |
| `proc … has no zone` | Add a zone with that label around the block, or remove `proc`. |
| `block X is half inside` zone | Make the zone larger or smaller. |
| `is inside but its proc is` | Set `proc` of the block to the zone label, or move the outline. |
