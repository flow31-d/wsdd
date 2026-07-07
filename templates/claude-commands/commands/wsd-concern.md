---
description: Captura uma preocupacao, risco ou item a conferir para {{PROJECT_NAME}} em CONCERNS.md e CONCERNS_PIPELINE.md.
argument-hint: "[descreva a preocupacao ou deixe em branco para o agente perguntar]"
allowed-tools:
  - Read
  - Edit
  - Write
---

# /concern-{{PROJECT_SLUG}} — Captura de Preocupacao

## Objetivo

Registrar uma preocupacao do operador ou descoberta do agente em `+specs/project/CONCERNS.md`
e criar o plano de acompanhamento em `+specs/project/CONCERNS_PIPELINE.md`.

## HARD-GATE

Nao implementar correcao depois de capturar. A captura cria memoria e plano; execucao exige nova instrucao.

## Procedimento

1. Se o argumento veio preenchido, use-o como preocupacao. Se estiver vazio, pergunte:
   "Qual preocupacao voce quer registrar para {{PROJECT_NAME}}?"
2. Classificar categoria: `fragile-component`, `technical-debt`, `l2-area`, `known-risk`, `needs-verification`, `external-dependency` ou `workaround`.
3. Estimar severidade L0/L1/L2.
4. Ler `+specs/project/CONCERNS.md`, localizar ultimo `CONC-###` e criar o proximo ID.
5. Adicionar linha em `## Preocupacoes Ativas`.
6. Adicionar linha em `+specs/project/CONCERNS_PIPELINE.md` com status `active`, etapa, plano, proximo passo e evidencia esperada.
7. Confirmar ID, severidade, status e proximo passo.

## Regras

- Atualizar sempre os dois arquivos.
- Nunca apagar concerns antigas.
- Concern L2 exige validacao reforcada e rollback documentado antes de execucao.
- Fechamento futuro exige evidencia registrada no pipeline.
