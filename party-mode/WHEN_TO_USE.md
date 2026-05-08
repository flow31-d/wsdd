---
title: "Quando Abrir Party Mode — Guia Prático"
created: 2026-05-07
modified: 2026-05-07
type: guia
tags:
  - wsd
  - party-mode
  - decision-tree
---

# Quando Abrir Party Mode — Decision Tree

[[party-mode/README|← Party Mode WSD]]

---

## Fluxo Rápido

```
Você tem uma spec ou decisão WSD.
         ↓
É L0 trivial?
  SIM → Skip Party Mode (overhead desnecessário, use quick-flow solo)
  NÃO → Continue
         ↓
Você está em EXECUTE?
  SIM → Skip (spec já diz o que fazer; implemente)
  NÃO → Continue
         ↓
Há incerteza, trade-offs, ou múltiplos ângulos relevantes?
  NÃO → Skip (você já decidiu; execute)
  SIM → Abra Party Mode 👇
```

---

## ✅ Contextos Onde Abrir

### SPECIFY — Criando ou Refinando uma Spec

```
✅ Abra SE:
  - Feature nova precisa de WHEN/THEN/SHALL
  - Problema não está 100% claro
  - Spec pode ser L1 ou L2 (não certeza qual)
  - Múltiplos ângulos: tech, produto, UX, estratégia

Agentes selecionados automaticamente:
  → analyst (Mary) + pm (John) + brainstorming-coach (Carson)
  → opcional: innovation-strategist (Victor) para angle estratégico

Exemplo:
  "Quero uma feature de exportação de relatórios"
  → Carson gera opções de WHEN conditions
  → Mary estrutura em WHEN/THEN/SHALL
  → John valida business value e MVP scope
  Resultado: spec draft pronta para DESIGN
```

---

### DESIGN — Decisão Arquitetural com Trade-offs

```
✅ Abra SE:
  - 2+ formas viáveis de implementar
  - Trade-off não é óbvio
  - L1 complexa ou L2

Agentes selecionados automaticamente:
  → architect (Winston) + dev (Amelia) + module-builder (Morgan)
  → opcional: tea (Murat) para angle de testabilidade

Exemplo:
  "Redis vs Memcached vs cache em banco?"
  → Winston avalia arquitetura e forbidden_paths
  → Amelia verifica viabilidade de implementação
  → Morgan valida design do módulo
  Resultado: decisão com trade-offs explícitos
```

---

### RISK L1 — Feature com Riscos Não Óbvios

```
✅ Abra SE:
  - L1 com integração externa ou mudança em comportamento crítico
  - Spec não cobre todos os failure cases
  - Quer validar testabilidade antes de iniciar

Agentes selecionados automaticamente:
  → qa (Quinn) + architect (Winston) + pm (John)
  → opcional: scrum-master (Bob) para spec readiness check

Exemplo:
  "Feature de notificações com webhook para Slack"
  → Quinn verifica testabilidade dos THENs
  → Winston analisa failure modes do webhook
  → John valida impacto em usuário se webhook falhar
  Resultado: riscos mapeados, spec ajustada
```

---

### RISK L2 — Mudança de Produção

```
✅ Abra SE:
  - L2 confirmado (impacto > 1 usuário, precisa rollback)
  - Antes de qualquer deploy de produção
  - Sistemas críticos afetados (auth, payments, data)

Agentes selecionados automaticamente:
  → tea (Murat) + test-architect (GLaDOS) + sys-architect (Cloud)
  → opcional: agile-coach (Max) para deploy strategy

Exemplo:
  "Migração do schema de usuários"
  → Cloud mapeia critical path e blast radius
  → GLaDOS define test gates obrigatórios para rollback
  → Murat verifica automação CI dos gates
  Resultado: gates definidos, rollback testado, go/no-go
```

---

### CODE REVIEW — PR Complexa Antes de Merge

```
✅ Abra SE:
  - PR é L1 complexa (não bugfix trivial)
  - Múltiplos ângulos relevantes (código, arch, testes, docs)
  - Quer mais que "LGTM"

Agentes selecionados automaticamente:
  → dev (Amelia) + test-architect (GLaDOS) + architect (Winston)
  → opcional: tech-writer (Paige) se docs precisam de review

Exemplo:
  "PR: implementação do módulo de cache"
  → Amelia: code quality, conventional commits, scope
  → GLaDOS: coverage, test strategy, flaky risks
  → Winston: patterns, forbidden_paths, architectural fit
  Resultado: aprovado com insights ou lista específica de ajustes
```

---

### PROCESS — Meta: Otimizar o Ciclo WSD

```
✅ Abra SE:
  - Retrospectiva de sprint ou ciclo WSD
  - Ciclo time está alto e não sabe por quê
  - Quer otimizar o fluxo de specs

Agentes selecionados automaticamente:
  → wsd-master + scrum-master (Bob) + workflow-builder (Wendy)

Exemplo:
  "3 specs L1 não foram concluídas na sprint"
  → Max analisa cycle time e WIP
  → Bob verifica spec readiness no início de cada ciclo
  → Wendy propõe ajustes no fluxo de gate conditions
  Resultado: ações concretas para próxima sprint
```

---

## ❌ Skip — Quando NÃO Usar

### L0 Trivial
```
"Corrigir typo em mensagem de erro"
"Adicionar variável de ambiente"
"Mudar cor de botão"
→ Usar quick-flow (Barry) solo ou implementar direto
```

### Você Já Decidiu
```
"Quero confirmar que Redis é a melhor opção"
→ Você está buscando validação, não perspectiva nova
→ Pedir a 1 agente específico para revisar, não Party Mode
```

### Fase de EXECUTE
```
"Qual é o padrão de retry para essa função?"
→ Spec já diz o que fazer
→ Dúvida de implementação, não de decisão
→ Amelia (dev) resolve sozinha
```

### Hotfix de Produção
```
"Está quebrando em prod agora"
→ Tempo crítico — sem cerimônia
→ Implemente, teste, deploy, retrospectiva depois
```

### Solo em Projeto Pessoal L0-L1 Simples
```
→ Usar solo-dev (Indie) — dá o processo enxuto certo para 1 pessoa
→ Party Mode é mais valioso com complexidade genuína
```

---

## Matriz de Decisão Rápida

| Contexto | Usar Party Mode? | Agentes | Tempo |
|----------|-----------------|---------|-------|
| Spec nova L1/L2 | ✅ Sim | analyst + pm + brainstorming-coach | ~20 min |
| Decisão arquitetural | ✅ Sim | architect + dev + module-builder | ~25 min |
| Risk L1 pré-execute | ✅ Sim | qa + architect + pm | ~20 min |
| Risk L2 pré-deploy | ✅ Sim (obrigatório) | tea + test-architect + sys-architect | ~30 min |
| Code review L1 | ✅ Sim | dev + test-architect + architect | ~20 min |
| Retrospectiva ciclo | ✅ Sim | wsd-master + scrum-master + workflow-builder | ~15 min |
| L0 trivial | ❌ Skip | — | — |
| Hotfix produção | ❌ Skip | — | — |
| Em EXECUTE phase | ❌ Skip | — | — |

---

## Checklist Rápido

Antes de abrir Party Mode:

- [ ] É L1 ou L2? (L0 → skip)
- [ ] Estou em SPECIFY, DESIGN, ou PRE-EXECUTE? (EXECUTE → skip)
- [ ] Há decisão real a tomar, não validação? (validação → 1 agente, não Party Mode)
- [ ] Há múltiplos ângulos relevantes? (só 1 ângulo → agente solo)
- [ ] Tenho ~20 min? (hotfix → skip)

**Todos SIM → Abra Party Mode**  
**Algum NÃO → Skip (ou agente solo)**

---

## TL;DR

> Incerteza genuína + múltiplos ângulos + tempo disponível = Party Mode.
> Trivial, decidido, em execução, ou urgente = skip.
