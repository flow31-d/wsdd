---
name: wsd-concern
description: Capture a WSD concern, risk, fragile component, debt, or "preciso conferir depois" item in CONCERNS.md and CONCERNS_PIPELINE.md. Use when the user mentions preocupacao, risco, verificar depois, precisa conferir, componente fragil, divida tecnica, workaround, or an active concern to track.
---

# WSD Concern Capture

## Quando usar

Ativar quando o operador:

- Diz "preocupacao", "registrar concern", "risco", "isso me preocupa"
- Pede para "verificar depois" ou "preciso conferir"
- Aponta componente fragil, divida tecnica, workaround ou dependencia incerta
- Quer acompanhar uma preocupacao ate resolucao

## Objetivo

Registrar a concern de forma rastreavel em `+specs/project/CONCERNS.md` e criar plano em
`+specs/project/CONCERNS_PIPELINE.md`.

## HARD-GATE

Nao implementar a correcao apos capturar. A captura cria memoria e plano; execucao exige instrucao separada.

## Procedimento

1. Capturar a preocupacao fielmente.
   Se estiver vaga, perguntar uma vez: "Qual preocupacao voce quer registrar?"

2. Classificar categoria:
   - `fragile-component`
   - `technical-debt`
   - `l2-area`
   - `known-risk`
   - `needs-verification`
   - `external-dependency`
   - `workaround`

3. Estimar severidade:
   - `L0`: acompanhamento simples, baixo risco
   - `L1`: pode afetar feature, testes, arquitetura local ou manutencao
   - `L2`: producao, dados, seguranca, secrets, disponibilidade, financeiro ou mudanca irreversivel

4. Determinar proximo ID:
   Ler `+specs/project/CONCERNS.md`, localizar ultimo `CONC-###`, usar N+1.
   Se nao houver, iniciar em `CONC-001`.

5. Atualizar `+specs/project/CONCERNS.md`.
   Adicionar linha em `Preocupacoes Ativas`:

```text
| [CONC-###](CONCERNS_PIPELINE.md#pipeline) | titulo curto | categoria | L0/L1/L2 | `active` | area/arquivo | plano curto | operador/agent | AAAA-MM-DD |
```

6. Atualizar `+specs/project/CONCERNS_PIPELINE.md`.
   Adicionar linha na tabela `Pipeline`:

```text
| [CONC-###](CONCERNS.md#preocupacoes-ativas) | titulo curto | `active` | triage/spec-needed/mitigation-plan/monitoring | plano inicial | proximo passo claro | evidencia esperada | operador/agent | AAAA-MM-DD |
```

7. Confirmar ao operador:
   Informar ID, severidade, status, proximo passo e se exige spec antes de tocar.

## Regras

- Nunca apagar concerns antigas.
- Sempre atualizar `CONCERNS.md` e `CONCERNS_PIPELINE.md` juntos.
- Se severidade for L2, marcar que exige aprovacao humana antes de qualquer execucao.
- Se a concern surgir durante uma tarefa, registrar imediatamente antes de continuar.
- Para resolver, exigir evidencia no pipeline.
