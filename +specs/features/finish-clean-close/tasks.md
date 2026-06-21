---
title: "Tasks — Finish Clean Close"
created: 2026-06-21
modified: 2026-06-21
status: implemented
risk: L1
owner: Codex
---

# Tasks — Finish Clean Close

## Implementacao

- [x] Adicionar parsing de opcoes para `wsd finish`.
- [x] Rodar gates de aprovacao antes do fechamento.
- [x] Rodar auditoria documental WSD quando disponivel.
- [x] Regerar `HANDOFF.md` com estado final limpo esperado.
- [x] Auto-commitar fechamento por padrao.
- [x] Bloquear paths sensiveis antes de `git add -A`.
- [x] Validar que o estado final esta limpo.

## Testes

- [x] Adicionar `test:install-finish-clean`.
- [x] Incluir o teste no `npm test`.
- [x] Atualizar `wsd_self_check.sh` para proteger o contrato.

## Documentacao

- [x] Atualizar README/wsd/CHANGELOG/ROADMAP.
- [x] Atualizar docs/08 e docs/18.
- [x] Atualizar docs de publicacao e matriz de sincronizacao.
- [x] Atualizar skill Codex e comando Claude `wsd-finish`.

## Release

- [x] Bump para `v0.4.3`.
- [x] Rodar gates completos.
- [x] Publicar privado e sincronizar `wsdd` publico.
