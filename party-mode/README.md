---
title: "Party Mode WSD — Sistema Autônomo"
created: 2026-05-07
modified: 2026-05-07
type: hub
status: ativo
tags:
  - wsd
  - party-mode
  - agentes
  - interno
---

# Party Mode WSD — Sistema Autônomo e Auto-Contido

[[wsd/wsd|← WSD]]

---

> [!info] Autonomia Total
> Este sistema é **completamente independente** do Party Mode genérico em `/Recursos/`.
> WSD tem seus próprios 26 agentes adaptados, manifest, workflows e selection engine,
> tudo versionado em `x/wsd/party-mode/`. Nunca linkará com `/Recursos/`.

---

## O que é

Party Mode WSD é um sistema de orquestração multi-agente **embutido em WSD**, baseado na arquitetura BMAD, onde:

- **26 agentes WSD-aware** — cada um com `wsd_expertise` específica (WHEN/THEN/SHALL, L0/L1/L2, git hooks, forbidden_paths, etc.)
- **Selection engine inteligente** — seleciona 2-3 agentes por contexto, não todos de uma vez
- **Micro-file architecture** — `workflow.md` + `steps/` separados (mesmo padrão BMAD)
- **Output integra em `+specs/`** — `PARTY_ANALYSIS.md` salvo junto com a spec
- **Zero dependências externas** — funciona offline, sem links para `/Recursos/`

---

## Por que 26 agentes?

O princípio BMAD: **ter muitos agentes é bom; o problema é selecionar errado**.

Com 26 agentes disponíveis e um selection engine que escolhe 2-3 por tópico:
- Cada contexto WSD (SPECIFY, DESIGN, RISK L1, RISK L2, CODE REVIEW) tem a combinação ideal
- Agentes especializados trazem perspectiva que agentes genéricos perdem
- Nenhum overhead: agentes não selecionados simplesmente não aparecem

---

## Domínios de Agentes

| Domínio | Agentes | Foco |
|---------|---------|------|
| **core** | wsd-master | Orquestração e síntese WSD |
| **bmm** | analyst, architect, dev, pm, qa, quick-flow, scrum-master, tech-writer, ux-designer | Business/dev principais |
| **bmb** | agent-builder, module-builder, workflow-builder | Builders/criadores de sistema |
| **cis** | brainstorming-coach, problem-solver, design-thinker, innovation-strategist, presentation-master, storyteller | Criatividade/inovação |
| **gds** | sys-architect, feature-designer, implementer, test-architect, agile-coach, solo-dev | Systems/delivery |
| **tea** | tea | Test engineering & automation |

---

## Selection Engine — Contextos WSD

O `step-02-discussion-orchestration.md` mapeia contextos a combinações:

| Contexto WSD | Agentes Primários | Agente Opcional |
|-------------|-------------------|-----------------|
| **SPECIFY / Brainstorm** | analyst + pm + brainstorming-coach | innovation-strategist |
| **DESIGN / Arquitetura** | architect + dev + module-builder | tea |
| **RISK L1** | qa + architect + pm | scrum-master |
| **RISK L2** | tea + test-architect + sys-architect | agile-coach |
| **CODE REVIEW** | dev + test-architect + architect | tech-writer |
| **PROCESS / Ciclo** | wsd-master + scrum-master + workflow-builder | — |
| **L0 / Quick** | quick-flow + dev (max 2) | — |

---

## Estrutura

```
party-mode/
├── README.md          ← este arquivo
├── INDEX.md           ← inventário completo
├── SISTEMA.md         ← internals e selection engine
├── WHEN_TO_USE.md     ← decision tree prático
├── agents-wsd.csv     ← manifest de 26 agentes
│
├── agents/            ← 26 perfis individuais (micro-file architecture)
│   ├── wsd-master.md
│   ├── analyst.md
│   ├── architect.md
│   ├── dev.md
│   ├── pm.md
│   ├── qa.md
│   ├── quick-flow.md
│   ├── scrum-master.md
│   ├── tech-writer.md
│   ├── ux-designer.md
│   ├── agent-builder.md
│   ├── module-builder.md
│   ├── workflow-builder.md
│   ├── brainstorming-coach.md
│   ├── problem-solver.md
│   ├── design-thinker.md
│   ├── innovation-strategist.md
│   ├── presentation-master.md
│   ├── storyteller.md
│   ├── sys-architect.md
│   ├── feature-designer.md
│   ├── implementer.md
│   ├── test-architect.md
│   ├── agile-coach.md
│   ├── solo-dev.md
│   └── tea.md
│
├── steps/             ← BMAD micro-file workflow
│   ├── step-01-agent-loading.md
│   ├── step-02-discussion-orchestration.md
│   └── step-03-graceful-exit.md
│
├── templates/
│   └── PARTY_ANALYSIS.md.template
│
└── examples/
    └── session-exemplo-design-review.md
```

---

## Como Usar

### Fluxo Básico

```
1. wsd start → feature em L1/L2 detectada
2. Abrir Party Mode: ler step-01, apresentar contexto
3. step-02 analisa: qual contexto WSD? quais agentes?
4. Debate: 2-3 agentes trazem perspectivas
5. Consenso ou tensões documentados
6. step-03: gerar PARTY_ANALYSIS.md → salvar em +specs/features/<slug>/
7. Continuar ciclo WSD normal
```

### Quando Usar Party Mode

✅ **Abra SE:**
- Spec é L1 ou L2 (não L0 trivial)
- Você está em SPECIFY ou DESIGN (não em EXECUTE)
- Há trade-offs, riscos, ou múltiplos ângulos relevantes
- ~20 min disponíveis para debate estruturado

❌ **Skip SE:**
- L0 trivial (typo, variável de config, bugfix óbvio)
- Você já decidiu e quer apenas validação
- Está em EXECUTE (a spec já diz o que fazer)
- Hotfix de produção (tempo crítico)

---

## Diferencial: Agentes WSD-Aware

Ao contrário de agentes genéricos, cada agente aqui:
- Conhece o ciclo WSD (L0/L1/L2, start/design/finish)
- Entende WHEN/THEN/SHALL como estrutura de spec
- Sabe o que são `forbidden_paths`, `HANDOFF.md`, `STATE.md`
- Responde dentro do vocabulário e contexto WSD

Exemplo — `analyst` (Mary) em Party Mode WSD:
```
📊 Mary: "Esse THEN está ambíguo — 'sistema responde apropriadamente'
não é um acceptance criterion testável. Precisa ser:
THEN: status code 200 com body {success: true, id: <uuid>}
Quinn, você consegue escrever teste para isso agora?"
```

---

## Output: PARTY_ANALYSIS.md

Toda sessão salva em `+specs/features/<slug>/PARTY_ANALYSIS.md`:
- Agentes que participaram
- Consensos encontrados
- Tensões e trade-offs
- Recomendação com rationale
- Riscos capturados e mitigações

Referenciado automaticamente no `HANDOFF.md` ao encerrar.

---

## Docs Relacionadas

- `INDEX.md` — inventário completo de arquivos
- `SISTEMA.md` — como o selection engine funciona internamente
- `WHEN_TO_USE.md` — decision tree prático com exemplos
- `steps/step-02-discussion-orchestration.md` — o coração do sistema
- `examples/session-exemplo-design-review.md` — sessão real transcrita
