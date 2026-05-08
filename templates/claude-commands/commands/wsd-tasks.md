---
description: Fase Tasks do WSD. Use quando o usuário diz "wsd-tasks", "criar tasks", "quebrar em tasks", ou pede um plano de implementação a partir de uma spec ou design aprovados.
argument-hint: slug da feature (ex: user-auth)
allowed-tools:
  - Bash
  - Read
  - Write
---

# WSD Tasks

## Objetivo

Quebrar spec/design aprovados em tasks atômicas verificáveis.
Output: `+specs/features/[slug]/tasks.md`.

## Quando Pular

Pular se há ≤3 passos óbvios — listar inline no início do Execute.

**Safety valve:** se a listagem inline revelar >5 passos ou dependências complexas → STOP e criar tasks.md.

## Procedimento

**1. Ler inputs:**
- `+specs/features/[slug]/spec.md` — acceptance criteria
- `+specs/features/[slug]/design.md` — se existir
- `+specs/codebase/TESTING.md` — comandos de gate e matriz de cobertura

**2. Mapear estrutura de arquivos:** quais arquivos serão criados ou modificados. Decisões de decomposição ficam fixas aqui.

**3. Quebrar em tasks atômicas** — uma task = um deliverable:
- Um componente, uma função, um endpoint, uma mudança de arquivo
- Independentemente verificável
- Independentemente commitável (um commit por task)

**4. Co-locar testes:** cada task que cria uma camada com tipo de teste obrigatório DEVE incluir escrever esses testes na mesma task. Testes NÃO são tasks separadas.

**5. Atribuir gate level** por task:
- Só unit tests → Quick
- E2E ou integration → Full
- Última task da fase ou sem testes → Build

**6. Definir dependências:** o que deve estar pronto antes de cada task.

**7. Marcar tasks paralelas [P]:** somente quando Parallel-Safe em TESTING.md permite.

**8. Salvar:** `+specs/features/[slug]/tasks.md` (usar template feature-tasks.md.template como base)

## Scope Guardrail

Se notar melhorias fora do escopo da feature atual ao criar tasks:
- Registrar em `+specs/project/STATE.md` (Ideias Adiadas)
- Não incluir nas tasks sem instrução explícita

## Limite

Apenas planejamento. Nenhum código ainda.
