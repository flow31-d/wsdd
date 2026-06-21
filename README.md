---
title: "WSD — Wolff Spec Driven"
created: 05/05/2026
modified: 15/06/2026
tags:
  - x
  - wsd
  - sdd
  - agentes
  - git
status: ativo
tipo: hub
parent: "[[x]]"
links: "[[wsd/wsd]], [[wsd/docs/00_planejamento_instalacao_wsd]], [[wsd/docs/01_constituicao]], [[wsd/docs/04_playbook_implantacao]], [[wsd/docs/06_personalizacao_por_projeto]], [[wsd/docs/10_matriz_sincronizacao_notas]]"
otimizado_para_obsidian: true
---
# WSD — Wolff Spec Driven

[[x|← x — Interface IA]]

---

> [!abstract] Visão Geral
> WSD é um kit pessoal de Spec Driven Development para agentes de código. Ele separa política global, contrato por repositório, specs por tarefa, rotinas de sessão, validação e governança Git.

WSD existe para transformar repositórios privados em ambientes previsíveis para agentes CLI. O objetivo não é criar burocracia; é impedir que agentes editem código sem saber onde estão, qual risco assumem, quais paths podem tocar, como validar e como deixar rastreabilidade. O WSD é otimizado para ser visualizado no Obsidian.


> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. Ideia Central]]
3. [[#3. Estrutura do Pacote]]
4. [[#4. Uso Oficial]]
5. [[#5. Princípios]]
6. [[#6. Status]]
7. [[#7. Fases de Consolidação]]
8. [[#8. Foco Atual]]
9. [[#9. Instalação Local]]
10. [[#10. Sincronização Obrigatória de Notas]]
11. [[#11. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 05/05/2026 13:29:54 -03 — Codex: Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes.
- 05/05/2026 13:41:50 -03 — Codex: Marcação da versão `v0.1.0-alpha`, registro das fases de consolidação e definição de foco inicial em Codex.
- 05/05/2026 13:57:20 -03 — Codex: Registro do instalador alpha local `wsd-method install`, `+wsd/bin/wsd` e instalação de skills Codex locais.
- 05/05/2026 14:13:39 -03 — Codex: Alinhamento do README à versão `v0.1.2-alpha`, priorização do instalador local e inclusão da matriz obrigatória de sincronização documental.
- 06/05/2026 11:38:28 -03 — Codex: Inclusão das pastas auxiliares `+imbox/` como inbox de notas e `wsd_philo/` como base filosófica do SDD.
- 06/05/2026 11:52:30 -03 — Codex: Registro da nota `13 — Compatibilidade WSD com Claude Code` como referência de apoio para a evolução do método.
- 06/05/2026 — Claude: Atualização para `v0.1.3-alpha` — suporte Claude Code operacional, templates `claude-commands/`, hooks e documentação.
- 06/05/2026 — Claude: Atualização para `v0.1.4-alpha` — integração TLC: `+specs/` expandido, 4 fases (Specify/Design/Tasks/Execute), auto-sizing por risco, STATE.md/HANDOFF.md, WHEN/THEN/SHALL, TESTING.md tiered, Knowledge Chain (R11), Scope Guardrail (R12), Conventional Commits 1.0.0, flag `--brownfield`.
- 07/05/2026 — Claude: Atualização para `v0.1.5-alpha` — JSON Schema 2020-12 canônico em `schemas/context.schema.json` + validador pure-JS zero-deps `wsd-validate-context.js` vendorizado em `+wsd/bin/`. `wsd_check.sh` agora valida `+context.json` contra o schema.
- 07/05/2026 — Claude: Atualização para `v0.1.6-alpha` — ghost spec detector em `wsd_check.sh` (WHEN/THEN/SHALL gate) e git hooks no bootstrap (`pre-commit`, `commit-msg`, `pre-push`). Subcomando `wsd hooks` para reinstalar após clone. Fecha a Fase 3.
- 07/05/2026 — Claude: Atualização para `v0.1.7-alpha` — HANDOFF.md gerado automaticamente por `wsd finish` + prompts interativos para STATE.md. Fecha o último item da Fase 3.
- 07/05/2026 — Claude: Atualização para `v0.1.8-alpha` — instalação interativa rica (linguagem, path, test/build/lint, forbidden_paths), `wsd update` real, WHEN+THEN+SHALL completos em ghost spec e L1/L2.
- 07/05/2026 — Codex: Atualização para `v0.1.9-alpha` — saneamento documental operacional em `docs/00` e `docs/12`; `wsd_philo/` mantido como referência histórica/pesquisa.
- 07/05/2026 — Codex: Planejamento da próxima frente `v0.1.10-alpha` — MVP Git/GitHub Governance antes da estabilização `v0.1.0`.
- 07/05/2026 — Codex: Atualização para `v0.1.10-alpha` — MVP Git/GitHub Governance implementado com `--git-policy none|basic|full`, `wsd git doctor|preflight|pr-check`, templates PR/Issue e bloco `git_governance`.
- 07/05/2026 — Claude: Atualização para `v0.1.11-alpha` — Party Mode Integration: `/wsd-party-mode`, `wsd party`, `installPartyMode`, seção AGENTS.md, 7/7 testes PASS.
- 07/05/2026 — Claude: Release **`v0.1.0`** estável — Fase 4 concluída. Drop do sufixo `-alpha`: API estável após 11 iterações alpha + piloto operacional brownfield + 2 itens descartados com rationale (perfis stacks, YAML schema). Adicionada seção "Uso Oficial" como entry point recomendado.
- 11/05/2026 — Claude: Atualização para **`v0.1.2`** — artefatos `ROADMAP.md`, `IDEAS.md` e `IDEAS_PIPELINE.md` instalados automaticamente em todo projeto; skill `/idea-{PROJECT_SLUG}` com captura estruturada, estimativa L0/L1/L2 e oferta de Party Mode; variável `PROJECT_SLUG` derivada no install; estratégia `npx github:flow31-d/wsdd install` documentada em `docs/15`; seção dogfooding em "Estrutura do Pacote" explicando separação toolkit × gestão própria.
- 30/05/2026 18:15:09 -03 — Codex: Atualização para `v0.3.1` com subcomando `./+wsd/bin/wsd version`, inventário multi-repo e documentação de rastreamento da versão WSD instalada por projeto.
- 15/06/2026 — Codex: Atualização para `v0.4.0` com `./+wsd/bin/wsd loop`, contrato `automation.loop`, prompts vendorizados, `WSD Codex Bootstrap`, `wsd codex-prompt`/`wsd codex` e nota `docs/19` para automação inteligente.
- 17/06/2026 — Codex: Atualização para `v0.4.1` com atalhos WSD Loop para agentes: skills Codex em `.agents/skills/`, `/loop` no Claude Code, prompt opcional `/prompts:loop` e comandos `codex-shortcuts`/`shortcuts`.
- 21/06/2026 — Codex: Atualização para `v0.4.2` com `CONCERNS_PIPELINE.md`, skill `wsd-concern`, comando `/concern-{PROJECT_SLUG}`, bootstrap obrigatório de concerns e snapshot com resumo de preocupações ativas.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. Ideia Central

```text
WSD global = método comum
WSD template = arquivos copiáveis
WSD adapter = personalização por repositório
WSD session = rotina de início, execução e encerramento
```

Cada repositório que adotar WSD deve receber um pacote local com:

```text
+wsd/
AGENTS.md
CLAUDE.md
+context.json
+specs/project/PROJECT.md
+specs/project/STATE.md
+specs/project/ROADMAP.md
+specs/project/IDEAS.md
+specs/project/IDEAS_PIPELINE.md
+specs/features/<slug>/spec.md (com WHEN/THEN/SHALL)
+specs/codebase/*.md (somente com --brownfield)
+logs/
scripts/wsd_check.sh
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. Estrutura do Pacote

```text
wsd/
├── README.md
├── wsd.md
├── ROADMAP.md
├── CHANGELOG.md
├── AGENTS.md
├── package.json
├── install.sh
├── bin/
│   └── wsd-method.js
├── docs/
├── +imbox/
├── wsd_philo/
├── templates/
│   ├── repo/
│   ├── specs/
│   ├── local-wsd/
│   ├── codex-skills/
│   ├── claude-commands/
│   └── modules/
├── profiles/
├── scripts/
└── examples/
```

Pastas auxiliares do repositório:

- `+imbox/`: inbox local para notas novas ou ainda não categorizadas; depois de uma análise mais profunda, elas podem ser movidas para a pasta definitiva correta.
- `wsd_philo/`: base filosófica e de pesquisa do SDD/WSD; serve como referência conceitual e não como contrato operacional do instalador.

> [!note] Dogfooding — WSD gerencia o próprio WSD
> O repositório WSD usa WSD para gerir seu próprio desenvolvimento. Por isso existem `+specs/`, `ROADMAP.md` e `STATE.md` na raiz — são artefatos de gestão *do toolkit*, não templates. O que chega em projetos novos via install é exclusivamente o que está em `templates/repo/`. Os arquivos de gestão do WSD em si nunca são copiados para o projeto alvo.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. Uso Oficial

WSD `v0.1.0` é a primeira release estável. Fluxo recomendado para qualquer projeto novo ou brownfield:

### 4.1 Greenfield (projeto novo)

```bash
bash install.sh \
  --directory /path/to/project \
  --tools both \
  --git-policy basic \
  --github skip \
  --yes
```

### 4.2 Brownfield (código existente)

```bash
bash install.sh \
  --directory /path/to/project \
  --tools both \
  --git-policy full \
  --github existing \
  --brownfield \
  --yes
```

`--brownfield` gera `+specs/codebase/` com 7 docs (STACK, ARCHITECTURE, CONVENTIONS, STRUCTURE, INTEGRATIONS, CONCERNS, TESTING) que o agente preenche após o install lendo o código real.

### 4.3 Ciclo de sessão

Dentro do projeto após o install, rotina diária:

```bash
./+wsd/bin/wsd doctor      # verifica saúde (uma vez)
./+wsd/bin/wsd version     # mostra versão WSD instalada e status frente à fonte
./+wsd/bin/wsd start       # abre sessão
./+wsd/bin/wsd codex-prompt --task "minha tarefa"  # gera prompt WSDD curto para Codex
# ... trabalho do agente: /wsd-specify, /wsd-design, /wsd-tasks, /wsd-party-mode ...
./+wsd/bin/wsd loop auto status  # mostra se Ralph/WSD Loop está em auto-use
./+wsd/bin/wsd codex-shortcuts status  # mostra atalhos Codex opcionais
./+wsd/bin/wsd shortcuts status  # mostra atalhos de terminal
./+wsd/bin/wsd loop plan --feature minha-feature  # prepara automação L0/L1
./+wsd/bin/wsd check       # valida gates antes do commit
./+wsd/bin/wsd finish      # fecha sessão (gera HANDOFF.md, atualiza STATE.md)
```

### 4.4 Comandos disponíveis após o install

- **Codex** (`--tools codex`): 9 skills em `.agents/skills/` — `wsd`, `wsd-start`, `wsd-finish`, `wsd-specify`, `wsd-design`, `wsd-tasks`, `wsd-idea`, `wsd-concern`, `wsd-loop`. O instalador também espelha em `.codex/skills/` para compatibilidade. O `AGENTS.md` gerado inclui `WSD Codex Bootstrap`, então abrir o Codex na pasta já deve ativar as regras WSDD.
- **Claude Code** (`--tools claude-code`): 9 slash commands em `.claude/commands/` — `loop`, `wsd-start`, `wsd-finish`, `wsd-specify`, `wsd-design`, `wsd-tasks`, `wsd-party-mode`, `idea-{PROJECT_SLUG}`, `concern-{PROJECT_SLUG}`. Use `/loop status`, `/loop on` e `/loop off` para o Ralph/WSD Loop; use `/concern-{PROJECT_SLUG}` para registrar preocupações. Hooks `PreToolUse|PreCompact|SessionStart|Stop` configurados em `.claude/settings.json`.
- **CLI vendorizado** (`./+wsd/bin/wsd`): `start`, `start --brief`, `check`, `finish`, `doctor`, `version`, `update`, `hooks`, `snapshot`, `lovable`, `git doctor|preflight|pr-check`, `party status|list-agents|when-to-use`, `loop plan|once|run|status|stop`, `codex-prompt`, `codex`, `codex-shortcuts`, `shortcuts`.

### 4.5 Política Git

- `--git-policy none`: sem governança Git extra (default mínimo).
- `--git-policy basic`: pre-commit/commit-msg/pre-push hooks + Conventional Commits 1.0.0 obrigatório.
- `--git-policy full`: tudo do `basic` + templates `.github/PULL_REQUEST_TEMPLATE.md` e `ISSUE_TEMPLATE/{task,bug,decision}.md`, `wsd git pr-check` validando branch/commits/PR.

### 4.6 Validação contínua

Após qualquer mudança em código WSD:

```bash
npm test                              # 13 gates de instalação
bash scripts/wsd_docs_check.sh        # sincronização documental
bash scripts/wsd_self_check.sh        # consistência interna
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. Princípios

- Intenção antes de edição.
- Risco define rigor.
- Git registra histórico; spec registra contrato.
- Agente não inventa validação.
- Agente não esconde worktree suja.
- Segredo nunca entra em Git, spec, prompt, log ou Obsidian.
- Produção exige regra explícita, rollback e decisão humana.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. Status

Este diretório está publicado como repositório GitHub público em versão **`v0.4.2`** (patch — pipeline de concerns e aderência de registro de preocupações). A série alpha (`v0.1.0-alpha` → `v0.1.11-alpha`) está consolidada na `v0.1.0` estável; `v0.1.1` a `v0.1.4` são patches pós-release; `v0.2.0` agrupa as 8 features do batch pré-v1; `v0.3.0` endurece o contrato operacional; `v0.3.1` adiciona inventário de versão; `v0.3.2`/`v0.3.3` carimbam versão no snapshot; `v0.4.0` adiciona `./+wsd/bin/wsd loop`; `v0.4.1` adiciona shortcuts Codex/Claude/shell; `v0.4.2` adiciona `CONCERNS_PIPELINE.md` e comandos/skills de concerns.

Histórico de entregas (alpha + estável):

- `v0.1.0-alpha`: documentação, templates, perfis, exemplos e primeira publicação privada.
- `v0.1.1-alpha`: instalador local, CLI `wsd-method`, `+wsd/bin/wsd` e skills Codex locais.
- `v0.1.2-alpha`: sincronização obrigatória de notas, checker documental e correção do teste de instalação.
- `v0.1.3-alpha`: suporte operacional ao Claude Code — `--tools claude-code`, comandos slash, hooks e settings.
- `v0.1.4-alpha`: integração TLC Spec-Driven — auto-sizing L0/L1/L2, 4 fases (Specify/Design/Tasks/Execute), STATE.md/HANDOFF.md, WHEN/THEN/SHALL, TESTING.md tiered (Quick/Full/Build), Knowledge Chain (Regra 11), Scope Guardrail (Regra 12), Conventional Commits 1.0.0, flag `--brownfield` e novos comandos `/wsd-specify`, `/wsd-design`, `/wsd-tasks`.
- `v0.1.5-alpha`: JSON Schema 2020-12 para `+context.json` em `schemas/context.schema.json` + validador pure-JS zero-deps `wsd-validate-context.js` vendorizado no install. `wsd_check.sh` valida o contrato runtime e falha cedo em campo faltante, tipo errado ou enum inválido.
- `v0.1.6-alpha`: ghost spec detector em `wsd_check.sh` (specs `approved`/`implemented` sem WHEN/THEN/SHALL bloqueadas em L1/L2) + git hooks no bootstrap (`pre-commit`, `commit-msg`, `pre-push`) instalados pelo `wsd-method install`. Subcomando `wsd hooks` para reinstalar após clone. Flag `--no-git-hooks` para opt-out.
- `v0.1.7-alpha`: `wsd finish` automatizado — gera `+specs/HANDOFF.md` (branch, último commit, últimos 5 commits, arquivos uncommitted, specs abertas) + prompts interativos para STATE.md (lições aprendidas, decisões, bloqueadores). Fecha o último item da Fase 3.
- `v0.1.8-alpha`: instalação interativa rica (linguagem principal, path canônico, test/build/lint commands, forbidden_paths), `wsd update` real (atualiza `+wsd/` sem tocar em arquivos do projeto), WHEN+THEN+SHALL completos obrigatórios em ghost spec scan e L1/L2.
- `v0.1.9-alpha`: saneamento documental operacional — checklists de `docs/00` e `docs/12` alinhados ao estado real, `wsd_philo/` classificado como referência histórica/pesquisa e não fonte de gate.
- `v0.1.10-alpha`: MVP Git/GitHub Governance — `--git-policy none|basic|full`, bloco `git_governance` no `+context.json`, seção Git/GitHub no `AGENTS.md`, comandos `./+wsd/bin/wsd git doctor|preflight|pr-check`, templates `.github/` no modo `full` e testes de instalação para os três modos.
- `v0.1.11-alpha`: Party Mode Integration — sistema de 26 agentes WSD-aware instalado em `+wsd/party-mode/`, comando Claude Code `/wsd-party-mode`, subcomando `wsd party status|list-agents|when-to-use`, seção Party Mode no AGENTS.md e 7 gates de instalação no `npm test`.
- **`v0.1.0`** (release estável): consolida toda a série alpha em API estável. Fase 4 fechada: documentação oficial (seção "Uso Oficial"), tags retroativas v0.1.10/v0.1.11, validação completa Codex e Claude Code (7/7 testes PASS), 2 itens descartados com rationale (perfis stacks, YAML schema). Sem mudanças de API; mantém compatibilidade com instalações alpha tardias.
- **`v0.1.2`**: ROADMAP.md, IDEAS.md e IDEAS_PIPELINE.md instalados automaticamente em todo projeto via `renderRepoTemplates()`. Skill `/idea-{PROJECT_SLUG}` (Claude Code e Codex) com captura estruturada L0/L1/L2 e oferta de Party Mode. Variável `PROJECT_SLUG` derivada no install + rename dinâmico do comando idea. Repositório público `wsdd` criado.
- **`v0.1.3`**: renomeação de `wsd-validate-context.js` e `wsd-snapshot.js` para `.cjs` (compatibilidade com projetos `"type": "module"`). Adição de `RELEASING.md` (checklist obrigatório pré-release), spec retroativa `project-snapshot`, `docs/05` expandido com seções `+specs/project/` e vendor tree `+wsd/`. Sync `wsdd` público atualizado para v0.1.3.
- **`v0.1.4`** (hotfix): fix do WSD-001 — três templates (`ROADMAP.md.template`, `IDEAS.md.template`, `IDEAS_PIPELINE.md.template`) que existiam apenas no WSD privado agora estão também no `wsdd` público. Inclui sync completo dos 6 commits pendentes pós-v0.1.3 e fechamento de gaps de governance do release v0.1.3 (linha de status do README + tag git retroativa). Refs: Issue #10.
- **`v0.2.0`** (minor "estável adotável"): primeiro minor pós-`v0.1.0`. Agrupa 8 features do batch pré-v1 + UX polish: `CONCERNS.md` como nota padrão (WSD-010); renderização condicional `{{#if}}` em templates (WSD-002); `scripts/wsd_release.sh` automatizando release end-to-end (WSD-009); install com opt-out interativo de módulos opcionais `docs/`/`party-mode/`/`examples/` resolvendo D-001 Opção B+ (WSD-007); `wsd check` L0+L1 robusto valida 6 notas de project/ e coerência ROADMAP↔spec (WSD-004); CI no `wsdd` rodando 9 gates em cada push (WSD-003); Obsidian declarado como pré-requisito recomendado resolvendo D-002 Opção A (WSD-006); fix raiz de `ENOENT` em loops de cópia (WSD-013); UX polish do install interativo (header Enter=default + brownfield como prompt). 9/9 npm test + 27/27 cenários e2e + piloto operacional no `flow31-d/worc`.
- **`v0.2.1`** (patch cosmético): mensagem "Refreshed" do `wsd update` agora construída dinamicamente a partir de `config.modules`, refletindo módulos efetivamente copiados. Antes a string era hardcoded e conflitava com mensagens `info: skipping ...` impressas na mesma execução. Detectado durante validação do piloto worc logo após v0.2.0. Sem mudança de comportamento.
- **`v0.3.0`** (minor — reforço do contrato operacional): `scripts/wsd_check.sh` reescrito (185 linhas) validando as 6 notas obrigatórias de `+specs/project/` como L0-required (PROJECT/STATE/ROADMAP/IDEAS/IDEAS_PIPELINE/CONCERNS) — antes só `STATE.md` era checada, o que permitiu WSD-001 escapar. `+context.json` ganha blocos formais `environment`, `repository` (com `clone_policy` canônico: canonical_history/operational_clone/audit_lab_clone/deploy_clone/promotion_flow), `permissions` (write/forbidden paths, tool_allowlist, secrets_policy, limites de runtime/tokens) e `workflow` (approval_mode, branch_policy, incident_mode, issue_policy, production_mutation_policy). Artefatos `+specs/project/` (PROJECT, ROADMAP, IDEAS, IDEAS_PIPELINE, CONCERNS) preenchidos com conteúdo real do WSD em vez de placeholders. `templates/local-wsd/bin/wsd-snapshot.cjs` propaga os novos campos. `docs/05_contrato_artefatos.md` e `docs/17_snapshot_campos_explicados.md` atualizados. Inclui `REVIEW_PRE_V1.md` (1131 linhas, tracker formal de revisão pré-v1) e `docs/18_manual_leigo_comandos_wsdd.md` (568 linhas, manual leigo dos comandos `wsdd` para operadores não-técnicos). Path rename `+Apps/WSD` → `+Apps/wsd` consolidado (PR #33). 9/9 npm test PASS.
- **`v0.3.1`** (patch — inventário de versão): adiciona `./+wsd/bin/wsd version` no CLI vendorizado. Sem flags, mostra a versão WSD instalada no projeto atual, `installed_at`, fonte (`wsd_source`), versão da fonte e status (`aligned`, `behind-source`, `ahead-of-source`, `source-unknown`). Com `--inventory --path <dir>`, varre múltiplos projetos com `+wsd/config.json`; com `--json`, produz saída consumível por automações.
- **`v0.3.2`** (patch — versão no snapshot): `templates/local-wsd/bin/wsd-snapshot.cjs` carimba `wsd_version` (lido do `+wsd/config.json`) em cada `+wsd/snapshot.json`. Habilita detecção passiva de deriva de versão por consumidores que já leem snapshots (ex.: Zelador), sem abrir o `config.json` por repo. Complementa o `wsd version` ativo da v0.3.1; snapshots sem o campo sinalizam gerador antigo.
- **`v0.3.3`** (patch — publicação pública): leva ao `wsdd` público a feature de `wsd_version` no snapshot (introduzida no privado em `v0.3.2`). Como o público estava em `v0.3.1`, esta release entrega o carimbo de versão e a detecção passiva de deriva ao repositório público.
- **`v0.4.0`** (minor — WSD Loop + Codex Adherence Pack): adiciona `automation.loop` ao `+context.json`, opção fixa `automation.loop.auto_use` para ligar/desligar uso automático do Ralph/WSD Loop, prompts `+wsd/loop/PROMPT_plan.md` e `PROMPT_build.md`, subcomando `./+wsd/bin/wsd loop plan|once|run|status|stop|auto`, `WSD Codex Bootstrap` no `AGENTS.md`, `./+wsd/bin/wsd start --brief`, `codex-prompt` e `codex`, gates de paths/risco/CI antes de auto-commit e testes `test:install-loop` + `test:install-codex-adherence` no `npm test`.
- **`v0.4.1`** (patch — atalhos de agente): alinha skills Codex ao caminho atual `.agents/skills/` com espelho legado `.codex/skills/`, adiciona skill `wsd-loop`, prompt opcional `/prompts:loop`, comando Claude `/loop`, CLI `codex-shortcuts`/`shortcuts` e reforço do fluxo `wsd-idea`/`IDEAS_PIPELINE`.
- **`v0.4.2`** (patch — pipeline de concerns): adiciona `CONCERNS_PIPELINE.md` como nota obrigatória, reestrutura `CONCERNS.md` com preocupações ativas `CONC-###`, adiciona skill Codex `wsd-concern`, comando Claude `/concern-{PROJECT_SLUG}`, bootstrap obrigatório de concerns, `start --brief` com contagem de concerns e snapshot com resumo de preocupações.

Não contém segredos.

A camada de qualidade da v0.1.4 está detalhada em [[wsd/docs/14_qualidade_desenvolvimento|14 — Qualidade de Desenvolvimento]]. A compatibilidade com Claude Code está em [[wsd/docs/13_compatibilidade_claude_code|13 — Compatibilidade WSD com Claude Code]]. O contrato JSON Schema do `+context.json` (v0.1.5) está documentado em [[wsd/docs/05_contrato_artefatos|05 — Contrato de Artefatos]]. O WSD Loop `v0.4.0` está em [[wsd/docs/19_wsd_loop_automacao_inteligente|19 — WSD Loop: Automação Inteligente]].

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. Fases de Consolidação

1. Aprimorar o WSD — concluído na série `v0.1.x-alpha`.
2. Validar operacionalmente em projeto brownfield real — concluído em 07/05/2026.
3. Ajustar a partir das lições da validação operacional — concluído em 07/05/2026 (incluindo Fase 3.5 Party Mode Integration).
4. Consolidar o repositório final oficial em `v0.1.0` — **concluído em 07/05/2026**.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. Foco Atual

WSD está em desenvolvimento ativo pós-v0.1.0. `v0.2.0` foi o primeiro marco "estável adotável"; `v0.3.0` endureceu o contrato operacional; **`v0.4.x` adiciona WSD Loop, aderência Codex e pipeline de concerns**. Próximas frentes estão em `+specs/project/IDEAS.md`:

- Auto-PR e GitHub Issues para runs aprovados.
- Dashboard de runs e falhas recorrentes.
- Sandbox forte para execução AFK.
- Adapters multi-agente.
- Checkpoints L2 assistidos.

Issues e bugs descobertos em uso real geram patches `v0.1.x`; novas features seguem ciclo planejado com spec aprovada antes de implementação.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 9. Instalação

> [!tip] Pré-requisitos Recomendados
> **Ferramenta recomendada para leitura das notas:** [Obsidian](https://obsidian.md).
>
> O WSD gera notas otimizadas para Obsidian com:
>
> - **Frontmatter YAML** (`tags`, `parent`, `links`, `otimizado_para_obsidian: true`)
> - **Callouts** (`> [!abstract]`, `> [!info]`, `> [!warning]`, `> [!tip]`)
> - **Wikilinks** (`[[wsd/wsd]]`) e links literais de cabeçalho (`[[#📑 Índice|⬆️ Voltar ao Índice]]`)
>
> Sem Obsidian o conteúdo ainda é legível em qualquer editor markdown ou no GitHub web, mas alguns elementos visuais aparecem como texto cru. Para usar o método, **Obsidian não é obrigatório** — apenas recomendado para a melhor experiência de leitura.
>
> Requisitos técnicos do install: **Node.js v20+** (necessário para `bin/wsd-method.js`). Git é detectado e usado se presente, mas não é exigido.

### 9.1 Quick Start (sem clone)

```bash
npx github:flow31-d/wsdd install \
  --directory /path/to/project \
  --tools claude-code \
  --git-policy basic \
  --yes
```

Requer Node.js v20+. Sem `npm publish` — usa o repositório GitHub diretamente.

### 9.2 Uso a partir do clone local

```bash
node bin/wsd-method.js install \
  --directory /path/to/project \
  --profile generic_node_frontend \
  --tools codex \
  --github skip \
  --yes
```

Uso pelo wrapper local:

```bash
bash install.sh --directory /path/to/project --tools codex --github skip --yes
```

Para projetos reais que valorizam PR/Issue no GitHub:

```bash
bash install.sh \
  --directory /path/to/project \
  --tools codex \
  --github existing \
  --git-policy full \
  --yes
```

Após instalar no projeto:

```bash
./+wsd/bin/wsd doctor
./+wsd/bin/wsd version
./+wsd/bin/wsd check
./+wsd/bin/wsd start
./+wsd/bin/wsd loop auto status
./+wsd/bin/wsd loop auto on
./+wsd/bin/wsd loop auto off
./+wsd/bin/wsd codex-prompt --task "minha tarefa"
./+wsd/bin/wsd codex-shortcuts status
./+wsd/bin/wsd shortcuts status
./+wsd/bin/wsd loop status
./+wsd/bin/wsd finish
```

Para Codex (`--tools codex`): cria 9 skills em `.agents/skills/` (`wsd`, `wsd-start`, `wsd-finish`, `wsd-specify`, `wsd-design`, `wsd-tasks`, `wsd-idea`, `wsd-concern`, `wsd-loop`) e espelha em `.codex/skills/` para compatibilidade. O `AGENTS.md` gerado inclui bootstrap automático. Para atalhos de TUI opcionais, rode `./+wsd/bin/wsd codex-shortcuts install` uma vez e use `/prompts:loop status`; para linguagem natural, peça `loop status`, `loop auto on`, `loop auto off` ou "registre esta preocupação".

Para Claude Code (`--tools claude-code`): cria 9 comandos slash em `.claude/commands/`: `loop`, `wsd-start`, `wsd-finish`, `wsd-specify`, `wsd-design`, `wsd-tasks`, `wsd-party-mode`, `idea-{PROJECT_SLUG}`, `concern-{PROJECT_SLUG}`. Use `/loop status` para consultar, `/loop on` para ligar `automation.loop.auto_use`, `/loop off` para desligar e `/concern-{PROJECT_SLUG}` para registrar preocupações. Também `.claude/settings.json` com hooks `PreToolUse`/`PreCompact`/`SessionStart`/`Stop` e `+wsd/hooks/pre-tool.sh`.

Para ambos: `--tools both` gera os dois conjuntos sem conflito.

Para projetos legados, adicionar `--brownfield`: gera `+specs/codebase/` com 7 docs (STACK, ARCHITECTURE, CONVENTIONS, STRUCTURE, INTEGRATIONS, CONCERNS, TESTING) que devem ser preenchidos pelo agente após o install.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 10. Sincronização Obrigatória de Notas

Antes de finalizar mudanças no WSD, todo agente deve abrir [[wsd/docs/10_matriz_sincronizacao_notas|10 — Matriz de Sincronização de Notas WSD]].

Regra prática:

- mudou versão ou release: atualizar `package.json`, README, CHANGELOG, ROADMAP e docs/09;
- mudou instalador ou CLI: atualizar README, docs/00, docs/04, docs/08 e CHANGELOG;
- mudou regra para agentes: atualizar AGENTS, docs/01 ou docs/03 quando aplicável, docs/07, templates de agentes e skills;
- mudou template ou profile: atualizar docs/05 ou docs/06 e exemplos relacionados;
- rodar `bash scripts/wsd_docs_check.sh` e `bash scripts/wsd_self_check.sh`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 11. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 05/05/2026 13:29:54 -03 | Codex | `x/wsd/README.md` | Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes. |
| 05/05/2026 13:41:50 -03 | Codex | `x/wsd/README.md` | Marcação da versão `v0.1.0-alpha`, registro das fases de consolidação e definição de foco inicial em Codex. |
| 05/05/2026 13:57:20 -03 | Codex | `x/wsd/README.md` | Registro do instalador alpha local `wsd-method install`, `+wsd/bin/wsd` e instalação de skills Codex locais. |
| 05/05/2026 14:13:39 -03 | Codex | `x/wsd/README.md` | Alinhamento do README à versão `v0.1.2-alpha`, priorização do instalador local e inclusão da matriz obrigatória de sincronização documental. |
| 06/05/2026 — | Claude | `x/wsd/README.md` | Atualização para `v0.1.3-alpha`: seções de status, foco atual, instalação e estrutura de pacote refletindo suporte Claude Code. |
| 06/05/2026 — | Claude | `x/wsd/README.md` | Atualização para `v0.1.4-alpha`: TLC integration — `+specs/` expandido, 4 fases, auto-sizing, STATE.md/HANDOFF.md, WHEN/THEN/SHALL, TESTING.md tiered, Conventional Commits, flag `--brownfield`, 5 comandos por agente, link para doc 14. |
| 07/05/2026 — | Claude | `x/wsd/README.md` | Atualização para `v0.1.5-alpha`: JSON Schema canônico em `schemas/context.schema.json`, validador pure-JS `wsd-validate-context.js`, hook em `wsd_check.sh`. Foco atual reposicionado para Fase 4. |
| 07/05/2026 — | Claude | `x/wsd/README.md` | Atualização para `v0.1.6-alpha`: ghost spec detector em `wsd_check.sh`, git hooks no bootstrap (`pre-commit`, `commit-msg`, `pre-push`), subcomando `wsd hooks`. Fase 3 concluída. |
| 07/05/2026 — | Claude | `x/wsd/README.md` | Atualização para `v0.1.7-alpha`: `wsd finish` automatizado (HANDOFF.md + prompts STATE.md). Último item da Fase 3 fechado. |
| 07/05/2026 — | Claude | `x/wsd/README.md` | Atualização para `v0.1.8-alpha`: instalação interativa rica, `wsd update` real, WHEN+THEN+SHALL completo. |
| 07/05/2026 — | Codex | `x/wsd/README.md` | Atualização para `v0.1.9-alpha`: saneamento documental operacional e classificação de `wsd_philo/` como histórico/pesquisa. |
| 07/05/2026 — | Codex | `x/wsd/README.md` | Planejamento da próxima frente `v0.1.10-alpha`: MVP Git/GitHub Governance antes da estabilização. |
| 07/05/2026 — | Codex | `x/wsd/README.md` | Atualização para `v0.1.10-alpha`: MVP Git/GitHub Governance implementado e Fase 4 reposicionada como próxima frente. |
| 07/05/2026 — | Claude | `x/wsd/README.md` | Atualização para `v0.1.11-alpha`: Party Mode Integration entregue (Fase 3.5). |
| 07/05/2026 — | Claude | `x/wsd/README.md` | Release **`v0.1.0`** estável: drop do sufixo `-alpha`, seção "Uso Oficial" expandida (greenfield/brownfield/ciclo de sessão/comandos/política Git/validação contínua), Fase 4 marcada concluída, foco em manutenção estável. |
| 11/05/2026 — | Claude | `+Apps/WSD/README.md` | Atualização para `v0.1.2`: status atualizado para repo público, novos artefatos (ROADMAP/IDEAS/IDEAS_PIPELINE) na ideia central, comando `idea-{slug}` nas seções 4.4 e 9, callout dogfooding na seção 3, quick start `npx` na seção 9, seção 8 com candidatas pós-v0.1.2. |
| 12/05/2026 — | Claude (Opus 4.7) | `+Apps/WSD/README.md` | Atualização para `v0.1.4` (hotfix): linha 217 corrigida `v0.1.2` → `v0.1.4` (gap do release v0.1.3), nova entrada `v0.1.4` no histórico, Foco Atual menciona `REVIEW_PRE_V1.md` e caminho para `v0.2.0`. |
| 13/05/2026 — | Claude (Opus 4.7) | `+Apps/WSD/README.md` | Atualização para `v0.2.0` (minor "estável adotável"): linha 217 atualizada `v0.1.4` → `v0.2.0`, nova entrada `v0.2.0` no histórico listando as 8 features e UX polish, Foco Atual atualizado para próximas frentes pós-v0.2.0 (WSD-004 L2, WSD-005, WSD-008, WSD-012). |
| 13/05/2026 — | Claude (Opus 4.7) | `+Apps/WSD/README.md` | Atualização para `v0.2.1` (patch cosmético): linha 217 `v0.2.0` → `v0.2.1`, nova entrada `v0.2.1` no histórico explicando o fix da mensagem "Refreshed". |
| 13/05/2026 — | Claude (Opus 4.7) | `+Apps/wsd/README.md` | Atualização para `v0.3.0` (minor — reforço do contrato operacional): linha 217 `v0.2.1` → `v0.3.0` com descrição expandida, nova entrada `v0.3.0` no histórico (checker validando 6 notas, blocos formais no `+context.json`, artefatos `+specs/project/` preenchidos, snapshot CJS expandido, `REVIEW_PRE_V1.md` + `docs/18` manual leigo). Foco Atual atualizado removendo WSD-008 (parcialmente endereçado no tracker). |
| 30/05/2026 18:15:09 -03 | Codex | `+Apps/wsd/README.md` | Atualização para `v0.3.1`: status, histórico, foco atual e comandos pós-install passam a documentar `wsd version` e inventário multi-repo. |
| 15/06/2026 | Codex | `+Apps/wsd/README.md` | Atualização para `v0.4.0`: documentação pública do `wsd loop`, contrato `automation.loop`, Codex Adherence Pack, 13 gates em `npm test` e link para `docs/19`. |
| 17/06/2026 | Codex | `+Apps/wsd/README.md` | Atualização para `v0.4.1`: atalhos WSD Loop para Codex/Claude/shell, `.agents/skills`, `/prompts:loop`, `/loop` e comandos `codex-shortcuts`/`shortcuts`. |
| 21/06/2026 | Codex | `+Apps/wsd/README.md` | Atualização para `v0.4.2`: pipeline de concerns, skill/comando de captura de preocupação, nota obrigatória `CONCERNS_PIPELINE.md` e contagem no snapshot/start brief. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
