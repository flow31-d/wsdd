---
title: "Tasks — TLC Integration (v0.1.4-alpha)"
created: 06/05/2026
modified: 06/05/2026
feature: tlc-integration
spec: "+specs/features/tlc-integration/spec.md"
status: completed
completed_at: "06/05/2026"
---

# Tasks — TLC Integration (v0.1.4-alpha)

> **Status:** ✅ Concluído em 06/05/2026 — 34/34 tasks executadas em ~18 commits.
> Gate final: `npm test` (3 suites passam), `bash scripts/wsd_self_check.sh` (PASS), `bash scripts/wsd_docs_check.sh` (PASS).
> Decisões e lições registradas em `+specs/project/STATE.md`.

Plano de implementação atômico. Uma task = um deliverable verificável + um commit.
Seguir ordem dos grupos. Tasks com `[P]` podem rodar em paralelo dentro do grupo.

Gate levels (ver TESTING.md quando criado):
- **quick**: `node bin/wsd-method.js --version` + verificar arquivo gerado
- **full**: `bash scripts/wsd_self_check.sh` + `bash scripts/wsd_docs_check.sh`
- **build**: `npm test` (todos os testes do instalador)

---

## Grupo A — Foundation: Renomear .specs → +specs e .logs → +logs

> Impacto: todos os arquivos gerados pelo instalador e todos os templates.
> Fazer esse grupo antes de qualquer outro — é a mudança de breaking change que afeta tudo.

### T01 — Atualizar PROFILE_PRESETS em wsd-method.js [P]

**Files:**
- Modify: `bin/wsd-method.js`

- [ ] Nos 4 profiles (`generic_node_frontend`, `generic_python_api`, `exemplo_saas_b`, `exemplo_saas_a`): substituir `./.specs` → `./ +specs` e `./.logs` → `./+logs` em `write_paths`
- [ ] Na função `buildSettings()`: atualizar valor padrão de `WRITE_PATHS` e `FORBIDDEN_PATHS` se referenciarem `.specs` ou `.logs`
- [ ] Gate: grep por `.specs` no arquivo e confirmar zero ocorrências

```bash
grep -n '\.specs\|\.logs' bin/wsd-method.js
```

- [ ] Commit: `refactor(installer): rename .specs → +specs and .logs → +logs in profiles`

---

### T02 — Atualizar .context.json.template [P]

**Files:**
- Modify: `templates/repo/.context.json.template`

- [ ] Substituir todos os paths `.specs/` → `+specs/` e `.logs/` → `+logs/`
- [ ] Atualizar `context_documents` para apontar para nova estrutura (`+specs/project/`, `+specs/codebase/`)
- [ ] Gate: `grep -n '\.specs\|\.logs' templates/repo/.context.json.template` → zero

- [ ] Commit: `refactor(templates): update .context.json paths to +specs and +logs`

---

### T03 — Atualizar todos os templates de specs [P]

**Files:**
- Modify: `templates/specs/l0-task-card.md.template`
- Modify: `templates/specs/l1-feature.spec.yaml.template`
- Modify: `templates/specs/l2-operational-change.spec.yaml.template`
- Modify: `templates/specs/session-close-report.md.template`
- Modify: `templates/specs/pr_body.md.template`
- Modify: `templates/specs/adr.md.template`

- [ ] Substituir referências `.specs/` → `+specs/` em todos os arquivos acima
- [ ] Gate: `grep -rn '\.specs\|\.logs' templates/specs/`

- [ ] Commit: `refactor(templates): update spec templates to +specs paths`

---

### T04 — Atualizar scripts de check [P]

**Files:**
- Modify: `scripts/wsd_check.sh`
- Modify: `scripts/wsd_docs_check.sh`
- Modify: `scripts/wsd_self_check.sh`
- Modify: `scripts/wsd_bootstrap_repo.sh`
- Modify: `scripts/wsd_list_placeholders.sh`

- [ ] Substituir referências `.specs/` → `+specs/` e `.logs/` → `+logs/`
- [ ] Gate: `grep -rn '\.specs\|\.logs' scripts/`

- [ ] Commit: `refactor(scripts): update checker scripts to +specs and +logs`

---

### T05 — Atualizar Codex skills e Claude commands [P]

**Files:**
- Modify: `templates/codex-skills/wsd/SKILL.md`
- Modify: `templates/codex-skills/wsd-start/SKILL.md`
- Modify: `templates/codex-skills/wsd-finish/SKILL.md`
- Modify: `templates/claude-commands/commands/wsd-start.md`
- Modify: `templates/claude-commands/commands/wsd-finish.md`

- [ ] Substituir referências `.specs/` → `+specs/` e `.logs/` → `+logs/`
- [ ] Gate: `grep -rn '\.specs\|\.logs' templates/codex-skills/ templates/claude-commands/`

- [ ] Commit: `refactor(skills): update skill templates to +specs and +logs`

---

### T06 — Atualizar docs e templates de repo [P]

**Files:**
- Modify: `templates/repo/AGENTS.md.template`
- Modify: `templates/repo/.specs/` (renomear para `templates/repo/+specs/`)
- Modify: `templates/repo/.logs/` (renomear para `templates/repo/+logs/`)
- Modify: todos os docs em `docs/` que referenciem `.specs/` ou `.logs/`

- [ ] Renomear pastas: `templates/repo/.specs/` → `templates/repo/+specs/` e `templates/repo/.logs/` → `templates/repo/+logs/`
- [ ] Atualizar AGENTS.md.template com novos paths
- [ ] Grep nos docs e atualizar ocorrências
- [ ] Gate: `grep -rn '\.specs\|\.logs' templates/repo/ docs/`

- [ ] Commit: `refactor(repo-templates): rename .specs → +specs and .logs → +logs in repo templates`

---

## Grupo B — Nova estrutura +specs/ (templates expandidos)

> Cria os novos templates de brownfield e projeto no instalador.

### T07 — Criar template +specs/project/PROJECT.md [P]

**Files:**
- Create: `templates/repo/+specs/project/PROJECT.md.template`

- [ ] Conteúdo: visão do projeto, goals, regras operacionais (migra de project-rules.md), out of scope
- [ ] Placeholders: `{{PROJECT_NAME}}`, `{{PROJECT_TYPE}}`, `{{PRIMARY_LANGUAGE}}`, `{{PROJECT_RULES_MARKDOWN}}`
- [ ] Gate: `cat templates/repo/+specs/project/PROJECT.md.template` e verificar placeholders

- [ ] Commit: `feat(templates): add +specs/project/PROJECT.md template`

---

### T08 — Criar template +specs/project/STATE.md [P]

**Files:**
- Create: `templates/repo/+specs/project/STATE.md.template`

- [ ] Seções: Decisões, Bloqueadores Ativos, Lições Aprendidas, Ideias Adiadas, Todos Ativos
- [ ] Formato tabular para decisões e lições; checkbox para todos
- [ ] Placeholder inicial com linha de exemplo comentada
- [ ] Gate: verificar estrutura de seções

- [ ] Commit: `feat(templates): add +specs/project/STATE.md template (replaces error_vault.json)`

---

### T09 — Criar templates +specs/codebase/ [P]

**Files:**
- Create: `templates/repo/+specs/codebase/STACK.md.template`
- Create: `templates/repo/+specs/codebase/ARCHITECTURE.md.template`
- Create: `templates/repo/+specs/codebase/CONVENTIONS.md.template`
- Create: `templates/repo/+specs/codebase/STRUCTURE.md.template`
- Create: `templates/repo/+specs/codebase/INTEGRATIONS.md.template`
- Create: `templates/repo/+specs/codebase/CONCERNS.md.template`

- [ ] Cada template com seções guiadas + placeholders + instruções inline
- [ ] ARCHITECTURE.md migra conteúdo de `product-architecture-summary.md`
- [ ] CONCERNS.md migra conteúdo de `active-debts.md` + adiciona seção "Componentes Frágeis"
- [ ] Gate: verificar que cada template tem pelo menos 3 seções guiadas

- [ ] Commit: `feat(templates): add +specs/codebase/ brownfield templates`

---

### T10 — Criar template +specs/codebase/TESTING.md [P]

**Files:**
- Create: `templates/repo/+specs/codebase/TESTING.md.template`

- [ ] Seções: Gate Check Commands (Quick/Full/Build), Coverage Matrix, Parallelism Assessment
- [ ] Placeholders: `{{TEST_QUICK_COMMAND}}`, `{{TEST_FULL_COMMAND}}`, `{{TEST_BUILD_COMMAND}}`
- [ ] Vincular valores ao perfil selecionado no install
- [ ] Gate: verificar 3 tiers e matriz de cobertura

- [ ] Commit: `feat(templates): add +specs/codebase/TESTING.md template with tiered gate checks`

---

### T11 — Criar templates +specs/features/ e +specs/quick/ [P]

**Files:**
- Create: `templates/specs/feature-spec.md.template` (WHEN/THEN/SHALL)
- Create: `templates/specs/feature-tasks.md.template` (atomic tasks com gates)
- Create: `templates/specs/quick-task.md.template`
- Create: `templates/specs/quick-summary.md.template`

- [ ] feature-spec.md: seções Problem Statement, Goals, Out of Scope, User Stories (P1/P2/P3), Acceptance Criteria WHEN/THEN/SHALL
- [ ] feature-tasks.md: header obrigatório, grupos de tasks, formato T01/T02/T03, gate checks por task
- [ ] quick-task.md: escopo, objetivo, verificação, commit — sem pipeline
- [ ] Gate: verificar formato WHEN/THEN/SHALL presente no feature-spec.md

- [ ] Commit: `feat(templates): add feature spec (WHEN/THEN/SHALL) and tasks templates`

---

## Grupo C — HANDOFF.md e STATE.md no fluxo de sessão

### T12 — Atualizar wsd-finish Codex skill

**Files:**
- Modify: `templates/codex-skills/wsd-finish/SKILL.md`

- [ ] Adicionar passo: "Perguntar se houve decisões, bloqueadores ou lições → atualizar STATE.md"
- [ ] Adicionar passo: "Gerar +specs/HANDOFF.md com task atual, itens concluídos, próximos passos, branch, uncommitted"
- [ ] Manter auditoria git existente
- [ ] Gate: verificar os 2 novos passos no SKILL.md

- [ ] Commit: `feat(skills): wsd-finish now updates STATE.md and generates HANDOFF.md`

---

### T13 — Atualizar wsd-finish Claude command

**Files:**
- Modify: `templates/claude-commands/commands/wsd-finish.md`

- [ ] Espelhar mudanças do T12
- [ ] Gate: verificar paridade com Codex skill

- [ ] Commit: `feat(commands): wsd-finish Claude command synced with STATE.md and HANDOFF.md`

---

### T14 — Atualizar wsd-start Codex skill

**Files:**
- Modify: `templates/codex-skills/wsd-start/SKILL.md`

- [ ] Adicionar passo: "Carregar STATE.md se existir — resumir decisões e bloqueadores ativos"
- [ ] Adicionar passo: "Carregar HANDOFF.md se existir — perguntar se quer continuar de onde parou"
- [ ] Adicionar passo: "Classificar tarefa do usuário: L0→Quick, L1→Specify+Execute, L2→4 fases"
- [ ] Gate: verificar 3 novos passos

- [ ] Commit: `feat(skills): wsd-start loads STATE.md, HANDOFF.md and auto-sizes task`

---

### T15 — Atualizar wsd-start Claude command

**Files:**
- Modify: `templates/claude-commands/commands/wsd-start.md`

- [ ] Espelhar mudanças do T14
- [ ] Gate: verificar paridade

- [ ] Commit: `feat(commands): wsd-start Claude command synced with STATE.md and auto-sizing`

---

## Grupo D — Novos comandos: wsd-specify, wsd-design, wsd-tasks

### T16 — Criar wsd-specify Codex skill

**Files:**
- Create: `templates/codex-skills/wsd-specify/SKILL.md`

- [ ] Fluxo: clarificar requirements (perguntas uma por uma) → user stories P1/P2/P3 → acceptance criteria WHEN/THEN/SHALL → gravar em `+specs/features/[slug]/spec.md`
- [ ] Incluir: auto-detect se feature tem áreas cinzas (discutir antes de escrever)
- [ ] Incluir: instruções de scope check (feature grande? decompor primeiro)
- [ ] Gate: verificar seções principais no SKILL.md

- [ ] Commit: `feat(skills): add wsd-specify Codex skill (Specify phase)`

---

### T17 — Criar wsd-specify Claude command

**Files:**
- Create: `templates/claude-commands/commands/wsd-specify.md`

- [ ] Espelhar wsd-specify Codex skill
- [ ] `allowed-tools: [Bash, Read, Write]`
- [ ] `argument-hint: nome da feature (slug)`
- [ ] Gate: verificar paridade com Codex skill

- [ ] Commit: `feat(commands): add /wsd-specify Claude command`

---

### T18 — Criar wsd-design Codex skill

**Files:**
- Create: `templates/codex-skills/wsd-design/SKILL.md`

- [ ] Fluxo: ler spec.md → knowledge verification chain → propor 2-3 abordagens → design.md (arquitetura, componentes, data flow, testing approach)
- [ ] Incluir: quando pular (feature clara sem decisões arquiteturais)
- [ ] Gate: verificar knowledge chain e seções de design.md

- [ ] Commit: `feat(skills): add wsd-design Codex skill (Design phase)`

---

### T19 — Criar wsd-design Claude command

**Files:**
- Create: `templates/claude-commands/commands/wsd-design.md`

- [ ] Espelhar wsd-design Codex skill
- [ ] Gate: verificar paridade

- [ ] Commit: `feat(commands): add /wsd-design Claude command`

---

### T20 — Criar wsd-tasks Codex skill

**Files:**
- Create: `templates/codex-skills/wsd-tasks/SKILL.md`

- [ ] Fluxo: ler spec.md + design.md → load TESTING.md → mapear layers a test types → criar tasks.md atômico (formato T01/T02/T03) → definir dependências → flags [P] para paralelas → gate level por task
- [ ] Safety valve: se listing revela >5 steps ou deps complexas sem tasks.md → STOP e criar tasks.md
- [ ] Gate: verificar safety valve e formatos de task

- [ ] Commit: `feat(skills): add wsd-tasks Codex skill (Tasks phase)`

---

### T21 — Criar wsd-tasks Claude command

**Files:**
- Create: `templates/claude-commands/commands/wsd-tasks.md`

- [ ] Espelhar wsd-tasks Codex skill
- [ ] Gate: verificar paridade

- [ ] Commit: `feat(commands): add /wsd-tasks Claude command`

---

## Grupo E — Atualizar Constituição e docs

### T22 — Adicionar Regra 11 à Constituição (knowledge chain)

**Files:**
- Modify: `docs/01_constituicao.md`

- [ ] Adicionar Regra 11: Knowledge Verification Chain (5 passos em ordem obrigatória)
- [ ] Adicionar exemplo prático: "NUNCA inventar APIs, padrões ou behaviors"
- [ ] Gate: verificar Rule 11 presente e numerada corretamente

- [ ] Commit: `docs: add Rule 11 (knowledge verification chain) to Constitution`

---

### T23 — Adicionar Regra 12 à Constituição (scope guardrail)

**Files:**
- Modify: `docs/01_constituicao.md`

- [ ] Adicionar Regra 12: Scope Guardrail — "is this in my task definition? If no, log in STATE.md"
- [ ] Gate: verificar Rule 12 presente

- [ ] Commit: `docs: add Rule 12 (scope guardrail) to Constitution`

---

### T24 — Atualizar git governance com Conventional Commits

**Files:**
- Modify: `docs/07_git_governance.md`
- Modify: `docs/11_modulo_git_governance.md`

- [ ] Adicionar seção: Conventional Commits 1.0.0 como padrão obrigatório
- [ ] Incluir tabela de tipos (feat, fix, refactor, docs, test, style, perf, build, ci, chore)
- [ ] Incluir regras de description (imperativo, lowercase, sem ponto)
- [ ] Gate: verificar seção Conventional Commits em ambos os docs

- [ ] Commit: `docs: add Conventional Commits standard to git governance`

---

### T25 — Atualizar playbook com 4 fases TLC + auto-sizing

**Files:**
- Modify: `docs/04_playbook_implantacao.md`
- Modify: `docs/08_rotinas_sessao.md`

- [ ] Adicionar diagrama das 4 fases: Specify → Design → Tasks → Execute
- [ ] Adicionar tabela de auto-sizing: L0→Quick, L1→Specify+Execute, L2→4 fases
- [ ] Atualizar rotinas de sessão para incluir STATE.md e HANDOFF.md
- [ ] Gate: verificar 4 fases e tabela de auto-sizing

- [ ] Commit: `docs: add TLC 4-phase workflow and auto-sizing table to playbook`

---

### T26 — Criar doc 14: Guia de Qualidade de Desenvolvimento

**Files:**
- Create: `docs/14_qualidade_desenvolvimento.md`

- [ ] Seções: Auto-sizing, STATE.md como memória, HANDOFF.md como handoff, WHEN/THEN/SHALL, TESTING.md tiered gates, knowledge chain, scope guardrail, Conventional Commits
- [ ] Links para specs de referência TLC e comparativo com Superpowers
- [ ] Gate: verificar 8 seções presentes

- [ ] Commit: `docs: add doc 14 - development quality guide (TLC integration)`

---

## Grupo F — Atualizar instalador (wsd-method.js)

### T27 — Gerar STATE.md no install

**Files:**
- Modify: `bin/wsd-method.js`

- [ ] Na função `renderRepoTemplates()`: garantir que `+specs/project/STATE.md` é gerado
- [ ] Gate: `node bin/wsd-method.js install --directory /tmp/wsd-test --init-git --tools codex --yes && cat /tmp/wsd-test/+specs/project/STATE.md`

- [ ] Commit: `feat(installer): generate +specs/project/STATE.md on install`

---

### T28 — Gerar TESTING.md no install com dados do perfil

**Files:**
- Modify: `bin/wsd-method.js`

- [ ] Mapear `LINT_COMMANDS`, `TEST_COMMANDS`, `BUILD_COMMANDS` para placeholders Quick/Full/Build no TESTING.md
- [ ] Adicionar `TEST_QUICK_COMMAND`, `TEST_FULL_COMMAND`, `TEST_BUILD_COMMAND` ao settings
- [ ] Gate: verificar TESTING.md gerado com comandos do perfil

- [ ] Commit: `feat(installer): generate +specs/codebase/TESTING.md with tiered gate commands`

---

### T29 — Adicionar flag --brownfield ao install

**Files:**
- Modify: `bin/wsd-method.js`

- [ ] Nova flag `--brownfield`: ao ativar, cria `+specs/codebase/` com os 7 docs e instrui o agente a preencher
- [ ] Sem `--brownfield`: cria só `+specs/project/` e `+specs/features/` (greenfield)
- [ ] Gate: testar `--brownfield` e verificar 7 docs criados

- [ ] Commit: `feat(installer): add --brownfield flag to generate codebase analysis docs`

---

### T30 — Instalar novos comandos no install

**Files:**
- Modify: `bin/wsd-method.js`

- [ ] Em `installCodexSkills()`: incluir wsd-specify, wsd-design, wsd-tasks
- [ ] Em `installClaudeCommands()`: incluir wsd-specify, wsd-design, wsd-tasks
- [ ] Gate: verificar 5 skills Codex e 5 commands Claude gerados

- [ ] Commit: `feat(installer): install wsd-specify, wsd-design and wsd-tasks on install`

---

### T31 — Atualizar profiles com +specs e TESTING.md placeholders

**Files:**
- Modify: `bin/wsd-method.js` (seção PROFILE_PRESETS)
- Modify: `profiles/generic_node_frontend.profile.yaml`
- Modify: `profiles/generic_python_api.profile.yaml`
- Modify: `profiles/exemplo_saas_b.profile.yaml`
- Modify: `profiles/exemplo_saas_a.profile.yaml`

- [ ] Cada profile: `write_paths` com `+specs` e `+logs`
- [ ] Cada profile: novo campo `test_quick`, `test_full`, `test_build` para TESTING.md
- [ ] Gate: `grep -n 'specs\|logs' profiles/` → só `+specs` e `+logs`

- [ ] Commit: `refactor(profiles): update all profiles to +specs, +logs and tiered gate commands`

---

## Grupo G — Testes e release

### T32 — Atualizar npm test para nova estrutura

**Files:**
- Modify: `package.json`

- [ ] Verificar que `test:install` cobre geração de `+specs/` (não `.specs/`)
- [ ] Adicionar `test:install-brownfield` para testar `--brownfield`
- [ ] Gate: `npm test` passa completamente

- [ ] Commit: `test: update install tests for +specs structure and brownfield flag`

---

### T33 — Atualizar wsd_docs_check.sh para nova estrutura

**Files:**
- Modify: `scripts/wsd_docs_check.sh`

- [ ] Checar existência de `+specs/project/STATE.md` e `+specs/codebase/TESTING.md`
- [ ] Checar ausência de `.specs/` residuais nos templates
- [ ] Gate: `bash scripts/wsd_docs_check.sh` passa sem erros

- [ ] Commit: `test: update docs checker for +specs structure and new templates`

---

### T34 — Bump de versão e CHANGELOG

**Files:**
- Modify: `package.json`
- Modify: `CHANGELOG.md`
- Modify: `ROADMAP.md`
- Modify: `README.md`

- [ ] `package.json`: `"version": "0.1.4-alpha"`
- [ ] CHANGELOG: seção `0.1.4-alpha` com todos os itens implementados
- [ ] ROADMAP: marcar itens da Fase 1 concluídos, adicionar v0.1.4 como próxima
- [ ] README: atualizar Status e Foco Atual
- [ ] Gate: `bash scripts/wsd_self_check.sh`

- [ ] Commit: `chore: bump to v0.1.4-alpha — TLC integration release`

---

## Resumo

| Grupo | Tasks | Deliverable |
|---|---|---|
| A — Path renaming | T01–T06 | Todos os `+specs` e `+logs` no lugar de `.specs` e `.logs` |
| B — Nova estrutura +specs/ | T07–T11 | Templates de brownfield, STATE.md, TESTING.md, feature spec e tasks |
| C — Sessão STATE/HANDOFF | T12–T15 | wsd-start e wsd-finish atualizados |
| D — Novos comandos | T16–T21 | wsd-specify, wsd-design, wsd-tasks (Codex + Claude Code) |
| E — Docs e Constituição | T22–T26 | Regras 11+12, Conventional Commits, playbook, doc 14 |
| F — Installer | T27–T31 | STATE.md, TESTING.md, --brownfield, novos comandos, profiles |
| G — Testes e release | T32–T34 | npm test, docs check, v0.1.4-alpha |

**Total: 34 tasks atômicas**  
Grupos A, B, C, D, E, F podem ser trabalhados em paralelo entre si (com cuidado ao Grupo A ser feito antes dos demais).  
Grupo G sempre por último.
