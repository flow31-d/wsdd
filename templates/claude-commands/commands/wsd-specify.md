---
description: Inicia a fase Specify do WSD para uma feature. Use quando o usuário diz "wsd-specify", "especificar feature", "definir requisitos", "escrever spec", ou pede para planejar uma nova feature.
argument-hint: nome/slug da feature (ex: user-auth, payment-flow)
allowed-tools:
  - Bash
  - Read
  - Write
---

# WSD Specify

## Objetivo

Capturar O QUE construir com requisitos testáveis e rastreáveis.
Output: `+specs/features/[slug]/spec.md`.

## HARD-GATE

Não iniciar implementação, scaffolding ou código antes da spec ser aprovada pelo usuário. Sem exceções.

## Procedimento

**1. Verificar contexto:**
- Ler `+specs/project/PROJECT.md` (goals e regras)
- Ler `+specs/codebase/ARCHITECTURE.md` se existir (padrões existentes)

**2. Clarificar requirements** — uma pergunta por vez:
- "Qual problema você está resolvendo?"
- "Quem é o usuário e qual é a dor?"
- "Como é o sucesso? O que significa 'funcionar'?"
- "O que está explicitamente fora do escopo?"

Desafiar respostas vagas. "Bom" significa o quê? "Simples" como?

**3. Scope check**: se a feature cobre múltiplos subsistemas independentes, sugerir decomposição antes de prosseguir.

**4. Propor 2-3 abordagens** com trade-offs e recomendação explícita.

**5. Escrever User Stories** com prioridade P1 (MVP), P2 (should), P3 (nice-to-have). Cada story deve ser independentemente testável.

**6. Escrever Acceptance Criteria** — formato OBRIGATÓRIO:
`WHEN [evento/ação do usuário] THEN [sistema] SHALL [comportamento mensurável]`

Critérios vagos como "funcionar corretamente" ou "estar correto" são inválidos — reescrever.

**7. Salvar spec:** `+specs/features/[slug]/spec.md` (usar template feature-spec.md.template)

**8. Self-review:** verificar placeholders, contradições, ambiguidade e escopo.

**9. Apresentar spec** ao usuário seção por seção. Aguardar aprovação.

**10. Após aprovação:** oferecer continuar com `/wsd-design` ou `/wsd-tasks`.

## Knowledge Chain (obrigatória)

1. Codebase existente (código, ARCHITECTURE.md, CONVENTIONS.md)
2. Docs do projeto (README, docs/, +specs/project/)
3. Ferramentas MCP disponíveis
4. Web search (docs oficiais)
5. Flagrar incerteza — nunca inventar

## Limite

Não implementar antes da aprovação da spec.
