#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');
const os = require('os');
const cp = require('child_process');
const readline = require('readline');

const WSD_ROOT = path.resolve(__dirname, '..');
const VERSION = readPackageVersion();

const PROFILE_PRESETS = {
  generic_node_frontend: {
    project_type: 'node_frontend',
    primary_language: 'TypeScript',
    write_paths: ['./src', './tests', './public', './docs', './scripts', './+specs', './+logs', './AGENTS.md', './+context.json'],
    forbidden_paths: ['./.git', './.env', './secrets', './keys', './certs'],
    tools: ['bash', 'git', 'gh', 'node', 'npm', 'python3'],
    lint: ['npm run lint'],
    test: ['npm test'],
    build: ['npm run build'],
    smoke: [],
    test_quick: 'npm test -- --findRelatedTests',
    test_full: 'npm run lint && npm test',
    test_build: 'npm run lint && npm test && npm run build',
    l2_areas: ['deploy publico', 'secrets', 'proxy/SSL', 'dados sensiveis']
  },
  generic_python_api: {
    project_type: 'python_api',
    primary_language: 'Python',
    write_paths: ['./app', './tests', './docs', './scripts', './+specs', './+logs', './AGENTS.md', './+context.json'],
    forbidden_paths: ['./.git', './.env', './secrets', './keys', './certs', './alembic/versions'],
    tools: ['bash', 'git', 'gh', 'python3', 'pytest', 'ruff', 'docker'],
    lint: ['ruff check app tests'],
    test: ['pytest'],
    build: ['docker compose config'],
    smoke: [],
    test_quick: 'pytest -x --ff',
    test_full: 'ruff check app tests && pytest',
    test_build: 'ruff check app tests && pytest && docker compose config',
    l2_areas: ['migracao de banco', 'auth/autorizacao', 'secrets', 'producao', 'dados sensiveis']
  },
  lovable_tanstack_start: {
    project_type: 'lovable_tanstack_start',
    primary_language: 'TypeScript',
    write_paths: ['./src', './tests', './public', './docs', './scripts', './+specs', './+logs', './AGENTS.md', './+context.json'],
    forbidden_paths: ['./.git', './.env', './secrets', './keys', './certs', './package-lock.json'],
    tools: ['bash', 'git', 'gh', 'node', 'bun', 'python3'],
    lint: [],
    test: ['bun test'],
    build: ['bun run build'],
    smoke: [],
    test_quick: 'bun test',
    test_full: 'bun test',
    test_build: 'bun test && bun run build',
    l2_areas: ['deploy Cloudflare Workers', 'merge Lovable → main', 'edicao de keyframes CSS pela Lovable', 'edicao de routeTree.gen.ts'],
    lovable_integration: {
      enabled: true,
      bot: 'gpt-engineer-app[bot]',
      package_manager: 'bun',
      forbidden_files: ['package-lock.json'],
      fragile_paths: [
        'src/routes/index.tsx',
        'src/**/keyframes*.css',
        'src/**/*parallax*',
        'src/**/*tilt*'
      ],
      auto_delete_branch_on_merge: false,
      collaboration_model: 'owner_plus_fork_pr'
    }
  }
};

main().catch((error) => {
  console.error(`FAIL: ${error.message}`);
  process.exit(1);
});

async function main() {
  const argv = process.argv.slice(2);
  const command = argv.shift() || 'help';
  const args = parseArgs(argv);

  if (command === 'install') {
    if (args['list-options']) {
      listOptions();
      return;
    }
    await install(args);
    return;
  }

  if (command === 'doctor') {
    doctor();
    return;
  }

  if (command === 'help' || command === '--help' || command === '-h') {
    help();
    return;
  }

  if (command === 'update') {
    await update(args);
    return;
  }

  throw new Error(`unknown command: ${command}`);
}

function parseArgs(argv) {
  const out = { set: [] };
  for (let index = 0; index < argv.length; index += 1) {
    const item = argv[index];
    if (!item.startsWith('--')) {
      if (!out._) out._ = [];
      out._.push(item);
      continue;
    }
    const eq = item.indexOf('=');
    let key = item.slice(2);
    let value = true;
    if (eq !== -1) {
      key = item.slice(2, eq);
      value = item.slice(eq + 1);
    } else if (index + 1 < argv.length && !argv[index + 1].startsWith('--')) {
      value = argv[index + 1];
      index += 1;
    }
    if (key === 'set') out.set.push(value);
    else out[key] = value;
  }
  return out;
}

async function install(args) {
  const interactive = !args.yes;
  const prompt = interactive ? makePrompt() : null;

  const directory = path.resolve(await valueOrAsk(args.directory, prompt, 'Pasta do projeto', process.cwd()));
  ensureDir(directory);

  const gitExists = fs.existsSync(path.join(directory, '.git'));
  if (!gitExists) {
    const shouldInit = args['init-git'] || (interactive && (await ask(prompt, 'Este diretorio nao e Git. Inicializar git? [s/N]', 'n')).toLowerCase().startsWith('s'));
    if (shouldInit) run('git', ['init', '-b', String(args.branch || 'main')], directory);
    else throw new Error(`target is not a Git repository: ${directory}. Use --init-git or initialize manually.`);
  }

  const profileName = String(args.profile || 'generic_node_frontend');
  const profile = PROFILE_PRESETS[profileName] || PROFILE_PRESETS.generic_node_frontend;
  const detected = detectProject(directory);
  const settings = buildSettings(profile, detected, args, directory);

  if (interactive) {
    console.log('');
    console.log('== Install WSD ==');
    console.log('Em todas as perguntas, [valor entre colchetes] é o default. Pressione Enter para aceitar.');
    console.log('');
    // Identidade do projeto
    // PROJECT_TYPE, PRIMARY_LANGUAGE e os comandos de validacao (test/build/lint)
    // NAO sao mais prompts — derivam automaticamente do profile. Operador edita
    // depois no +context.json se precisar customizar.
    settings.PROJECT_NAME = await ask(prompt, 'Nome do projeto', settings.PROJECT_NAME);
    settings.CANONICAL_HOST = await ask(prompt, 'Host canonico', settings.CANONICAL_HOST);
    settings.CANONICAL_PATH = await ask(prompt, 'Path canonico', settings.CANONICAL_PATH);
    settings.DEFAULT_BRANCH = await ask(prompt, 'Branch principal', settings.DEFAULT_BRANCH);
    settings.REPO_NAME = await ask(prompt, 'Repositorio GitHub owner/name', settings.REPO_NAME);
    settings.GITHUB_MODE = await ask(prompt, 'GitHub: existing, auto, assisted ou skip', settings.GITHUB_MODE);
    settings.GIT_POLICY = normalizeGitPolicy(await ask(prompt, 'Git Governance: none, basic ou full', settings.GIT_POLICY));
    settings.TOOLS = splitCsv(await ask(prompt, 'Ferramentas: codex, claude-code, both ou none', settings.TOOLS.join(',')));

    // Seguranca
    const forbidIn = await ask(prompt, 'Paths proibidos csv (ex: ./secrets,./prod)', settings.FORBIDDEN_PATHS.join(','));
    if (forbidIn && forbidIn !== settings.FORBIDDEN_PATHS.join(',')) settings.FORBIDDEN_PATHS = splitCsv(forbidIn);

    // Modo (brownfield = projeto com código existente)
    const askYesNo = async (msg, def) => {
      const ans = (await ask(prompt, msg, def ? 'S' : 'n')).trim().toLowerCase();
      if (ans === '') return def;
      return !/^n/.test(ans);
    };
    settings.BROWNFIELD = await askYesNo(
      'Projeto brownfield (gera +specs/codebase/ com STACK, ARCHITECTURE, CONVENTIONS, STRUCTURE, INTEGRATIONS, TESTING)?',
      settings.BROWNFIELD
    );

    // Modulos opcionais (D-001 Opcao B+: full default, opt-out via prompt).
    settings.INSTALL_DOCS = await askYesNo('Instalar metodologia em +wsd/docs/ (~18 arquivos)?', settings.INSTALL_DOCS);
    settings.INSTALL_PARTY_MODE = await askYesNo('Instalar party-mode em +wsd/party-mode/ (~30 arquivos)?', settings.INSTALL_PARTY_MODE);
    settings.INSTALL_EXAMPLES = await askYesNo('Instalar exemplos em +wsd/examples/?', settings.INSTALL_EXAMPLES);

    // Auto-run pos-install (doctor/check/both/nada)
    const autoIn = (await ask(prompt, 'Rodar agora ./+wsd/bin/wsd (doctor, check, both ou nada)?', 'both')).trim().toLowerCase();
    if (['doctor', 'check', 'both'].includes(autoIn)) {
      settings._AUTO_RUN_POST_INSTALL = autoIn;
    } else {
      settings._AUTO_RUN_POST_INSTALL = 'nada';
    }
  }
  if (prompt) prompt.close();

  applySetOverrides(settings, args.set || []);
  normalizeSettings(settings);

  installVendorTree(directory, settings);
  renderRepoTemplates(directory, settings, Boolean(args.force));
  installCodexSkills(directory, settings, Boolean(args.force));
  installClaudeCommands(directory, settings, Boolean(args.force));
  installGitHooks(directory, Boolean(args.force), Boolean(args['no-git-hooks']));
  installGitGovernanceModule(directory, settings, Boolean(args.force));
  installPartyMode(directory, Boolean(args.force), settings.INSTALL_PARTY_MODE !== false);
  writeProjectConfig(directory, settings);
  appendSnapshotGitignore(directory);
  generateInitialSnapshot(directory);

  handleGitHubMode(directory, settings, args);

  if (settings.LOVABLE) {
    appendLovableGitignore(directory);
  }

  console.log('');
  console.log(`WSD installed in ${directory}`);
  if (settings.LOVABLE) {
    console.log('');
    console.log('Lovable profile detected:');
    console.log('  - package-lock.json marcado como forbidden (regra causa-raiz Preview travado)');
    console.log('  - Use sempre `bun install`; nunca `npm install`');
    console.log('  - Próximo passo opcional: ./+wsd/bin/wsd lovable bootstrap (desliga auto-delete branch no GitHub)');
  }

  // Auto-run pos-install (escolhido no prompt interativo do bloco anterior).
  const autoRun = settings._AUTO_RUN_POST_INSTALL || 'nada';
  const wsdBin = path.join(directory, '+wsd', 'bin', 'wsd');
  const ranDoctor = (autoRun === 'doctor' || autoRun === 'both');
  const ranCheck = (autoRun === 'check' || autoRun === 'both');
  if (ranDoctor) {
    console.log('');
    console.log('== ./+wsd/bin/wsd doctor ==');
    cp.spawnSync(wsdBin, ['doctor'], { stdio: 'inherit', cwd: directory });
  }
  if (ranCheck) {
    console.log('');
    console.log('== ./+wsd/bin/wsd check ==');
    cp.spawnSync(wsdBin, ['check'], { stdio: 'inherit', cwd: directory });
  }

  console.log('');
  console.log('Next steps:');
  console.log('  1. Review generated files.');
  if (!ranDoctor) console.log('  2. Run: ./+wsd/bin/wsd doctor');
  if (!ranCheck) console.log(`  ${ranDoctor ? '2' : '3'}. Run: ./+wsd/bin/wsd check`);
  console.log(`  ${ranDoctor && ranCheck ? '2' : (ranDoctor || ranCheck ? '3' : '4')}. Commit generated WSD files on a dedicated branch.`);
}

async function update(args) {
  const directory = path.resolve(args.directory || process.cwd());
  const configPath = path.join(directory, '+wsd', 'config.json');

  if (!fs.existsSync(configPath)) {
    throw new Error('+wsd/config.json not found in ' + directory + '. Run install first.');
  }

  const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
  const prevVersion = config.version || 'unknown';
  const vendor = path.join(directory, '+wsd');
  const modules = config.modules || { docs: true, party_mode: true, examples: true };

  const dirs = ['templates', 'profiles', 'scripts', 'schemas'];
  if (modules.docs !== false) dirs.push('docs');
  else console.log('info: skipping docs/ (modules.docs=false in +wsd/config.json)');
  if (modules.examples !== false) dirs.push('examples');
  else console.log('info: skipping examples/ (modules.examples=false in +wsd/config.json)');

  for (const name of dirs) {
    const srcPath = path.join(WSD_ROOT, name);
    if (!fs.existsSync(srcPath)) {
      console.log(`info: skipping ${name}/ (not present in source)`);
      continue;
    }
    copyDir(srcPath, path.join(vendor, name));
  }

  // party-mode/ é tratado separadamente (não no loop principal)
  if (modules.party_mode !== false) {
    const partyMode = path.join(WSD_ROOT, 'party-mode');
    if (fs.existsSync(partyMode)) {
      copyDir(partyMode, path.join(vendor, 'party-mode'));
    }
  } else {
    console.log('info: skipping party-mode/ (modules.party_mode=false in +wsd/config.json)');
  }

  const loopSource = path.join(WSD_ROOT, 'templates', 'local-wsd', 'loop');
  if (fs.existsSync(loopSource)) {
    copyDir(loopSource, path.join(vendor, 'loop'));
  }

  ensureDir(path.join(vendor, 'bin'));
  copyFile(path.join(WSD_ROOT, 'templates', 'local-wsd', 'bin', 'wsd'), path.join(vendor, 'bin', 'wsd'));
  fs.chmodSync(path.join(vendor, 'bin', 'wsd'), 0o755);
  copyFile(path.join(WSD_ROOT, 'templates', 'local-wsd', 'bin', 'wsd-validate-context.cjs'), path.join(vendor, 'bin', 'wsd-validate-context.cjs'));
  fs.chmodSync(path.join(vendor, 'bin', 'wsd-validate-context.cjs'), 0o755);
  copyFile(path.join(WSD_ROOT, 'templates', 'local-wsd', 'bin', 'wsd-snapshot.cjs'), path.join(vendor, 'bin', 'wsd-snapshot.cjs'));
  fs.chmodSync(path.join(vendor, 'bin', 'wsd-snapshot.cjs'), 0o755);

  config.version = VERSION;
  config.updated_at = new Date().toISOString();
  config.wsd_source = WSD_ROOT;
  fs.writeFileSync(configPath, JSON.stringify(config, null, 2) + '\n');
  appendSnapshotGitignore(directory);

  // Lista dinâmica reflete o que foi efetivamente copiado (respeita config.modules).
  const refreshed = ['bin', 'templates', 'profiles', 'scripts', 'schemas'];
  if (modules.docs !== false) refreshed.push('docs');
  if (modules.examples !== false) refreshed.push('examples');
  if (modules.party_mode !== false) refreshed.push('party-mode');
  refreshed.push('loop');
  console.log('');
  console.log(`WSD updated: ${prevVersion} -> ${VERSION}`);
  console.log(`Refreshed: +wsd/{${refreshed.sort().join(',')}}`);
  console.log('Preserved: +context.json, AGENTS.md, +specs/, scripts/wsd_check.sh, scripts/git-hooks/');
  console.log('');
  console.log('Run: ./+wsd/bin/wsd doctor');
}

function buildSettings(profile, detected, args, directory) {
  const projectName = String(args['project-name'] || profile.project_name || titleize(path.basename(directory)));
  const branch = String(args.branch || profile.default_branch || detected.branch || 'main');
  const repoName = String(args.repo || profile.repo_name || detected.repoName || '');
  const githubRemote = String(args.remote || profile.github_remote || detected.remote || (repoName ? `https://github.com/${repoName}.git` : ''));
  const tools = splitCsv(String(args.tools || 'codex'));

  return {
    DATE: new Date().toISOString().slice(0, 10),
    PROJECT_NAME: projectName,
    PROJECT_OWNER: String(args.owner || profile.owner || 'private'),
    PROJECT_STATUS: String(args.status || 'active'),
    PROJECT_TYPE: String(args.type || profile.project_type || 'generic'),
    PRIMARY_LANGUAGE: String(args.language || profile.primary_language || 'unknown'),
    REPO_NAME: repoName,
    GITHUB_REMOTE: githubRemote,
    CANONICAL_HOST: String(args['canonical-host'] || profile.canonical_host || os.hostname()),
    CANONICAL_PATH: String(args['canonical-path'] || profile.canonical_path || directory),
    DEFAULT_BRANCH: branch,
    ENVIRONMENT_NAME: String(args.environment || 'development'),
    NETWORK_MODE: String(args['network-mode'] || 'local_or_vps'),
    REPO_TYPE: String(args['repo-type'] || 'private'),
    OPERATIONAL_CLONE: String(args['operational-clone'] || profile.operational_clone || directory),
    AUDIT_LAB_CLONE: String(args['audit-lab-clone'] || profile.audit_lab_clone || ''),
    DEPLOY_CLONE: String(args['deploy-clone'] || profile.deploy_clone || ''),
    PROMOTION_FLOW: String(args['promotion-flow'] || 'branch_push_pr_merge'),
    GITHUB_MODE: String(args.github || 'auto'),
    GIT_POLICY: normalizeGitPolicy(args['git-policy'] || 'full'),
    REMOTE_PROTOCOL: String(args['remote-protocol'] || 'https'),
    GITHUB_CLI_REQUIRED: String(args['github-cli-required'] || 'false'),
    LEGACY_BRANCH_ALLOWED: String(args['legacy-branch-allowed'] || 'false'),
    ISSUE_POLICY: String(args['issue-policy'] || 'required_for_l1_l2'),
    PR_POLICY: String(args['pr-policy'] || 'required_for_relevant_changes'),
    SYNC_POLICY: String(args['sync-policy'] || 'pull_ff_only'),
    DIRTY_WORKTREE_POLICY: String(args['dirty-worktree-policy'] || 'declare_and_halt_for_risky_ops'),
    BRANCH_NAMING: String(args['branch-naming'] || 'issue-<number>-<slug>'),
    COMMIT_STYLE: String(args['commit-style'] || 'conventional_commits'),
    TOOLS: tools,
    WRITE_PATHS: profile.write_paths || ['./src', './tests', './docs', './scripts', './+specs', './+logs', './AGENTS.md', './+context.json'],
    FORBIDDEN_PATHS: profile.forbidden_paths || ['./.git', './.env', './secrets', './keys', './certs'],
    TOOL_ALLOWLIST: profile.tools || ['bash', 'git', 'gh', 'python3'],
    LINT_COMMANDS: profile.lint || [],
    TEST_COMMANDS: profile.test || [],
    BUILD_COMMANDS: profile.build || [],
    SMOKE_COMMANDS: profile.smoke || [],
    L2_AREAS: profile.l2_areas || [],
    TEST_QUICK_COMMAND: String(args['test-quick'] || profile.test_quick || (profile.test ? profile.test.join(' && ') : 'echo "no quick gate configured"')),
    TEST_FULL_COMMAND: String(args['test-full'] || profile.test_full || [...(profile.lint || []), ...(profile.test || [])].join(' && ') || 'echo "no full gate configured"'),
    TEST_BUILD_COMMAND: String(args['test-build'] || profile.test_build || [...(profile.lint || []), ...(profile.test || []), ...(profile.build || [])].join(' && ') || 'echo "no build gate configured"'),
    BROWNFIELD: Boolean(args.brownfield),
    LOVABLE: Boolean(profile.lovable_integration && profile.lovable_integration.enabled),
    LOVABLE_INTEGRATION_JSON: profile.lovable_integration
      ? JSON.stringify(profile.lovable_integration, null, 2).replace(/\n/g, '\n  ')
      : '',
    INSTALL_DOCS: !args['no-docs'],
    INSTALL_PARTY_MODE: !args['no-party-mode'],
    INSTALL_EXAMPLES: Boolean(args.examples) && !args['no-examples'],
    ENVIRONMENT_POLICY_SUMMARY: profile.environment_policy_summary || 'GitHub e o historico compartilhado. O host canonico declarado neste arquivo e a fonte operacional do projeto.',
    ENVIRONMENT_POLICY_DETAILS: profile.environment_policy_details || 'Trabalhar sempre a partir do host canonico, em branch dedicada, com validacao proporcional ao risco.',
    CLONE_TOPOLOGY_MARKDOWN: profile.clone_topology_markdown || '- GitHub: historico compartilhado.\\n- Host canonico: desenvolvimento e validacao local.',
    PROJECT_RULES_MARKDOWN: '- Seguir WSD para tarefas L1/L2.\\n- Usar branch dedicada para mudancas relevantes.\\n- Nao registrar secrets.',
    TECHNICAL_DECISIONS_MARKDOWN: '- Decisoes tecnicas relevantes devem ser registradas em spec ou ADR.',
    AGENT_AVOID_MARKDOWN: '- Nao usar `git add .`.\\n- Nao esconder worktree suja.\\n- Nao inventar comandos de validacao.',
    VALIDATION_POLICY_MARKDOWN: '- Usar somente comandos reais do projeto.\\n- Registrar comandos nao executados e motivo.',
    PRODUCT_SUMMARY: 'Resumo do produto a ser preenchido pelo operador.',
    USER_CONTEXT: 'Usuarios/publico a serem descritos pelo operador.',
    STACK_SUMMARY: 'Stack tecnica a ser preenchida pelo operador.',
    MODULES_MARKDOWN: '- Preencher modulos principais.',
    CRITICAL_FLOWS_MARKDOWN: '- Preencher fluxos criticos.',
    INTEGRATIONS_MARKDOWN: '- Preencher integracoes.',
    ENVIRONMENTS_MARKDOWN: '- Preencher ambientes.',
    TECHNICAL_DEBTS_MARKDOWN: '- Preencher dividas tecnicas.',
    PRODUCT_DEBTS_MARKDOWN: '- Preencher dividas de produto.',
    KNOWN_RISKS_MARKDOWN: '- Preencher riscos conhecidos.',
    DEFERRED_WITHOUT_SPEC_MARKDOWN: '- Preencher itens que exigem spec.'
  };
}

function normalizeSettings(settings) {
  settings.PROJECT_SLUG = settings.PROJECT_NAME.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9-]/g, '');
  settings.GIT_POLICY = normalizeGitPolicy(settings.GIT_POLICY);
  settings.GIT_GOVERNANCE_ENABLED = settings.GIT_POLICY === 'none' ? 'false' : 'true';
  settings.GIT_GOVERNANCE_MODE = settings.GIT_POLICY;
  settings.GIT_GOVERNANCE_SUMMARY = gitGovernanceSummary(settings);
  settings.WRITE_PATHS_JSON_ARRAY = JSON.stringify(settings.WRITE_PATHS, null, 6);
  settings.FORBIDDEN_PATHS_JSON_ARRAY = JSON.stringify(settings.FORBIDDEN_PATHS, null, 6);
  settings.TOOL_ALLOWLIST_JSON_ARRAY = JSON.stringify(settings.TOOL_ALLOWLIST, null, 6);
  settings.LINT_COMMANDS_JSON_ARRAY = JSON.stringify(settings.LINT_COMMANDS, null, 6);
  settings.TEST_COMMANDS_JSON_ARRAY = JSON.stringify(settings.TEST_COMMANDS, null, 6);
  settings.BUILD_COMMANDS_JSON_ARRAY = JSON.stringify(settings.BUILD_COMMANDS, null, 6);
  settings.SMOKE_COMMANDS_JSON_ARRAY = JSON.stringify(settings.SMOKE_COMMANDS, null, 6);
  settings.SENSITIVE_PATHS_MARKDOWN_LIST = settings.FORBIDDEN_PATHS.map((item) => `- \`${item}\``).join('\n');
  settings.VALIDATION_COMMANDS_BLOCK = [...settings.LINT_COMMANDS, ...settings.TEST_COMMANDS, ...settings.BUILD_COMMANDS, ...settings.SMOKE_COMMANDS].join('\n') || 'bash scripts/wsd_check.sh --risk L0 .';
  settings.VALIDATION_COMMANDS_YAML_LIST = toYamlList([...settings.LINT_COMMANDS, ...settings.TEST_COMMANDS, ...settings.BUILD_COMMANDS]);
  settings.L2_AREAS_MARKDOWN = settings.L2_AREAS.map((item) => `- ${item}`).join('\n');
}

function applySetOverrides(settings, overrides) {
  for (const raw of overrides) {
    const eq = String(raw).indexOf('=');
    if (eq === -1) continue;
    const key = String(raw).slice(0, eq);
    const value = String(raw).slice(eq + 1);
    if (key === 'validation.test') settings.TEST_COMMANDS = splitCsv(value);
    else if (key === 'validation.build') settings.BUILD_COMMANDS = splitCsv(value);
    else if (key === 'validation.lint') settings.LINT_COMMANDS = splitCsv(value);
    else if (key === 'validation.smoke') settings.SMOKE_COMMANDS = splitCsv(value);
    else if (key === 'validation.test_quick') settings.TEST_QUICK_COMMAND = value;
    else if (key === 'validation.test_full') settings.TEST_FULL_COMMAND = value;
    else if (key === 'validation.test_build') settings.TEST_BUILD_COMMAND = value;
    else if (key === 'project.name') settings.PROJECT_NAME = value;
    else if (key === 'project.type') settings.PROJECT_TYPE = value;
    else if (key === 'project.primary_language') settings.PRIMARY_LANGUAGE = value;
    else if (key === 'environment.canonical_host') settings.CANONICAL_HOST = value;
    else if (key === 'environment.canonical_path') settings.CANONICAL_PATH = value;
    else if (key === 'repository.name') settings.REPO_NAME = value;
    else if (key === 'repository.remote') settings.GITHUB_REMOTE = value;
    else if (key === 'repository.default_branch') settings.DEFAULT_BRANCH = value;
    else if (key === 'git_governance.mode') settings.GIT_POLICY = normalizeGitPolicy(value);
    else if (key === 'git_governance.remote_protocol') settings.REMOTE_PROTOCOL = value;
    else if (key === 'git_governance.github_cli_required') settings.GITHUB_CLI_REQUIRED = value;
    else if (key === 'git_governance.issue_policy') settings.ISSUE_POLICY = value;
    else if (key === 'git_governance.pr_policy') settings.PR_POLICY = value;
    else if (key === 'git_governance.branch_naming') settings.BRANCH_NAMING = value;
    else if (key === 'permissions.write_paths') settings.WRITE_PATHS = splitCsv(value);
    else if (key === 'permissions.forbidden_paths') settings.FORBIDDEN_PATHS = splitCsv(value);
    else {
      const mapped = keyToPlaceholder(key);
      settings[mapped] = value;
    }
  }
}

function keyToPlaceholder(key) {
  return key.replace(/[^A-Za-z0-9]+/g, '_').toUpperCase();
}

function installVendorTree(directory, settings) {
  const vendor = path.join(directory, '+wsd');
  ensureDir(vendor);
  // templates/, profiles/, scripts/, schemas/ sao runtime obrigatorios.
  // docs/ e examples/ sao opt-out via settings (D-001 Opcao B+).
  const dirs = ['templates', 'profiles', 'scripts', 'schemas'];
  if (settings.INSTALL_DOCS !== false) dirs.push('docs');
  else console.log('info: skipping docs/ (--no-docs)');
  if (settings.INSTALL_EXAMPLES !== false) dirs.push('examples');
  else console.log('info: skipping examples/ (--no-examples)');
  for (const name of dirs) {
    const srcPath = path.join(WSD_ROOT, name);
    if (!fs.existsSync(srcPath)) {
      console.log(`info: skipping ${name}/ (not present in source)`);
      continue;
    }
    copyDir(srcPath, path.join(vendor, name), { skipGit: true });
  }
  const loopSource = path.join(WSD_ROOT, 'templates', 'local-wsd', 'loop');
  if (fs.existsSync(loopSource)) {
    copyDir(loopSource, path.join(vendor, 'loop'));
  }
  ensureDir(path.join(vendor, 'bin'));
  copyFile(path.join(WSD_ROOT, 'templates', 'local-wsd', 'bin', 'wsd'), path.join(vendor, 'bin', 'wsd'));
  fs.chmodSync(path.join(vendor, 'bin', 'wsd'), 0o755);
  copyFile(path.join(WSD_ROOT, 'templates', 'local-wsd', 'bin', 'wsd-validate-context.cjs'), path.join(vendor, 'bin', 'wsd-validate-context.cjs'));
  fs.chmodSync(path.join(vendor, 'bin', 'wsd-validate-context.cjs'), 0o755);
  copyFile(path.join(WSD_ROOT, 'templates', 'local-wsd', 'bin', 'wsd-snapshot.cjs'), path.join(vendor, 'bin', 'wsd-snapshot.cjs'));
  fs.chmodSync(path.join(vendor, 'bin', 'wsd-snapshot.cjs'), 0o755);
  fs.writeFileSync(path.join(vendor, 'config.json'), JSON.stringify({
    schema: 'wsd/local-config/v1',
    version: VERSION,
    installed_at: new Date().toISOString(),
    wsd_source: WSD_ROOT,
    project_name: settings.PROJECT_NAME,
    repo_name: settings.REPO_NAME,
    tools: settings.TOOLS,
    git_policy: settings.GIT_POLICY
  }, null, 2) + '\n');
}

function renderRepoTemplates(directory, settings, force) {
  const sourceRoot = path.join(WSD_ROOT, 'templates', 'repo');
  const isBrownfield = Boolean(settings.BROWNFIELD);
  for (const src of walkFiles(sourceRoot)) {
    const rel = path.relative(sourceRoot, src);
    if (!isBrownfield && rel.startsWith('+specs/codebase/')) continue;
    const destRel = rel.endsWith('.template') ? rel.slice(0, -'.template'.length) : rel;
    const dest = path.join(directory, destRel);
    if (fs.existsSync(dest) && !force) continue;
    ensureDir(path.dirname(dest));
    const rendered = render(fs.readFileSync(src, 'utf8'), settings);
    fs.writeFileSync(dest, rendered);
    if (dest.endsWith('.sh')) fs.chmodSync(dest, 0o755);
  }
}

function installCodexSkills(directory, settings, force) {
  if (!settings.TOOLS.includes('codex') && !settings.TOOLS.includes('both')) return;
  const sourceRoot = path.join(WSD_ROOT, 'templates', 'codex-skills');
  const targetRoots = [
    path.join(directory, '.agents', 'skills'),
    path.join(directory, '.codex', 'skills')
  ];
  for (const targetRoot of targetRoots) {
    for (const src of walkFiles(sourceRoot)) {
      const rel = path.relative(sourceRoot, src);
      const dest = path.join(targetRoot, rel);
      if (fs.existsSync(dest) && !force) continue;
      ensureDir(path.dirname(dest));
      fs.writeFileSync(dest, render(fs.readFileSync(src, 'utf8'), settings));
    }
  }
}

function installGitHooks(directory, force, skip) {
  if (skip) return;
  const gitDir = path.join(directory, '.git');
  if (!fs.existsSync(gitDir)) return;
  const templateRoot = path.join(WSD_ROOT, 'templates', 'git-hooks');
  if (!fs.existsSync(templateRoot)) return;

  const projectHooksDir = path.join(directory, 'scripts', 'git-hooks');
  ensureDir(projectHooksDir);
  const gitHooksDir = path.join(gitDir, 'hooks');
  ensureDir(gitHooksDir);

  for (const src of walkFiles(templateRoot)) {
    const hookName = path.basename(src);
    const projectDest = path.join(projectHooksDir, hookName);
    if (!fs.existsSync(projectDest) || force) {
      fs.copyFileSync(src, projectDest);
      fs.chmodSync(projectDest, 0o755);
    }
    const gitDest = path.join(gitHooksDir, hookName);
    if (!fs.existsSync(gitDest) || force) {
      fs.copyFileSync(src, gitDest);
      fs.chmodSync(gitDest, 0o755);
    }
  }
}

function installPartyMode(directory, force, enabled = true) {
  if (!enabled) {
    console.log('info: skipping party-mode/ (--no-party-mode)');
    return;
  }
  const sourceRoot = path.join(WSD_ROOT, 'party-mode');
  if (!fs.existsSync(sourceRoot)) return;
  const targetRoot = path.join(directory, '+wsd', 'party-mode');
  for (const src of walkFiles(sourceRoot)) {
    const rel = path.relative(sourceRoot, src);
    const dest = path.join(targetRoot, rel);
    if (fs.existsSync(dest) && !force) continue;
    ensureDir(path.dirname(dest));
    fs.copyFileSync(src, dest);
  }
}

function installGitGovernanceModule(directory, settings, force) {
  if (settings.GIT_POLICY !== 'full') return;
  const sourceRoot = path.join(WSD_ROOT, 'templates', 'modules', 'git-governance', '.github');
  if (!fs.existsSync(sourceRoot)) return;
  const targetRoot = path.join(directory, '.github');
  for (const src of walkFiles(sourceRoot)) {
    const rel = path.relative(sourceRoot, src);
    const dest = path.join(targetRoot, rel);
    if (fs.existsSync(dest) && !force) continue;
    ensureDir(path.dirname(dest));
    fs.writeFileSync(dest, render(fs.readFileSync(src, 'utf8'), settings));
  }
}

function installClaudeCommands(directory, settings, force) {
  if (!settings.TOOLS.includes('claude-code') && !settings.TOOLS.includes('both')) return;
  const templateRoot = path.join(WSD_ROOT, 'templates', 'claude-commands');

  // commands → .claude/commands/
  const commandsSourceRoot = path.join(templateRoot, 'commands');
  const commandsTargetRoot = path.join(directory, '.claude', 'commands');
  for (const src of walkFiles(commandsSourceRoot)) {
    const rel = path.relative(commandsSourceRoot, src);
    if (path.basename(src) === 'wsd-idea.md') continue; // renamed below
    if (path.basename(src) === 'wsd-concern.md') continue; // renamed below
    const dest = path.join(commandsTargetRoot, rel);
    if (fs.existsSync(dest) && !force) continue;
    ensureDir(path.dirname(dest));
    fs.writeFileSync(dest, render(fs.readFileSync(src, 'utf8'), settings));
  }
  // wsd-idea.md → idea-{PROJECT_SLUG}.md (personalized per project)
  const wsdIdeaSrc = path.join(commandsSourceRoot, 'wsd-idea.md');
  if (fs.existsSync(wsdIdeaSrc)) {
    const ideaDest = path.join(commandsTargetRoot, `idea-${settings.PROJECT_SLUG || 'project'}.md`);
    if (!fs.existsSync(ideaDest) || force) {
      ensureDir(path.dirname(ideaDest));
      fs.writeFileSync(ideaDest, render(fs.readFileSync(wsdIdeaSrc, 'utf8'), settings));
    }
  }

  // wsd-concern.md → concern-{PROJECT_SLUG}.md (personalized per project)
  const wsdConcernSrc = path.join(commandsSourceRoot, 'wsd-concern.md');
  if (fs.existsSync(wsdConcernSrc)) {
    const concernDest = path.join(commandsTargetRoot, `concern-${settings.PROJECT_SLUG || 'project'}.md`);
    if (!fs.existsSync(concernDest) || force) {
      ensureDir(path.dirname(concernDest));
      fs.writeFileSync(concernDest, render(fs.readFileSync(wsdConcernSrc, 'utf8'), settings));
    }
  }

  // hooks → +wsd/hooks/
  const hooksSourceRoot = path.join(templateRoot, 'hooks');
  const hooksTargetRoot = path.join(directory, '+wsd', 'hooks');
  for (const src of walkFiles(hooksSourceRoot)) {
    const rel = path.relative(hooksSourceRoot, src);
    const dest = path.join(hooksTargetRoot, rel);
    if (fs.existsSync(dest) && !force) continue;
    ensureDir(path.dirname(dest));
    fs.copyFileSync(src, dest);
    fs.chmodSync(dest, 0o755);
  }

  // settings.json → .claude/settings.json
  const settingsSrc = path.join(templateRoot, 'settings.json');
  const settingsDest = path.join(directory, '.claude', 'settings.json');
  if (!fs.existsSync(settingsDest) || force) {
    ensureDir(path.dirname(settingsDest));
    fs.writeFileSync(settingsDest, fs.readFileSync(settingsSrc, 'utf8'));
  }
}
function appendSnapshotGitignore(directory) {
  const gitignorePath = path.join(directory, '.gitignore');
  const entries = ['+wsd/snapshot.json', '+wsd/.last-check.json', '+wsd/loop/state.json', '+wsd/loop/lock', '+logs/wsd-loop/'];
  let existing = '';
  if (fs.existsSync(gitignorePath)) existing = fs.readFileSync(gitignorePath, 'utf8');
  const toAdd = entries.filter(e => !existing.includes(e));
  if (toAdd.length > 0) {
    const block = '\n# WSD generated (local state)\n' + toAdd.join('\n') + '\n';
    fs.writeFileSync(gitignorePath, existing + block);
  }
}

function generateInitialSnapshot(directory) {
  const snapshotScript = path.join(directory, '+wsd', 'bin', 'wsd-snapshot.cjs');
  if (!fs.existsSync(snapshotScript)) return;

  const result = cp.spawnSync(process.execPath, [snapshotScript], {
    cwd: directory,
    encoding: 'utf8',
  });
  if (result.status === 0) {
    console.log('WSD snapshot initialized: +wsd/snapshot.json');
    return;
  }

  const stderr = (result.stderr || result.stdout || '').trim();
  console.log(`warn: initial WSD snapshot failed${stderr ? ` — ${stderr.split(/\r?\n/)[0]}` : ''}`);
}

function appendLovableGitignore(directory) {
  // Lovable scaffold é Bun-puro. Presença de package-lock.json é causa raiz
  // do "Preview travado" (ver docs_lovable/r.2.11_lovable.md). Garantimos via
  // .gitignore que `npm install` acidental não promova o lockfile ao repo.
  const gitignorePath = path.join(directory, '.gitignore');
  const entries = ['package-lock.json'];
  let existing = '';
  if (fs.existsSync(gitignorePath)) existing = fs.readFileSync(gitignorePath, 'utf8');
  const toAdd = entries.filter(e => !existing.split(/\r?\n/).some(line => line.trim() === e));
  if (toAdd.length > 0) {
    const block = '\n# Lovable: package-lock.json proibido (scaffold é Bun-puro)\n' + toAdd.join('\n') + '\n';
    fs.writeFileSync(gitignorePath, existing + block);
  }
}


function writeProjectConfig(directory, settings) {
  const configPath = path.join(directory, '+wsd', 'config.json');
  const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
  config.context = {
    canonical_host: settings.CANONICAL_HOST,
    canonical_path: settings.CANONICAL_PATH,
    default_branch: settings.DEFAULT_BRANCH,
    github_mode: settings.GITHUB_MODE,
    git_policy: settings.GIT_POLICY
  };
  // Modulos opcionais (D-001 Opcao B+) — escolhidos no install, respeitados por update.
  config.modules = {
    docs: settings.INSTALL_DOCS !== false,
    party_mode: settings.INSTALL_PARTY_MODE !== false,
    examples: settings.INSTALL_EXAMPLES !== false
  };
  fs.writeFileSync(configPath, JSON.stringify(config, null, 2) + '\n');
}

function handleGitHubMode(directory, settings, args) {
  if (settings.GITHUB_MODE === 'skip') return;
  if (settings.GITHUB_MODE === 'assisted') {
    console.log('');
    console.log('GitHub assisted mode:');
    console.log(`  gh repo create ${settings.REPO_NAME || '<owner/repo>'} --private --source=. --remote=origin --push`);
    return;
  }
  if (settings.GITHUB_MODE === 'existing') {
    if (settings.GITHUB_REMOTE && !hasRemote(directory)) {
      run('git', ['remote', 'add', 'origin', settings.GITHUB_REMOTE], directory);
    }
    return;
  }
  if (settings.GITHUB_MODE === 'auto') {
    if (!settings.REPO_NAME) throw new Error('--repo owner/name is required for --github auto');
    if (!commandExists('gh')) throw new Error('gh is required for --github auto');
    if (!args.yes) throw new Error('--github auto currently requires --yes in alpha');
    run('gh', ['repo', 'create', settings.REPO_NAME, '--private', '--source=.', '--remote=origin', '--push'], directory);
  }
}

function detectProject(directory) {
  const remote = tryRun('git', ['remote', 'get-url', 'origin'], directory).trim();
  const branch = tryRun('git', ['branch', '--show-current'], directory).trim();
  return {
    remote,
    branch,
    repoName: githubRepoName(remote)
  };
}

function githubRepoName(remote) {
  const match = remote.match(/github\.com[:/](.+?)(?:\.git)?$/);
  return match ? match[1] : '';
}

function hasRemote(directory) {
  return Boolean(tryRun('git', ['remote', 'get-url', 'origin'], directory).trim());
}

function render(text, settings) {
  // Conditional blocks (não-aninhados, lazy match para suportar múltiplos blocos):
  //   {{#if FLAG}}...{{/if}}        — incluído se settings[FLAG] truthy
  //   {{#unless FLAG}}...{{/unless}} — incluído se settings[FLAG] falsy
  text = text.replace(/\{\{#if ([A-Z0-9_]+)\}\}([\s\S]*?)\{\{\/if\}\}/g, (_m, flag, content) => {
    return settings[flag] ? content : '';
  });
  text = text.replace(/\{\{#unless ([A-Z0-9_]+)\}\}([\s\S]*?)\{\{\/unless\}\}/g, (_m, flag, content) => {
    return !settings[flag] ? content : '';
  });
  // Placeholders simples {{KEY}}.
  return text.replace(/\{\{([A-Z0-9_]+)\}\}/g, (_match, key) => {
    if (Object.prototype.hasOwnProperty.call(settings, key)) return String(settings[key]);
    return '';
  });
}

function copyDir(src, dest) {
  ensureDir(dest);
  for (const entry of fs.readdirSync(src, { withFileTypes: true })) {
    if (entry.name === '.git') continue;
    const s = path.join(src, entry.name);
    const d = path.join(dest, entry.name);
    if (entry.isDirectory()) copyDir(s, d);
    else copyFile(s, d);
  }
}

function copyFile(src, dest) {
  ensureDir(path.dirname(dest));
  fs.copyFileSync(src, dest);
  const mode = fs.statSync(src).mode;
  if (mode & 0o111) fs.chmodSync(dest, 0o755);
}

function walkFiles(dir) {
  const out = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) out.push(...walkFiles(full));
    else out.push(full);
  }
  return out;
}

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

function run(cmd, args, cwd) {
  cp.execFileSync(cmd, args, { cwd, stdio: 'inherit' });
}

function tryRun(cmd, args, cwd) {
  try {
    return cp.execFileSync(cmd, args, { cwd, encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] });
  } catch (_error) {
    return '';
  }
}

function commandExists(command) {
  return Boolean(tryRun('bash', ['-lc', `command -v ${shellQuote(command)}`], process.cwd()).trim());
}

function shellQuote(value) {
  return `'${String(value).replace(/'/g, "'\\''")}'`;
}

function splitCsv(value) {
  return String(value || '').split(',').map((item) => item.trim()).filter(Boolean);
}

function normalizeGitPolicy(value) {
  const normalized = String(value || 'none').trim().toLowerCase();
  if (['none', 'basic', 'full'].includes(normalized)) return normalized;
  throw new Error(`invalid --git-policy: ${value}. Expected none, basic or full.`);
}

function gitGovernanceSummary(settings) {
  if (settings.GIT_POLICY === 'none') {
    return 'Git Governance: none. Mantem apenas a politica Git minima do WSD core; GitHub, gh, Issues e PR templates nao sao obrigatorios.';
  }
  if (settings.GIT_POLICY === 'basic') {
    return 'Git Governance: basic. Exige preflight local de branch, upstream e worktree; nao exige gh nem templates GitHub.';
  }
  return 'Git Governance: full. Adiciona checks GitHub/PR, templates .github/ e warnings sobre gh sem executar operacoes administrativas.';
}

function toYamlList(items) {
  return items.length ? items.map((item) => `  - "${String(item).replace(/"/g, '\\"')}"`).join('\n') : '  []';
}

function titleize(value) {
  return String(value).replace(/[-_]+/g, ' ').replace(/\b\w/g, (char) => char.toUpperCase());
}

function makePrompt() {
  return readline.createInterface({ input: process.stdin, output: process.stdout });
}

function ask(rl, question, fallback) {
  return new Promise((resolve) => {
    const done = (answer) => {
      rl.removeListener('close', onClose);
      resolve((typeof answer === 'string' ? answer.trim() : '') || fallback || '');
    };
    const onClose = () => done('');
    rl.once('close', onClose);
    try {
      rl.question(`${question}${fallback ? ` [${fallback}]` : ''}: `, done);
    } catch (_) {
      done('');
    }
  });
}

async function valueOrAsk(value, rl, question, fallback) {
  if (value) return value;
  if (!rl) return fallback;
  return ask(rl, question, fallback);
}

function doctor() {
  console.log(`WSD ${VERSION}`);
  const checks = [
    ['git', commandExists('git')],
    ['node', commandExists('node')],
    ['python3', commandExists('python3')],
    ['gh optional', commandExists('gh')]
  ];
  for (const [name, ok] of checks) console.log(`${ok ? 'ok' : 'missing'}: ${name}`);
  console.log(`root: ${WSD_ROOT}`);
  const hooksRoot = path.join(WSD_ROOT, 'templates', 'git-hooks');
  if (fs.existsSync(hooksRoot)) {
    for (const entry of fs.readdirSync(hooksRoot)) {
      console.log(`ok: template git-hook ${entry}`);
    }
  }
}

function listOptions() {
  console.log('Profiles:');
  for (const key of Object.keys(PROFILE_PRESETS)) console.log(`  - ${key}`);
  console.log('');
  console.log('Git policies:');
  for (const key of ['none', 'basic', 'full']) console.log(`  - ${key}`);
  console.log('');
  console.log('Common --set keys:');
  for (const key of ['project.name', 'environment.canonical_host', 'validation.test', 'validation.build', 'validation.test_quick', 'validation.test_full', 'validation.test_build', 'repository.default_branch', 'git_governance.mode']) {
    console.log(`  - ${key}=value`);
  }
}

function help() {
  console.log(`WSD Method ${VERSION}`);
  console.log('');
  console.log('Usage:');
  console.log('  wsd-method install [--directory path] [--profile name] [--tools codex|claude-code|both] [--github skip] [--git-policy none|basic|full] [--brownfield] [--no-git-hooks] [--yes]');
  console.log('  wsd-method install --list-options');
  console.log('  wsd-method update [--directory path]');
  console.log('  wsd-method doctor');
  console.log('  wsd-method help');
  console.log('');
  console.log('Flags (install):');
  console.log('  --brownfield        Generate +specs/codebase/ (STACK, ARCHITECTURE, CONVENTIONS, STRUCTURE, INTEGRATIONS, TESTING)');
  console.log('  --git-policy        Git/GitHub Governance mode: none, basic or full (default: none)');
  console.log('  --no-git-hooks      Skip installing pre-commit, commit-msg and pre-push git hooks');
  console.log('  --no-docs           Skip installing +wsd/docs/ (methodology reference)');
  console.log('  --no-party-mode     Skip installing +wsd/party-mode/ (multi-agent system)');
  console.log('  --examples          Install +wsd/examples/ (reference material; default: skipped)');
  console.log('  --test-quick STR    Override quick gate command (default from profile)');
  console.log('  --test-full STR     Override full gate command');
  console.log('  --test-build STR    Override build gate command');
  console.log('');
  console.log('update: refreshes +wsd/ vendor tree (docs, templates, schemas, bin) from WSD source.');
  console.log('  Preserves: +context.json, AGENTS.md, +specs/, scripts/wsd_check.sh, scripts/git-hooks/');
  console.log('');
  console.log('Examples:');
  console.log('  npx wsd-method install');
  console.log('  node bin/wsd-method.js install --directory /tmp/wsd-pilot --init-git --tools codex --github skip --yes');
  console.log('  node bin/wsd-method.js install --directory /path/to/legacy --profile generic_python_api --brownfield --yes');
  console.log('  node bin/wsd-method.js install --directory /path/to/project --git-policy full --github existing --yes');
}

function readPackageVersion() {
  try {
    return JSON.parse(fs.readFileSync(path.join(WSD_ROOT, 'package.json'), 'utf8')).version;
  } catch (_error) {
    return '0.0.0-alpha';
  }
}
