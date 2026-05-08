---
title: "Party Mode WSD — Índice Completo"
created: 2026-05-07
modified: 2026-05-07
type: índice
---

# Party Mode WSD — Inventário Completo de Arquivos

---

## Documentação Principal

| Arquivo | Descrição | Leia quando |
|---------|-----------|-------------|
| [README.md](README.md) | Visão geral, domínios, selection engine, quando usar | Sempre primeiro |
| [WHEN_TO_USE.md](WHEN_TO_USE.md) | Decision tree — abrir ou não abrir Party Mode | Antes de cada sessão |
| [SISTEMA.md](SISTEMA.md) | Internals: selection engine, formatos de output, integração WSD | Entender como funciona |
| [INDEX.md](INDEX.md) | Este arquivo — inventário completo | Encontrar algo específico |

---

## Workflow (BMAD Micro-File Architecture)

| Arquivo | Papel |
|---------|-------|
| [workflow.md](workflow.md) | Entry point — carrega manifest, detecta contexto, executa steps |
| [steps/step-01-agent-loading.md](steps/step-01-agent-loading.md) | Carrega agentes, detecta contexto WSD, cria welcome |
| [steps/step-02-discussion-orchestration.md](steps/step-02-discussion-orchestration.md) | **Selection engine** — mapeia contexto → agentes → debate |
| [steps/step-03-graceful-exit.md](steps/step-03-graceful-exit.md) | Encerramento, geração de PARTY_ANALYSIS.md, farewells |

---

## Manifest

| Arquivo | Descrição |
|---------|-----------|
| [agents-wsd.csv](agents-wsd.csv) | Manifest completo dos 26 agentes com campos: name, displayName, title, icon, role, identity, communicationStyle, principles, domain, wsd_expertise, path |

---

## Agentes — 26 Perfis WSD-Aware

### Domínio: core

| Agente | Persona | Especialidade WSD |
|--------|---------|-------------------|
| [wsd-master.md](agents/wsd-master.md) | 🧙 Maestro | Orquestração, síntese, classificação L0/L1/L2 |

### Domínio: bmm (Business & Main Dev)

| Agente | Persona | Especialidade WSD |
|--------|---------|-------------------|
| [analyst.md](agents/analyst.md) | 📊 Mary | WHEN/THEN/SHALL gaps, spec completeness |
| [architect.md](agents/architect.md) | 🏗️ Winston | Arquitetura, forbidden_paths, L2 rollback design |
| [dev.md](agents/dev.md) | 💻 Amelia | Implementação, conventional commits, scope creep |
| [pm.md](agents/pm.md) | 📋 John | Business value, MVP scope, product decisions |
| [qa.md](agents/qa.md) | 🧪 Quinn | Testabilidade de specs, TESTING.md, ghost spec |
| [quick-flow.md](agents/quick-flow.md) | 🚀 Barry | L0 specialist, anti-overhead, fast cycle |
| [scrum-master.md](agents/scrum-master.md) | 🏃 Bob | Spec readiness, STATE.md/HANDOFF.md rituals |
| [tech-writer.md](agents/tech-writer.md) | 📚 Paige | WSD frontmatter compliance, doc quality |
| [ux-designer.md](agents/ux-designer.md) | 🎨 Sally | UX em specs, user impact L2 assessment |

### Domínio: bmb (Builders)

| Agente | Persona | Especialidade WSD |
|--------|---------|-------------------|
| [agent-builder.md](agents/agent-builder.md) | 🤖 Bond | Party Mode design, selection engine improvement |
| [module-builder.md](agents/module-builder.md) | 🏗️ Morgan | WSD module architecture, profile design |
| [workflow-builder.md](agents/workflow-builder.md) | 🔄 Wendy | Gate conditions, L0/L1/L2 flow optimization |

### Domínio: cis (Creativity, Innovation, Strategy)

| Agente | Persona | Especialidade WSD |
|--------|---------|-------------------|
| [brainstorming-coach.md](agents/brainstorming-coach.md) | 🧠 Carson | SPECIFY brainstorm, WHEN condition ideation |
| [problem-solver.md](agents/problem-solver.md) | 🔬 Dr. Quinn | Root cause analysis, problem framing |
| [design-thinker.md](agents/design-thinker.md) | 🌳 Maya | Empathy em WHEN, human impact L2 |
| [innovation-strategist.md](agents/innovation-strategist.md) | ⚡ Victor | Strategic framing, value proposition |
| [presentation-master.md](agents/presentation-master.md) | 🎨 Caravaggio | Spec readability, PARTY_ANALYSIS.md visual |
| [storyteller.md](agents/storyteller.md) | 📖 Sophia | STATE.md/HANDOFF.md narrativa, risk storytelling |

### Domínio: gds (Governance, Delivery, Systems)

| Agente | Persona | Especialidade WSD |
|--------|---------|-------------------|
| [sys-architect.md](agents/sys-architect.md) | 🏛️ Cloud | L2 sistemas críticos, critical path, scalability |
| [feature-designer.md](agents/feature-designer.md) | 🎲 Samus | Feature → spec translation, acceptance criteria |
| [implementer.md](agents/implementer.md) | 🕹️ Link | Implementation planning, feasibility check |
| [test-architect.md](agents/test-architect.md) | 🧪 GLaDOS | TESTING.md design, L2 test gates |
| [agile-coach.md](agents/agile-coach.md) | 🎯 Max | Deploy strategy, cycle time, retrospective |
| [solo-dev.md](agents/solo-dev.md) | 🎮 Indie | WSD solo workflow, enxuto sem overhead |

### Domínio: tea (Test Engineering & Automation)

| Agente | Persona | Especialidade WSD |
|--------|---------|-------------------|
| [tea.md](agents/tea.md) | 🧪 Murat | CI pipeline alignment, test automation, flaky test |

---

## Templates

| Arquivo | Uso |
|---------|-----|
| [templates/PARTY_ANALYSIS.md.template](templates/PARTY_ANALYSIS.md.template) | Template de output para sessões — salvar em `+specs/features/<slug>/` |

---

## Exemplos

| Arquivo | Conteúdo |
|---------|----------|
| [examples/session-exemplo-design-review.md](examples/session-exemplo-design-review.md) | Transcrição completa de sessão real de design review |

---

## Contagem Final

| Categoria | Qtd |
|-----------|-----|
| Docs principais | 4 |
| Steps (workflow) | 3 + 1 entry point |
| Agentes | **26** |
| Templates | 1 |
| Exemplos | 1 |
| **Total de arquivos** | **36** |

---

## Como Navegar

1. **Novo aqui?** → [README.md](README.md)
2. **Decidindo se usa?** → [WHEN_TO_USE.md](WHEN_TO_USE.md)
3. **Quer entender o selection engine?** → [steps/step-02-discussion-orchestration.md](steps/step-02-discussion-orchestration.md)
4. **Quer conhecer um agente?** → Tabelas acima → `agents/<nome>.md`
5. **Quer ver uma sessão real?** → [examples/session-exemplo-design-review.md](examples/session-exemplo-design-review.md)
