# Visual language

`assets/engine.html` implements this language. You do not write it again for a map. Read this file to explain the map to the user, or when the user asks for a change to the look of all maps.

## Tokens

| Token | Value | Use |
| --- | --- | --- |
| `--ink` | `#000` | Text, outlines, lines, dots, hatch |
| `--muted` | `#555` | Small labels, step numbers |
| `--rule` | `#b4c0c8` | Hairlines between page areas, the floor grid |
| `--paper` | `#f8f9fa` | Top faces, panels |
| `--mist` | `#dde3e7` | Front faces |
| `--slate` | `#ccd5db` | Right faces |
| `--steel` | `#8fa3b0` | Side faces of outside blocks |
| `--shade` | black at 6% | The floor of a process |
| Page background | gradient at 168°, `#ccd5db` to `#f8f9fa` | |

Type: Helvetica 11px for all text. Menlo 10.5px for code and JSON. Headings are 14px, weight 500. Small labels are 9px capitals with letter spacing 0.14em. The page uses no other face, weight or colour. Red `#b00020` is only for a fact that the reader must not miss.

Controls are flat: a 1px black border, no radius, no shadow. A hovered or selected control is black with white text.

The page has one look. It has no dark theme.

## The page

| Area | Contents |
| --- | --- |
| Top bar | Repository, 0 to 3 constants of the design, and the buttons "Pause the flow", "Trace one step", "Reset view" |
| Left list | Each block by group. A number shows how many steps the block has. |
| Floor | The isometric map |
| Right panel | Two tabs: "What it does" and "How it's built" |
| Line below the floor | The name of the item below the pointer |

On a narrow screen the left list is hidden and the panel is below the floor.

## Blocks

A block is a prism on the floor. Its name is on the top face, horizontal, in 9.5px text with a pale outline. The style of the block shows its kind.

| Style | Drawing | Kinds |
| --- | --- | --- |
| Hatched block | Vertical hatch on the two side faces. Plain top. | `stage`, `child`, each step |
| Block with horizontal lines | Horizontal lines on the two side faces | `support` |
| Stack of rounded slabs | 3 slabs with round corners, plain sides | `table`, `store`, `state` |
| Block of stacked plates | Plain sides with a heavy line each 0.3 units of height | `queue`, `scheduler` |
| Dotted slab | A slab 0.4 high with dots on the sides | `ui` |
| Steel block | Solid grey-blue sides, no hatch | `external`, `model` |

The legend in the first panel lists only the styles that the map uses.

Height shows importance, in a small range: 0.4 to 1.6 units.

A selected block has a black top face and white text.

## Process floors

A dashed rectangle on the floor, with a slightly darker floor inside, shows the blocks that one process runs. The process name lies on the floor in front of the rectangle, in small capitals, along the x axis. The floor grid has a line each 4 units.

## Lines

- A line is a thin black track on the floor, with right-angle corners, like a track on a circuit board.
- A round pad marks each end, on the edge of a block.
- A dashed line is a conditional connection.
- Where two lines cross, the later line has a pale casing. Thus it shows as the line on top.
- A line becomes thick on hover and when it is selected.

## Dots

- A dot is a small black diamond that moves along a line at a constant speed.
- One dot is one packet. A line with data in two directions has two dots.
- Hover shows a ring. A selected dot is larger.
- "Pause the flow" stops all dots. "Trace one step" stops the flow and selects the next dot of the main subject, in order.
- If the reader prefers reduced motion, the flow starts paused.

## Selection

- A click on a block shows the block in the panel. The blocks and lines that have no connection to it become faint (20% opacity).
- A click on a line or a dot shows it in the panel. All other lines, and all blocks that are not at its ends, become faint.
- A click on the open floor removes the selection.

## The inside view

- A double-click on a block opens its steps. The change has no zoom animation.
- Steps are hatched blocks in rows of 4, left to right. A large faint number lies in the back corner of each step, along the x axis. The number is not part of the name.
- The blocks that send data to this block are on the left. The blocks that receive data from it are on the right. Each has its real style and its real name. A double-click on one opens that block.
- A dashed outline around the steps has the block name and the process name.
- "← Come back out", the left arrow key and Esc go back to the full map.

## The panel

| Selection | Panel contents |
| --- | --- |
| Nothing | The system: pipeline sentences, legend, controls. Second tab: structure. |
| Block | Group and process, name, "Enter" button, `does`. Second tab: `built` and files. Then the list "Data in and out". |
| Step | "Step 2 of 5", name, "What it does", "Why it exists", files |
| Line | "Connection", the two block names, `what`, the list "Carries" |
| Dot | "Data packet", the two block names, title, the table name, the JSON, `src` |

## Controls

| Input | Result |
| --- | --- |
| Click | Select |
| Double-click a block, or Enter | Open its steps |
| ← or Esc | Go back, or remove the selection |
| ↓ ↑ | Select the next or the previous block |
| → | Open the selected block |
| Drag | Move the floor |
| Scroll, or + and − | Zoom |

## What the language never has

- A tagline or decoration text.
- Live numbers.
- Angled block names.
- A line that ends in open floor.
- Colour as a category. The style of the block shows the category.
- Icons, emoji, gradients on blocks, shadows, rounded controls.
- A zoom animation when the reader opens or closes a block.

## Changing the language

If the user asks for a change that applies to all maps (a new kind, a new style, a new control), change `assets/engine.html`, the `STYLE` table in `scripts/build.mjs`, and the tables in this skill together. Build `assets/minimal-data.js` again to make sure that it builds with 0 errors.

If the user asks for a change to one map, change only its data file.
