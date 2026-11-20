#!/usr/bin/env node
/* Checks one map data file and builds the flow map page. Usage: node build.mjs <map-data.js> <out.html> [--repo <dir>] */
import { existsSync, readFileSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';

const [dataPath, outPath, flag, repo] = process.argv.slice(2);
if (!dataPath || !outPath || (flag !== undefined && (flag !== '--repo' || !repo))) {
  console.error('Usage: node build.mjs <map-data.js> <out.html> [--repo <dir>]');
  process.exit(2);
}
const engine = readFileSync(new URL('../assets/engine.html', import.meta.url), 'utf8');
const data = readFileSync(dataPath, 'utf8');
const NAMES = ['META', 'PK', 'GROUPS', 'NODES', 'STEPS', 'FLOWS', 'TRACE', 'ZONES', 'OVERVIEW'];
const { META, PK, GROUPS, NODES, STEPS, FLOWS, TRACE, ZONES, OVERVIEW } = new Function(`${data}\nreturn { ${NAMES.join(', ')} };`)();

const errors = [], warnings = [];
const STYLE = { stage: 'box', child: 'box', support: 'bands', table: 'rounded', store: 'rounded', state: 'rounded', queue: 'stack', scheduler: 'stack', ui: 'dots', external: 'steel', model: 'steel' };
const OUTSIDE = new Set(['external', 'model']);
const CORNER = 0.7, EPS = 1e-6;
const byId = Object.fromEntries(NODES.map((n) => [n.id, n]));

/* ---------- Text: ASD-STE100 checks ---------- */
const BANNED = ['should', 'may', 'might', 'utilize', 'utilise', 'leverage', 'via', 'just', 'simply', 'basically', 'very', 'really', 'easily', 'seamlessly', 'robust',
  'currently', 'right now', 'at the moment', 'in order to', 'due to', 'e\\.g\\.', 'i\\.e\\.', 'etc', 'previously', 'formerly', 'no longer', 'used to'];
const banned = new RegExp(`\\b(${BANNED.join('|')})(?![\\w-])`, 'i');
const passive = /\b(is|are|was|were|be|been|being)\s+(not\s+)?(\w+ed|built|sent|written|kept|held|made|done|run|shown|given|taken|found|read|lost|stored)\b/i;
function lint(where, html) {
  if (typeof html !== 'string' || html.trim() === '') { errors.push(`${where}: text is missing`); return; }
  const text = html.replace(/<code>[\s\S]*?<\/code>/g, 'CODE').replace(/<[^>]+>/g, '').replace(/&\w+;/g, ' ').trim();
  if (/[;]/.test(text)) errors.push(`${where}: semicolon. Write two sentences. "${text.slice(0, 70)}"`);
  if (/—|\s–\s/.test(text)) errors.push(`${where}: dash between clauses. Write two sentences. "${text.slice(0, 70)}"`);
  if (/\b\w+n't\b|\b(it|that|there|here|what)'s\b|\b\w+'(re|ll|ve)\b/i.test(text)) errors.push(`${where}: contraction. "${text.slice(0, 70)}"`);
  if (!/[.:]$/.test(text)) errors.push(`${where}: the text must end with a full stop. "${text.slice(-50)}"`);
  for (const sentence of text.split(/(?<=[.?!])\s+/)) {
    const words = sentence.split(/\s+/).filter(Boolean).length;
    if (words > 25) errors.push(`${where}: sentence of ${words} words, the maximum is 25. "${sentence.slice(0, 70)}…"`);
    const hit = sentence.match(banned);
    if (hit) errors.push(`${where}: word "${hit[0]}" is not permitted. "${sentence.slice(0, 70)}"`);
    if (passive.test(sentence)) warnings.push(`${where}: possible passive voice. Put the actor first. "${sentence.slice(0, 70)}"`);
  }
}

/* ---------- Data ---------- */
for (const key of ['title', 'repo', 'snapshot']) if (typeof META[key] !== 'string') errors.push(`META.${key} is missing`);
if (TRACE.length > 0 && typeof META.trace !== 'string') errors.push('META.trace is missing. It completes the sentence: Click "Trace one step" to follow …');
/* A path in the data file must exist in the repository, if the caller gave the repository. */
const checkPath = (where, path) => { if (repo && !existsSync(join(repo, path))) errors.push(`${where}: the path ${path} does not exist in ${repo}`); };
if (!repo) warnings.push('no --repo <dir>: the file paths are not checked');
if (!Array.isArray(META.facts)) errors.push('META.facts is missing');
if (META.title && META.title.split(/\s+/).length > 4) errors.push('META.title must have 2 to 4 words');
if (!OVERVIEW.title || !Array.isArray(OVERVIEW.pipeline) || typeof OVERVIEW.built !== 'string') errors.push('OVERVIEW needs title, pipeline and built');
(OVERVIEW.pipeline || []).forEach((p, i) => lint(`OVERVIEW.pipeline[${i}]`, p));
[...String(OVERVIEW.built).matchAll(/<p>([\s\S]*?)<\/p>/g)].forEach((m, i) => lint(`OVERVIEW.built paragraph ${i + 1}`, m[1]));
if (NODES.length > 25) warnings.push(`${NODES.length} blocks. The maximum that reads well is 25`);
const groups = new Set(GROUPS.map((g) => g[0]));
for (const n of NODES) {
  const at = `block ${n.id}`;
  if ('now' in n || 'one' in n) errors.push(`${at}: do not store counts or taglines`);
  if (!STYLE[n.kind]) errors.push(`${at}: kind "${n.kind}" is not one of ${Object.keys(STYLE).join(', ')}`);
  if (!groups.has(n.g)) errors.push(`${at}: group "${n.g}" is not in GROUPS`);
  for (const k of ['x', 'y', 'w', 'd', 'h']) if (typeof n[k] !== 'number') errors.push(`${at}: ${k} must be a number`);
  if (!n.name) errors.push(`${at}: name is missing`);
  for (const key of ['does', 'built']) {
    if (!Array.isArray(n[key]) || n[key].length === 0) errors.push(`${at}: ${key} must be a list of paragraphs`);
    else n[key].forEach((p, i) => lint(`${at} ${key}[${i}]`, p));
  }
  if (!Array.isArray(n.files) || n.files.length === 0) errors.push(`${at}: files is missing`);
  else n.files.forEach((p) => checkPath(at, p));
  if (String(n.name).split(' ').length > 3) warnings.push(`${at}: the name has more than 3 words`);
  if (n.proc && !ZONES.some((z) => z.label === n.proc)) warnings.push(`${at}: proc "${n.proc}" has no zone`);
  const max = Math.floor((n.w * 24 - 8) / 4.9), words = String(n.name).split(' ');
  if (words.some((w) => w.length > max)) warnings.push(`${at}: a word of the name is wider than the block (${max} characters)`);
  const steps = STEPS[n.id];
  if (OUTSIDE.has(n.kind)) { if (steps) errors.push(`${at}: an outside block has no steps`); continue; }
  if (!Array.isArray(steps) || steps.length < 2) { errors.push(`${at}: STEPS.${n.id} needs 2 or more steps`); continue; }
  if (steps.length > 8) warnings.push(`${at}: ${steps.length} steps. 3 to 8 steps read best`);
  steps.forEach((s, i) => {
    const sat = `step ${n.id}/${i + 1}`;
    if (!s.n || !s.f) errors.push(`${sat}: n and f are mandatory`);
    else checkPath(sat, s.f);
    lint(`${sat} d`, s.d);
    lint(`${sat} why`, s.why);
    if (s.pk && !PK[s.pk]) errors.push(`${sat}: packet "${s.pk}" does not exist`);
  });
}
for (const id of Object.keys(STEPS)) if (!byId[id]) errors.push(`STEPS.${id}: no block has this id`);
for (const [key, p] of Object.entries(PK)) {
  if (!p.title || !p.table || p.data === undefined) errors.push(`packet ${key}: title, table and data are mandatory`);
  lint(`packet ${key} src`, p.src);
  const raw = JSON.stringify(p.data);
  if (/(secret|password|passwd|token|api[_-]?key|authorization)"\s*:\s*"[^"]{6,}"/i.test(raw) || /\b(sk|pk|ghp|xox[bap])[-_][A-Za-z0-9]{16,}/.test(raw)) errors.push(`packet ${key}: the data looks like a credential. Remove it`);
}

/* ---------- Geometry ---------- */
function side(p, n) {
  const inX = p[0] >= n.x - EPS && p[0] <= n.x + n.w + EPS, inY = p[1] >= n.y - EPS && p[1] <= n.y + n.d + EPS;
  if (!inX || !inY) return undefined;
  if (Math.abs(p[1] - n.y) < EPS) return 'back';
  if (Math.abs(p[1] - n.y - n.d) < EPS) return 'front';
  if (Math.abs(p[0] - n.x) < EPS) return 'left';
  if (Math.abs(p[0] - n.x - n.w) < EPS) return 'right';
  return undefined;
}
function checkEnd(f, p, n, label) {
  const s = side(p, n);
  if (!s) { errors.push(`line ${f.id}: the ${label} [${p}] is not on the edge of block ${n.id}`); return; }
  if (STYLE[n.kind] === 'rounded') {
    const along = s === 'back' || s === 'front' ? [p[0] - n.x, n.w] : [p[1] - n.y, n.d];
    if (along[0] < CORNER - EPS || along[0] > along[1] - CORNER + EPS) errors.push(`line ${f.id}: the ${label} [${p}] is on a rounded corner of ${n.id}. Keep ${CORNER} from each corner`);
  }
}
/* The length of segment p→q that block n hides from the viewer. A block of height h hides the floor point (x, y) if (x + k, y + k) is inside its footprint for some 0 < k <= h. */
function hiddenBy(p, q, n) {
  const len = Math.hypot(q[0] - p[0], q[1] - p[1]), steps = Math.max(1, Math.ceil(len / 0.1));
  let hidden = 0;
  for (let i = 0; i < steps; i++) {
    const t = (i + 0.5) / steps, x = p[0] + (q[0] - p[0]) * t, y = p[1] + (q[1] - p[1]) * t;
    const lo = Math.max(0, n.x - x, n.y - y), hi = Math.min(n.h, n.x + n.w - x, n.y + n.d - y);
    if (lo < hi - EPS) hidden += len / steps;
  }
  return hidden;
}
const segs = [];
const flowIds = new Set();
const pads = new Map();
for (const f of FLOWS) {
  if (flowIds.has(f.id)) errors.push(`line ${f.id}: the id is not unique`);
  flowIds.add(f.id);
  const a = byId[f.a], b = byId[f.b];
  if (!a || !b) { errors.push(`line ${f.id}: block "${a ? f.b : f.a}" does not exist`); continue; }
  lint(`line ${f.id} what`, f.what);
  for (const key of ['pk', 'rk']) if (f[key] && !PK[f[key]]) errors.push(`line ${f.id}: packet "${f[key]}" does not exist`);
  if (!Array.isArray(f.path) || f.path.length < 2) { errors.push(`line ${f.id}: path needs 2 or more points`); continue; }
  for (const p of [f.path[0], f.path[f.path.length - 1]]) {
    const key = p.join(',');
    if (pads.has(key)) errors.push(`lines ${pads.get(key)} and ${f.id} share the pad [${key}]. Move one pad 0.5 units or more`);
    pads.set(key, f.id);
  }
  checkEnd(f, f.path[0], a, 'start');
  checkEnd(f, f.path[f.path.length - 1], b, 'end');
  const hide = {};
  for (let i = 1; i < f.path.length; i++) {
    const p = f.path[i - 1], q = f.path[i];
    if (p[0] !== q[0] && p[1] !== q[1]) errors.push(`line ${f.id}: segment [${p}]→[${q}] is diagonal. Each segment must be parallel to x or y`);
    segs.push({ id: f.id, p, q });
    for (const n of NODES) {
      const x0 = Math.min(p[0], q[0]), x1 = Math.max(p[0], q[0]), y0 = Math.min(p[1], q[1]), y1 = Math.max(p[1], q[1]);
      const under = x1 > n.x + EPS && x0 < n.x + n.w - EPS && y1 > n.y + EPS && y0 < n.y + n.d - EPS;
      if (under) errors.push(`line ${f.id}: segment [${p}]→[${q}] goes under block ${n.id}`);
      hide[n.id] = (hide[n.id] || 0) + hiddenBy(p, q, n);
    }
  }
  for (const [id, len] of Object.entries(hide)) {
    const own = id === f.a || id === f.b;
    if (!own && len > 0.6) errors.push(`line ${f.id}: block ${id} hides ${len.toFixed(1)} units of the line. Move the line or lower the block`);
    if (own && len > 1.3) warnings.push(`line ${f.id}: its own block ${id} hides ${len.toFixed(1)} units. Put the pad nearer the right corner or the front corner`);
  }
}
for (let i = 0; i < segs.length; i++) for (let j = i + 1; j < segs.length; j++) {
  const s = segs[i], t = segs[j];
  if (s.id === t.id) continue;
  const sv = s.p[0] === s.q[0], tv = t.p[0] === t.q[0];
  if (sv === tv) {
    const c = sv ? 0 : 1, o = 1 - c;
    if (Math.abs(s.p[c] - t.p[c]) > EPS) continue;
    const overlap = Math.min(Math.max(s.p[o], s.q[o]), Math.max(t.p[o], t.q[o])) - Math.max(Math.min(s.p[o], s.q[o]), Math.min(t.p[o], t.q[o]));
    if (overlap > EPS) errors.push(`lines ${s.id} and ${t.id} share a segment. Give each line its own track`);
  } else {
    const v = sv ? s : t, h = sv ? t : s, x = v.p[0], y = h.p[1];
    const cross = x > Math.min(h.p[0], h.q[0]) + EPS && x < Math.max(h.p[0], h.q[0]) - EPS && y > Math.min(v.p[1], v.q[1]) + EPS && y < Math.max(v.p[1], v.q[1]) - EPS;
    if (cross) warnings.push(`lines ${v.id} and ${h.id} cross at [${x}, ${y}]`);
  }
}
for (let i = 0; i < NODES.length; i++) for (let j = i + 1; j < NODES.length; j++) {
  const a = NODES[i], b = NODES[j];
  if (a.x < b.x + b.w - EPS && b.x < a.x + a.w - EPS && a.y < b.y + b.d - EPS && b.y < a.y + a.d - EPS) errors.push(`blocks ${a.id} and ${b.id} overlap`);
}
const packetIds = new Set(FLOWS.flatMap((f) => [f.pk && f.id, f.rk && `${f.id}~`]).filter(Boolean));
for (const id of TRACE) if (!packetIds.has(id)) errors.push(`TRACE: "${id}" is not a packet. Use a line id with pk, or the id and "~" for rk`);
for (const n of NODES) if (!FLOWS.some((f) => f.a === n.id || f.b === n.id)) warnings.push(`block ${n.id}: no line connects it`);
for (const z of ZONES) {
  if (!(z.x0 < z.x1 && z.y0 < z.y1) || !z.label) errors.push(`zone ${z.label}: needs x0 < x1, y0 < y1 and a label`);
  /* The floor area of the label: 0.31 units for each character along x, 0.4 units along y. */
  const lx0 = z.lx ?? z.x0 + 0.3, lx1 = lx0 + 0.31 * String(z.label).length, ly0 = z.back ? z.y0 - 0.75 : z.y1 + 0.35, ly1 = ly0 + 0.4;
  for (const g of segs) {
    const over = Math.max(g.p[0], g.q[0]) > lx0 && Math.min(g.p[0], g.q[0]) < lx1 && Math.max(g.p[1], g.q[1]) > ly0 && Math.min(g.p[1], g.q[1]) < ly1;
    if (over) warnings.push(`zone ${z.label}: line ${g.id} goes through the label. Set lx, or set back: true`);
  }
  for (const n of NODES) {
    const inside = n.x >= z.x0 && n.x + n.w <= z.x1 && n.y >= z.y0 && n.y + n.d <= z.y1;
    const apart = n.x >= z.x1 || n.x + n.w <= z.x0 || n.y >= z.y1 || n.y + n.d <= z.y0;
    if (!inside && !apart) errors.push(`zone ${z.label}: block ${n.id} is half inside`);
    if (inside && n.proc !== z.label) warnings.push(`zone ${z.label}: block ${n.id} is inside but its proc is "${n.proc}"`);
  }
}

for (const w of warnings) console.log('warning  ' + w);
for (const e of errors) console.log('ERROR    ' + e);
console.log(`${NODES.length} blocks, ${Object.values(STEPS).flat().length} steps, ${FLOWS.length} lines, ${Object.keys(PK).length} packets. ${errors.length} errors, ${warnings.length} warnings.`);
if (errors.length > 0) process.exit(1);
if (!engine.includes('/*__MAP_DATA__*/')) throw new Error('assets/engine.html has no data placeholder');
writeFileSync(outPath, engine.replace('__MAP_TITLE__', META.title).replace('/*__MAP_DATA__*/', () => data));
console.log('wrote ' + outPath);
