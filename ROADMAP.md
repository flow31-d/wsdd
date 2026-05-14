---
title: "Roadmap WSD"
created: 05/05/2026
modified: 13/05/2026
tags:
  - x
  - wsd
  - roadmap
status: ativo
tipo: nota
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/README]], [[wsd/CHANGELOG]], [[wsd/docs/04_playbook_implantacao]], [[wsd/docs/10_matriz_sincronizacao_notas]], [[wsd/docs/11_modulo_git_governance]]"
otimizado_para_obsidian: true
---
# Roadmap WSD

[[wsd/wsd|← WSD]]

---


> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. Fase 1 — Aprimorar WSD]]
3. [[#3. Fase 2 — Validação Operacional em Projeto Brownfield]]
4. [[#4. Fase 3 — Ajustes Pós-Validação]]
5. [[#5. Fase 3.5 — Party Mode Integration]]
6. [[#6. Fase 4 — Repositório Final Oficial]]
7. [[#7. Fora de Escopo Inicial]]
8. [[#8. Regra de Sincronização do Roadmap]]
9. [[#9. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 05/05/2026 13:29:54 -03 — Codex: Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes.
- 05/05/2026 13:41:50 -03 — Codex: Reorganização do roadmap em fases alpha, com foco inicial em Codex e preparação posterior para Claude Code.
- 05/05/2026 13:57:20 -03 — Codex: Marcação dos itens implementados na fase 1 alpha: CLI local, instalador, renderização de templates, `+wsd/` vendorizado e skills Codex locais.
- 05/05/2026 14:13:39 -03 — Codex: Alinhamento do roadmap à versão `v0.1.2-alpha`, separando itens concluídos, pendentes e regra de sincronização documental.
- 05/05/2026 14:38:29 -03 — Codex: Registro do módulo opcional `git-governance` como próxima frente de aprimoramento planejada para `v0.1.3-alpha`.
- 06/05/2026 11:31:14 -03 — Codex: Registro da reavaliação da nota crítica `12 — Avaliação Crítica`, consolidando o foco Codex-first com Claude Code quase igualmente importante.
- 06/05/2026 12:50:21 -03 — Codex: Padronização das listas de acompanhamento com checkboxes `- [ ]` e `- [x]` para controlar tarefas pendentes e concluídas no roadmap.
- 06/05/2026 13:17:00 -03 — Codex: Consolidação da entrega `v0.1.3-alpha` com comandos slash Claude Code, hooks e documentação sincronizada.
- 07/05/2026 — Claude: Consolidação da entrega `v0.1.5-alpha` — JSON Schema canônico para `+context.json` (`schemas/context.schema.json`) + validador zero-deps `wsd-validate-context.js` integrado a `wsd_check.sh`. Fecha o último pendente da Fase 1.
- 07/05/2026 — Claude: Consolidação da entrega `v0.1.6-alpha` — ghost spec detector em `wsd_check.sh` + git hooks no bootstrap (`pre-commit`, `commit-msg`, `pre-push`). Fase 3 fechada (exceto itens para futuras alphas). Consolidação de todos os itens planejados em uma lista única.
- 07/05/2026 — Claude: Consolidação da entrega `v0.1.7-alpha` — HANDOFF.md gerado automaticamente por `wsd finish` + prompts interativos para STATE.md (lições, decisões, bloqueadores). Fecha último item pendente da Fase 3.
- 07/05/2026 — Claude: Consolidação da entrega `v0.1.8-alpha` — instalação interativa rica (linguagem, path, test/build/lint, forbidden_paths), `wsd update` real, WHEN+THEN+SHALL completos em ghost spec e L1/L2.
- 07/05/2026 — Codex: Consolidação da entrega `v0.1.9-alpha` — saneamento documental operacional em `docs/00` e `docs/12`, com `wsd_philo/` tratado como referência histórica/pesquisa, não como fonte de gate.
- 07/05/2026 — Codex: Planejamento da entrega `v0.1.10-alpha` — MVP Git/GitHub Governance como última alpha funcional antes da estabilização `v0.1.0`.
- 07/05/2026 — Codex: Consolidação da entrega `v0.1.10-alpha` — MVP Git/GitHub Governance implementado (`--git-policy`, `wsd git`, templates PR/Issue, `git_governance` e testes por modo).
- 07/05/2026 — Claude: Planejamento da entrega `v0.1.11-alpha` — Party Mode Integration: spec aprovada (7 ACs WHEN/THEN/SHALL), tasks definidas (T1–T6). Fase 3.5 adicionada ao roadmap como pré-requisito da Fase 4.
- 07/05/2026 — Claude: Consolidação da entrega `v0.1.11-alpha` — Party Mode Integration concluída: T1–T6 entregues (`installPartyMode`, `/wsd-party-mode`, `wsd party status|list-agents|when-to-use`, seção AGENTS.md, `test:install-party-mode`). Fase 3.5 fechada e Fase 4 (estabilização `v0.1.0`) liberada como próxima frente. 7/7 testes PASS.
- 07/05/2026 — Claude: Fechamento dos 2 itens em aberto da Fase 3 — perfis para outros stacks descartado (instalação interativa rica e `--brownfield` cobrem; BMAD/TLC não usam perfis pré-definidos) e validação YAML formal descartada (templates `.spec.yaml.template` são legados não usados; ghost detector + WHEN/THEN/SHALL no markdown substituem). Fase 3 100% fechada.
- 07/05/2026 — Claude: Release **`v0.1.0`** estável — Fase 4 100% fechada. Bump `0.1.11-alpha` → `0.1.0`, README com "Uso Oficial" expandido, CHANGELOG seção 14, tags retroativas `v0.1.10-alpha`/`v0.1.11-alpha` + tag final `v0.1.0`, compatibilidade Codex e Claude Code validada via 7/7 gates de `npm test`. Modo manutenção estável.
- 11/05/2026 — Claude: Adição da Fase 5 (Evolução Pós-v0.1.0). Planejamento de `v0.1.1` — Project ROADMAP: spec aprovada (6 ACs WHEN/THEN/SHALL) e tasks definidas (T1–T8) em `+specs/features/project-roadmap/`.
- 11/05/2026 — Claude: Planejamento de `v0.1.2` — Ideas Workflow: spec aprovada (10 ACs WHEN/THEN/SHALL) e tasks definidas (T1–T9) em `+specs/features/ideas-workflow/`. Três componentes: IDEAS.md, IDEAS_PIPELINE.md, skill `/idea-{project_slug}`.
- 11/05/2026 — Claude: Consolidação da entrega `v0.1.3` — CJS/ESM fix (`wsd-validate-context.cjs`, `wsd-snapshot.cjs`), governance gaps fechados (specs marcadas `implemented`, `docs/05` atualizado com seções ROADMAP/IDEAS/+wsd/), spec retroativa `project-snapshot`, `RELEASING.md` criado. 7/7 gates PASS.
- 12/05/2026 — Claude (Opus 4.7): Consolidação da entrega `v0.1.4` (hotfix) — fix WSD-001 (3 templates faltantes no `wsdd`) + sync `wsdd` dos 6 commits pós-v0.1.3 + fechamento dos gaps de governance do release v0.1.3 (linha 217 do README + tag retroativa v0.1.3). Refs: Issue #10, `REVIEW_PRE_V1.md`. Próximo marco "estável adotável": `v0.2.0` (WSD-002/003/004 L0+L1/009/010).
- 13/05/2026 — Claude (Opus 4.7): Consolidação da entrega `v0.2.0` (minor "estável adotável"). 8 features + UX polish: WSD-010 (CONCERNS padrão), WSD-002 (render condicional), WSD-009 (release script), WSD-007 (install opt-out D-001), WSD-004 L0+L1 (check robusto), WSD-003 (CI no wsdd), WSD-006 (Obsidian D-002), WSD-013 (fix raiz ENOENT). Decisões D-001 (Opção B+) e D-002 (Opção A) resolvidas. 9/9 npm test + 27/27 cenários e2e + piloto operacional no `flow31-d/worc`. Próximas frentes mapeadas para `v0.2.1`/`v0.3.0`: WSD-004 L2, WSD-005, WSD-008, WSD-012.
- 13/05/2026 — Claude (Opus 4.7): Consolidação da entrega `v0.3.0` (minor — reforço do contrato operacional WSD). `scripts/wsd_check.sh` reescrito (185 linhas) validando 6 notas obrigatórias de `+specs/project/` como L0-required (PROJECT/STATE/ROADMAP/IDEAS/IDEAS_PIPELINE/CONCERNS). `+context.json` com blocos formais `environment`, `repository` (+ `clone_policy`), `permissions`, `workflow`. Artefatos `+specs/project/` preenchidos com conteúdo real do projeto. `templates/local-wsd/bin/wsd-snapshot.cjs` propaga novos campos. Inclui `REVIEW_PRE_V1.md` (tracker pré-v1) e `docs/18_manual_leigo_comandos_wsdd.md` (manual leigo). WSD-008 parcialmente endereçado pelo tracker. Próximas frentes restantes: WSD-004 L2 (branch_naming, pre-flight git, audit), WSD-005 (normalização cosmética), WSD-012 (`wsd git audit`).

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. Fase 1 — Aprimorar WSD

- [x] Publicar versão `v0.1.0-alpha` em repositório GitHub privado.
- [x] Publicar versão `v0.1.1-alpha` com instalador local, renderização por perfil, `+wsd/bin/wsd` e skills Codex locais.
- [x] Publicar versão `v0.1.2-alpha` com matriz de sincronização documental, `scripts/wsd_docs_check.sh` e correção de `npm run test:install`.
- [x] Otimizar primeiro para Codex.
- [x] Criar comando local de instalação por projeto como `wsd-method install`.
- [x] Adicionar renderização automática por perfil.
- [x] Planejar módulo opcional `git-governance` baseado em `Recursos/r.3.4_git_github`, concluído em [[wsd/docs/11_modulo_git_governance|11 — Módulo Git Governance WSD]].
- [x] Revisar e manter coerente a nota `12 — Avaliação Crítica` com o estado atual do WSD.
- [x] Entregar suporte operacional ao Claude Code em `v0.1.3-alpha`.
- [x] Entregar camada de qualidade de desenvolvimento TLC em `v0.1.4-alpha` (34 tasks atômicas concluídas — ver [[wsd/+specs/features/tlc-integration/spec|spec]] e [[wsd/+specs/features/tlc-integration/tasks|tasks]]).
- [x] Absorver módulo opcional `git-governance` na v0.1.4 via Conventional Commits 1.0.0 obrigatório (ver `docs/07_git_governance.md`).
- [x] Adicionar validação JSON Schema para `+context.json` em `v0.1.5-alpha` (`schemas/context.schema.json` + validador zero-deps `wsd-validate-context.js`).

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. Fase 2 — Validação Operacional em Projeto Brownfield

- [x] Separar/registrar worktree suja do projeto-alvo antes do bootstrap.
- [x] Instalar WSD como piloto local com `--brownfield` quando aplicável.
- [x] Rodar fluxo de início, check e fechamento.
- [x] Criar primeira spec real com WHEN/THEN/SHALL.
- [x] Validar com `npm test` (ou equivalente) e `npm run build`.
- [x] Concluída em 07/05/2026 — informações operacionais ficam no `+specs/project/STATE.md` do projeto-alvo, não neste roadmap.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. Fase 3 — Ajustes Pós-Validação

- [x] Corrigir paths legados no `templates/local-wsd/bin/wsd` (detectado durante validação operacional, fix `0d78bf2`).
- [x] Estender `wsd_docs_check.sh` para escanear `templates/local-wsd/` (anti-regressão).
- [x] Preparar templates Claude Code.
- [x] Ghost spec detector em `wsd_check.sh`: scan de specs `approved`/`implemented` sem WHEN/THEN/SHALL — `warn:` genérico, hard `fail:` em L1/L2 (`v0.1.6-alpha`).
- [x] Git hooks instalados pelo bootstrap: `pre-commit` (WSD gate), `commit-msg` (Conventional Commits 1.0.0), `pre-push` (WSD gate). Versioned em `scripts/git-hooks/`, ativos em `.git/hooks/`. Subcomando `wsd hooks` para reinstalar. Flag `--no-git-hooks` para opt-out (`v0.1.6-alpha`).
- [x] Refinar perguntas de instalação interativa (`v0.1.8-alpha`).
- [x] ~~Adicionar perfis para outros stacks (Go, React Native, etc).~~ **Descartado em 07/05/2026** — instalação interativa rica (v0.1.8) coleta linguagem/paths/comandos no install e `--brownfield` detecta stack via dependency manifests. BMAD não usa perfis por stack (workflows agnósticos) e TLC pergunta o stack durante init. Perfis pré-definidos viraram desnecessários após v0.1.8.
- [x] ~~Validação YAML formal para specs L1/L2 (campo `acceptance_criteria` verificável por schema).~~ **Descartado em 07/05/2026** — `templates/specs/l1-feature.spec.yaml.template` e `l2-operational-change.spec.yaml.template` são formato legado não copiado pelo installer e sem instâncias ativas. Specs operacionais usam `+specs/features/<slug>/spec.md` (markdown + frontmatter + WHEN/THEN/SHALL), já validadas pelo ghost spec detector (`scripts/wsd_check.sh`).
- [x] HANDOFF.md gerado automaticamente por `wsd finish` — branch, último commit, últimos 5 commits, arquivos em andamento, specs abertas (`v0.1.7-alpha`).
- [x] Prompts interativos no `wsd finish` para STATE.md: lições aprendidas, decisões, bloqueadores (`v0.1.7-alpha`).
- [x] Instalação interativa rica: linguagem principal, path canônico, test/build/lint commands, forbidden_paths (`v0.1.8-alpha`).
- [x] `wsd update` real: atualiza `+wsd/` vendor tree sem tocar em arquivos do projeto (`v0.1.8-alpha`).
- [x] Validação WHEN+THEN+SHALL completa: todos os três keywords obrigatórios em ghost scan e L1/L2 (`v0.1.8-alpha`).
- [x] Saneamento documental pós-v0.1.8: checklists operacionais atualizados e `wsd_philo/` classificado como referência histórica/pesquisa (`v0.1.9-alpha`).
- [x] Implementar MVP Git/GitHub Governance (`v0.1.10-alpha`): `--git-policy none|basic|full`, `wsd git doctor`, `wsd git preflight`, `wsd git pr-check`, templates PR/Issue e campos `git_governance` no `+context.json`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. Fase 3.5 — Party Mode Integration

Pré-requisito da Fase 4. Party Mode (`v0.1.11-alpha`): sistema de orquestração multi-agente
instalado pelo `wsd-method`, exposto como comando Claude Code e subcomando `wsd party`.

Spec: `+specs/features/party-mode-integration/spec.md`

- [x] T1 — Criar `templates/claude-commands/commands/wsd-party-mode.md` (AC-1)
- [x] T2 — `installPartyMode()` em `wsd-method.js` — copia assets para `+wsd/party-mode/` (AC-2, AC-7)
- [x] T3 — Subcomando `wsd party list-agents|when-to-use|status` em `templates/local-wsd/bin/wsd` (AC-3)
- [x] T4 — Seção `## Party Mode` no `templates/repo/AGENTS.md.template` (AC-4)
- [x] T5 — `test:install-party-mode` em `package.json` e no pipeline `test` (AC-5, AC-6)
- [x] T6 — Bump `0.1.10-alpha` → `0.1.11-alpha`, sync documental completo

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. Fase 4 — Repositório Final Oficial

- [x] Publicar versão estável `v0.1.0` (07/05/2026 — bump de `0.1.11-alpha`, Fase 4 concluída).
- [x] Documentar uso oficial — README seção "Uso Oficial" expandida (greenfield, brownfield, ciclo de sessão, comandos, política Git, validação contínua).
- [x] Criar tags e changelog de release — tags retroativas `v0.1.10-alpha`, `v0.1.11-alpha` + tag final `v0.1.0`; CHANGELOG seção 14.
- [x] Confirmar compatibilidade Codex e Claude Code — `npm test` 7/7 gates PASS (test:install Codex + test:install-claude Claude Code + brownfield + git modes + party-mode).

[[#📑 Índice|⬆️ Voltar ao Índice]]

## Fase 5 — Evolução Pós-v0.1.0 (Manutenção Estável)

Novas features em `v0.1.x` (patches) ou `v0.2.0` (features grandes), seguindo o ciclo: spec aprovada → tasks → implementação → testes → sync documental → release.

- [x] `v0.1.1` — **Project ROADMAP**: `+specs/project/ROADMAP.md` adicionado como artefato padrão do installer via `templates/repo/+specs/project/ROADMAP.md.template`. Formato Obsidian com frontmatter, callouts e instruções para agentes. Gates de install atualizados.
- [x] `v0.1.2` — **Ideas Workflow**: `IDEAS.md` + `IDEAS_PIPELINE.md` + skill `/idea-{PROJECT_SLUG}` com rename dinâmico por projeto + `PROJECT_SLUG` como variável de template derivada de `PROJECT_NAME` + opção Party Mode para L1/L2 em `wsd-idea.md`. Formato Obsidian. 8/8 gates PASS.
- [x] `v0.1.3` — **CJS/ESM fix + Governance + Snapshot spec + RELEASING.md**: `wsd-validate-context.js` e `wsd-snapshot.js` renomeados para `.cjs` (compatibilidade com projetos `"type": "module"`); specs de `project-roadmap` e `ideas-workflow` marcadas como `implemented`; `docs/05` atualizado com seções ROADMAP/IDEAS/`+wsd/`; spec retroativa de `project-snapshot` criada; `RELEASING.md` com checklist obrigatório de release. 7/7 gates PASS.
- [x] `v0.1.4` — **WSD-001 hotfix + governance cleanup**: três templates faltantes no `wsdd` público (`ROADMAP.md.template`, `IDEAS.md.template`, `IDEAS_PIPELINE.md.template`) sincronizados; 6 commits pendentes pós-v0.1.3 também sincronizados; README linha 217 corrigida de `v0.1.2` para `v0.1.4`; tag retroativa `v0.1.3` criada no commit `9525e90`. Refs: Issue #10, `REVIEW_PRE_V1.md` (WSD-001). 7/7 gates PASS.
- [x] `v0.2.0` — **Marco "estável adotável"**: 8 features funcionais + UX polish. WSD-010 (CONCERNS.md padrão #13), WSD-002 (renderização condicional `{{#if}}` no AGENTS.md #20), WSD-003 (CI no `wsdd`), WSD-009 (`scripts/wsd_release.sh` #22), WSD-007 (install com opt-out interativo D-001 #24), WSD-004 L0+L1 (`wsd check` robusto #26), WSD-006 (Obsidian declarado D-002 #15), WSD-013 (fix raiz ENOENT #18), UX polish (#27). Decisões D-001 (Opção B+) e D-002 (Opção A) resolvidas em 12-13/05/2026. 9/9 npm test PASS + 27/27 cenários e2e + piloto operacional no `flow31-d/worc`.
- [x] `v0.2.1` — **Patch cosmético**: `wsd update` agora monta a lista "Refreshed: +wsd/{...}" dinamicamente a partir de `config.modules`, refletindo módulos efetivamente copiados. Antes era string hardcoded que conflitava com mensagens `info: skipping ...`. Detectado durante validação do piloto worc 13/05/2026.
- [x] `v0.3.0` — **Reforço do contrato operacional**: `scripts/wsd_check.sh` reescrito (185 linhas) validando as 6 notas obrigatórias de `+specs/project/` como L0-required (antes só STATE.md era checada — WSD-001 escapou justamente por isso). `+context.json` ganha blocos formais `environment`, `repository` (+ `clone_policy` canônico), `permissions` (write/forbidden paths, tool_allowlist, secrets_policy, limites runtime/tokens) e `workflow`. Artefatos `+specs/project/` (PROJECT, ROADMAP, IDEAS, IDEAS_PIPELINE, CONCERNS) preenchidos com conteúdo real. `templates/local-wsd/bin/wsd-snapshot.cjs` (+81 linhas) e `templates/repo/scripts/wsd_check.sh` (+45 linhas) propagam mudanças para projetos instalados. `docs/05_contrato_artefatos.md` e `docs/17_snapshot_campos_explicados.md` atualizados. Inclui `REVIEW_PRE_V1.md` (1131 linhas, tracker formal pré-v1 — parcialmente endereça WSD-008) e `docs/18_manual_leigo_comandos_wsdd.md` (568 linhas, manual leigo dos comandos `wsdd`). Path rename `+Apps/WSD` → `+Apps/wsd` consolidado (PR #33). 9/9 npm test PASS.
- [ ] `v0.3.x` / `v0.4.0` — **Próxima frente**: itens restantes não bloqueantes: WSD-004 L2 (branch_naming, pre-flight git, audit ROADMAP↔status), WSD-005 (normalização cosmética de PROJECT_NAME/CANONICAL_HOST), WSD-012 (`wsd git audit`). WSD-008 parcialmente endereçado pelo `REVIEW_PRE_V1.md` da v0.3.0. Ver `REVIEW_PRE_V1.md` para detalhes.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. Fora de Escopo Inicial

- CI remoto obrigatório.
- Deploy autônomo.
- Armazenamento de segredos.
- Migração automática de branches.
- Decisão automática de produção.
- Party Mode interativo com streaming de agentes no terminal.
- Scoring automático de conformidade ("spec recebeu debate suficiente?").
- Integração Party Mode com GitHub Discussions ou PR reviews automáticos.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. Regra de Sincronização do Roadmap

Sempre que uma fase mudar de status, o agente deve revisar:

- [[wsd/README|README]], para que o uso recomendado e status público estejam corretos;
- [[wsd/wsd|hub WSD]], para que o mapa aponte para as notas certas;
- [[wsd/CHANGELOG|CHANGELOG]], se houver versão ou entrega registrável;
- [[wsd/docs/10_matriz_sincronizacao_notas|10 — Matriz de Sincronização]], se a fase criar nova fonte de verdade.

Antes de finalizar, rodar:

```bash
bash scripts/wsd_docs_check.sh
```

Regra de acompanhamento:

- use `- [ ]` para tarefas pendentes ou em andamento;
- use `- [x]` para tarefas concluídas;
- mantenha esse padrão em toda lista controlável do roadmap.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 05/05/2026 13:29:54 -03 | Codex | `x/wsd/ROADMAP.md` | Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes. |
| 05/05/2026 13:41:50 -03 | Codex | `x/wsd/ROADMAP.md` | Reorganização do roadmap em fases alpha, com foco inicial em Codex e preparação posterior para Claude Code. |
| 05/05/2026 13:57:20 -03 | Codex | `x/wsd/ROADMAP.md` | Marcação dos itens implementados na fase 1 alpha: CLI local, instalador, renderização de templates, `+wsd/` vendorizado e skills Codex locais. |
| 05/05/2026 14:13:39 -03 | Codex | `x/wsd/ROADMAP.md` | Alinhamento do roadmap à versão `v0.1.2-alpha`, separando itens concluídos, pendentes e regra de sincronização documental. |
| 05/05/2026 14:38:29 -03 | Codex | `x/wsd/ROADMAP.md` | Registro do módulo opcional `git-governance` como próxima frente de aprimoramento planejada para `v0.1.3-alpha`. |
| 06/05/2026 11:31:14 -03 | Codex | `x/wsd/ROADMAP.md` | Registro da reavaliação da nota crítica `12 — Avaliação Crítica`, consolidando o foco Codex-first com Claude Code quase igualmente importante. |
| 06/05/2026 — | Claude | `x/wsd/ROADMAP.md`, `x/wsd/+specs/` | Planejamento completo da v0.1.4-alpha: integração TLC (34 tasks), convenção +specs/+logs, STATE.md, HANDOFF.md, WHEN/THEN/SHALL, TESTING.md tiered, 3 novos comandos, Regras 11+12 da Constituição. |
| 06/05/2026 — | Claude | `x/wsd/ROADMAP.md` | Marcação da v0.1.4-alpha como concluída (34 tasks executadas) e absorção do módulo `git-governance` via Conventional Commits. JSON Schema diferido para v0.1.5-alpha. |
| 07/05/2026 — | Claude | `x/wsd/ROADMAP.md` | Marcação da v0.1.5-alpha como concluída — JSON Schema canônico para `+context.json` em `schemas/context.schema.json` + validador zero-deps `wsd-validate-context.js`. Fase 1 completa. |
| 07/05/2026 — | Claude | `x/wsd/ROADMAP.md` | Marcação da v0.1.6-alpha como concluída — ghost spec detector + git hooks no bootstrap. Fase 3 fechada. Consolidação de todos os itens planejados (docs/12, docs/11, STATE.md) em lista única. |
| 07/05/2026 — | Claude | `x/wsd/ROADMAP.md` | Marcação da v0.1.7-alpha como concluída — HANDOFF.md automático + prompts interativos de STATE.md no `wsd finish`. Último item da Fase 3 fechado. |
| 07/05/2026 — | Claude | `x/wsd/ROADMAP.md` | Marcação da v0.1.8-alpha como concluída — instalação interativa rica, `wsd update` real, WHEN+THEN+SHALL completos. |
| 07/05/2026 — | Codex | `x/wsd/ROADMAP.md` | Marcação da v0.1.9-alpha como concluída — saneamento documental operacional e classificação de `wsd_philo/` como histórico/pesquisa. |
| 07/05/2026 — | Codex | `x/wsd/ROADMAP.md` | Planejamento da v0.1.10-alpha como última alpha funcional antes da estabilização: MVP Git/GitHub Governance. |
| 07/05/2026 — | Codex | `x/wsd/ROADMAP.md` | Marcação da v0.1.10-alpha como concluída — MVP Git/GitHub Governance implementado e Fase 4 liberada como próxima frente. |
| 07/05/2026 — | Claude | `x/wsd/ROADMAP.md` | Marcação da v0.1.11-alpha como concluída — Party Mode Integration entregue (T1–T6). Fase 3.5 fechada; Fase 4 (estabilização `v0.1.0`) é a próxima frente. 7/7 testes PASS. |
| 07/05/2026 — | Claude | `x/wsd/ROADMAP.md` | Fechamento dos 2 itens em aberto da Fase 3: perfis para outros stacks (descartado por redundância com instalação interativa) e validação YAML formal (descartado por obsolescência — formato `.spec.yaml.template` é legado). Fase 3 fechada 100%. |
| 07/05/2026 — | Claude | `x/wsd/ROADMAP.md` | Release **`v0.1.0`** estável: Fase 4 100% fechada — bump v0.1.0, README "Uso Oficial", tags retroativas + tag final, compatibilidade Codex/Claude Code validada. Modo manutenção estável. |
| 12/05/2026 — | Claude (Opus 4.7) | `+Apps/WSD/ROADMAP.md` | Consolidação da `v0.1.4` (hotfix WSD-001 + sync wsdd + governance v0.1.3) e adição de `v0.2.0` como próximo marco estável adotável conforme `REVIEW_PRE_V1.md`. |
| 13/05/2026 — | Claude (Opus 4.7) | `+Apps/WSD/ROADMAP.md` | Consolidação da `v0.2.0` (minor "estável adotável") — 8 features + UX polish entregues; D-001/D-002 resolvidas. Adição de `v0.2.1`/`v0.3.0` como próximas frentes (WSD-004 L2, WSD-005, WSD-008, WSD-012). |
| 13/05/2026 — | Claude (Opus 4.7) | `+Apps/WSD/ROADMAP.md` | Consolidação da `v0.2.1` (patch cosmético) — mensagem "Refreshed" do `wsd update` agora dinâmica via `config.modules`. Próxima frente fica `v0.2.x`/`v0.3.0`. |
| 13/05/2026 — | Claude (Opus 4.7) | `+Apps/wsd/ROADMAP.md` | Consolidação da `v0.3.0` (minor — reforço do contrato operacional): `wsd_check.sh` reescrito (6 notas obrigatórias), `+context.json` com blocos formais (`environment`/`repository`/`permissions`/`workflow` + `clone_policy`), artefatos `+specs/project/` preenchidos, snapshot CJS expandido, `REVIEW_PRE_V1.md` + `docs/18` manual leigo. Próxima frente passa a `v0.3.x`/`v0.4.0` (WSD-004 L2, WSD-005, WSD-012). |

[[#📑 Índice|⬆️ Voltar ao Índice]]
