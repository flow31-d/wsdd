---
description: Captura uma nova ideia para {{PROJECT_NAME}} e registra em IDEAS.md e IDEAS_PIPELINE.md. Use quando o operador diz "tenho uma ideia", "quero registrar uma ideia", "nova ideia" ou invoca diretamente.
argument-hint: "[descreva sua ideia brevemente, ou deixe em branco para o agente perguntar]"
allowed-tools:
  - Read
  - Edit
  - Write
---

# /idea-{{PROJECT_SLUG}} — Captura de Ideia

## Objetivo

Registrar a ideia do operador em `+specs/project/IDEAS.md` de forma estruturada e fiel,
atualizar `+specs/project/IDEAS_PIPELINE.md` com resumo e sugestão de etapa,
e — opcionalmente — acionar o Party Mode para debater a ideia antes de virar spec.

## HARD-GATE

Não interpretar, refinar, julgar ou questionar a viabilidade da ideia neste momento.
A missão é capturar com fidelidade. Análise e triagem acontecem em outro momento.

---

## Procedimento

**1. Capturar a ideia**

Se o operador passou a ideia como argumento, use-a diretamente.
Se não, pergunte: *"Qual é a sua ideia para {{PROJECT_NAME}}?"*

**2. Capturar motivação** (se não estiver clara na descrição)

Pergunte apenas uma vez: *"Por que isso importa? O que te motivou?"*
Se o operador não quiser elaborar, registre "Não especificada".

**3. Determinar o próximo ID**

- Ler `+specs/project/IDEAS.md`
- Localizar o último `## IDEA-{N}` no arquivo
- Próximo ID = N + 1, formatado como 3 dígitos (IDEA-001, IDEA-012, IDEA-100)
- Se não houver ideias ainda, começar em IDEA-001

**4. Escrever em `+specs/project/IDEAS.md`**

Acrescentar ao final do arquivo, após o último `---`:

```
## IDEA-{N} — {título em uma linha, máx 80 chars}

**Data:** {data atual no formato DD/MM/AAAA}
**Motivação:** {motivação capturada — fiel à voz do operador}
**Descrição:** {descrição completa — fiel à voz do operador, sem editar}
**Impacto esperado:** {o que muda para o usuário ou sistema — inferir se não explicitado}
**Status:** `raw`

---
```

**5. Estimar complexidade**

Com base no escopo descrito, estimar:
- **L0**: mudança trivial, risco baixo, escopo claro → task card direto
- **L1**: feature nova, escopo moderado → `/wsd-specify` + `ROADMAP.md`
- **L2**: mudança estrutural ou múltiplos subsistemas → `/wsd-specify` + `/wsd-design` + `ROADMAP.md`

**6. Atualizar `+specs/project/IDEAS_PIPELINE.md`**

Adicionar linha na tabela Pipeline:

```
| [IDEA-{N}](IDEAS.md#idea-{n-com-hifens}) | {título ≤ 60 chars} | `raw` | {L0/L1/L2 — etapa} | — | — |
```

**7. Oferecer Party Mode** (se L1 ou L2)

Se a estimativa for L1 ou L2, perguntar:

> *"Esta ideia é de nível {L1/L2}. Quer rodar o Party Mode agora para debatê-la com múltiplos agentes antes de virar spec? (`/wsd-party-mode` — arquiteto, dev, QA, UX, PM debatem a ideia)"*

- Se **sim**: orientar o operador a invocar `/wsd-party-mode` e informar que o debate pode revelar riscos e trade-offs antes da spec formal.
- Se **não**: continuar normalmente para a confirmação final.

> [!note] O Party Mode não substitui o `/wsd-specify` — ele precede. Use-o quando a ideia é nova o suficiente para se beneficiar de perspectivas múltiplas antes de formalizar os WHEN/THEN/SHALL.

**8. Confirmar ao operador**

```
✓ Ideia IDEA-{N} — "{título}" registrada em IDEAS.md.
  Estimativa: {L0/L1/L2}
  Sugestão de próxima etapa: {etapa sugerida}
  Quando quiser avançar: {/wsd-party-mode (se L1/L2) → /wsd-specify → ROADMAP.md}
```

---

## Regras

- Nunca sobrescrever ou editar ideias existentes — apenas acrescentar
- Sempre incrementar o ID com base no último existente no arquivo
- Ser fiel à voz do operador — não melhorar, não resumir além do necessário
- A sugestão de etapa é orientativa — o operador decide quando e como avançar
- Não iniciar implementação, spec ou design após capturar a ideia (aguardar instrução)
- Oferecer Party Mode apenas para L1 e L2 — L0 não tem complexidade suficiente para debate
