# Skill: wsd-idea — Captura de Ideia

## Quando usar

Ativar quando o operador:
- Diz "tenho uma ideia", "quero registrar uma ideia", "nova ideia para o projeto"
- Menciona algo que gostaria que o sistema fizesse mas não é uma tarefa imediata
- Pede para capturar um pensamento para implementação futura

## Objetivo

Registrar a ideia do operador em `+specs/project/IDEAS.md` de forma estruturada e fiel,
e atualizar `+specs/project/IDEAS_PIPELINE.md` com resumo e sugestão de próxima etapa.

## HARD-GATE

Não interpretar, refinar, julgar ou questionar a viabilidade da ideia.
A missão é capturar com fidelidade. Análise acontece em outro momento.

## Comportamento esperado



**1. Capturar a ideia**
Se o operador já descreveu a ideia, use-a. Se não, pergunte:
*"Qual é a sua ideia para o projeto?"*

**2. Capturar motivação** (se não estiver clara)
Pergunte apenas uma vez: *"O que te motivou? Por que isso importa?"*
Se o operador não elaborar, registre "Não especificada".

**3. Determinar próximo ID**
Ler `+specs/project/IDEAS.md`, localizar o último `## IDEA-{N}`, usar N+1.
Se não houver ideias ainda, começar em IDEA-001. Formato: 3 dígitos.

**4. Escrever em `+specs/project/IDEAS.md`**

Acrescentar ao final do arquivo:

```
## IDEA-{N} — {título em uma linha, máx 80 chars}

**Data:** {DD/MM/AAAA}
**Motivação:** {motivação capturada}
**Descrição:** {fiel à voz do operador}
**Impacto esperado:** {o que muda para o usuário ou sistema}
**Status:** `raw`

---
```

**5. Estimar complexidade**
- L0: mudança trivial, risco baixo → task card direto
- L1: feature nova, escopo moderado → wsd-specify + ROADMAP.md
- L2: mudança estrutural → wsd-specify + wsd-design + ROADMAP.md

**6. Atualizar `+specs/project/IDEAS_PIPELINE.md`**
Adicionar linha na tabela Pipeline com: ID linkado, título resumido (≤ 60 chars),
status `raw`, etapa sugerida, campo WSD artefato vazio.

**7. Oferecer Party Mode** (se L1 ou L2)
Se a estimativa for L1 ou L2, perguntar:
*"Quer rodar o Party Mode para debater esta ideia com múltiplos agentes (arquiteto, dev, QA, UX, PM) antes de virar spec?"*
- Se sim: orientar a invocar `/wsd-party-mode` (Claude Code) ou a skill equivalente.
- Se não: continuar para a confirmação.

**8. Confirmar ao operador**
Informar: ID atribuído, título registrado, estimativa L0/L1/L2, sugestão de próxima etapa.

## Regras

- Nunca sobrescrever ou editar ideias existentes — apenas acrescentar
- Sempre incrementar o ID baseado no último existente
- Fiel à voz do operador — não melhorar, não resumir além do necessário
- Não iniciar implementação, spec ou design após capturar (aguardar instrução)
- Sugestão de etapa é orientativa — operador decide quando avançar
