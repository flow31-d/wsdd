---
name: wsd-specify
description: Run the Specify phase for a WSD feature. Use when the user says wsd-specify, especificar feature, definir requisitos, or asks to write a spec for a new feature.
---

# WSD Specify

## Purpose

Capture WHAT to build with testable, traceable requirements. Output: `+specs/features/[slug]/spec.md`.

## Procedure

1. **Clarify requirements** — be a thinking partner, not an interviewer:
   - "Qual problema você está resolvendo?"
   - "Quem é o usuário e qual é a dor?"
   - "Como é o sucesso?"
   - Uma pergunta por vez. Desafiar respostas vagas.

2. **Scope check**: se a feature cobre múltiplos subsistemas independentes, ajudar a decompor antes de continuar.

3. **Propor 2-3 abordagens** com trade-offs e recomendação.

4. **Escrever User Stories** com prioridade P1/P2/P3. Cada story deve ser independentemente testável.

5. **Escrever Acceptance Criteria** — formato WHEN/THEN/SHALL obrigatório:
   `WHEN [evento/ação] THEN [sistema] SHALL [comportamento mensurável]`

6. **Salvar em `+specs/features/[slug]/spec.md`** usando o template `templates/specs/feature-spec.md.template`.

7. **Self-review da spec**: verificar placeholders, contradições, ambiguidade, escopo.

8. **Mostrar spec ao usuário** para aprovação antes de prosseguir.

9. **Após aprovação**: oferecer continuar com `/wsd-design` (se feature complexa) ou `/wsd-tasks` (se design é óbvio).

## Boundary

GATE: Com `workflow.approval_mode=full_auto` (default), finalize a spec, promova a `approved` com auto-revisão registrada e siga para implementação sem pausar. Pause para aprovação do usuário apenas se ele pediu revisão explícita ou se o approval_mode do projeto exigir. Nunca iniciar código antes da spec estar `approved` pelo usuário.

## Knowledge Chain

Antes de propor abordagens, verificar nesta ordem:
1. Codebase existente (`+specs/codebase/ARCHITECTURE.md`, CONVENTIONS.md)
2. Docs do projeto
3. Ferramentas MCP disponíveis
4. Web search
5. Flagrar como incerto se não encontrar resposta
