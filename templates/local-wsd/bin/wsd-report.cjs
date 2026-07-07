#!/usr/bin/env node
'use strict';

// WSD report engine — fonte única de leitura estruturada dos artefatos WSD.
// Todo parsing de markdown acontece aqui (Node), nunca em bash.
// Modos:
//   report [--save|--output <file>]  Markdown completo (usado por `wsd relatorio`)
//   brief                            pares chave: valor (usado por `wsd start --brief`)
//   bloat                            avisos de compactação (usado por `wsd check`/`finish`)

const fs = require('fs');
const path = require('path');
const cp = require('child_process');

const root = process.cwd();

const BLOAT_LIMITS = {
  '+specs/project/STATE.md': 150,
  '+specs/project/CONCERNS.md': 120,
  '+specs/project/CONCERNS_PIPELINE.md': 120,
};

function read(file) {
  try {
    return fs.readFileSync(path.join(root, file), 'utf8');
  } catch (_error) {
    return '';
  }
}

function readJson(file) {
  try {
    return JSON.parse(read(file));
  } catch (_error) {
    return {};
  }
}

function git(args, fallback = '') {
  try {
    return cp.execFileSync('git', args, { cwd: root, encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] }).trim();
  } catch (_error) {
    return fallback;
  }
}

function strip(value) {
  return String(value || '')
    .replace(/`/g, '')
    .replace(/\*\*/g, '')
    .replace(/\s+/g, ' ')
    .trim();
}

function normalizeHeading(value) {
  return strip(value)
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .toLowerCase();
}

function section(markdown, heading) {
  const lines = markdown.split(/\r?\n/);
  const wanted = normalizeHeading(heading);
  const start = lines.findIndex((line) => normalizeHeading(line.trim()) === wanted);
  if (start === -1) return '';
  const out = [];
  for (let i = start + 1; i < lines.length; i += 1) {
    if (/^##\s+/.test(lines[i])) break;
    out.push(lines[i]);
  }
  return out.join('\n');
}

function parseTableRows(markdown) {
  return markdown
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter((line) => line.startsWith('|') && line.endsWith('|'))
    .filter((line) => !/^\|\s*-{2,}/.test(line))
    .filter((line) => !line.includes('---'))
    .map((line) => line.slice(1, -1).split('|').map((cell) => strip(cell)))
    .filter((cells) => cells.some((cell) => cell && cell !== '—'))
    .filter((cells) => !cells.some((cell) => cell.startsWith('_(')));
}

function tableRows(file, heading) {
  const markdown = read(file);
  if (!markdown) return [];
  return parseTableRows(section(markdown, heading));
}

function checkboxItems(file, heading) {
  const markdown = read(file);
  if (!markdown) return [];
  return section(markdown, heading)
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter((line) => /^- \[ \]/.test(line))
    .map((line) => strip(line.replace(/^- \[ \]\s*/, '')));
}

function frontmatter(file) {
  const content = read(file);
  if (!content.startsWith('---')) return {};
  const end = content.indexOf('\n---', 3);
  if (end === -1) return {};
  const data = {};
  content.slice(3, end).split(/\r?\n/).forEach((line) => {
    const match = line.match(/^([A-Za-z0-9_-]+):\s*(.*)$/);
    if (match) data[match[1]] = strip(match[2]).replace(/^["']|["']$/g, '');
  });
  return data;
}

function listSpecs() {
  const base = path.join(root, '+specs/features');
  if (!fs.existsSync(base)) return [];
  return fs.readdirSync(base, { withFileTypes: true })
    .filter((entry) => entry.isDirectory())
    .map((entry) => {
      const specPath = `+specs/features/${entry.name}/spec.md`;
      const tasksPath = `+specs/features/${entry.name}/tasks.md`;
      const meta = frontmatter(specPath);
      const tasks = read(tasksPath);
      const openTasks = (tasks.match(/^- \[ \]/gm) || []).length;
      return {
        slug: entry.name,
        title: meta.title || entry.name,
        status: strip(meta.status || 'unknown'),
        risk: strip(meta.risk || 'unknown'),
        specPath,
        tasksPath: fs.existsSync(path.join(root, tasksPath)) ? tasksPath : '',
        openTasks,
      };
    })
    .sort((a, b) => a.slug.localeCompare(b.slug));
}

function countIdeaIds() {
  const ideas = read('+specs/project/IDEAS.md');
  return [...ideas.matchAll(/^##\s+(IDEA-[0-9]+)/gm)].map((match) => match[1]);
}

function rowStatus(row, index) {
  return strip(row[index] || '').toLowerCase();
}

function isClosedStatus(status) {
  return ['done', 'resolved', 'accepted-risk', 'obsolete', 'implementada', 'descartada', 'discarded'].includes(status);
}

function bulletRows(rows, formatter, emptyText, limit = 10) {
  const visible = rows.slice(0, limit);
  if (!visible.length) return [`- ${emptyText}`];
  const out = visible.map(formatter);
  if (rows.length > limit) out.push(`- ... mais ${rows.length - limit} item(ns) omitido(s)`);
  return out;
}

function mdList(items, emptyText, limit = 10) {
  if (!items.length) return [`- ${emptyText}`];
  const out = items.slice(0, limit).map((item) => `- ${item}`);
  if (items.length > limit) out.push(`- ... mais ${items.length - limit} item(ns) omitido(s)`);
  return out;
}

function bloatWarnings() {
  const warnings = [];
  for (const [file, limit] of Object.entries(BLOAT_LIMITS)) {
    const content = read(file);
    if (!content) continue;
    const lineCount = content.split(/\r?\n/).length;
    if (lineCount > limit) {
      warnings.push(`${file} tem ${lineCount} linhas (limite ${limit}) — arquivar entradas resolvidas em +specs/project/archive/ (ver +wsd/guides/sessao.md)`);
    }
  }
  return warnings;
}

function collectModel() {
  const context = readJson('+context.json');
  const wsdConfig = readJson('+wsd/config.json');

  const roadmapActive = tableRows('+specs/project/ROADMAP.md', '## Features Ativas')
    .filter((row) => row[0] && row[0] !== 'Feature');
  const roadmapBacklog = tableRows('+specs/project/ROADMAP.md', '## Backlog')
    .filter((row) => row[0] && row[0] !== 'Feature');
  const specs = listSpecs();
  const blockers = tableRows('+specs/project/STATE.md', '## Bloqueadores Ativos')
    .filter((row) => row[1] && row[1] !== 'Bloqueador' && !isClosedStatus(rowStatus(row, 3)));
  const ideaIds = countIdeaIds();
  const ideaPipeline = tableRows('+specs/project/IDEAS_PIPELINE.md', '## Pipeline')
    .filter((row) => /^IDEA-[0-9]+$/.test(row[0] || ''));
  const concernRows = tableRows('+specs/project/CONCERNS.md', '## Preocupacoes Ativas')
    .filter((row) => /^CONC-[0-9]+$/.test(row[0] || ''));
  const concernPipeline = tableRows('+specs/project/CONCERNS_PIPELINE.md', '## Pipeline')
    .filter((row) => /^CONC-[0-9]+$/.test(row[0] || ''));

  return {
    context,
    wsdConfig,
    projectName: (context.project && context.project.name) || path.basename(root),
    projectType: (context.project && context.project.type) || 'unknown',
    defaultBranch: (context.repository && context.repository.default_branch) || 'main',
    branch: git(['rev-parse', '--abbrev-ref', 'HEAD'], 'unknown'),
    upstream: git(['rev-parse', '--abbrev-ref', '--symbolic-full-name', '@{u}'], 'missing'),
    statusShort: git(['status', '--short', '--untracked-files=all'], ''),
    lastCommit: git(['log', '-1', '--pretty=%h - %s (%ad)', '--date=short'], '(no commits)'),
    remote: git(['remote', 'get-url', 'origin'], 'missing'),
    aheadBehind: git(['status', '--short', '--branch'], '').split(/\r?\n/)[0] || 'unknown',
    roadmapActive,
    roadmapBacklog,
    inProgressRoadmap: roadmapActive.filter((row) => rowStatus(row, 1) === 'in-progress'),
    plannedRoadmap: roadmapActive.filter((row) => ['planned', 'specified', 'blocked'].includes(rowStatus(row, 1))),
    specs,
    openSpecs: specs.filter((spec) => !isClosedStatus(spec.status)),
    specsWithOpenTasks: specs.filter((spec) => spec.openTasks > 0 && !isClosedStatus(spec.status)),
    blockers,
    todos: checkboxItems('+specs/project/STATE.md', '## Todos Ativos'),
    ideaIds,
    ideaPipeline,
    activeIdeas: ideaPipeline.filter((row) => !isClosedStatus(rowStatus(row, 2))),
    ideasWithoutPipeline: ideaIds.filter((id) => !new Set(ideaPipeline.map((row) => row[0])).has(id)),
    concernRows,
    activeConcerns: concernRows.filter((row) => !isClosedStatus(rowStatus(row, 4))),
    concernPipeline,
    activeConcernPipeline: concernPipeline.filter((row) => !isClosedStatus(rowStatus(row, 2))),
    bloat: bloatWarnings(),
    docs: {
      context: fs.existsSync(path.join(root, '+context.json')),
      agents: fs.existsSync(path.join(root, 'AGENTS.md')),
      handoff: fs.existsSync(path.join(root, '+specs/HANDOFF.md')),
      state: fs.existsSync(path.join(root, '+specs/project/STATE.md')),
      roadmap: fs.existsSync(path.join(root, '+specs/project/ROADMAP.md')),
      ideas: fs.existsSync(path.join(root, '+specs/project/IDEAS.md')),
      ideasPipeline: fs.existsSync(path.join(root, '+specs/project/IDEAS_PIPELINE.md')),
      concerns: fs.existsSync(path.join(root, '+specs/project/CONCERNS.md')),
      concernsPipeline: fs.existsSync(path.join(root, '+specs/project/CONCERNS_PIPELINE.md')),
    },
  };
}

function renderReport(m) {
  const concernPipelineIds = new Set(m.concernPipeline.map((row) => row[0]));
  const concernsWithoutPipeline = m.activeConcerns.map((row) => row[0]).filter((id) => !concernPipelineIds.has(id));
  const generatedAt = new Date().toISOString().replace('T', ' ').replace(/\..+$/, ' UTC');

  const attention = [];
  if (m.statusShort) attention.push('worktree com alterações pendentes');
  if (m.blockers.length) attention.push(`${m.blockers.length} bloqueador(es) ativo(s)`);
  if (m.activeConcerns.length) attention.push(`${m.activeConcerns.length} concern(s) ativa(s)`);
  if (concernsWithoutPipeline.length) attention.push(`${concernsWithoutPipeline.length} concern(s) sem pipeline`);
  if (m.ideasWithoutPipeline.length) attention.push(`${m.ideasWithoutPipeline.length} ideia(s) sem pipeline`);
  if (m.inProgressRoadmap.length || m.specsWithOpenTasks.length) attention.push('implementação em andamento detectada');
  if (m.bloat.length) attention.push(`${m.bloat.length} nota(s) acima do limite de compactação`);
  const overall = attention.length ? `atenção: ${attention.join('; ')}` : 'estável: sem sinais críticos nos artefatos WSD';

  let suggestion;
  if (m.statusShort) {
    suggestion = 'Finalizar ou registrar as alterações pendentes antes de iniciar nova frente. Se estiver tudo aprovado, rode `./+wsd/bin/wsd finish`.';
  } else if (m.blockers.length) {
    suggestion = `Resolver ou reclassificar o bloqueador mais antigo: ${m.blockers[0][1]}.`;
  } else if (concernsWithoutPipeline.length) {
    suggestion = `Criar plano no CONCERNS_PIPELINE.md para ${concernsWithoutPipeline[0]} antes de mexer em novas features.`;
  } else if (m.activeConcernPipeline.length) {
    suggestion = `Avançar a concern ${m.activeConcernPipeline[0][0]} para o próximo passo: ${m.activeConcernPipeline[0][5] || m.activeConcernPipeline[0][4] || 'triagem/mitigação'}.`;
  } else if (m.inProgressRoadmap.length) {
    suggestion = `Concluir a feature em andamento "${m.inProgressRoadmap[0][0]}" antes de puxar outro item.`;
  } else if (m.specsWithOpenTasks.length) {
    suggestion = `Executar as tarefas abertas da spec ${m.specsWithOpenTasks[0].specPath}.`;
  } else if (m.plannedRoadmap.length) {
    suggestion = `Promover o primeiro item ativo do ROADMAP: "${m.plannedRoadmap[0][0]}".`;
  } else if (m.activeIdeas.length) {
    suggestion = `Triar a ideia ${m.activeIdeas[0][0]} e decidir se vira spec, roadmap ou descarte.`;
  } else if (m.roadmapBacklog.length) {
    suggestion = `Escolher o primeiro item do backlog ("${m.roadmapBacklog[0][0]}") e criar spec se for L1/L2.`;
  } else {
    suggestion = 'Projeto sem fila operacional clara. A próxima ação recomendada é revisar objetivos e alimentar ROADMAP, IDEAS ou CONCERNS com o próximo trabalho real.';
  }

  const planItems = [];
  m.activeConcernPipeline.slice(0, 5).forEach((row) => {
    planItems.push(`Concern ${row[0]} (${row[2] || 'status n/a'}): ${row[5] || row[4] || row[1]}`);
  });
  m.inProgressRoadmap.slice(0, 5).forEach((row) => {
    planItems.push(`Feature em andamento: ${row[0]} (${row[3] || 'spec não informada'})`);
  });
  m.plannedRoadmap.slice(0, 5).forEach((row) => {
    planItems.push(`Feature ${row[1] || 'planejada'}: ${row[0]} (${row[3] || 'sem spec'})`);
  });
  m.activeIdeas.slice(0, 5).forEach((row) => {
    planItems.push(`Ideia ${row[0]} (${row[2]}): ${row[3] || 'definir próxima etapa'}`);
  });

  return [
    `# Relatorio WSD — ${m.projectName}`,
    '',
    `Gerado em: ${generatedAt}`,
    '',
    '## Resumo Executivo',
    '',
    `- Estado geral: ${overall}`,
    `- Implementação pela metade: ${m.inProgressRoadmap.length || m.specsWithOpenTasks.length ? 'sim' : 'não'}`,
    `- Plano programado: ${planItems.length ? `${planItems.length} item(ns) inferidos em ordem WSD` : 'não há fila clara registrada'}`,
    `- Ideias: ${m.ideaIds.length} registrada(s), ${m.activeIdeas.length} ativa(s) no pipeline, ${m.ideasWithoutPipeline.length} sem pipeline`,
    `- Concerns: ${m.activeConcerns.length} ativa(s), ${m.activeConcernPipeline.length} ativa(s) no pipeline, ${concernsWithoutPipeline.length} sem pipeline`,
    `- Sugestão do agente: ${suggestion}`,
    '',
    '## Estado Atual',
    '',
    `- Projeto: ${m.projectName}`,
    `- Tipo: ${m.projectType}`,
    `- Path: ${root}`,
    `- Branch: ${m.branch}`,
    `- Upstream: ${m.upstream}`,
    `- Default branch: ${m.defaultBranch}`,
    `- Remote: ${m.remote}`,
    `- Git: ${m.aheadBehind}`,
    `- Worktree: ${m.statusShort ? 'dirty' : 'clean'}`,
    `- Último commit: ${m.lastCommit}`,
    `- WSD instalado: ${m.wsdConfig.version || 'unknown'}`,
    `- HANDOFF: ${m.docs.handoff ? '+specs/HANDOFF.md presente' : 'ausente'}`,
    '',
    '## Artefatos WSD',
    '',
    `- AGENTS.md: ${m.docs.agents ? 'presente' : 'ausente'}`,
    `- +context.json: ${m.docs.context ? 'presente' : 'ausente'}`,
    `- ROADMAP.md: ${m.docs.roadmap ? 'presente' : 'ausente'}`,
    `- IDEAS.md / IDEAS_PIPELINE.md: ${m.docs.ideas ? 'presente' : 'ausente'} / ${m.docs.ideasPipeline ? 'presente' : 'ausente'}`,
    `- CONCERNS.md / CONCERNS_PIPELINE.md: ${m.docs.concerns ? 'presente' : 'ausente'} / ${m.docs.concernsPipeline ? 'presente' : 'ausente'}`,
    '',
    '## Compactação',
    '',
    ...mdList(m.bloat, 'memória dentro dos limites — nada a arquivar'),
    '',
    '## Implementações Em Desenvolvimento',
    '',
    ...bulletRows(m.inProgressRoadmap, (row) => `- ${row[0]} — status ${row[1]}, prioridade ${row[2] || 'n/a'}, spec ${row[3] || 'n/a'}`, 'nenhuma feature `in-progress` no ROADMAP'),
    '',
    '### Specs Abertas',
    '',
    ...bulletRows(m.openSpecs, (spec) => `- ${spec.slug} — status ${spec.status}, risco ${spec.risk}, tarefas abertas ${spec.openTasks}`, 'nenhuma spec aberta detectada'),
    '',
    '## Plano Programado',
    '',
    ...mdList(planItems, 'nenhum plano programado claro em ROADMAP, specs, concerns ou ideias'),
    '',
    '## Bloqueadores e Todos Ativos',
    '',
    ...bulletRows(m.blockers, (row) => `- ${row[0]} — ${row[1]} (impacto: ${row[2] || 'n/a'}, status: ${row[3] || 'n/a'})`, 'nenhum bloqueador ativo registrado'),
    '',
    ...mdList(m.todos, 'nenhum todo ativo em STATE.md'),
    '',
    '## Ideias',
    '',
    ...bulletRows(m.activeIdeas, (row) => `- ${row[0]} — ${row[1]} (status: ${row[2]}, etapa: ${row[3] || 'n/a'}, artefato: ${row[4] || 'n/a'})`, 'nenhuma ideia ativa no pipeline'),
    '',
    ...mdList(m.ideasWithoutPipeline.map((id) => `${id} sem linha em IDEAS_PIPELINE.md`), 'pipeline de ideias alinhado com as ideias registradas'),
    '',
    '## Concerns',
    '',
    ...bulletRows(m.activeConcerns, (row) => `- ${row[0]} — ${row[1]} (severidade: ${row[3] || 'n/a'}, status: ${row[4] || 'n/a'}, área: ${row[5] || 'n/a'})`, 'nenhuma concern ativa registrada'),
    '',
    '### Pipeline de Concerns',
    '',
    ...bulletRows(m.activeConcernPipeline, (row) => `- ${row[0]} — status ${row[2] || 'n/a'}, etapa ${row[3] || 'n/a'}, próximo passo: ${row[5] || 'n/a'}, evidência: ${row[6] || 'n/a'}`, 'nenhuma concern ativa no pipeline'),
    '',
    ...mdList(concernsWithoutPipeline.map((id) => `${id} sem linha em CONCERNS_PIPELINE.md`), 'pipeline de concerns alinhado com as concerns ativas'),
    '',
    '## Sugestão do Agente',
    '',
    suggestion,
    '',
  ].join('\n');
}

function renderBrief(m) {
  const lines = [
    '== WSD Start Brief ==',
    `path: ${root}`,
    `branch: ${m.branch}`,
    `upstream: ${m.upstream}`,
    `worktree: ${m.statusShort ? 'dirty' : 'clean'}`,
    `wsd_version: ${m.wsdConfig.version || 'unknown'}`,
    `agents: ${m.docs.agents ? 'present' : 'missing'}`,
    `context: ${m.docs.context ? 'present' : 'missing'}`,
    `state: ${m.docs.state ? 'present' : 'missing'}`,
    `concerns: ${m.docs.concerns ? 'present' : 'missing'}`,
    `concerns_pipeline: ${m.docs.concernsPipeline ? 'present' : 'missing'}`,
    `concerns_active: ${m.activeConcernPipeline.length}`,
    `handoff: ${m.docs.handoff ? 'present' : 'missing'}`,
    `features: ${m.specs.length}`,
    `open_specs: ${m.openSpecs.length}`,
    `blockers_active: ${m.blockers.length}`,
  ];
  for (const warning of m.bloat) lines.push(`compact_warn: ${warning}`);
  return lines.join('\n');
}

function main() {
  const argv = process.argv.slice(2);
  const mode = argv.shift() || 'report';

  if (mode === 'brief') {
    process.stdout.write(`${renderBrief(collectModel())}\n`);
    return;
  }

  if (mode === 'bloat') {
    const warnings = bloatWarnings();
    for (const warning of warnings) process.stdout.write(`warn: ${warning}\n`);
    if (!warnings.length) process.stdout.write('ok: memória WSD dentro dos limites de compactação\n');
    return;
  }

  if (mode === 'report') {
    let outputPath = '';
    for (let i = 0; i < argv.length; i += 1) {
      if (argv[i] === '--save') outputPath = '+specs/RELATORIO.md';
      else if (argv[i] === '--output') { outputPath = argv[i + 1] || ''; i += 1; }
    }
    const report = renderReport(collectModel());
    if (outputPath) {
      const targetPath = path.isAbsolute(outputPath) ? outputPath : path.join(root, outputPath);
      fs.mkdirSync(path.dirname(targetPath), { recursive: true });
      fs.writeFileSync(targetPath, `${report}\n`);
      process.stdout.write(`PASS: relatorio WSD salvo em ${outputPath}\n`);
    } else {
      process.stdout.write(`${report}\n`);
    }
    return;
  }

  process.stderr.write(`FAIL: modo desconhecido: ${mode} (use report|brief|bloat)\n`);
  process.exit(1);
}

main();
