---
title: "Spec — Project Snapshot (v0.1.3)"
created: 2026-05-11
modified: 2026-05-11
type: spec
status: implemented
risk_level: L1
feature_slug: project-snapshot
version: v0.1.3
tags:
  - wsd
  - snapshot
  - installer
  - observabilidade
---

# Spec — Project Snapshot

## Contexto

O WSD precisava de uma forma rápida de gerar um resumo legível do estado atual do projeto —
sem abrir múltiplos arquivos — para ser consumido por agentes, usado em HANDOFF.md e
compartilhado em code reviews.

O `wsd snapshot` gera `+wsd/snapshot.json` com informações extraídas de:
`+context.json`, `+specs/project/STATE.md`, `+specs/project/ROADMAP.md`,
`+specs/project/IDEAS.md`, `+specs/project/IDEAS_PIPELINE.md`, git e o codebase.

O arquivo é ignorado no `.gitignore` (`+wsd/snapshot.json`) — é estado efêmero, não artefato versionado.
Um hook post-commit pode regenerá-lo automaticamente.

## Fora de Escopo

- Snapshot de infraestrutura remota (CI, deploys, ambientes)
- Diff entre snapshots
- Publicação do snapshot em repositório remoto

---

## Acceptance Criteria

### AC-1 — `wsd snapshot` disponível no CLI vendorizado

WHEN o operador executa `+wsd/bin/wsd snapshot` ou `wsd snapshot` (se `+wsd/bin` estiver no PATH),
THEN o comando SHALL gerar (ou atualizar) `+wsd/snapshot.json`,
SHALL imprimir confirmação: `>> +wsd/snapshot.json atualizado`.

### AC-2 — Snapshot gerado automaticamente no `wsd start`

WHEN o operador executa `wsd start` no início de uma sessão,
THEN o CLI SHALL tentar executar `wsd-snapshot.cjs` (se disponível),
SHALL prosseguir sem erro se `wsd-snapshot.cjs` não existir (compatibilidade retroativa).

### AC-3 — Conteúdo mínimo do snapshot

WHEN `wsd snapshot` é executado,
THEN `+wsd/snapshot.json` SHALL conter pelo menos:
`project_name`, `generated_at`, `git_branch`, `git_head`, `open_specs` (lista de slugs),
`roadmap_summary` (contagens por status), `ideas_count` (total de ideias capturadas).

### AC-4 — Título de snapshot limitado a 60 caracteres

WHEN o snapshot inclui títulos de specs ou ideias,
THEN cada título SHALL ser truncado a 60 caracteres máximos,
SHALL ser incluído como campo `title` ao lado do campo `slug` ou `id` para legibilidade.

### AC-5 — Compatibilidade ESM/CJS

WHEN o projeto-alvo tem `"type": "module"` em `package.json`,
THEN `wsd-snapshot.cjs` SHALL ser tratado como CommonJS pelo Node (extensão `.cjs`),
SHALL executar sem erro de `require is not defined in ES module scope`.

### AC-6 — Vendorizado pelo installer

WHEN `wsd-method install` é executado,
THEN `+wsd/bin/wsd-snapshot.cjs` SHALL existir e ser executável (`chmod 755`),
SHALL ser copiado de `templates/local-wsd/bin/wsd-snapshot.cjs`.
