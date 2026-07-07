---
title: "Roadmap WSD"
created: 05/05/2026
modified: 2026-07-07
tags:
  - wsd
  - roadmap
status: ativo
tipo: nota
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/README]], [[wsd/CHANGELOG]], [[wsd/docs/10_matriz_sincronizacao_notas]]"
---
# Roadmap WSD

Versão atual: **`v0.5.1`**.

O roadmap operacional vivo (features ativas, backlog, concluídas) tem **fonte
única** em [`+specs/project/ROADMAP.md`](+specs/project/ROADMAP.md) — gere a
visão consolidada com `./+wsd/bin/wsd relatorio`.

## Fases históricas (concluídas)

1. **Fase 1 — Aprimorar o WSD**: série `v0.1.x-alpha` (05–07/05/2026).
2. **Fase 2 — Validação brownfield real**: 07/05/2026.
3. **Fase 3 (+3.5 Party Mode) — Ajustes pós-validação**: 07/05/2026.
4. **Fase 4 — Release estável `v0.1.0`**: 07/05/2026.
5. **Fase 5 — Estável adotável**: `v0.2.0` → `v0.4.8` (13/05–21/06/2026).
6. **Fase 6 — Lean core + full-auto**: `v0.5.0` (07/07/2026) — fonte única de
   histórico, AGENTS lean com guias on-demand, compactação de memória,
   snapshot como fonte de leitura, superfície de comandos reduzida,
   `approval_mode=full_auto`, gate de doc drift (`docs-map.json`).

Detalhes de cada fase: [CHANGELOG.md](CHANGELOG.md) e
[CHANGELOG_ARCHIVE.md](CHANGELOG_ARCHIVE.md). O plano detalhado das fases
antigas foi arquivado em `archive/historico_notas_2026H1.md`.

## Próximas frentes (candidatas)

Fonte: [`+specs/project/IDEAS_PIPELINE.md`](+specs/project/IDEAS_PIPELINE.md).
Destaques: auto-PR do WSD Loop (IDEA-001), dashboard de runs (IDEA-002),
sandbox forte AFK (IDEA-003), adapters multi-agente (IDEA-004), checkpoints L2
assistidos (IDEA-005), adapter de hooks Codex (IDEA-006).

## Regra de sincronização

Mudou versão/release → atualizar `package.json`, `CHANGELOG.md` e a linha de
versão de `README.md`/`wsd.md`/este arquivo. Nada além disso duplica histórico.
Antes de finalizar: `bash scripts/wsd_docs_check.sh`.
