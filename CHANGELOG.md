---
title: "Changelog WSD"
created: 05/05/2026
modified: 07/05/2026
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
15. [[#15. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 05/05/2026 13:29:54 -03 — Codex: Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes.
- 05/05/2026 13:41:50 -03 — Codex: Registro da versão alpha inicial para publicação em repositório GitHub privado.
- 05/05/2026 13:57:20 -03 — Codex: Inclusão da versão `0.1.1-alpha` com instalador local, CLI de projeto e suporte Codex local.
- 05/05/2026 14:13:39 -03 — Codex: Inclusão da versão `0.1.2-alpha` com matriz de sincronização documental, checker dedicado e correção do teste de instalação.
- 06/05/2026 — Claude: Inclusão da versão `0.1.3-alpha` com suporte operacional completo ao Claude Code.
- 06/05/2026 — Claude: Inclusão da versão `0.1.4-alpha` — integração TLC (auto-sizing, STATE.md, HANDOFF.md, WHEN/THEN/SHALL, TESTING.md tiered, knowledge chain, scope guardrail, Conventional Commits, brownfield support, novos comandos `/wsd-specify`, `/wsd-design`, `/wsd-tasks`).
- 07/05/2026 — Claude: Inclusão da versão `0.1.5-alpha` — JSON Schema 2020-12 canônico para `.context.json` em `schemas/context.schema.json` + validador zero-deps `wsd-validate-context.js` integrado a `wsd_check.sh`. Fecha o último pendente da Fase 1.
- 07/05/2026 — Claude: Inclusão da versão `0.1.6-alpha` — ghost spec detector em `wsd_check.sh` + git hooks no bootstrap (`pre-commit`, `commit-msg`, `pre-push`). Fecha a Fase 3.
- 07/05/2026 — Claude: Inclusão da versão `0.1.7-alpha` — `wsd finish` automatizado: HANDOFF.md gerado pelo CLI + prompts interativos para STATE.md. Fecha o último item da Fase 3.
- 07/05/2026 — Claude: Inclusão da versão `0.1.8-alpha` — instalação interativa rica, `wsd update` real via `wsd_source`, WHEN+THEN+SHALL todos obrigatórios. Seção 10 adicionada, Registro renumerado para seção 11.
- 07/05/2026 — Codex: Inclusão da versão `0.1.9-alpha` — saneamento documental operacional, checklists de `docs/00` e `docs/12` alinhados ao estado real, `wsd_philo/` preservado como histórico/pesquisa. Seção 11 adicionada, Registro renumerado para seção 12.
- 07/05/2026 — Codex: Inclusão da versão `0.1.10-alpha` — MVP Git/GitHub Governance com `--git-policy`, `git_governance`, `wsd git doctor|preflight|pr-check`, templates PR/Issue e testes por modo. Seção 12 adicionada, Registro renumerado para seção 13.
- 07/05/2026 — Claude: Inclusão da versão `0.1.11-alpha` — Party Mode Integration: `installPartyMode`, `/wsd-party-mode`, `wsd party status|list-agents|when-to-use`, seção Party Mode no AGENTS.md, `test:install-party-mode`. Seção 13 adicionada, Registro renumerado para seção 14.
- 07/05/2026 — Claude: Inclusão da release **`0.1.0`** estável — drop do sufixo `-alpha`, Fase 4 fechada (documentação oficial, tags retroativas, validação Codex/Claude Code), 2 itens descartados com rationale (perfis stacks, YAML schema). Seção 14 adicionada, Registro renumerado para seção 15.

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
- exemplos para Exemplo SaaS A e Exemplo SaaS B.

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
- instalação vendorizada em `.wsd/`;
- `.wsd/bin/wsd` com `start`, `check`, `finish`, `doctor` e `update`;
- renderização automática de templates por perfil e overrides `--set`;
- instalação local de skills Codex em `.codex/skills`;
- teste de instalação em repositório temporário.

Ainda pendente:

- prompts interativos mais ricos;
- JSON Schema formal;
- validação YAML formal;
- Claude Code;
- teste no `exemplo-saas-b`.

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

- JSON Schema formal para `.context.json`;
- validação YAML formal para specs;
- piloto no `exemplo-saas-b`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. 0.1.3-alpha — 06/05/2026

Suporte operacional ao Claude Code.

Inclui:

- `templates/claude-commands/commands/wsd-start.md` e `wsd-finish.md` — comandos slash Claude Code com `allowed-tools`, `argument-hint` e triggers em português;
- `templates/claude-commands/hooks/pre-tool.sh` — hook `PreToolUse` que lê `forbidden_paths` do `.context.json` e bloqueia com exit 2;
- `templates/claude-commands/settings.json` — configuração de hooks `PreToolUse`, `PreCompact`, `SessionStart` e `Stop`;
- `installClaudeCommands()` no `bin/wsd-method.js` — gera `.claude/commands/`, `.wsd/hooks/pre-tool.sh` e `.claude/settings.json`;
- `--tools claude-code` e `--tools both` operacionais no instalador;
- `test:install-claude` em `package.json` para validar instalação Claude Code;
- `AGENTS.md.template` atualizado com referências a `/wsd-start` e `/wsd-finish`.

Ainda pendente:

- JSON Schema formal para `.context.json`;
- validação YAML formal para specs;
- piloto no `exemplo-saas-b`.

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

- JSON Schema formal para `.context.json` (planejado para v0.1.5-alpha);
- validação YAML formal para specs L1/L2 antigos (a maioria já migrou para spec.md MD-based).

### Validação Operacional

- ✅ Concluída em 07/05/2026 com bootstrap brownfield em projeto real: 72/72 testes do projeto + build OK + 9 acceptance criteria WHEN/THEN/SHALL atendidos.
- ✅ Bug `bin/wsd doctor` detectado e corrigido em `0d78bf2` durante a validação.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. 0.1.5-alpha — 07/05/2026

JSON Schema validation para o contrato `.context.json`. Fecha o último pendente da Fase 1 do roadmap.

### Adicionado

- `schemas/context.schema.json` — JSON Schema 2020-12 canônico (`$id: wsd/context/v1`) cobrindo `project`, `environment`, `repository`, `permissions`, `workflow`, `wsd`, `ci`. Required, types, enums fortes (`secrets_policy`, `production_mutation_policy`, `repo_type`).
- `templates/local-wsd/bin/wsd-validate-context.js` — validador pure-JS zero-deps. Suporta `type`/`required`/`properties`/`additionalProperties`/`items`/`enum`/`const`/`pattern`/`minLength`/`maxLength`/`minimum`/`maximum`/`oneOf`. Erros com path JSON-pointer.
- Vendorização: `wsd-method install` copia `schemas/` → `.wsd/schemas/` e validator → `.wsd/bin/wsd-validate-context.js` (chmod 755).
- Self-tests inline em `scripts/wsd_self_check.sh`: sample válido + 3 samples inválidos (missing required, wrong type, bad enum).
- `+specs/features/json-schema-context/` (spec WHEN/THEN/SHALL aprovada + design.md + tasks.md).

### Mudado

- `templates/repo/scripts/wsd_check.sh` chama validator após JSON syntax check (hard-fail). Fallback `warn:` quando Node ausente.
- `templates/local-wsd/bin/wsd doctor` reporta `.wsd/schemas/context.schema.json`, `.wsd/bin/wsd-validate-context.js` e presença de `node`.
- `npm test` (`test:install`, `test:install-claude`, `test:install-brownfield`) assertam vendor + validação do `.context.json` renderizado.
- `scripts/wsd_docs_check.sh` exige documentação do schema em `docs/05` e `docs/10`.

### Documentação

- `docs/05_contrato_artefatos.md` — nova subseção "Schema canônico (v0.1.5-alpha)".
- `docs/10_matriz_sincronizacao_notas.md` — schema + validator em "Fontes de Verdade" e "Matriz Obrigatória".

### Validação

- ✅ `npm test`: 3/3 gates passam com schema validation acoplada.
- ✅ Todos os 4 profiles (`generic_node_frontend`, `generic_python_api`, `exemplo_saas_b`, `exemplo_saas_a`) renderizam `.context.json` que valida.
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

**Subcomando `wsd hooks`** no CLI local (`.wsd/bin/wsd`):

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

- Pergunta linguagem principal do projeto (preenche `PRIMARY_LANGUAGE` no `.context.json`).
- Pergunta path canônico do projeto (preenche `CANONICAL_PATH`).
- Pergunta comandos de test, build e lint — padrão vem do perfil; Enter mantém o padrão.
- Pergunta forbidden_paths em CSV — padrão vem do perfil.
- Todas as perguntas são puladas com `--yes`.

**`wsd update` real** (em `templates/local-wsd/bin/wsd` e `bin/wsd-method.js`):

- `wsd-method install` grava `wsd_source: WSD_ROOT` em `.wsd/config.json`.
- `wsd update` lê `wsd_source` com `python3 -c "import json..."` e chama `node $src/bin/wsd-method.js update --directory .`.
- `update()` no CLI principal: atualiza `.wsd/bin/`, `.wsd/hooks/`, `.wsd/schemas/` sem tocar em arquivos do projeto; atualiza `config.json` mantendo campos existentes.
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
- Bloco `git_governance` no `.context.json` renderizado pelo template.
- Secao Git/GitHub Governance no `AGENTS.md` renderizado.
- Namespace local `./.wsd/bin/wsd git doctor|preflight|pr-check`.
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

- `installPartyMode(directory, force)` em `bin/wsd-method.js` — copia `party-mode/` para `.wsd/party-mode/` no projeto instalado.
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

## 15. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 05/05/2026 13:29:54 -03 | Codex | `x/wsd/CHANGELOG.md` | Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes. |
| 05/05/2026 13:41:50 -03 | Codex | `x/wsd/CHANGELOG.md` | Registro da versão alpha inicial para publicação em repositório GitHub privado. |
| 05/05/2026 13:57:20 -03 | Codex | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.1-alpha` com instalador local, CLI de projeto e suporte Codex local. |
| 05/05/2026 14:13:39 -03 | Codex | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.2-alpha` com matriz de sincronização documental, checker dedicado e correção do teste de instalação. |
| 06/05/2026 — | Claude | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.3-alpha` com suporte operacional ao Claude Code. |
| 06/05/2026 — | Claude | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.4-alpha` — integração TLC Spec-Driven: `+specs/` expandido, 4 fases, auto-sizing, STATE.md/HANDOFF.md, WHEN/THEN/SHALL, TESTING.md tiered, Knowledge Chain (Regra 11), Scope Guardrail (Regra 12), Conventional Commits 1.0.0, flag `--brownfield` e novos comandos `/wsd-specify`, `/wsd-design`, `/wsd-tasks`. |
| 07/05/2026 — | Claude | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.5-alpha` — JSON Schema 2020-12 canônico para `.context.json` em `schemas/context.schema.json` + validador zero-deps `wsd-validate-context.js`. |
| 07/05/2026 — | Claude | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.6-alpha` — ghost spec detector em `wsd_check.sh` + git hooks no bootstrap. Seção 8 adicionada, Registro renumerado para seção 9. |
| 07/05/2026 — | Claude | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.7-alpha` — `wsd finish` automatizado (HANDOFF.md + prompts STATE.md). Seção 9 adicionada, Registro renumerado para seção 10. |
| 07/05/2026 — | Claude | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.8-alpha` — instalação interativa rica, `wsd update` real, WHEN+THEN+SHALL completo. Seção 10 adicionada, Registro renumerado para seção 11. |
| 07/05/2026 — | Codex | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.9-alpha` — saneamento documental operacional e classificação de `wsd_philo/` como histórico/pesquisa. Seção 11 adicionada, Registro renumerado para seção 12. |
| 07/05/2026 — | Codex | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.10-alpha` — MVP Git/GitHub Governance. Seção 12 adicionada, Registro renumerado para seção 13. |
| 07/05/2026 — | Claude | `x/wsd/CHANGELOG.md` | Inclusão da versão `0.1.11-alpha` — Party Mode Integration. Seção 13 adicionada, Registro renumerado para seção 14. |
| 07/05/2026 — | Claude | `x/wsd/CHANGELOG.md` | Inclusão da release **`0.1.0`** estável — drop do sufixo `-alpha`, Fase 4 fechada, modo manutenção. Seção 14 adicionada, Registro renumerado para seção 15. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
