---
title: "Tasks — Git/GitHub Governance MVP (v0.1.10-alpha)"
created: 07/05/2026
modified: 07/05/2026
feature: git-governance-mvp
status: in_progress
---

# Tasks — Git/GitHub Governance MVP

Tasks atomicas para implementar a `v0.1.10-alpha`.

---

## T1. Installer e settings

- [x] Adicionar parse/normalizacao de `--git-policy none|basic|full`.
- [x] Adicionar campos derivados para `git_governance`.
- [x] Adicionar pergunta interativa do modo Git Governance.
- [x] **VERIFY:** install default continua funcionando.

## T2. Contexto e schema

- [x] Atualizar `+context.json.template` com `git_governance`.
- [x] Atualizar `schemas/context.schema.json` para aceitar bloco opcional.
- [x] **VERIFY:** validator aceita installs `none`, `basic` e `full`.

## T3. AGENTS local

- [x] Atualizar `AGENTS.md.template` com secao Git/GitHub Governance.
- [x] Renderizar modo, politicas, comandos e proibicoes.
- [x] **VERIFY:** install `basic` e `full` contem comandos `wsd git`.

## T4. Templates GitHub

- [x] Criar `templates/modules/git-governance/.github/PULL_REQUEST_TEMPLATE.md`.
- [x] Criar templates de Issue `task.md`, `bug.md`, `decision.md`.
- [x] Copiar templates apenas no modo `full`.
- [x] **VERIFY:** install `full` gera `.github/`; `none` e `basic` nao geram.

## T5. CLI local `wsd git`

- [x] Adicionar namespace `git` em `templates/local-wsd/bin/wsd`.
- [x] Implementar `git doctor`.
- [x] Implementar `git preflight`.
- [x] Implementar `git pr-check`.
- [x] **VERIFY:** comandos rodam em projeto temporario.

## T6. Testes

- [x] Adicionar scripts `test:install-git-none`, `test:install-git-basic`, `test:install-git-full`.
- [x] Atualizar `npm test`.
- [x] Atualizar `scripts/wsd_self_check.sh`.
- [x] Atualizar `scripts/wsd_docs_check.sh`.
- [x] **VERIFY:** `npm test`, docs-check e self-check passam.

## T7. Sincronizacao documental

- [x] Bump `package.json` para `0.1.10-alpha`.
- [x] Atualizar README, hub, ROADMAP e CHANGELOG.
- [x] Atualizar docs/00, docs/03, docs/04, docs/05, docs/07, docs/08, docs/10, docs/11 e docs/12.
- [x] Atualizar `+specs/project/STATE.md`.
- [x] **VERIFY:** docs-check passa.

## T8. Final gate

- [x] `bash scripts/wsd_docs_check.sh`
- [x] `bash scripts/wsd_self_check.sh`
- [x] `npm test`
- [x] `git diff --check`
- [x] Revisar que `+specs/analise_party_mode_integracao.md` segue intocado e nao stageado.
