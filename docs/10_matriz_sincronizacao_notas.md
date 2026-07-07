---
title: "10 — Matriz de Sincronização de Notas WSD"
created: 05/05/2026
modified: 2026-07-07
tags:
  - wsd
  - sincronizacao
status: ativo
tipo: guia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/README]], [[wsd/CHANGELOG]], [[wsd/AGENTS]]"
---
# 10 — Matriz de Sincronização de Notas WSD

Objetivo: impedir que o WSD evolua em um arquivo e fique desatualizado em outro
— **sem duplicar conteúdo**. Desde a v0.5.0 (lean-core), histórico vive só em
git + `CHANGELOG.md`; esta matriz cobre apenas dependências estruturais reais.
O gate automático é `bash scripts/wsd_docs_check.sh` (coerência) +
`bash scripts/wsd_drift_check.sh` (código→doc via `docs-map.json`).

## Regra central

Antes de finalizar, responda: o que mudou (versão, instalador, regra, template,
skill, release)? Qual arquivo é a fonte de verdade? O que precisa acompanhar?
Rode os checkers. Nada de copiar texto entre notas — referencie.

## Matriz

| Se alterar | Deve acompanhar |
|---|---|
| `package.json` `version` (release) | `CHANGELOG.md` (entrada nova) + linha "Versão atual" em README/wsd.md/ROADMAP + tag git |
| `bin/wsd-method.js` (installer) | docs/00, docs/04, `npm test` |
| `templates/local-wsd/bin/wsd` (CLI) | docs/08, docs/18, testes de instalação |
| `templates/local-wsd/bin/wsd-report.cjs` | docs/08, docs/17, `test:install-relatorio` |
| `templates/local-wsd/bin/wsd-snapshot.cjs` | docs/16, docs/17 |
| `templates/local-wsd/loop/` ou contrato `automation.loop` | docs/19, schema, template de contexto |
| `templates/local-wsd/guides/` | AGENTS.md.template (tabela de guias), docs/08 |
| `templates/repo/AGENTS.md.template` | docs/05, docs/08, limite de 150 linhas (gate) |
| `templates/repo/+context.json.template` ou `schemas/context.schema.json` | docs/05, validador, `npm test` |
| `templates/codex-skills/` ou `templates/claude-commands/` | docs/08 ou docs/13, installer |
| `templates/git-hooks/` ou `templates/modules/git-governance/` | docs/07 ou docs/11 |
| `profiles/` | docs/06 |
| Regra para agentes (AGENTS.md raiz) | AGENTS.md.template quando a regra valer para projetos |
| Release/publicação pública | RELEASING.md, docs/09, docs/15 |

O mapa machine-readable equivalente está em `docs-map.json` — mantenha os dois
alinhados ao adicionar linhas.

## Validação

```bash
bash scripts/wsd_docs_check.sh
bash scripts/wsd_self_check.sh
npm test   # quando tocar installer/CLI/templates
```
