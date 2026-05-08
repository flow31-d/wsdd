---
title: "Sistema Party Mode WSD — Internals"
created: 2026-05-07
modified: 2026-05-07
type: tecnico
tags:
  - wsd
  - party-mode
  - sistema
---

# Sistema Party Mode WSD — Como Funciona

[[party-mode/README|← Party Mode WSD]]

---

## Arquitetura: BMAD Micro-File Pattern

O sistema segue a mesma arquitetura do BMAD: **entry point + steps separados**.

```
workflow.md              ← entry point (carrega contexto, chama steps)
steps/
  step-01-agent-loading.md        ← carrega manifest, detecta contexto WSD
  step-02-discussion-orchestration.md  ← selection engine + debate
  step-03-graceful-exit.md        ← encerramento + geração de output
```

Cada step é um arquivo autônomo — pode ser lido, atualizado ou substituído independentemente sem quebrar os outros.

---

## Fluxo Operacional

### 1 — Entrada (step-01)

```
Input: contexto WSD atual
  ↓
Carrega agents-wsd.csv (manifest dos 26 agentes)
  ↓
Detecta contexto WSD via STATE.md ou HANDOFF.md:
  - Qual fase? (SPECIFY / DESIGN / EXECUTE)
  - Qual nível? (L0 / L1 / L2)
  - Qual domínio de problema? (spec, arch, risk, review, process)
  ↓
Organiza roster por domínio (core, bmm, bmb, cis, gds, tea)
  ↓
Apresenta boas-vindas + roster para o usuário
  ↓
[C] para continuar → step-02
```

### 2 — Selection Engine (step-02)

O coração do sistema. Recebe a pergunta/contexto e:

```
1. Analisa domínio via palavras-chave:
   SPECIFY → spec, feature, quando, quero, precisa
   DESIGN  → arquitetura, padrão, como implementar, trade-off
   RISK L1 → risco, garantir, testável, seguro
   RISK L2 → produção, crítico, migração, rollback
   REVIEW  → código, PR, merge, implementação pronta
   PROCESS → ciclo, processo, wsd, fluxo
   L0/QUICK → trivial, rápido, simples, óbvio

2. Mapeia contexto → combinação de agentes:

   SPECIFY/BRAINSTORM  → analyst + pm + brainstorming-coach
   DESIGN/ARQUITETURA  → architect + dev + module-builder
   RISK L1             → qa + architect + pm
   RISK L2             → tea + test-architect + sys-architect
   CODE REVIEW         → dev + test-architect + architect
   PROCESS/CICLO       → wsd-master + scrum-master + workflow-builder
   L0/QUICK            → quick-flow + dev (máximo 2)

3. Apresenta os agentes selecionados em personagem
4. Facilita debate com cross-talk entre agentes
5. Sintetiza consensos e tensões
```

### 3 — Encerramento (step-03)

```
Detecta sinal de encerramento (done, fim, [exit], etc.)
  ↓
Oferece gerar PARTY_ANALYSIS.md
  ↓
Se aceito: preenche template com:
  - Agentes participantes
  - Consensos
  - Tensões & trade-offs
  - Recomendação
  - Riscos capturados
  ↓
Salva em: +specs/features/<slug>/PARTY_ANALYSIS.md
  ↓
Farewell in-character de cada agente participante
```

---

## O Campo wsd_expertise

Cada agente tem um campo `wsd_expertise` no frontmatter — o diferencial desta implementação vs agentes genéricos.

```yaml
# agents/analyst.md
wsd_expertise: WHEN/THEN/SHALL gap analysis, L0/L1 classification, spec completeness scoring, acceptance criteria validation
```

Isso garante que quando o agente responde, ele usa vocabulário WSD:
- Referencia L0/L1/L2 levels
- Fala sobre WHEN/THEN/SHALL como estrutura
- Conhece git hooks, forbidden_paths, HANDOFF.md
- Entende o ciclo wsd start → design → finish

---

## Comportamento de Agentes

### Princípios de Interação

1. **Voice consistente** — cada agente sempre usa o mesmo tom e abordagem
2. **Cross-questioning** — agentes questionam e respondem uns aos outros
3. **Perspectiva única** — cada um traz apenas seu ângulo especializado
4. **Convergir quando possível** — "Concordo com X, adicionaria Y"
5. **Explicitar tensões** — "O trade-off aqui é Z"

### Exemplo: Cross-talk de SPECIFY

```
📊 Mary (analyst): "O WHEN está ambíguo — 'quando usuário acessa dashboard'
  pode ser inicial load, refresh, ou retorno de tab. Qual exatamente?"

📋 John (pm): "Para MVP, só o initial load. Refresh é edge case que
  podemos postponar sem perder valor core."

🧠 Carson (brainstorming-coach): "Antes de finalizar — e se incluirmos
  WHEN usuário faz search dentro do dashboard? Isso multiplica o valor
  sem complexidade adicional."

📊 Mary: "Boa adição Carson. Mas WHEN conditions separadas — não misturar
  os dois cenários em um THEN. John, adicionamos como segundo WHEN?"
```

---

## Consenso vs Tensão vs Bloqueador

### Consenso (✅)
Todos agentes concordam → documentar como consenso no PARTY_ANALYSIS.md.

### Tensão (⚠️)
Agentes têm perspectivas diferentes válidas:
```
RESULTADO:
  - Winston (architect): prefere padrão A — mais robusto
  - Amelia (dev): prefere padrão B — mais rápido de implementar
  - Tensão documentada + recomendação: B para MVP, A para v2
  - Decisão final: usuário/PM call
```

### Bloqueador (🔴)
Algo obrigatoriamente faltante — não continuar sem resolver:
```
RESULTADO:
  - Spec tem gap crítico: nenhum THEN cobre falha de pagamento
  - Party Mode não pode recomendar proceed
  - AÇÃO: voltar a SPECIFY, adicionar failure cases, reabrir
```

---

## Formato: PARTY_ANALYSIS.md

Salvo em `+specs/features/<slug>/PARTY_ANALYSIS.md`:

```markdown
# Party Mode Analysis — <Feature Slug>

**Data:** YYYY-MM-DD  
**Contexto WSD:** SPECIFY | DESIGN | RISK L1 | RISK L2 | CODE REVIEW  
**Status:** ✅ Consenso | ⚠️ Tensões | 🔴 Bloqueador

## Agentes Participantes
- 📊 Mary (analyst) — spec completeness
- 🏗️ Winston (architect) — arquitetura
- 📋 John (pm) — business value

## Consensos

- Item 1
- Item 2

## Tensões & Trade-offs

| Opção | Vantagem | Custo | Defensor |
|-------|----------|-------|---------|
| A | ... | ... | Winston |
| B | ... | ... | Amelia |

## Recomendação

→ **Opção X** com rationale em negrito.

**Porque:** razão específica.

## Riscos Capturados

| Risco | Severidade | Mitigação |
|-------|-----------|-----------|
| Risk 1 | 🔴 Alto | Mitigação A |
| Risk 2 | 🟠 Médio | Mitigação B |

## Próximos Passos

- [ ] Ação 1
- [ ] Ação 2
```

---

## Integração no Ciclo WSD

```
Ciclo WSD:
├── wsd start
├── Classify (L0/L1/L2)
├── SPECIFY ← Party Mode pode entrar (brainstorm, feature design)
├── DESIGN  ← Party Mode pode entrar (arquitetura, trade-offs, risk L1)
├── PRE-EXECUTE L2 ← Party Mode pode entrar (risk L2, test gates)
├── EXECUTE ← NÃO entra (spec já diz o que fazer)
├── VALIDATE
├── PROMOTE
└── wsd finish
    └── HANDOFF.md referencia +specs/features/<slug>/PARTY_ANALYSIS.md
```

### Referência em HANDOFF.md

```markdown
## Party Mode Review

**SPECIFY Brainstorm** — [PARTY_ANALYSIS.md](+specs/features/slug/PARTY_ANALYSIS.md)
- Consenso: padrão X escolhido
- Rationale: [1 linha]

**Risk Assessment** — [PARTY_ANALYSIS.md](+specs/features/slug/PARTY_ANALYSIS.md)
- Riscos residuais: [lista]
- Go/no-go: ✅ Proceed
```

---

## Autonomia — Zero Dependências Externas

✅ Todos os 26 agentes salvos localmente em `party-mode/agents/`  
✅ Manifest em `party-mode/agents-wsd.csv`  
✅ Steps em `party-mode/steps/`  
✅ Templates em `party-mode/templates/`  
✅ Exemplos em `party-mode/examples/`  
✅ Zero links para `/Recursos/` ou sistemas externos  
✅ Versionado junto com WSD repo  
✅ Funciona 100% offline  
