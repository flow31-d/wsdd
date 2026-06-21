---
title: "Changelog WSD"
created: 05/05/2026
modified: 15/06/2026
tags:
  - x
  - wsd
  - changelog
status: ativo
tipo: nota
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/README]]"
otimizado_para_obsidian: true
---
# Changelog WSD

[[wsd/wsd|← WSD]]

---


> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. 0.1.0-alpha — 05/05/2026]]
3. [[#3. 0.1.1-alpha — 05/05/2026]]
4. [[#4. 0.1.2-alpha — 05/05/2026]]
5. [[#5. 0.1.3-alpha — 06/05/2026]]
6. [[#6. 0.1.4-alpha — 06/05/2026]]
7. [[#7. 0.1.5-alpha — 07/05/2026]]
8. [[#8. 0.1.6-alpha — 07/05/2026]]
9. [[#9. 0.1.7-alpha — 07/05/2026]]
10. [[#10. 0.1.8-alpha — 07/05/2026]]
11. [[#11. 0.1.9-alpha — 07/05/2026]]
12. [[#12. 0.1.10-alpha — 07/05/2026]]
13. [[#13. 0.1.11-alpha — 07/05/2026]]
14. [[#14. 0.1.0 — 07/05/2026]]
15. [[#15. 0.1.2 — 11/05/2026]]
16. [[#16. 0.1.3 — 11/05/2026]]
17. [[#17. 0.1.4 — 12/05/2026]]
18. [[#18. 0.2.0 — 13/05/2026]]
19. [[#19. 0.2.1 — 13/05/2026]]
20. [[#20. 0.3.0 — 13/05/2026]]
21. [[#21. 0.3.1 — 30/05/2026]]
22. [[#22. 0.3.3 — 13/06/2026]]
23. [[#23. 0.4.0 — 15/06/2026]]
24. [[#24. 0.4.1 — 17/06/2026]]
25. [[#25. 0.4.2 — 21/06/2026]]
26. [[#26. 0.4.3 — 21/06/2026]]
27. [[#27. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 05/05/2026 13:29:54 -03 — Codex: Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes.
- 05/05/2026 13:41:50 -03 — Codex: Registro da versão alpha inicial para publicação em repositório GitHub privado.
- 05/05/2026 13:57:20 -03 — Codex: Inclusão da versão `0.1.1-alpha` com instalador local, CLI de projeto e suporte Codex local.
- 05/05/2026 14:13:39 -03 — Codex: Inclusão da versão `0.1.2-alpha` com matriz de sincronização documental, checker dedicado e correção do teste de instalação.
- 06/05/2026 — Claude: Inclusão da versão `0.1.3-alpha` com suporte operacional completo ao Claude Code.
- 06/05/2026 — Claude: Inclusão da versão `0.1.4-alpha` — integração TLC (auto-sizing, STATE.md, HANDOFF.md, WHEN/THEN/SHALL, TESTING.md tiered, knowledge chain, scope guardrail, Conventional Commits, brownfield support, novos comandos `/wsd-specify`, `/wsd-design`, `/wsd-tasks`).
- 07/05/2026 — Claude: Inclusão da versão `0.1.5-alpha` — JSON Schema 2020-12 canônico para `+context.json` em `schemas/context.schema.json` + validador zero-deps `wsd-validate-context.js` integrado a `wsd_check.sh`. Fecha o último pendente da Fase 1.
- 07/05/2026 — Claude: Inclusão da versão `0.1.6-alpha` — ghost spec detector em `wsd_check.sh` + git hooks no bootstrap (`pre-commit`, `commit-msg`, `pre-push`). Fecha a Fase 3.
- 07/05/2026 — Claude: Inclusão da versão `0.1.7-alpha` — `wsd finish` automatizado: HANDOFF.md gerado pelo CLI + prompts interativos para STATE.md. Fecha o último item da Fase 3.
- 07/05/2026 — Claude: Inclusão da versão `0.1.8-alpha` — instalação interativa rica, `wsd update` real via `wsd_source`, WHEN+THEN+SHALL todos obrigatórios. Seção 10 adicionada, Registro renumerado para seção 11.
- 07/05/2026 — Codex: Inclusão da versão `0.1.9-alpha` — saneamento documental operacional, checklists de `docs/00` e `docs/12` alinhados ao estado real, `wsd_philo/` preservado como histórico/pesquisa. Seção 11 adicionada, Registro renumerado para seção 12.
- 07/05/2026 — Codex: Inclusão da versão `0.1.10-alpha` — MVP Git/GitHub Governance com `--git-policy`, `git_governance`, `wsd git doctor|preflight|pr-check`, templates PR/Issue e testes por modo. Seção 12 adicionada, Registro renumerado para seção 13.
- 07/05/2026 — Claude: Inclusão da versão `0.1.11-alpha` — Party Mode Integration: `installPartyMode`, `/wsd-party-mode`, `wsd party status|list-agents|when-to-use`, seção Party Mode no AGENTS.md, `test:install-party-mode`. Seção 13 adicionada, Registro renumerado para seção 14.
- 07/05/2026 — Claude: Inclusão da release **`0.1.0`** estável — drop do sufixo `-alpha`, Fase 4 fechada (documentação oficial, tags retroativas, validação Codex/Claude Code), 2 itens descartados com rationale (perfis stacks, YAML schema). Seção 14 adicionada, Registro renumerado para seção 15.
- 11/05/2026 — Claude: Inclusão da versão **`0.1.3`** — CJS/ESM fix, governance gaps, project-snapshot spec, RELEASING.md. Seção 16 adicionada, Registro renumerado para seção 17.
- 12/05/2026 — Claude (Opus 4.7): Inclusão da versão **`0.1.4`** (hotfix) — fix WSD-001 (templates faltantes ROADMAP/IDEAS/IDEAS_PIPELINE no wsdd público) + sincronização completa dos 6 commits pendentes pós-v0.1.3 + fechamento dos gaps de governance do release v0.1.3 (README dessincronizado linha 217 + tag retroativa v0.1.3). Seção 17 adicionada, Registro renumerado para seção 18.
- 13/05/2026 — Claude (Opus 4.7): Inclusão da versão **`0.2.0`** (estável adotável) — minor release com 8 features funcionais + UX polish: CONCERNS.md como nota padrão (WSD-010), renderização condicional `{{#if}}` em templates (WSD-002), `scripts/wsd_release.sh` para automação de release (WSD-009), install com opt-out interativo de módulos opcionais (WSD-007 / D-001), `wsd check` L0+L1 robusto (WSD-004), CI no wsdd (WSD-003), Obsidian declarado como pré-requisito (WSD-006 / D-002), fix raiz de ENOENT em loops de cópia (WSD-013), e UX polish do install interativo (brownfield prompt + Enter=default header) baseado em feedback do piloto worc 13/05. Seção 18 adicionada, Registro renumerado para seção 19.
- 13/05/2026 — Claude (Opus 4.7): Inclusão da versão **`0.2.1`** (patch cosmético) — primeiro patch pós-v0.2.0, detectado durante validação do piloto worc com `./+wsd/bin/wsd update`. Lista "Refreshed: +wsd/{...}" do `update` agora reflete dinamicamente os módulos efetivamente copiados (respeita `config.modules`). Antes era string hardcoded `docs,templates,profiles,schemas,scripts,examples,bin` que conflitava com mensagens `info: skipping examples/ (modules.examples=false)`. Sem mudança de comportamento — apenas mensagem. Seção 19 adicionada, Registro renumerado para seção 20.
- 13/05/2026 — Claude (Opus 4.7): Inclusão da versão **`0.3.0`** (minor — reforço do contrato operacional) — `scripts/wsd_check.sh` reescrito (185 linhas) valida as 6 notas obrigatórias de `+specs/project/` (PROJECT/STATE/ROADMAP/IDEAS/IDEAS_PIPELINE/CONCERNS) como L0-required, suporta `--risk` e `--spec` e tem fallback degradado quando Node ausente. `+context.json` ganha blocos formais `environment`, `repository`, `permissions`, `workflow` e `clone_policy` (canonical_history/operational_clone/audit_lab_clone/deploy_clone/promotion_flow). Artefatos `+specs/project/` (PROJECT, ROADMAP, IDEAS, IDEAS_PIPELINE, CONCERNS) preenchidos com conteúdo real do projeto. `templates/local-wsd/bin/wsd-snapshot.cjs` propaga os novos campos. `docs/05_contrato_artefatos.md` e `docs/17_snapshot_campos_explicados.md` atualizados. Inclui `REVIEW_PRE_V1.md` (tracker formal) e `docs/18_manual_leigo_comandos_wsdd.md` (manual leigo). Seção 20 adicionada, Registro renumerado para seção 21.
- 30/05/2026 21:00:00 -03 — Codex: Correção de template para alinhar o check Lovable em projetos novos: inclusão da validação `lovable_integration` no `templates/repo/scripts/wsd_check.sh` (gatilho em `+context.json` exige `package-lock.json` ausente e `bun.lock` presente).
- 30/05/2026 18:15:09 -03 — Codex: Inclusão da versão **`0.3.1`** (patch — inventário de versão WSD por projeto): `templates/local-wsd/bin/wsd` ganha subcomando `version`, inventário multi-repo, saída JSON e comparação com `wsd_source`; `package.json` adiciona gate `test:install-version`. Seção 21 adicionada, Registro renumerado para seção 22.
- 30/05/2026 — Codex: Higiene pós-release `v0.3.1`: quick start atual padronizado para `flow31-d/wsdd`, registro de fechamento público adicionado em `docs/15` e pendências antigas de estabilização `v0.1.0` marcadas como concluídas.
- 13/06/2026 — Claude (Opus 4.8): Inclusão da versão **`0.3.2`** (patch — versão no snapshot): `templates/local-wsd/bin/wsd-snapshot.cjs` passa a carimbar o campo `wsd_version` (lido do `+wsd/config.json`) em cada `+wsd/snapshot.json`. Permite detecção passiva de deriva de versão por consumidores que já leem snapshots (ex.: Zelador), sem abrir o `config.json` por repo. Complementa o subcomando ativo `wsd version` da v0.3.1. Snapshots sem o campo passam a sinalizar gerador antigo.
- 13/06/2026 — Claude (Opus 4.8): Inclusão da versão **`0.3.3`** (patch — publicação pública): leva ao `wsdd` público a feature de `wsd_version` no snapshot (privada na `0.3.2`). Público estava em `0.3.1`; passa a receber o carimbo de versão e a detecção passiva de deriva. Seção 22 adicionada, Registro renumerado para seção 23.
- 15/06/2026 — Codex: Inclusão da versão **`0.4.0`** (minor — WSD Loop + Codex Adherence Pack): `automation.loop`, `automation.loop.auto_use`, prompts vendorizados `+wsd/loop/`, subcomando `wsd loop plan|once|run|status|stop|auto`, `WSD Codex Bootstrap`, `start --brief`, `codex-prompt`, `codex`, gates de paths/risco/CI antes de auto-commit e testes `test:install-loop`/`test:install-codex-adherence`. Seção 23 adicionada, Registro renumerado para seção 24.
- 17/06/2026 — Codex: Inclusão da versão **`0.4.1`** (patch — atalhos de agente): skills Codex no caminho atual `.agents/skills/` com espelho `.codex/skills/`, skill `wsd-loop`, prompt opcional `/prompts:loop`, comando Claude `/loop`, CLI `codex-shortcuts`/`shortcuts` e gates cobrindo a ergonomia de WSD Loop. Seção 24 adicionada, Registro renumerado para seção 25.
- 21/06/2026 — Codex: Inclusão da versão **`0.4.2`** (patch — pipeline de concerns): `CONCERNS_PIPELINE.md`, concerns ativas `CONC-###`, skill `wsd-concern`, comando Claude `/concern-{PROJECT_SLUG}`, bootstrap obrigatório de concerns, `start --brief` e snapshot com resumo de preocupações. Seção 25 adicionada, Registro renumerado para seção 26.
- 21/06/2026 — Codex: Inclusão da versão **`0.4.3`** (patch — finish limpo): `wsd finish` passa a rodar gates, docs audit quando disponível, HANDOFF.md, snapshot, commit automático e verificação final de worktree limpa. Seção 26 adicionada, Registro renumerado para seção 27.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. 0.1.0-alpha — 05/05/2026

Criação inicial do pacote WSD.

Inclui:

- documentação metodológica;
- templates de repositório;
- templates de specs;
- perfis iniciais;
- scripts de bootstrap e validação;
- modelos de skills Codex;
- exemplos para Prescreve Mais e Koomplet Office.

Status:

- versão alpha documental e operacional inicial;
- otimização prioritária para Codex;
- Claude Code planejado para fase posterior;
- instalador interativo ainda não implementado.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. 0.1.1-alpha — 05/05/2026

Implementação inicial da fase 1 focada em Codex.

Inclui:

- `package.json` com binário `wsd-method`;
- `bin/wsd-method.js` com `install`, `doctor`, `help`, `update` e `--list-options`;
- `install.sh` como wrapper local;
- instalação vendorizada em `+wsd/`;
- `+wsd/bin/wsd` com `start`, `check`, `finish`, `doctor` e `update`;
- renderização automática de templates por perfil e overrides `--set`;
- instalação local de skills Codex em `.codex/skills`;
- teste de instalação em repositório temporário.

Ainda pendente:

- prompts interativos mais ricos;
- JSON Schema formal;
- validação YAML formal;
- Claude Code;
- teste no `koomplet-office`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. 0.1.2-alpha — 05/05/2026

Alinhamento documental e proteção contra divergência entre notas centrais.

Inclui:

- `docs/10_matriz_sincronizacao_notas.md` como fonte de verdade para saber quais notas e arquivos devem mudar juntos;
- `scripts/wsd_docs_check.sh` para validar versão, links de skills, README, hub, roadmap e docs operacionais;
- chamada do docs-check dentro de `scripts/wsd_self_check.sh`;
- correção de `npm run test:install`, que estava incompleto por terminar em `--directory` sem valor;
- atualização de README, hub, roadmap, AGENTS, playbook, rotinas de sessão e publicação GitHub para a versão `v0.1.3-alpha`.

Ainda pendente:

- JSON Schema formal para `+context.json`;
- validação YAML formal para specs;
- piloto no `koomplet-office`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. 0.1.3-alpha — 06/05/2026

Suporte operacional ao Claude Code.

Inclui:

- `templates/claude-commands/commands/wsd-start.md` e `wsd-finish.md` — comandos slash Claude Code com `allowed-tools`, `argument-hint` e triggers em português;
- `templates/claude-commands/hooks/pre-tool.sh` — hook `PreToolUse` que lê `forbidden_paths` do `+context.json` e bloqueia com exit 2;
- `templates/claude-commands/settings.json` — configuração de hooks `PreToolUse`, `PreCompact`, `SessionStart` e `Stop`;
- `installClaudeCommands()` no `bin/wsd-method.js` — gera `.claude/commands/`, `+wsd/hooks/pre-tool.sh` e `.claude/settings.json`;
- `--tools claude-code` e `--tools both` operacionais no instalador;
- `test:install-claude` em `package.json` para validar instalação Claude Code;
- `AGENTS.md.template` atualizado com referências a `/wsd-start` e `/wsd-finish`.

Ainda pendente:

- JSON Schema formal para `+context.json`;
- validação YAML formal para specs;
- piloto no `koomplet-office`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. 0.1.4-alpha — 06/05/2026

Camada de qualidade de desenvolvimento — integração da metodologia TLC Spec-Driven (Tech Leads Club).

### Adicionado

**Estrutura `+specs/` expandida** (substitui `.specs/` em todo lugar):

- `+specs/project/PROJECT.md` — visão, goals, regras operacionais, out of scope, política de ambiente, topologia de clones;
- `+specs/project/STATE.md` — memória operacional persistente: Decisões, Bloqueadores Ativos, Lições Aprendidas, Ideias Adiadas, Todos Ativos (substitui `+logs/error_vault.json` como fonte de verdade);
- `+specs/codebase/` (gerada com `--brownfield`): `STACK.md`, `ARCHITECTURE.md`, `CONVENTIONS.md`, `STRUCTURE.md`, `INTEGRATIONS.md`, `CONCERNS.md`, `TESTING.md`;
- `+specs/features/<slug>/` para features (spec.md WHEN/THEN/SHALL + tasks.md atômico + design.md opcional);
- `+specs/quick/` para tarefas L0 express;
- `+specs/HANDOFF.md` — passe de bastão entre sessões (gerado em `wsd-finish`).

**4 fases TLC + Auto-sizing**:

- `Specify → Design → Tasks → Execute` com HARD-GATE entre Specify e Design;
- L0 → Quick mode; L1 → Specify+Execute; L2 → 4 fases + aprovação humana;
- novos comandos: `/wsd-specify`, `/wsd-design`, `/wsd-tasks` (Codex e Claude Code);
- `wsd-start` carrega `STATE.md` e `HANDOFF.md` e classifica risco automaticamente;
- `wsd-finish` atualiza `STATE.md` e gera `HANDOFF.md` antes de fechar a sessão.

**Constituição (regras 11 e 12)**:

- Regra 11 — Knowledge Verification Chain: 5 passos obrigatórios (codebase → docs → MCP → web search → flagrar incerteza). Anti-alucinação;
- Regra 12 — Scope Guardrail: "Isto está na minha task?". Ideias adjacentes vão para `STATE.md`. Anti scope-creep.

**Padrões de qualidade**:

- WHEN/THEN/SHALL como formato obrigatório de acceptance criteria em specs L1/L2;
- TESTING.md tiered gates (Quick/Full/Build) com placeholders por perfil (`TEST_QUICK_COMMAND`, `TEST_FULL_COMMAND`, `TEST_BUILD_COMMAND`);
- **Conventional Commits 1.0.0** como padrão obrigatório (ver `docs/07_git_governance.md`).

**Instalador**:

- nova flag `--brownfield` para gerar `+specs/codebase/`;
- novas flags `--test-quick`, `--test-full`, `--test-build` para sobrescrever gates;
- novos `--set` keys: `validation.test_quick`, `validation.test_full`, `validation.test_build`;
- todos os profiles atualizados com comandos de gate por nível.

**Documentação**:

- `docs/14_qualidade_desenvolvimento.md` — guia consolidado dos padrões TLC adotados;
- `docs/01_constituicao.md` — Regras 11 e 12;
- `docs/04_playbook_implantacao.md` — Passo 7 (Auto-sizing + 4 fases);
- `docs/07_git_governance.md` — Conventional Commits 1.0.0 obrigatório;
- `docs/08_rotinas_sessao.md` — STATE.md/HANDOFF.md no fluxo de sessão.

**Testes**:

- `npm test` agora roda os 3 gates (`test:install`, `test:install-claude`, `test:install-brownfield`);
- `scripts/wsd_docs_check.sh` valida 20+ artefatos TLC e bane paths legados em árvores novas.

### Mudado

- `.specs/` → `+specs/` em todo o instalador, scripts, profiles e templates;
- `.logs/` → `+logs/` em todo o instalador, scripts, profiles e templates;
- `.logs/error_vault.json` → substituído por `+specs/project/STATE.md` como memória operacional principal;
- `templates/repo/AGENTS.md.template` reescrito com TLC: context loading strategy, auto-sizing table, knowledge chain, scope guardrail e Conventional Commits.

### Pendente

- JSON Schema formal para `+context.json` (planejado para v0.1.5-alpha);
- validação YAML formal para specs L1/L2 antigos (a maioria já migrou para spec.md MD-based).

### Validação Operacional

- ✅ Concluída em 07/05/2026 com bootstrap brownfield em projeto real: 72/72 testes do projeto + build OK + 9 acceptance criteria WHEN/THEN/SHALL atendidos.
- ✅ Bug `bin/wsd doctor` detectado e corrigido em `0d78bf2` durante a validação.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. 0.1.5-alpha — 07/05/2026

JSON Schema validation para o contrato `+context.json`. Fecha o último pendente da Fase 1 do roadmap.

### Adicionado

- `schemas/context.schema.json` — JSON Schema 2020-12 canônico (`$id: wsd/context/v1`) cobrindo `project`, `environment`, `repository`, `permissions`, `workflow`, `wsd`, `ci`. Required, types, enums fortes (`secrets_policy`, `production_mutation_policy`, `repo_type`).
- `templates/local-wsd/bin/wsd-validate-context.js` — validador pure-JS zero-deps. Suporta `type`/`required`/`properties`/`additionalProperties`/`items`/`enum`/`const`/`pattern`/`minLength`/`maxLength`/`minimum`/`maximum`/`oneOf`. Erros com path JSON-pointer.
- Vendorização: `wsd-method install` copia `schemas/` → `+wsd/schemas/` e validator → `+wsd/bin/wsd-validate-context.js` (chmod 755).
- Self-tests inline em `scripts/wsd_self_check.sh`: sample válido + 3 samples inválidos (missing required, wrong type, bad enum).
- `+specs/features/json-schema-context/` (spec WHEN/THEN/SHALL aprovada + design.md + tasks.md).

### Mudado

- `templates/repo/scripts/wsd_check.sh` chama validator após JSON syntax check (hard-fail). Fallback `warn:` quando Node ausente.
- `templates/local-wsd/bin/wsd doctor` reporta `+wsd/schemas/context.schema.json`, `+wsd/bin/wsd-validate-context.js` e presença de `node`.
- `npm test` (`test:install`, `test:install-claude`, `test:install-brownfield`) assertam vendor + validação do `+context.json` renderizado.
- `scripts/wsd_docs_check.sh` exige documentação do schema em `docs/05` e `docs/10`.

### Documentação

- `docs/05_contrato_artefatos.md` — nova subseção "Schema canônico (v0.1.5-alpha)".
- `docs/10_matriz_sincronizacao_notas.md` — schema + validator em "Fontes de Verdade" e "Matriz Obrigatória".

### Validação

- ✅ `npm test`: 3/3 gates passam com schema validation acoplada.
- ✅ Todos os 4 profiles (`generic_node_frontend`, `generic_python_api`, `koomplet_office`, `prescreve_mais`) renderizam `+context.json` que valida.
- ✅ `bash scripts/wsd_self_check.sh` PASS com self-tests do validator.
- ✅ `bash scripts/wsd_docs_check.sh` PASS.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. 0.1.6-alpha — 07/05/2026

Ghost spec detector e git hooks no bootstrap. Fecha a Fase 3 do roadmap.

### Adicionado

**Ghost spec detector em `wsd_check.sh`**:

- Scan de `+specs/features/**/spec.md` com status `approved`, `implemented` ou `verified`.
- `warn:` quando spec não tem WHEN/THEN/SHALL (aviso sem bloqueio para L0).
- Hard `fail:` ao executar check L1/L2 via `--spec`: spec sem SHALL é bloqueada com mensagem `"ghost spec blocked"`.

**Git hooks no bootstrap** (instalados por `wsd-method install`):

- `templates/git-hooks/pre-commit` — roda `scripts/wsd_check.sh --risk L0 .` antes de cada commit; gracioso se `wsd_check.sh` ausente.
- `templates/git-hooks/commit-msg` — valida Conventional Commits 1.0.0; pula merge/revert/fixup/squash/WIP.
- `templates/git-hooks/pre-push` — roda `wsd_check.sh --risk L0` antes de push.
- Destino versioned: `scripts/git-hooks/` (auditável, versionado junto ao projeto).
- Destino ativo: `.git/hooks/` (executado pelo git).

**Subcomando `wsd hooks`** no CLI local (`+wsd/bin/wsd`):

- Reinstala hooks após `git clone` (copia `scripts/git-hooks/*` → `.git/hooks/`).

**Flag `--no-git-hooks`** no instalador:

- Opt-out para repos que não querem enforcement de hooks.

### Mudado

- `bin/wsd-method.js` — nova função `installGitHooks()` chamada por `install()`; `doctor` lista templates de hooks; help documenta `--no-git-hooks`.
- `templates/local-wsd/bin/wsd` — subcomando `hooks`; `doctor` verifica os 3 hooks em `.git/hooks/`.
- `templates/repo/AGENTS.md.template` — nova seção "Git Hooks instalados".
- `scripts/wsd_self_check.sh` — 3 hooks adicionados ao manifest, parse de shell e verificação de executável.
- `scripts/wsd_docs_check.sh` — assertions para hooks e para ghost spec gate em `wsd_check.sh`.
- `package.json` `version` — `0.1.5-alpha` → `0.1.6-alpha`.
- `package.json` `test:install` / `test:install-claude` — assertions para os 3 hooks.

### Documentação

- `docs/07_git_governance.md` — nova Seção 9 "Git Hooks no Bootstrap" com tabela, localização e reinstalação.

### Validação

- ✅ `npm test`: 3/3 gates passam com assertions de hooks.
- ✅ `bash scripts/wsd_self_check.sh` PASS.
- ✅ `bash scripts/wsd_docs_check.sh` PASS.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 9. 0.1.7-alpha — 07/05/2026

`wsd finish` automatizado: HANDOFF.md gerado pelo CLI e prompts interativos para STATE.md. Fecha o último item pendente da Fase 3.

### Adicionado

**`wsd finish` automatizado** (em `templates/local-wsd/bin/wsd`):

- Gera `+specs/HANDOFF.md` automaticamente com: branch atual, último commit, últimos 5 commits, arquivos uncommitted (excluindo untracked) e specs abertas em `+specs/features/`.
- Prompts interativos em terminal (se `python3` disponível e stdin interativo):
  - Lição aprendida → tabela `## Lições Aprendidas` em `STATE.md`.
  - Decisão arquitetural/de método → tabela `## Decisões`.
  - Bloqueador ativo → tabela `## Bloqueadores Ativos`.
- Gracioso: pula prompts se stdin não-interativo ou python3 ausente (exibe `info:` mensagem).
- Campos em branco ignorados (prompt não insere linha vazia).

**Gate de regressão** (em `scripts/wsd_self_check.sh`):

- Verifica que `templates/local-wsd/bin/wsd` contém `HANDOFF.md` no finish.
- Verifica que `templates/local-wsd/bin/wsd` contém `_state_insert` no finish.

### Mudado

- `templates/local-wsd/bin/wsd` — case `finish` expandido com geração de HANDOFF.md e prompts STATE.md.
- `scripts/wsd_self_check.sh` — 2 novos gates de regressão para o finish automatizado.
- `docs/08_rotinas_sessao.md` — seção 4 reescrita para refletir comportamento automatizado.
- `package.json` `version` — `0.1.6-alpha` → `0.1.7-alpha`.

### Validação

- ✅ `bash -n templates/local-wsd/bin/wsd` PASS.
- ✅ `bash -n scripts/wsd_self_check.sh` PASS.
- ✅ `bash scripts/wsd_self_check.sh` PASS.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 10. 0.1.8-alpha — 07/05/2026

Instalação interativa rica, `wsd update` real e WHEN+THEN+SHALL completo obrigatório.

### Adicionado

**Instalação interativa rica** (em `bin/wsd-method.js`):

- Pergunta linguagem principal do projeto (preenche `PRIMARY_LANGUAGE` no `+context.json`).
- Pergunta path canônico do projeto (preenche `CANONICAL_PATH`).
- Pergunta comandos de test, build e lint — padrão vem do perfil; Enter mantém o padrão.
- Pergunta forbidden_paths em CSV — padrão vem do perfil.
- Todas as perguntas são puladas com `--yes`.

**`wsd update` real** (em `templates/local-wsd/bin/wsd` e `bin/wsd-method.js`):

- `wsd-method install` grava `wsd_source: WSD_ROOT` em `+wsd/config.json`.
- `wsd update` lê `wsd_source` com `python3 -c "import json..."` e chama `node $src/bin/wsd-method.js update --directory .`.
- `update()` no CLI principal: atualiza `+wsd/bin/`, `+wsd/hooks/`, `+wsd/schemas/` sem tocar em arquivos do projeto; atualiza `config.json` mantendo campos existentes.
- Gracioso: se `wsd_source` ausente/inválido, exibe `warn:` com instrução manual.

**WHEN+THEN+SHALL completo em ghost scan e L1/L2**:

- `_spec_has_wts()` em `templates/repo/scripts/wsd_check.sh`: verifica `\bWHEN\b`, `\bTHEN\b` e `\bSHALL\b` com word-boundary.
- Ghost scan usa `_spec_has_wts "$specfile"` (antes usava `grep -q 'SHALL'` — apenas um keyword).
- L1/L2 usa `_spec_has_wts "$spec"` com `fail:` `"all three required (ghost spec blocked)"`.
- `scripts/wsd_self_check.sh` atualizado: gate verifica `_spec_has_wts` no template (não só `grep -q 'SHALL'`).

### Mudado

- `bin/wsd-method.js` — perguntas interativas ricas, `update()` implementado (antes era stub), `wsd_source` em `config.json`.
- `templates/local-wsd/bin/wsd` — `update)` case lê `wsd_source` e delega ao CLI principal.
- `templates/repo/scripts/wsd_check.sh` — `_spec_has_wts()` substituiu grep single-keyword.
- `scripts/wsd_self_check.sh` — gate WHEN/THEN/SHALL verifica `_spec_has_wts`.
- `package.json` `version` — `0.1.7-alpha` → `0.1.8-alpha`.

### Validação

- ✅ `bash -n templates/local-wsd/bin/wsd` PASS.
- ✅ `bash -n scripts/wsd_self_check.sh` PASS.
- ✅ `bash scripts/wsd_self_check.sh` PASS.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 11. 0.1.9-alpha — 07/05/2026

Saneamento documental operacional após a consolidação da v0.1.8-alpha.

### Mudado

- `package.json` `version` — `0.1.8-alpha` → `0.1.9-alpha`.
- `docs/00_planejamento_instalacao_wsd.md` — checklists de primeira implementação atualizados para refletir prompts interativos, piloto brownfield e JSON Schema já entregues.
- `docs/12_avaliacao_critica.md` — item "prompt de lição aprendida no wsd finish" marcado como concluído, alinhado à v0.1.7-alpha.
- `+specs/project/STATE.md` — decisão registrada: `wsd_philo/` é referência histórica/pesquisa e não fonte operacional de gate.
- README, hub, ROADMAP e publicação GitHub sincronizados para `v0.1.9-alpha`.

### Não Mudado

- Nenhuma mudança funcional em installer, templates, hooks, schemas ou scripts.
- `wsd_philo/` não foi migrado; a pasta continua preservada como material histórico/filosófico.

### Validação

- `bash scripts/wsd_self_check.sh` PASS.
- `npm test` PASS — 3/3 gates (`test:install`, `test:install-claude`, `test:install-brownfield`).

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 12. 0.1.10-alpha — 07/05/2026

MVP Git/GitHub Governance para tornar branch, remote, upstream, Issue e PR parte explicita do contrato operacional sem exigir GitHub no core.

### Adicionado

- `--git-policy none|basic|full` no `bin/wsd-method.js`.
- Bloco `git_governance` no `+context.json` renderizado pelo template.
- Secao Git/GitHub Governance no `AGENTS.md` renderizado.
- Namespace local `./+wsd/bin/wsd git doctor|preflight|pr-check`.
- Templates `.github/PULL_REQUEST_TEMPLATE.md` e `.github/ISSUE_TEMPLATE/{task,bug,decision}.md` no modo `full`.
- Testes `test:install-git-none`, `test:install-git-basic` e `test:install-git-full`.

### Mudado

- `package.json` `version` — `0.1.9-alpha` → `0.1.10-alpha`.
- `npm test` agora roda 6 gates de instalacao.
- `schemas/context.schema.json` aceita `git_governance` como bloco opcional.
- `scripts/wsd_docs_check.sh` e `scripts/wsd_self_check.sh` validam os artefatos do MVP Git Governance.

### Fora do MVP

- `multi-host`.
- `wsd git audit`.
- `wsd git bootstrap`.
- server-side hooks.
- OPA/Rego.
- alteracoes administrativas sensiveis no GitHub.

### Validação

- `npm run test:install-git-none` PASS.
- `npm run test:install-git-basic` PASS.
- `npm run test:install-git-full` PASS.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 13. 0.1.11-alpha — 07/05/2026

Party Mode Integration: sistema de orquestração multi-agente instalado pelo CLI,
exposto como comando Claude Code e subcomando `wsd party`.

### Adicionado

- `installPartyMode(directory, force)` em `bin/wsd-method.js` — copia `party-mode/` para `+wsd/party-mode/` no projeto instalado.
- `templates/claude-commands/commands/wsd-party-mode.md` — slash command `/wsd-party-mode` para Claude Code.
- Subcomando `wsd party status|list-agents|when-to-use` em `templates/local-wsd/bin/wsd`.
- Seção `## Party Mode` em `templates/repo/AGENTS.md.template` com comandos e contextos.
- `test:install-party-mode` em `package.json` — verifica command, assets, AGENTS.md e `wsd party status`.

### Mudado

- `package.json` `version` — `0.1.10-alpha` → `0.1.11-alpha`.
- `npm test` agora roda 7 gates de instalação.
- `wsd doctor` reporta status do party-mode.
- 5 agentes órfãos removidos de `party-mode/agents/` (design anterior de 5-agentes, não referenciados no CSV).

### Fora do MVP

- Streaming interativo de agentes no terminal.
- Scoring automático de conformidade.
- Integração com GitHub Discussions ou PR reviews automáticos.

### Validação

- `npm run test:install-party-mode` PASS.
- `npm test` — 7/7 gates PASS.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 14. 0.1.0 — 07/05/2026

**Primeira release estável.** Consolida toda a série alpha (`0.1.0-alpha` → `0.1.11-alpha`)
em API estável após validação operacional brownfield e fechamento de todas as fases do roadmap.

### Mudado

- `package.json` `version` — `0.1.11-alpha` → `0.1.0` (drop do sufixo).
- README seção "Uso Recomendado" expandida e renomeada para **"Uso Oficial"** com 6 subseções: greenfield, brownfield, ciclo de sessão, comandos disponíveis, política Git, validação contínua.
- README seção "Fases de Consolidação" — todas as 4 fases marcadas como concluídas.
- README seção "Foco Atual" — passa para modo de manutenção estável; lista frentes futuras opt-in (server-side hook, OPA/Rego, ajv).
- ROADMAP Fase 4 fechada com `[x]` em todos os itens.

### Validação

- `npm test` — 7/7 gates PASS (test:install, test:install-claude, test:install-brownfield, test:install-git-{none,basic,full}, test:install-party-mode).
- `bash scripts/wsd_docs_check.sh` — PASS (14 assertions documentais).
- `bash scripts/wsd_self_check.sh` — PASS (consistência interna, sem segredos).

### Nota de Compatibilidade

`0.1.0` não introduz mudanças de API. Projetos instalados com `0.1.11-alpha` são totalmente
compatíveis. Patches futuros seguem semver: `0.1.x` (bug fixes), `0.2.0` (novas features
grandes após validação em piloto), `1.0.0` (contrato auditado e múltiplos pilotos
concluídos).

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 15. 0.1.2 — 11/05/2026

**Ideas Workflow + ROADMAP.md + estratégia de repositório público.**

### Adicionado

- `templates/repo/+specs/project/ROADMAP.md.template` — instalado automaticamente em todo projeto via `renderRepoTemplates()`. Formato Obsidian com frontmatter, callouts e tabela de features por status (`planned`, `in-progress`, `done`, `cancelled`).
- `templates/repo/+specs/project/IDEAS.md.template` — notebook de ideias brutas do projeto.
- `templates/repo/+specs/project/IDEAS_PIPELINE.md.template` — controle de progressão de ideias (`raw` → `implementada`).
- `templates/claude-commands/commands/wsd-idea.md` — comando slash `idea-{PROJECT_SLUG}` para Claude Code: captura estruturada, estimativa L0/L1/L2, oferta de Party Mode para L1/L2.
- `templates/codex-skills/wsd-idea/SKILL.md` — skill equivalente para Codex.
- `docs/15_repositorio_publico_e_quick_start.md` — estratégia `npx github:flow31-d/wsdd install`, workflow de sync privado×público e checklist de release.
- `+specs/features/project-roadmap/` e `+specs/features/ideas-workflow/` — specs WHEN/THEN/SHALL e tasks atômicas para as duas features.

### Mudado

- `bin/wsd-method.js` — `normalizeSettings()` deriva `PROJECT_SLUG` (lowercase + hyphens); `installClaudeCommands()` renomeia dinamicamente `wsd-idea.md` → `idea-{PROJECT_SLUG}.md` no projeto alvo.
- `templates/repo/AGENTS.md.template` — carga on-demand de ROADMAP e IDEAS_PIPELINE adicionada; seção "Regras de planejamento" com referência ao `{{PROJECT_SLUG}}`.
- `package.json` — versão `0.1.0` → `0.1.2`; gates `test:install`, `test:install-claude` e `test:install-brownfield` validam novos artefatos.
- `README.md` — quick start `npx`, callout dogfooding, novos artefatos em seção 2, comando `idea-{slug}` em seções 4.4 e 9, status atualizado para repo público.

### Validação

- `npm test` — 7/7 gates PASS.

### Nota

Não há mudanças de API que quebrem instalações existentes da `v0.1.0`. Os novos artefatos são adicionais — projetos instalados antes simplesmente não os têm.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 16. 0.1.3 — 11/05/2026

### fix

- `templates/local-wsd/bin/wsd-validate-context.js` → `wsd-validate-context.cjs` — renomeado para extensão `.cjs` para compatibilidade com projetos Node.js que têm `"type": "module"` em `package.json`. Sem essa renomeação, `require()` falhava com `ReferenceError: require is not defined in ES module scope`.
- `templates/local-wsd/bin/wsd-snapshot.js` → `wsd-snapshot.cjs` — mesma correção aplicada ao gerador de snapshot.

### Mudado

- `bin/wsd-method.js` — cópia de `wsd-validate-context` e `wsd-snapshot` atualizada para extensão `.cjs` (instalador e `wsd update`).
- `scripts/wsd_self_check.sh` — referências ao arquivo de validação atualizadas para `.cjs`.
- `scripts/wsd_docs_check.sh` — verificação de existência atualizada para `.cjs`.
- `templates/repo/scripts/wsd_check.sh` — template do checker instalado em projetos atualizado para `.cjs`.
- `templates/local-wsd/bin/wsd` — comandos `doctor` e `snapshot` atualizados para `.cjs`.
- `package.json` — scripts de teste (`test:install`, `test:install-claude`, `test:install-brownfield`) atualizados para verificar `.cjs`.

### Adicionado

- `RELEASING.md` — checklist obrigatório pré-release (testes, specs, artefatos, git/tag). Previne gaps de governança como os da sessão 11/05 onde ROADMAP.md e docs/05 ficaram desatualizados.
- `+specs/features/project-snapshot/spec.md` e `tasks.md` — spec retroativa do `wsd snapshot` com 6 ACs WHEN/THEN/SHALL e tasks marcadas como `implemented`.
- `docs/05_contrato_artefatos.md` — novas seções: `+specs/project/` (ROADMAP.md, IDEAS.md, IDEAS_PIPELINE.md com regras de manutenção) e `+wsd/` vendor tree (estrutura, arquivos ignorados, `wsd update`).

### Governance

- `+specs/features/project-roadmap/` — spec e tasks atualizadas para `status: implemented`; tasks de T1–T8 marcadas `[x]`.
- `+specs/features/ideas-workflow/` — spec e tasks atualizadas para `status: implemented`; tasks de T1–T9 marcadas `[x]`.
- `ROADMAP.md` — v0.1.3 marcada `[x]` na Fase 5; v0.1.4 adicionada como próxima frente.

### Validação

- `npm test` — 7/7 gates PASS após renomeação CJS.

### Nota

Sem mudança de API. Instalações existentes da v0.1.2 não quebram — os arquivos `.js` não existem mais nos templates, mas projetos já instalados continuam funcionando com seus próprios `+wsd/bin/`. Para corrigir projetos existentes, renomear manualmente `+wsd/bin/wsd-validate-context.js` → `.cjs` e `+wsd/bin/wsd-snapshot.js` → `.cjs`, e atualizar referências no `scripts/wsd_check.sh` do projeto.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 17. 0.1.4 — 12/05/2026

**Hotfix.** Resolve o WSD-001 (templates faltantes no `wsdd` público) e fecha gaps de governance do release `v0.1.3` (README dessincronizado e tag git ausente). Inclui sincronização completa dos 6 commits pendentes pós-`v0.1.3` do WSD privado para o `wsdd` (Opção B do `REVIEW_PRE_V1.md`).

### fix

- **`templates/repo/+specs/project/{ROADMAP,IDEAS,IDEAS_PIPELINE}.md.template`** — 3 templates que existiam apenas no WSD privado agora estão também no `wsdd` público. Sem eles, `npx github:flow31-d/wsdd install` gerava `+specs/project/` sem as 3 notas que o `AGENTS.md` prescreve, deixando o fluxo de ideias e o ROADMAP incompletos. Refs: WSD-001 (REVIEW_PRE_V1.md), Issue [#10](https://github.com/flow31-d/WSD/issues/10).
- **README.md linha 217** — referência atualizada de `v0.1.2` (estado pré-`v0.1.3`) para `v0.1.4`. O release `v0.1.3` saiu sem atualizar esta linha — sintoma do WSD-009 (release process sem automação).

### Adicionado

- Entrada `v0.1.4` no `ROADMAP.md` (Fase 5 — Manutenção Estável) descrevendo o hotfix.
- Tag git retroativa `v0.1.3` criada no commit `9525e90` (`chore(release): v0.1.3` de 11/05/2026), que havia ficado sem tag.

### Mudado

- `package.json` `version` — `0.1.3` → `0.1.4`.
- README.md histórico de entregas — adicionado item `v0.1.4`.
- `+specs/project/STATE.md` — registrada decisão da release `v0.1.4` em Decisões.

### Sincronização wsdd

A release `v0.1.4` sincroniza para o `wsdd` público, além dos 3 templates do fix WSD-001, os 6 commits pendentes pós-`v0.1.3` do WSD privado:

- `934492e` docs(readme): adicionar v0.1.3 no histórico e atualizar Foco Atual
- `2948a91` feat(snapshot): adicionar +context.json e +specs/project/ROADMAP.md
- `498b1b8` docs: adiciona doc 17 — explicação detalhada dos campos do snapshot
- `6341eb2` fix: corrige paths obsoletos x/wsd e remove exemplos de projetos privados
- `91bc107` fix(docs/06): remove wikilink para exemplo privado no frontmatter
- `e7a36b3` fix(installer): não vendorizar meta-docs do toolkit em +wsd/ do projeto
- `456ba05` docs: decidir idioma português, clarificar branch por modo e limpar docs/11

### Validação

- `npm test` — 7/7 gates PASS no WSD privado e no clone fresh do `wsdd`.
- `bash scripts/wsd_docs_check.sh` — PASS.
- `bash scripts/wsd_self_check.sh` — PASS.

### Nota de Compatibilidade

Sem mudança de API. Instalações `v0.1.3` continuam funcionando. Projetos podem rodar `./+wsd/bin/wsd update` para puxar os 3 templates faltantes em `+wsd/templates/repo/+specs/project/` (não-destrutivo — não toca em arquivos do projeto-alvo).

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 18. 0.2.0 — 13/05/2026

**Minor release "estável adotável".** Consolida 8 features funcionais + UX polish que vinham acumulando desde a `v0.1.4` (hotfix). Todos os itens foram especificados no `REVIEW_PRE_V1.md` durante a revisão pré-v1, com decisões de design (D-001 e D-002) registradas pelo usuário em 12/05/2026.

### Adicionado

- **WSD-002 — Renderização condicional do `AGENTS.md`** ([#20](https://github.com/flow31-d/WSD/pull/20))
  - `render()` de `bin/wsd-method.js` suporta `{{#if FLAG}}...{{/if}}` e `{{#unless FLAG}}...{{/unless}}` (sintaxe mustache-like, lazy match, não-aninhada).
  - `templates/repo/AGENTS.md.template` envolve refs a `+specs/codebase/*` em `{{#if BROWNFIELD}}` — em greenfield essas linhas somem; em brownfield aparecem.
  - Antes: greenfield AGENTS.md tinha 8+ refs a arquivos inexistentes; agente batia em `ENOENT` ao tentar carregar.
  - Depois: greenfield 0 refs codebase/, brownfield 7 refs codebase/ (validado por gates).

- **WSD-003 — CI no `wsdd`** (commit `3d57c20` direto em `flow31-d/wsdd`)
  - `.github/workflows/install-gates.yml` no `wsdd` público. Triggers: push e PR para `main`. Roda os 9 gates de `npm test` + `wsd_docs_check.sh` + `wsd_self_check.sh` em Node.js 20.
  - Primeira validação independente do produto distribuído. Antes era "honor system" — WSD-001 e WSD-013 ficaram silenciosos por mais de uma semana.

- **WSD-004 L0+L1 — `wsd check` robusto** ([#26](https://github.com/flow31-d/WSD/pull/26))
  - L0: valida presença das 6 notas obrigatórias de `+specs/project/` (PROJECT, STATE, ROADMAP, IDEAS, IDEAS_PIPELINE, CONCERNS).
  - L1: coerência ROADMAP ↔ specs — cada `+specs/features/<slug>/spec.md` referenciado no ROADMAP exige arquivo existente.
  - L2 (branch_naming, pre-flight git, audit completo) fica para `v0.2.x`/`v0.3.0`.

- **WSD-006 — Obsidian declarado como pré-requisito** ([#15](https://github.com/flow31-d/WSD/pull/15), resolve **D-002 Opção A**)
  - Callout `> [!tip] Pré-requisitos Recomendados` no início da seção `## 9. Instalação` do README listando Obsidian e a sintaxe usada (frontmatter, callouts, wikilinks).
  - Nova linha "Obsidian (recomendado)" na tabela de pré-requisitos em `docs/15`.

- **WSD-007 — Install com opt-out interativo de módulos** ([#24](https://github.com/flow31-d/WSD/pull/24), resolve **D-001 Opção B+**)
  - Settings `INSTALL_DOCS`, `INSTALL_PARTY_MODE`, `INSTALL_EXAMPLES` (default true).
  - Prompts interativos no install: "Instalar metodologia em `+wsd/docs/`?", equivalentes para party-mode e examples.
  - Flags equivalentes para automação: `--no-docs`, `--no-party-mode`, `--no-examples`.
  - `+wsd/config.json` grava `modules` para que `wsd update` respeite as escolhas.
  - Runtime essencial (`bin/`, `templates/`, `profiles/`, `scripts/`, `schemas/`) continua mandatório.

- **WSD-009 — `scripts/wsd_release.sh`** ([#22](https://github.com/flow31-d/WSD/pull/22))
  - Automação completa de release WSD privado + sync wsdd público.
  - Fluxo: pré-flight, calculo de versão, verifica CHANGELOG/README/ROADMAP, bump, gates locais, branch + commit + push + PR, merge, tag + push tag, sync wsdd via whitelist, gates lá, commit + push + tag + GitHub Release.
  - Flags: `--dry-run`, `--skip-wsdd`, `--auto-merge`, `--yes`, `--skip-tag`, `--skip-gh-release`.
  - Shortcuts em `package.json`: `release:patch`, `release:minor`, `release:major`, `release:dry`.
  - `RELEASING.md` ganha seção "Automatizada" como caminho recomendado.

- **WSD-010 — `CONCERNS.md` como nota padrão de `+specs/project/`** ([#13](https://github.com/flow31-d/WSD/pull/13))
  - Template movido de `templates/repo/+specs/codebase/CONCERNS.md.template` (só brownfield) para `templates/repo/+specs/project/CONCERNS.md.template` (sempre).
  - Conteúdo reescrito para começar genuinamente vazio (5 seções com tabelas só com header).
  - `AGENTS.md.template`, `+context.json.template`, `docs/05_contrato_artefatos.md`, `docs/04` atualizados.

- **WSD-013 — Fix raiz de `ENOENT` em loops de cópia** ([#18](https://github.com/flow31-d/WSD/pull/18))
  - `bin/wsd-method.js` ganha `fs.existsSync(srcPath)` guard nos 2 loops (`installVendorTree` e `update`).
  - Antes: install morria com `ENOENT: scandir 'examples'` quando algum diretório opcional ausente. Resolvido pontualmente em `v0.1.4` (restaurando `examples/README.md` no wsdd); agora resolvido na causa.
  - Novo gate `test:install-missing-optional` simula cenário "wsdd-like" sem `examples/`/`docs/`.

- **UX polish do install interativo** ([#27](https://github.com/flow31-d/WSD/pull/27) + round 2 baseado em feedback piloto)
  - Header `== Install WSD ==` explica explicitamente que `[valor entre colchetes]` é o default e Enter aceita. Resolve ambiguidade reportada no piloto worc.
  - Brownfield vira prompt interativo (não só flag): "Projeto brownfield? [N]". Default `N`; pode ser pré-respondido via `--brownfield`.
  - **Round 2** (feedback do operador após uso real):
    - Removidos prompts redundantes: `PROJECT_TYPE`, `PRIMARY_LANGUAGE` e os 3 prompts de `TEST/BUILD/LINT` commands. Derivam automaticamente do profile. Operador edita `+context.json` se precisar customizar.
    - Mensagem do prompt `Repositorio GitHub` limpa: removida nota "(vazio = skip)" que conflitava com o default sugerido a partir do remote detectado.
    - Defaults mais ergonômicos: `GITHUB_MODE` `skip` → `auto`; `GIT_POLICY` `none` → `full`; `INSTALL_EXAMPLES` `true` → `false` (flag agora é `--examples` para opt-in, não mais `--no-examples` para opt-out).
    - Novo prompt no final: "Rodar agora ./+wsd/bin/wsd (doctor, check, both ou nada)? [both]" — auto-executa diagnóstico/check após install. Default `both`. "Next steps" suprime as linhas dos comandos já executados.

### Mudado

- `package.json` `version` — `0.1.4` → `0.2.0`.
- `npm test` — passa de 7 para **9 gates** (adicionados `test:install-missing-optional` e `test:install-modules-opt-out`).
- `scripts/wsd_self_check.sh` — 8 novos gates de regressão (cobrem WSD-002, WSD-004, WSD-007, WSD-009, WSD-013).

### Decisões de Design Registradas

Durante a revisão pré-v1 (`REVIEW_PRE_V1.md`), o usuário decidiu em 12/05/2026:

- **D-001 → Opção B+**: full default + prompts interativos para opt-out de módulos durante install. Justificativa: usuário novo greenfield que não sabe `--full` perderia acesso a metodologia em modo minimal. Implementado em WSD-007.
- **D-002 → Opção A**: Obsidian-first declarado no README + docs/15. Justificativa: refactor portable consumiria 8-12h para ganho incremental baixo dado público-alvo. Implementado em WSD-006.

### Validação

- `npm test` — **9/9 gates PASS**.
- `bash scripts/wsd_docs_check.sh` — PASS.
- `bash scripts/wsd_self_check.sh` — PASS (8 novos gates de regressão).
- **Validação end-to-end em matriz**: 27 cenários cobrindo brownfield+claude+git-full, both tools, opt-out de módulos, `wsd update`, `wsd check L1` com spec válida e com spec ausente → 27/27 PASS.
- **Piloto operacional**: install interativo executado em projeto real (`flow31-d/worc`, monorepo TS Node 22 + Fastify + Next.js) em 13/05/2026. Todos os ~19 prompts funcionaram; `wsd doctor` e `wsd check L0` passaram limpo no projeto piloto.

### Nota de Compatibilidade

Sem mudança quebra-compat de API. **Mudanças de default no install** (ver Round 2) afetam apenas novos installs interativos que aceitam defaults sem flags — automação via `--yes` continua segura desde que as flags relevantes sejam passadas explicitamente (todos os gates `npm test` já fazem isso).

- Instalações `v0.1.4` continuam funcionando inalteradas.
- Projetos pré-`v0.2.0` rodando `./+wsd/bin/wsd update` ganham automaticamente: render condicional no `AGENTS.md` (próxima sessão), gates novos no `wsd check`, e (se reinstalarem) a possibilidade de opt-out de módulos.
- O `+wsd/config.json` antigo (sem `modules`) continua funcionando — `update()` aplica default `true` para todos os módulos quando o campo está ausente.
- **Mudança de flag**: `--no-examples` continua aceita (no-op explícito); novo `--examples` para opt-in. Defaults invertidos: examples agora é opt-in, não opt-out.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 19. 0.2.1 — 13/05/2026

**Patch cosmético.** Primeiro patch pós-`v0.2.0`, detectado durante validação do piloto worc em 13/05/2026 logo após a v0.2.0 ser publicada. Sem mudança de comportamento — apenas consistência de mensagem.

### fix

- **`bin/wsd-method.js update()`** — a linha "Refreshed: +wsd/{...}" agora é construída dinamicamente refletindo os módulos efetivamente copiados, respeitando `config.modules` gravado no install. Antes era string hardcoded `docs,templates,profiles,schemas,scripts,examples,bin` que conflitava com as mensagens `info: skipping examples/ (modules.examples=false)` impressas logo acima na mesma execução.

  Exemplo (worc instalado sem examples e sem party-mode):

  ```
  Antes:
    info: skipping examples/ (modules.examples=false in +wsd/config.json)
    info: skipping party-mode/ (modules.party_mode=false in +wsd/config.json)
    WSD updated: 0.2.0 -> 0.2.0
    Refreshed: +wsd/{docs,templates,profiles,schemas,scripts,examples,bin}  ← mente!

  Depois:
    info: skipping examples/ (modules.examples=false in +wsd/config.json)
    info: skipping party-mode/ (modules.party_mode=false in +wsd/config.json)
    WSD updated: 0.2.0 -> 0.2.0
    Refreshed: +wsd/{bin,docs,profiles,schemas,scripts,templates}  ← consistente
  ```

### Validação

- `npm test` — 9/9 gates PASS.
- `bash scripts/wsd_docs_check.sh` — PASS.
- `bash scripts/wsd_self_check.sh` — PASS.
- Manual: `wsd update` em projeto com `modules.examples=false` agora mostra mensagem consistente.

### Nota de Compatibilidade

Sem mudança de API ou comportamento — apenas string de log. Instalações `v0.2.0` continuam funcionando inalteradas; rodar `./+wsd/bin/wsd update` traz o fix da mensagem.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 20. 0.3.0 — 13/05/2026

**Minor — Reforço do contrato operacional WSD.** Primeira release pós-v0.2.x do batch "estável adotável". Foca em endurecer o contrato runtime do método: checker mais rigoroso, `+context.json` com schema expandido, artefatos `+specs/project/` preenchidos com conteúdo real (não mais placeholders), tracker formal de revisão pré-v1 e manual leigo dos comandos `wsdd`.

### Adicionado

- **`scripts/wsd_check.sh` reescrito (185 linhas)** — checker do método refeito para validar as 6 notas obrigatórias de `+specs/project/` como L0-required (PROJECT.md, STATE.md, ROADMAP.md, IDEAS.md, IDEAS_PIPELINE.md, CONCERNS.md). Antes só STATE.md era checada — WSD-001 escapou justamente porque o gate não validava as outras 5. Suporte completo a `--risk L0|L1|L2` e `--spec path`. Validação de schema `+context.json` via `wsd-validate-context.cjs` (com fallback degradado se Node ausente). Propagado para `templates/repo/scripts/wsd_check.sh` (+45 linhas) para que projetos instalados recebam o mesmo gate.
- **`+context.json` com blocos formais** (+100 linhas) — schema expandido com:
  - `$schema: "wsd/context/v1"` (alinhado com JSON Schema)
  - `environment` (canonical_host, canonical_path, environment, network_mode)
  - `repository` (name, default_branch, remote, repo_type, **`clone_policy`** com `canonical_history`/`operational_clone`/`audit_lab_clone`/`deploy_clone`/`promotion_flow`)
  - `permissions` (write_paths, forbidden_paths expandido, tool_allowlist, secrets_policy, max_runtime_seconds, max_tokens_per_request)
  - `workflow` (approval_mode, branch_policy, incident_mode, issue_policy, production_mutation_policy)
- **Artefatos `+specs/project/` preenchidos com conteúdo real do WSD** — antes eram templates vazios:
  - `PROJECT.md` (+61 linhas) — visão consolidada do projeto
  - `ROADMAP.md` (+9 linhas) — projeto roadmap operacional
  - `IDEAS.md` (+34 linhas) — backlog de ideias com triagem L0/L1/L2
  - `IDEAS_PIPELINE.md` (+21 linhas) — pipeline raw→implementada
  - `CONCERNS.md` (+39 linhas) — preocupações operacionais e mitigações
- **`templates/local-wsd/bin/wsd-snapshot.cjs` (+81 linhas)** — snapshot CJS expandido para coletar todos os novos campos do `+context.json` (environment, repository.clone_policy, permissions, workflow).
- **`scripts/wsd_self_check.sh` (+5 linhas)** — gates do self-check ajustados para a nova superfície do contrato.
- **`docs/05_contrato_artefatos.md`** atualizado — contrato de artefatos refletindo o `+context.json` expandido e a obrigação das 6 notas `+specs/project/`.
- **`docs/17_snapshot_campos_explicados.md` (+25 linhas)** — campos novos do snapshot explicados em português.
- **`REVIEW_PRE_V1.md` (1131 linhas)** — tracker formal de revisão pré-v1: catalogação dos WSD-001…WSD-013 (BLOQUEADOR/ALTO/MÉDIO/BAIXO), decisões D-001/D-002, status de cada item e mapa de quando cada arquivo do `+specs/project/` passa a ter conteúdo real (parcialmente endereça WSD-008).
- **`docs/18_manual_leigo_comandos_wsdd.md` (568 linhas)** — manual leigo dos comandos do `wsdd` orientado a operadores não-técnicos: `npx`, instalação, sessões `wsd start/finish`, comandos `/wsd-*`, triagem L0/L1/L2.

### Mudado

- **`+specs/features/tlc-integration/tasks.md`** — pequenos ajustes pós-implementação.
- **`docs/path-rename-WSD-to-wsd`** (PR #33 mergeado em 13/05) — paths legados `+Apps/WSD` → `+Apps/wsd` corrigidos em 6 arquivos (CONTRIBUTING, docs/04, docs/09, docs/15, docs/16, wsd_philo).

### Validação

- `npm test` — 9/9 gates PASS.
- `bash scripts/wsd_docs_check.sh` — PASS.
- `bash scripts/wsd_self_check.sh` — PASS.
- `wsd_check.sh` valida instalação fresca com as 6 notas presentes e bloqueia se alguma ausente.

### Nota de Compatibilidade

Mudança de chave `schema` → `$schema` no `+context.json` é **compatível** com validador atual (ambos aceitos no path lookup). Instalações pré-v0.3.0 continuam funcionando; rodar `./+wsd/bin/wsd update` traz o checker e snapshot novos. Para projetos brownfield que ainda não tenham as 6 notas em `+specs/project/`, o `wsd_check.sh` agora bloqueia em L0 — rodar `wsd-method install` para preencher os templates.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 21. 0.3.1 — 30/05/2026

**Patch — inventário de versão WSD por projeto.** Esta release resolve o problema operacional de ter WSD aplicado em vários repositórios sem uma forma simples de saber qual versão cada projeto usa.

### Adicionado

- **`./+wsd/bin/wsd version`** — consulta o projeto atual lendo `+wsd/config.json` e `+context.json`.
- **Status de alinhamento** — compara `installed_version` com a versão do pacote em `wsd_source/package.json` quando a fonte local ainda existe. Estados principais: `aligned`, `behind-source`, `ahead-of-source`, `source-unknown`, `not-installed`.
- **Inventário em lote** — `./+wsd/bin/wsd version --inventory --path <dir>` varre diretórios procurando `+wsd/config.json` e imprime uma tabela com path, projeto, versão instalada, data, fonte, versão da fonte e status.
- **Saída JSON** — `--json` funciona tanto no projeto atual quanto no inventário, permitindo alimentar dashboards, auditorias e scripts.
- **Documentação no `AGENTS.md` gerado** — `templates/repo/AGENTS.md.template` passa a listar `./+wsd/bin/wsd version` entre os comandos locais.
- **Gate de regressão** — `package.json` adiciona `test:install-version` e inclui o gate no `npm test`.

### Exemplos

```bash
./+wsd/bin/wsd version
./+wsd/bin/wsd version --json
./+wsd/bin/wsd version --inventory --path /srv/CLI/+Apps --max-depth 4
./+wsd/bin/wsd version --json --inventory --path /srv/CLI
```

### Validação

- `bash -n templates/local-wsd/bin/wsd` — PASS.
- `npm run test:install-version` — PASS.

### Nota de Compatibilidade

Sem mudança quebra-compat. Projetos já instalados precisam rodar `./+wsd/bin/wsd update` ou reinstalar WSD para receber o novo subcomando no CLI vendorizado.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 22. 0.3.3 — 13/06/2026

**Patch — versão carimbada no snapshot (publicação pública).** Leva ao `wsdd` público a feature introduzida no privado em `0.3.2`: o gerador de snapshot passa a registrar a versão WSD instalada dentro de cada `+wsd/snapshot.json`, permitindo detecção passiva de deriva de versão por consumidores que já leem snapshots — sem abrir o `+wsd/config.json` de cada repositório.

### Adicionado

- **`wsd_version` no snapshot** — `templates/local-wsd/bin/wsd-snapshot.cjs` grava o campo `wsd_version` (lido de `+wsd/config.json`) em cada `+wsd/snapshot.json`.
- **Detecção passiva de deriva** — consumidores comparam `wsd_version` com a versão da fonte e classificam `atual` / `patch_atras` / `minor_atras` / `desconhecida`. Snapshots sem o campo sinalizam gerador antigo. Complementa o `wsd version` ativo da v0.3.1.

### Nota de Compatibilidade

Sem mudança quebra-compat. Projetos já instalados recebem o gerador novo ao rodar `./+wsd/bin/wsd update`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 23. 0.4.0 — 15/06/2026

**Minor — WSD Loop + Codex Adherence Pack.** Esta release adiciona uma camada Ralph-like nativa ao WSD: ciclos curtos de planejar, executar, validar e repetir, amarrados a `+context.json`, specs, tasks, matriz de risco, permissões de path e gates locais. Também reforça o fluxo diário do Codex: abrir o agente na pasta do projeto continua válido, mas o `AGENTS.md` e o CLI local agora deixam a aderência WSDD explícita.

### Adicionado

- **`automation.loop` no `+context.json`** — defaults conservadores: L0/L1 automatizáveis, L2 com aprovação explícita, worktree limpa, auto-commit depois dos gates e auto-push desligado.
- **`automation.loop.auto_use`** — opção fixa para ligar/desligar o uso automático do Ralph/WSD Loop por agentes; default `false`, comandos `wsd loop auto on|off|status`.
- **Prompts vendorizados** — `+wsd/loop/PROMPT_plan.md` e `+wsd/loop/PROMPT_build.md` para padronizar como agentes planejam e executam uma tarefa por iteração.
- **`./+wsd/bin/wsd loop`** — subcomandos `plan`, `once`, `run`, `status` e `stop`.
- **Gates por iteração** — validação de risco, spec, tasks, lock, paths alterados, `git diff --check`, `wsd_check.sh` e CI declarada antes de auto-commit.
- **Logs locais ignorados** — `.gitignore` recebe `+logs/wsd-loop/`, `+wsd/loop/state.json` e `+wsd/loop/lock`.
- **WSD Codex Bootstrap** — o `AGENTS.md` gerado instrui Codex a carregar `+context.json`, `STATE.md`, `HANDOFF.md`, classificar L0/L1/L2 e validar sem o operador listar arquivos.
- **`./+wsd/bin/wsd start --brief`** — contexto compacto para agentes e wrappers.
- **`./+wsd/bin/wsd codex-prompt` e `./+wsd/bin/wsd codex`** — geram ou executam prompt WSDD curto; `--dry-run` permite testar sem Codex instalado.
- **`wsd doctor` ampliado** — reporta o bloco `WSD Codex Bootstrap` e a presença opcional do Codex CLI.
- **Docs e ideias futuras** — `docs/19_wsd_loop_automacao_inteligente.md` e novas ideias em `+specs/project/IDEAS.md`.
- **Gates de regressão** — `test:install-loop` e `test:install-codex-adherence` incluídos em `npm test`.

### Exemplos

```bash
./+wsd/bin/wsd loop plan --feature minha-feature
./+wsd/bin/wsd loop once --feature minha-feature --agent-cmd 'codex exec ...'
./+wsd/bin/wsd loop run --feature minha-feature --agent-cmd 'codex exec ...' --max-iterations 3
./+wsd/bin/wsd loop auto on
./+wsd/bin/wsd loop status
./+wsd/bin/wsd codex-prompt --task "minha tarefa"
./+wsd/bin/wsd codex --dry-run --task "minha tarefa"
```

### Nota de Compatibilidade

Sem quebra para projetos existentes. Rodar `./+wsd/bin/wsd update` copia `+wsd/loop/`, atualiza o CLI vendorizado e anexa os ignores locais. Para usar o loop com contrato completo, revisar ou adicionar o bloco `automation.loop` ao `+context.json` do projeto. Para receber o `WSD Codex Bootstrap` no `AGENTS.md`, projetos antigos devem atualizar o arquivo manualmente ou regenerá-lo de forma consciente, porque `wsd update` preserva `AGENTS.md`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 24. 0.4.1 — 17/06/2026

**Patch — atalhos de agente para WSD Loop e aderência do fluxo de ideias.** Esta release reduz a fricção de uso diário do Ralph/WSD Loop sem mudar o contrato de risco da `v0.4.0` e fecha gaps de descoberta da captura de ideias no Codex.

### Adicionado

- **Skills Codex no caminho atual** — `install --tools codex` agora gera `.agents/skills/*` e mantém espelho em `.codex/skills/*` para compatibilidade.
- **Skill `wsd-loop`** — mapeia pedidos curtos como `loop status`, `loop auto on`, `loop auto off`, `loop plan <feature>` para `./+wsd/bin/wsd loop ...`.
- **Prompt Codex opcional** — `templates/codex-prompts/loop.md` pode ser instalado com `./+wsd/bin/wsd codex-shortcuts install`, habilitando `/prompts:loop status` no Codex CLI.
- **Claude `/loop`** — `templates/claude-commands/commands/loop.md` permite `/loop status`, `/loop on`, `/loop off`, `/loop plan <feature>`.
- **Atalhos de shell** — `./+wsd/bin/wsd shortcuts shell` imprime funções `wsd()` e `wl()` que resolvem o Git root e evitam digitar `./+wsd/bin/wsd`.
- **Aderência do `wsd-idea` no Codex** — `templates/codex-skills/wsd-idea/SKILL.md` agora tem frontmatter `name`/`description`, e os gates validam que toda skill Codex instalável declare esses metadados.
- **Pipeline de ideias dogfooded** — `+specs/project/IDEAS_PIPELINE.md` foi sincronizado com as ideias existentes do próprio WSD e o self-check falha se o pipeline ficar placeholder enquanto `IDEAS.md` contém ideias.

### Nota de Compatibilidade

No Codex CLI, o comando customizado documentado fica no namespace `/prompts:...`; portanto o atalho literal `/loop status` é entregue no Claude Code, enquanto no Codex o caminho compartilhável é a skill `wsd-loop` e o atalho opcional é `/prompts:loop status`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 25. 0.4.2 — 21/06/2026

**Patch — pipeline de concerns e aderência de registro de preocupações.** Esta release transforma preocupações em fluxo rastreável, com foco em concerns ativas e plano de resolução até evidência.

### Adicionado

- **`CONCERNS_PIPELINE.md` obrigatório** — novo artefato em `+specs/project/` com status, etapa, plano, próximo passo, evidência, owner e data de revisão para cada concern.
- **`CONCERNS.md` reestruturado** — seção `Preocupacoes Ativas` no topo, IDs `CONC-###`, categoria, severidade, status, área/arquivo e link para o pipeline.
- **Skill Codex `wsd-concern`** — captura preocupação, risco, dívida técnica, workaround, dependência instável ou item "precisa conferir" em `CONCERNS.md` + `CONCERNS_PIPELINE.md`.
- **Claude `/concern-{PROJECT_SLUG}`** — comando slash gerado pelo installer a partir de `templates/claude-commands/commands/wsd-concern.md`.
- **Bootstrap obrigatório de concerns** — `AGENTS.md` passa a instruir leitura de `CONCERNS.md` e `CONCERNS_PIPELINE.md` antes de editar, com gatilhos explícitos de registro.
- **Visibilidade operacional** — `wsd start --brief` mostra presença do pipeline e contagem de concerns ativas; `wsd-snapshot.cjs` inclui resumo `concerns`.

### Alterado

- `scripts/wsd_check.sh` e o template instalado agora validam 7 notas obrigatórias em `+specs/project/`, incluindo `CONCERNS_PIPELINE.md`.
- Testes de instalação Codex/Claude/brownfield validam a nova nota, a skill `wsd-concern` e o comando `concern-{PROJECT_SLUG}`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 26. 0.4.3 — 21/06/2026

**Patch — fechamento limpo do `wsd finish`.** Esta release transforma o encerramento de sessão em uma aprovação operacional: o comando valida, registra, commita e só passa com worktree limpo.

### Alterado

- **`wsd finish` com commit automático** — o comando cria commit `chore(wsd): finish session` por padrão depois dos gates.
- **Handoff sem estado final sujo** — `+specs/HANDOFF.md` registra alterações capturadas pelo fechamento e estado final esperado limpo após o commit.
- **Auditoria documental WSD** — `finish` roda `scripts/wsd_docs_check.sh` quando o auditor documental está disponível na raiz do método.
- **Bloqueio de caminhos sensíveis** — paths como `.env`, `secrets`, `keys`, `certs`, `id_rsa` e `id_ed25519` impedem o commit automático.
- **Sem atalhos destrutivos** — o comando não usa `git reset`, `git stash`, `git clean`, `git commit --no-verify`, auto-push ou auto-merge.

### Adicionado

- **`test:install-finish-clean`** — instala WSD em repo temporário, cria alteração pendente, roda `./+wsd/bin/wsd finish` e exige commit de fechamento + `git status` limpo.
- **Spec `finish-clean-close`** — contrato da mudança em `+specs/features/finish-clean-close/`.

### Documentação

- README, wsd.md, docs/05, docs/08, docs/10, docs/13, docs/18, docs/19 e comandos/skills `wsd-finish` atualizados para o novo contrato.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 27. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 05/05/2026 13:29:54 -03 | Codex | `x/wsd/CHANGELOG.md` | Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes. |
| 05/05/2026 13:41:50 -03 | Codex | `x/wsd/CHANGELOG.md` | Registro da versão alpha inicial para publicação em repositório GitHub privado. |
| 05/05/2026 13:57:20 -03 | Codex | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.1-alpha` com instalador local, CLI de projeto e suporte Codex local. |
| 05/05/2026 14:13:39 -03 | Codex | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.2-alpha` com matriz de sincronização documental, checker dedicado e correção do teste de instalação. |
| 06/05/2026 — | Claude | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.3-alpha` com suporte operacional ao Claude Code. |
| 06/05/2026 — | Claude | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.4-alpha` — integração TLC Spec-Driven: `+specs/` expandido, 4 fases, auto-sizing, STATE.md/HANDOFF.md, WHEN/THEN/SHALL, TESTING.md tiered, Knowledge Chain (Regra 11), Scope Guardrail (Regra 12), Conventional Commits 1.0.0, flag `--brownfield` e novos comandos `/wsd-specify`, `/wsd-design`, `/wsd-tasks`. |
| 07/05/2026 — | Claude | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.5-alpha` — JSON Schema 2020-12 canônico para `+context.json` em `schemas/context.schema.json` + validador zero-deps `wsd-validate-context.js`. |
| 07/05/2026 — | Claude | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.6-alpha` — ghost spec detector em `wsd_check.sh` + git hooks no bootstrap. Seção 8 adicionada, Registro renumerado para seção 9. |
| 07/05/2026 — | Claude | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.7-alpha` — `wsd finish` automatizado (HANDOFF.md + prompts STATE.md). Seção 9 adicionada, Registro renumerado para seção 10. |
| 07/05/2026 — | Claude | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.8-alpha` — instalação interativa rica, `wsd update` real, WHEN+THEN+SHALL completo. Seção 10 adicionada, Registro renumerado para seção 11. |
| 07/05/2026 — | Codex | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.9-alpha` — saneamento documental operacional e classificação de `wsd_philo/` como histórico/pesquisa. Seção 11 adicionada, Registro renumerado para seção 12. |
| 07/05/2026 — | Codex | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.10-alpha` — MVP Git/GitHub Governance. Seção 12 adicionada, Registro renumerado para seção 13. |
| 07/05/2026 — | Claude | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.11-alpha` — Party Mode Integration. Seção 13 adicionada, Registro renumerado para seção 14. |
| 07/05/2026 — | Claude | `x/wsd/CHANGELOG.md` | Inclusão da release **`0.1.0`** estável — drop do sufixo `-alpha`, Fase 4 fechada, modo manutenção. Seção 14 adicionada, Registro renumerado para seção 15. |
| 11/05/2026 — | Claude | `+Apps/WSD/CHANGELOG.md` | Inclusão da versão **`0.1.2`** — ROADMAP.md, IDEAS.md, IDEAS_PIPELINE.md, skill idea-{slug}, PROJECT_SLUG, docs/15. Seção 15 adicionada, Registro renumerado para seção 16. |
| 11/05/2026 — | Claude | `+Apps/WSD/CHANGELOG.md` | Inclusão da versão **`0.1.3`** — CJS/ESM fix (.cjs), RELEASING.md, project-snapshot spec, docs/05 expandido, governance gaps fechados. Seção 16 adicionada, Registro renumerado para seção 17. |
| 12/05/2026 — | Claude (Opus 4.7) | `+Apps/WSD/CHANGELOG.md` | Inclusão da versão **`0.1.4`** (hotfix) — fix WSD-001 (templates faltantes ROADMAP/IDEAS/IDEAS_PIPELINE no wsdd) + sync wsdd dos 6 commits pendentes pós-v0.1.3 + fechamento dos gaps de governance do release v0.1.3 (README dessincronizado linha 217 + tag retroativa v0.1.3). Seção 17 adicionada, Registro renumerado para seção 18. |
| 13/05/2026 — | Claude (Opus 4.7) | `+Apps/WSD/CHANGELOG.md` | Inclusão da versão **`0.2.0`** (minor "estável adotável") — 8 features funcionais (WSD-002, WSD-003, WSD-004 L0+L1, WSD-006, WSD-007, WSD-009, WSD-010, WSD-013) + UX polish do install interativo. Resolve D-001 (Opção B+) e D-002 (Opção A). 9/9 npm test + 27/27 e2e + piloto worc validados. Seção 18 adicionada, Registro renumerado para seção 19. |
| 13/05/2026 — | Claude (Opus 4.7) | `+Apps/WSD/CHANGELOG.md` | Inclusão da versão **`0.2.1`** (patch cosmético) — mensagem "Refreshed" do `wsd update` agora reflete dinamicamente os módulos copiados (respeita `config.modules`). Bug detectado durante `./+wsd/bin/wsd update` no piloto worc logo após v0.2.0. Seção 19 adicionada, Registro renumerado para seção 20. |
| 30/05/2026 18:15:09 -03 | Codex | `+Apps/wsd/CHANGELOG.md` | Inclusão da versão **`0.3.1`** — subcomando `wsd version`, inventário multi-repo, saída JSON e gate `test:install-version`. Seção 21 adicionada, Registro renumerado para seção 22. |
| 15/06/2026 | Codex | `+Apps/wsd/CHANGELOG.md` | Inclusão da versão **`0.4.0`** — WSD Loop, Codex Adherence Pack, `automation.loop.auto_use`, prompts vendorizados, subcomandos `wsd loop`/`wsd loop auto`/`wsd codex-prompt`/`wsd codex` e gates `test:install-loop`/`test:install-codex-adherence`. |
| 17/06/2026 | Codex | `+Apps/wsd/CHANGELOG.md` | Inclusão da versão **`0.4.1`** — atalhos Codex/Claude/shell para WSD Loop, `.agents/skills`, `wsd-loop`, `/prompts:loop`, `/loop` e gates de instalação. |
| 21/06/2026 | Codex | `+Apps/wsd/CHANGELOG.md` | Inclusão da versão **`0.4.2`** — pipeline de concerns, `wsd-concern`, `/concern-{PROJECT_SLUG}`, `CONCERNS_PIPELINE.md` obrigatório e resumo de concerns em start/snapshot. |
| 21/06/2026 | Codex | `+Apps/wsd/CHANGELOG.md` | Inclusão da versão **`0.4.3`** — finish limpo, docs audit, HANDOFF, snapshot, commit automático e teste `test:install-finish-clean`. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
