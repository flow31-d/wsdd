---
title: "Tasks — Project ROADMAP (v0.1.1)"
created: 2026-05-11
modified: 2026-05-11
type: tasks
status: implemented
feature_slug: project-roadmap
tags:
  - wsd
  - roadmap
---

# Tasks — Project ROADMAP

Referência: `+specs/features/project-roadmap/spec.md`

---

## T1 — Criar `templates/specs/ROADMAP.md.template`

- [x] Criar arquivo `templates/specs/ROADMAP.md.template`
- [x] Conteúdo: cabeçalho com `{{project_name}}`, legenda de status, tabela Features Ativas, Backlog, Concluídas, Descartadas, bloco Instruções para Agentes
- [x] Verificar que o markdown é válido com qualquer valor de `{{project_name}}`

Cobre: AC-1, AC-2

---

## T2 — Atualizar `bin/wsd-method.js` para copiar ROADMAP.md no install

- [x] Localizar a função que copia `STATE.md` e `PROJECT.md` para `+specs/project/`
- [x] Adicionar cópia de `templates/specs/ROADMAP.md.template` → `+specs/project/ROADMAP.md` com renderização de `{{project_name}}`
- [x] Garantir que a cópia ocorre em greenfield e brownfield (sem flag especial)
- [x] Registrar no log de instalação: `created +specs/project/ROADMAP.md`

Cobre: AC-1, AC-2

---

## T3 — Atualizar `scripts/wsd_check.sh` para gate L1/L2

- [x] Localizar seção de verificação de artefatos obrigatórios em `wsd_check.sh`
- [x] Adicionar: se `risk_level` for L1 ou L2 e `+specs/project/ROADMAP.md` ausente → `warn: ROADMAP.md não encontrado em +specs/project/`
- [x] Confirmar que L0 não dispara o warn

Cobre: AC-5

---

## T4 — Atualizar `templates/repo/AGENTS.md.template`

- [x] Localizar seção de artefatos de projeto no template
- [x] Adicionar `+specs/project/ROADMAP.md` como artefato obrigatório de planejamento
- [x] Adicionar regra: ao mudar status de feature, atualizar frontmatter da spec E linha no ROADMAP.md

Cobre: AC-4

---

## T5 — Atualizar `/wsd-specify` para instruir manutenção do ROADMAP.md

- [x] Localizar `templates/claude-commands/commands/wsd-specify.md` (ou equivalente Codex)
- [x] Adicionar instrução na seção de encerramento: após criar spec, adicionar linha em `+specs/project/ROADMAP.md` com status `specified` e link para a nova spec
- [x] Verificar que a instrução é clara e acionável pelo agente sem ambiguidade

Cobre: AC-3

---

## T6 — Atualizar `npm test` para verificar ROADMAP.md

- [x] Em `test:install` (Codex): adicionar `test -f "$tmpdir/+specs/project/ROADMAP.md"` na cadeia de assertions
- [x] Em `test:install-claude`: idem
- [x] Em `test:install-brownfield`: idem
- [x] Confirmar que `npm test` falha se o arquivo estiver ausente

Cobre: AC-6

---

## T7 — Sync documental

- [x] `CHANGELOG.md`: adicionar seção `0.1.1` com descrição da feature
- [x] `ROADMAP.md` (WSD próprio): marcar `project-roadmap` como entregue com `[x]`
- [x] `README.md`: atualizar versão para `v0.1.1` e mencionar ROADMAP.md na lista de artefatos instalados
- [x] `docs/05_contrato_artefatos.md`: adicionar `+specs/project/ROADMAP.md` na lista de artefatos padrão
- [x] `docs/10_matriz_sincronizacao_notas.md`: adicionar linha para ROADMAP.md como artefato derivado do installer
- [x] `+specs/project/STATE.md` (WSD próprio): registrar decisão e marcar task como concluída

Cobre: consistência documental (ver [[wsd/docs/10_matriz_sincronizacao_notas|Matriz de Sincronização]])

---

## T8 — Bump de versão

- [x] `package.json`: `0.1.0` → `0.1.1`
- [x] Confirmar que `npm test` (7 gates + novo gate ROADMAP.md) passa com 8/8

Cobre: release patch

---

## Ordem de Execução

```
T1 → T2 → T3 → T4 → T5 → T6 → T7 → T8
```

T1 deve vir primeiro (template precisa existir antes de referenciar no installer).
T2 depende de T1. T3, T4 e T5 são independentes entre si após T1.
T6 depende de T2 (o arquivo precisa ser gerado para o teste verificar).
T7 e T8 sempre por último — sync documental e bump só após tudo testado.
