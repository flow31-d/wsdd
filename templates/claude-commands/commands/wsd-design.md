---
description: Fase Design do WSD. Use quando o usuário diz "wsd-design", "desenhar arquitetura", "design da feature", ou pede um documento de design para uma spec aprovada.
argument-hint: slug da feature (ex: user-auth)
allowed-tools:
  - Bash
  - Read
  - Write
---

# WSD Design

## Objetivo

Traduzir spec aprovada em design arquitetural.
Output: `+specs/features/[slug]/design.md`.

## Quando Pular

Pular se:
- Mudança sem decisões arquiteturais (≤3 arquivos, abordagem óbvia)
- Sem novos padrões ou componentes
- Time já sabe exatamente como implementar

Nesse caso, ir direto para `/wsd-tasks`.

## Procedimento

**1. Ler spec:** `+specs/features/[slug]/spec.md` — todos os acceptance criteria devem estar claros.

**2. Knowledge chain (obrigatória):**
1. Codebase existente — padrões em uso, `+specs/codebase/ARCHITECTURE.md`, CONVENTIONS.md
2. Docs do projeto
3. MCP tools se disponíveis
4. Web search — docs oficiais
5. Flagrar incerteza — nunca inventar APIs ou comportamentos

**3. Propor 2-3 abordagens** com trade-offs. Liderar com recomendação e motivo.

**4. Apresentar seções de design** — escalar à complexidade, uma seção por vez:
- Visão geral da arquitetura
- Componentes e responsabilidades
- Fluxo de dados / sequência
- Tratamento de erros
- Abordagem de testes

**5. Aguardar aprovação** após cada seção. Revisar se solicitado.

**6. Salvar:** `+specs/features/[slug]/design.md`

**7. Após aprovação:** oferecer continuar com `/wsd-tasks`.

## Limite

Apenas design. Nenhum código ou scaffolding. Implementação começa no Execute.
