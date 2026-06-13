#!/usr/bin/env node
'use strict';
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const ROOT = process.cwd();

function readFile(p) {
  try { return fs.readFileSync(path.join(ROOT, p), 'utf8'); } catch { return null; }
}

function git(cmd) {
  try { return execSync(cmd, { cwd: ROOT, stdio: ['pipe','pipe','pipe'] }).toString().trim(); }
  catch { return ''; }
}

function gitStatusEntries() {
  const out = git('git status --porcelain=v1 -z');
  if (!out) return [];

  const parts = out.split('\0').filter(Boolean);
  const entries = [];

  for (let i = 0; i < parts.length; i++) {
    const row = parts[i];
    const status = row.slice(0, 2).trim() || row.slice(0, 2);
    let file = row.slice(3);

    // Rename/copy records include the secondary path as the next NUL field.
    if ((row[0] === 'R' || row[0] === 'C') && i + 1 < parts.length) {
      i += 1;
    }

    if (file) entries.push({ status, path: file });
  }

  return entries;
}

const GENERATED_DIRTY_EXACT = new Set([
  '+wsd/snapshot.json',
  '+wsd/.last-check.json',
]);

const GENERATED_DIRTY_PREFIXES = [
  '.mypy_cache/',
  '.pytest_cache/',
  '.ruff_cache/',
  '.next/',
  'coverage/',
  'dist/',
  'build/',
];

const GENERATED_DIRTY_SUFFIXES = [
  '.log',
  '.pyc',
  '.tmp',
  '.tsbuildinfo',
];

function isGeneratedDirtyPath(filePath) {
  return GENERATED_DIRTY_EXACT.has(filePath) ||
    GENERATED_DIRTY_PREFIXES.some(prefix => filePath.startsWith(prefix)) ||
    GENERATED_DIRTY_SUFFIXES.some(suffix => filePath.endsWith(suffix));
}

function slugify(str) {
  return str.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9-]/g, '').slice(0, 40);
}

// Table row parser: returns array of trimmed cell values, or null if it's a header/separator/empty
function parseTableRows(sectionContent) {
  return sectionContent
    .split('\n')
    .filter(l => l.trim().startsWith('|'))
    .map(l => l.split('|').map(c => c.trim()).filter(Boolean))
    .filter(cols => cols.length >= 2)
    .filter(cols => !cols[0].match(/^[-:]+$/))        // skip separator rows
    .filter(cols => !cols[0].match(/^[A-Z][a-z]/) || cols.every(c => !c.includes('—'))); // keep data rows
}

// Extract content of a ## Section up to next --- or ##
function extractSection(content, heading) {
  const re = new RegExp(`## ${heading}[\\s\\S]*?\\n\\|[^\\n]+\\|\\n\\|[-| :]+\\|\\n([\\s\\S]*?)(?=\\n---|\\n##|$)`);
  const m = content.match(re);
  return m ? m[1] : '';
}

function extractFirstSection(content, headings) {
  for (const heading of headings) {
    const section = extractSection(content, heading);
    if (section) return section;
  }
  return '';
}

// ── Project ───────────────────────────────────────────────────────────────────
let project = { name: 'unknown', slug: 'unknown', type: 'unknown' };
const ctxRaw = readFile('+context.json');
if (ctxRaw) {
  try {
    const ctx = JSON.parse(ctxRaw);
    const name = (ctx.project && ctx.project.name) || 'unknown';
    project = {
      name,
      slug: name.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9-]/g, ''),
      type: (ctx.project && ctx.project.type) || 'unknown',
    };
  } catch {}
}

// ── Git ───────────────────────────────────────────────────────────────────────
const branch = git('git rev-parse --abbrev-ref HEAD') || 'unknown';
const dirty_entries = gitStatusEntries();
const generated_dirty_files = dirty_entries.filter(entry => isGeneratedDirtyPath(entry.path)).map(entry => entry.path);
const source_dirty_files = dirty_entries.filter(entry => !isGeneratedDirtyPath(entry.path)).map(entry => entry.path);
const is_dirty = dirty_entries.length > 0;
let ahead_count = 0;
try { ahead_count = parseInt(git('git rev-list --count @{u}..HEAD'), 10) || 0; } catch {}
const last_commit_message = git('git log -1 --format=%s').slice(0, 72);

// ── Session ───────────────────────────────────────────────────────────────────
const handoff_exists = fs.existsSync(path.join(ROOT, '+specs/HANDOFF.md'));

// ── Roadmap ───────────────────────────────────────────────────────────────────
function parseRoadmap() {
  const content = readFile('+specs/project/ROADMAP.md');
  if (!content) return { total: 0, by_status: {}, items: [] };

  const byStatus = {};
  const items = [];

  function addItem(title, status) {
    const t = title.replace(/\*\*/g, '').replace(/\[([^\]]+)\]\([^)]*\)/, '$1').trim().slice(0, 60);
    if (!t || t.startsWith('_') || t === '—' || t === 'Feature') return;
    byStatus[status] = (byStatus[status] || 0) + 1;
    items.push({ id: slugify(t), title: t, status });
  }

  // Features Ativas — col0=Feature, col1=Status
  const ativas = extractSection(content, 'Features Ativas');
  for (const cols of parseTableRows(ativas)) {
    const status = cols[1] ? cols[1].replace(/`/g, '').trim() : '';
    if (!status || status === '—' || status === 'Status' || status === 'Prioridade') continue;
    addItem(cols[0], status);
  }

  // Backlog — implied planned
  const backlog = extractSection(content, 'Backlog');
  for (const cols of parseTableRows(backlog)) {
    if (cols[0] === '—' || cols[0].startsWith('_')) continue;
    addItem(cols[0], 'planned');
  }

  // Concluídas — implied done
  const conclSection = content.match(/## Conclu[íi]das[\s\S]*?\n\|[^\n]+\|\n\|[-| :]+\|\n([\s\S]*?)(?=\n---|\n##|$)/);
  if (conclSection) {
    for (const cols of parseTableRows(conclSection[1])) {
      if (cols[0] === '—' || cols[0].startsWith('_')) continue;
      addItem(cols[0], 'done');
    }
  }

  // Descartadas — implied discarded
  const discSection = content.match(/## Descartadas[\s\S]*?\n\|[^\n]+\|\n\|[-| :]+\|\n([\s\S]*?)(?=\n---|\n##|$)/);
  if (discSection) {
    for (const cols of parseTableRows(discSection[1])) {
      if (cols[0] === '—' || cols[0].startsWith('_')) continue;
      byStatus['discarded'] = (byStatus['discarded'] || 0) + 1;
    }
  }

  const order = ['in-progress', 'blocked', 'specified', 'planned', 'done', 'discarded'];
  items.sort((a, b) => (order.indexOf(a.status) + 99) % 100 - (order.indexOf(b.status) + 99) % 100);

  return { total: Object.values(byStatus).reduce((s, v) => s + v, 0), by_status: byStatus, items };
}

// ── Ideas Pipeline ────────────────────────────────────────────────────────────
function parseIdeas() {
  const content = readFile('+specs/project/IDEAS_PIPELINE.md');
  if (!content) return { total: 0, by_status: {}, items: [] };

  const byStatus = {};
  const items = [];

  const pipeline = extractSection(content, 'Pipeline');
  for (const cols of parseTableRows(pipeline)) {
    const id = cols[0];
    const title = (cols[1] || '').slice(0, 60);
    const status = (cols[2] || '').replace(/`/g, '').trim();
    if (!id || id === '—' || id === 'ID') continue;
    if (!status || status === '—' || status === 'Status') continue;
    byStatus[status] = (byStatus[status] || 0) + 1;
    items.push({ id, title, status });
  }

  return { total: Object.values(byStatus).reduce((s, v) => s + v, 0), by_status: byStatus, items };
}

// ── State ─────────────────────────────────────────────────────────────────────
function parseState() {
  const content = readFile('+specs/project/STATE.md');
  if (!content) return { active_blockers: 0, total_decisions: 0 };

  const decisoesSection = extractFirstSection(content, ['Decisões', 'Decisions']);
  const blocksSection   = extractFirstSection(content, ['Bloqueadores Ativos', 'Blockers']);

  function countDataRows(sectionContent) {
    return sectionContent
      .split('\n')
      .filter(l => l.trim().startsWith('|'))
      .map(l => l.split('|').map(c => c.trim()).filter(Boolean))
      .filter(cols => cols.length >= 2)
      .filter(cols => !cols[0].match(/^[-:]+$/))
      .filter(cols => cols[0] !== 'Data' && cols[0] !== '—' && !cols[0].startsWith('_'))
      .length;
  }

  // For blockers, skip rows where last column contains "resolvido"
  const activeBlockers = blocksSection
    .split('\n')
    .filter(l => l.trim().startsWith('|'))
    .map(l => l.split('|').map(c => c.trim()).filter(Boolean))
    .filter(cols => cols.length >= 2 && !cols[0].match(/^[-:]+$/) && cols[0] !== 'Data' && cols[0] !== '—')
    .filter(cols => !cols[cols.length - 1].toLowerCase().includes('resolvido'))
    .length;

  return {
    active_blockers: activeBlockers,
    total_decisions: countDataRows(decisoesSection),
  };
}

// ── Health ────────────────────────────────────────────────────────────────────
function readHealth() {
  const cacheFile = path.join(ROOT, '+wsd/.last-check.json');
  if (!fs.existsSync(cacheFile)) return { last_check_passed: null, ghost_specs_detected: 0 };
  try {
    const d = JSON.parse(fs.readFileSync(cacheFile, 'utf8'));
    return { last_check_passed: d.passed === true, ghost_specs_detected: d.ghost_specs || 0 };
  } catch { return { last_check_passed: null, ghost_specs_detected: 0 }; }
}

// ── Assemble ──────────────────────────────────────────────────────────────────
const roadmap = parseRoadmap();
const ideas   = parseIdeas();
const state   = parseState();
const health  = readHealth();
const open_specs = roadmap.items.filter(i => i.status === 'in-progress').map(i => i.id);

function readWsdVersion() {
  try { return JSON.parse(readFile('+wsd/config.json') || '{}').version || null; }
  catch { return null; }
}

const snapshot = {
  schema: 'wsd/project-snapshot/v1',
  generated_at: new Date().toISOString(),
  wsd_version: readWsdVersion(),
  project,
  git: {
    branch,
    is_dirty,
    ahead_count,
    dirty_count: dirty_entries.length,
    source_dirty_count: source_dirty_files.length,
    generated_dirty_count: generated_dirty_files.length,
    has_source_changes: source_dirty_files.length > 0,
    source_dirty_files: source_dirty_files.slice(0, 20),
    generated_dirty_files: generated_dirty_files.slice(0, 20),
    last_commit_message,
  },
  session: { handoff_exists, open_specs },
  roadmap,
  ideas,
  state,
  health,
};

const outPath = path.join(ROOT, '+wsd', 'snapshot.json');
fs.mkdirSync(path.dirname(outPath), { recursive: true });
fs.writeFileSync(outPath, JSON.stringify(snapshot, null, 2) + '\n');
console.log('ok: snapshot gerado em +wsd/snapshot.json');
