---
title: "Tasks — Project Snapshot (v0.1.3)"
created: 2026-05-11
modified: 2026-05-11
type: tasks
status: implemented
feature_slug: project-snapshot
tags:
  - wsd
  - snapshot
---

# Tasks — Project Snapshot

Referência: `+specs/features/project-snapshot/spec.md`

> **Nota:** Esta spec e tasks são retroativas. A feature foi implementada durante o desenvolvimento
> da v0.1.2/v0.1.3 e documentada formalmente em 11/05/2026.

---

## T1 — Criar `templates/local-wsd/bin/wsd-snapshot.cjs`

- [x] Criar o script Node.js (CommonJS) que lê `+context.json`, `STATE.md`, `ROADMAP.md`, `IDEAS.md`, `IDEAS_PIPELINE.md` e dados git
- [x] Gerar `+wsd/snapshot.json` com campos: `project_name`, `generated_at`, `git_branch`, `git_head`, `open_specs`, `roadmap_summary`, `ideas_count`
- [x] Truncar títulos a 60 caracteres
- [x] Usar extensão `.cjs` para compatibilidade com projetos `"type": "module"`

Cobre: AC-1, AC-3, AC-4, AC-5

---

## T2 — Integrar `wsd start` para rodar snapshot automaticamente

- [x] No comando `start` do CLI vendorizado (`templates/local-wsd/bin/wsd`), adicionar tentativa de execução de `+wsd/bin/wsd-snapshot.cjs`
- [x] Usar `|| true` para não bloquear se o script falhar ou não existir

Cobre: AC-2

---

## T3 — Expor `wsd snapshot` como subcomando

- [x] Adicionar case `snapshot)` no CLI vendorizado
- [x] Verificar existência de `+wsd/bin/wsd-snapshot.cjs` antes de executar
- [x] Emitir `FAIL:` com instrução de reinstalação se ausente

Cobre: AC-1

---

## T4 — Atualizar installer para copiar `wsd-snapshot.cjs`

- [x] Em `bin/wsd-method.js` (função `installVendor`): copiar `templates/local-wsd/bin/wsd-snapshot.cjs` → `+wsd/bin/wsd-snapshot.cjs`
- [x] Aplicar `chmod 755`
- [x] Aplicar em greenfield e brownfield (ambas as funções de install)

Cobre: AC-6

---

## T5 — Adicionar `+wsd/snapshot.json` ao `.gitignore`

- [x] Template `.gitignore` ou instrução no installer para excluir `+wsd/snapshot.json`
- [x] Confirmar que `+wsd/.last-check.json` também está excluído

Cobre: artefato efêmero não versionado

---

## T6 — Fix CJS/ESM: renomear `wsd-validate-context.js` → `.cjs`

- [x] Renomear `templates/local-wsd/bin/wsd-validate-context.js` → `wsd-validate-context.cjs`
- [x] Atualizar todas as referências: `bin/wsd-method.js`, `scripts/wsd_self_check.sh`, `scripts/wsd_docs_check.sh`, `templates/repo/scripts/wsd_check.sh`, `templates/local-wsd/bin/wsd`, `package.json`
- [x] Confirmar que `npm test` (7/7) passa com a renomeação

Cobre: AC-5 (mesma correção aplicada ao `wsd-validate-context`)

---

## Ordem de Execução

```
T1 → T2 → T3    (implementação do script e integração no CLI)
T4               (installer — depende de T1)
T5               (gitignore — independente)
T6               (fix CJS — independente, pode ser paralelo)
```
