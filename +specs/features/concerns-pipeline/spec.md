---
title: "Spec — Concerns Pipeline (v0.4.2)"
created: 2026-06-21
modified: 2026-06-21
type: spec
status: implemented
implementation_status: implemented
severity: L1
risk_level: L1
risk: L1
feature_slug: concerns-pipeline
version: v0.4.2
tags:
  - wsd
  - concerns
  - governance
  - agents
---

# Spec — Concerns Pipeline

## Contexto

O WSD ja gera `+specs/project/CONCERNS.md`, mas agentes ainda tratam preocupacoes como contexto opcional. Na pratica, riscos, coisas a conferir e fragilidades aparecem durante a execucao e nem sempre sao registrados. Isso cria perda de memoria operacional.

Esta feature torna concerns um fluxo explicito: registrar preocupacoes com ID, manter foco nas ativas e acompanhar um pipeline de resolucao ate evidencia final.

## Fora de Escopo

- Resolver automaticamente todas as preocupacoes existentes.
- Criar issue/PR no GitHub para cada concern.
- Bloquear qualquer edicao apenas por existir concern ativa.
- Substituir `STATE.md` para bloqueadores de sessao.

---

## Acceptance Criteria

### AC-1 — Artefato `CONCERNS_PIPELINE.md`

WHEN um projeto e instalado,
THEN o projeto SHALL receber `+specs/project/CONCERNS_PIPELINE.md`,
AND `scripts/wsd_check.sh --risk L0` SHALL exigir esse arquivo junto das demais notas de projeto.

### AC-2 — `CONCERNS.md` foca preocupacoes ativas

WHEN `CONCERNS.md` e gerado,
THEN o documento SHALL conter uma secao `Preocupacoes Ativas` no topo,
AND cada concern SHALL usar ID `CONC-###`, categoria, severidade, status, owner e link para plano.

### AC-3 — Pipeline detalha plano de resolucao

WHEN uma concern e registrada,
THEN `CONCERNS_PIPELINE.md` SHALL receber uma linha com ID, status, etapa, plano, proximo passo, gate/evidencia, owner e data de revisao,
AND o status SHALL permitir acompanhar `active`, `triaged`, `mitigating`, `verifying`, `resolved`, `accepted-risk` ou `obsolete`.

### AC-4 — Agentes recebem gatilhos explicitos

WHEN um agente inicia uma sessao WSD,
THEN `AGENTS.md` SHALL instruir leitura de `CONCERNS.md` e `CONCERNS_PIPELINE.md` antes de editar,
AND SHALL listar gatilhos obrigatorios para registrar concern: fragilidade encontrada, duvida a conferir, risco de regressao, area L2, debt descoberta, workaround ou dependencia externa instavel.

### AC-5 — Captura por skill/comando

WHEN o usuario disser "preocupacao", "preciso conferir", "registrar risco", "verificar depois" ou equivalente,
THEN Codex SHALL ter skill `wsd-concern`,
AND Claude Code SHALL receber comando `concern-{PROJECT_SLUG}`,
AND ambos SHALL atualizar `CONCERNS.md` e `CONCERNS_PIPELINE.md` sem iniciar implementacao.

### AC-6 — Visibilidade operacional

WHEN `./+wsd/bin/wsd start --brief` ou `+wsd/snapshot.json` forem usados,
THEN o estado de concerns SHALL ficar visivel com presenca dos arquivos e contagem por status quando possivel.

### AC-7 — Gates cobrem a regressao

WHEN `npm test`, `wsd_self_check` ou `wsd_docs_check` rodam,
THEN eles SHALL validar templates, skills, comandos e instalacao do fluxo de concerns.
