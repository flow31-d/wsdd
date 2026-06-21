---
title: "Tasks — Concerns Pipeline (v0.4.2)"
created: 2026-06-21
modified: 2026-06-21
type: tasks
status: implemented
feature_slug: concerns-pipeline
version: v0.4.2
tags:
  - wsd
  - concerns
  - governance
---

# Tasks — Concerns Pipeline

Referência: `+specs/features/concerns-pipeline/spec.md`

---

## T1 — Artefatos de projeto

- [x] Reestruturar `CONCERNS.md.template` com foco em preocupacoes ativas.
- [x] Criar `CONCERNS_PIPELINE.md.template`.
- [x] Atualizar os artefatos reais do WSD em `+specs/project/`.

Cobre: AC-1, AC-2, AC-3

## T2 — Regras de agente

- [x] Atualizar `AGENTS.md.template` e `AGENTS.md` com leitura obrigatoria e gatilhos de registro.
- [x] Atualizar skills base `wsd` e `wsd-start`.

Cobre: AC-4

## T3 — Captura de concern

- [x] Criar skill Codex `wsd-concern`.
- [x] Criar comando Claude `wsd-concern.md`.
- [x] Fazer o installer renomear para `concern-{PROJECT_SLUG}.md`.

Cobre: AC-5

## T4 — Visibilidade e snapshot

- [x] Fazer `start --brief` exibir concerns/pipeline e contagem ativa.
- [x] Fazer `wsd-snapshot.cjs` incluir resumo de concerns.

Cobre: AC-6

## T5 — Gates e docs

- [x] Atualizar checks de instalacao, docs-check, self-check e package tests.
- [x] Atualizar README, hub, docs/05, docs/08, docs/10, docs/13, CHANGELOG e ROADMAP.

Cobre: AC-1 a AC-7
