---
title: "Feature — Finish Clean Close"
created: 2026-06-21
modified: 2026-06-21
status: implemented
risk: L1
owner: Codex
version: v0.4.3
---

# Feature — Finish Clean Close

## Contexto

O `wsd finish` foi criado para encerrar sessoes com relatorio e `HANDOFF.md`,
mas o fluxo antigo gerava o proprio handoff sem fechar o estado Git. Na pratica,
o proximo agente via `HANDOFF.md` avisando que a sessao anterior terminou com
worktree suja, mesmo quando a intencao do operador era encerrar tudo.

## Objetivo

Transformar `wsd finish` em fechamento completo: rodar gates, revisar docs WSD
quando o auditor estiver disponivel, gerar handoff/snapshot e terminar com o
worktree limpo. Se nao for possivel aprovar e fechar, o comando deve falhar de
forma explicita.

## Escopo

- `templates/local-wsd/bin/wsd`
- Skills/comandos `wsd-finish`
- Testes de instalacao
- Documentacao central do WSD

## Fora de Escopo

- Auto-push para remoto
- Auto-merge de PR
- Ignorar hooks Git ou commitar com `--no-verify`
- Passar por cima de gates que falham

## Acceptance Criteria

### AC-1 — Finish termina limpo

GIVEN um projeto WSD instalado com Git configurado
AND existem alteracoes pendentes
WHEN `./+wsd/bin/wsd finish` roda com sucesso
THEN o comando SHALL criar commit de fechamento
AND `git status --short` SHALL ficar vazio.

### AC-2 — Gates antes de aprovar

GIVEN um projeto WSD
WHEN `wsd finish` e executado
THEN o comando SHALL rodar `git diff --check`
AND SHALL rodar `scripts/wsd_check.sh --risk L0 .` quando disponivel
AND SHALL rodar auditoria documental WSD quando `scripts/wsd_docs_check.sh` ou
`+wsd/scripts/wsd_docs_check.sh` estiver disponivel junto dos docs.

### AC-3 — Handoff nao relata sujeira como estado final

GIVEN `wsd finish` cria `+specs/HANDOFF.md`
WHEN havia alteracoes antes do fechamento
THEN o handoff SHALL registrar as alteracoes como pendentes capturadas pelo
fechamento
AND SHALL registrar que o estado final esperado e limpo apos commit.

### AC-4 — Sem override inseguro

GIVEN gates falham, hooks falham ou paths sensiveis aparecem no estado Git
WHEN `wsd finish` e executado
THEN o comando SHALL falhar
AND SHALL explicar o motivo
AND SHALL NOT usar `--no-verify`, `git reset`, `git stash` ou `git clean`.

### AC-5 — Documentacao sincronizada

GIVEN a release v0.4.3
WHEN docs check roda
THEN README, wsd.md, CHANGELOG, docs/08, docs/18, docs/09, docs/10 e artefatos
de agente SHALL descrever o novo contrato do `wsd finish`.
