---
title: "Spec — TLC Integration (v0.1.4-alpha)"
created: 06/05/2026
modified: 06/05/2026
feature: tlc-integration
risco: L1
status: approved
owner: lpo
---

# Spec — TLC Integration (v0.1.4-alpha)

## Problema

O WSD governa **o que o agente pode fazer** (risco, paths, auditoria), mas não guia **como o agente desenvolve** (spec, design, tasks, TDD, gate checks). O Superpowers resolve o fluxo mas não tem proporcionalidade de risco nem governança. O TLC Spec-Driven resolve ambos com auto-sizing, STATE.md, WHEN/THEN/SHALL e gate checks tiered — e é filosoficamente alinhado ao WSD.

## Objetivo

Integrar as boas práticas do TLC ao WSD como camada de qualidade de desenvolvimento, sem substituir a camada de governança existente (L0/L1/L2, forbidden_paths, hooks, secrets).

## Fora de Escopo

| Item | Motivo |
|---|---|
| Substituir L0/L1/L2 pelo modelo de complexidade do TLC | São camadas complementares — risco ≠ complexidade |
| Remover hooks PreToolUse ou forbidden_paths | Governança técnica é diferente de fluxo de desenvolvimento |
| Suporte a múltiplos harnesses além de Codex e Claude Code | Fora do escopo pessoal atual |
| OPA/Rego ou server-side hooks | Esforço alto, uso solo não justifica |

---

## Requisitos

### R01 — Convenção de pastas

WHEN o instalador WSD cria arquivos em um repositório alvo  
THEN ele SHALL usar `+specs/` (não `.specs/`) e `+logs/` (não `.logs/`)  
em todos os paths gerados, templates, write_paths e context_documents.

### R02 — Estrutura +specs/ expandida

WHEN o instalador roda com qualquer `--tools`  
THEN ele SHALL criar a seguinte estrutura mínima no repositório alvo:

```
+specs/
├── project/
│   ├── PROJECT.md      (visão, goals, regras do projeto)
│   ├── STATE.md        (decisões, bloqueadores, lições, deferred)
│   └── ROADMAP.md      (features e milestones)
├── codebase/           (gerado pelo wsd-brownfield ou preenchido manualmente)
│   ├── STACK.md
│   ├── ARCHITECTURE.md
│   ├── CONVENTIONS.md
│   ├── STRUCTURE.md
│   ├── TESTING.md      (gate checks por tier)
│   ├── INTEGRATIONS.md
│   └── CONCERNS.md     (tech debt + componentes frágeis)
├── features/           (specs por feature, formato WHEN/THEN/SHALL)
└── quick/              (tasks L0 express)
```

### R03 — STATE.md como memória primária

WHEN o wsd-finish é executado  
THEN ele SHALL perguntar ao usuário se houve decisões, bloqueadores ou lições  
E SHALL atualizar STATE.md com as respostas estruturadas  
em vez de (ou além de) escrever no error_vault.json.

WHEN o wsd-start é executado  
THEN ele SHALL carregar STATE.md e HANDOFF.md (se existirem)  
E SHALL resumir o estado atual a partir deles antes de reportar.

### R04 — HANDOFF.md para cross-session

WHEN o wsd-finish é executado  
THEN ele SHALL gerar `+specs/HANDOFF.md` com:
- task atual e status
- itens concluídos na sessão
- itens em andamento (arquivo:linha se aplicável)
- próximos passos imediatos
- branch e uncommitted changes
- referências relevantes ao STATE.md

WHEN o wsd-start detecta HANDOFF.md existente  
THEN ele SHALL resumir o handoff e perguntar "Continuar de onde parou?"

### R05 — Acceptance criteria WHEN/THEN/SHALL

WHEN um agente cria ou edita uma spec L1 ou L2  
THEN cada acceptance criterion SHALL seguir o formato:
`WHEN [evento/ação] THEN [sistema] SHALL [comportamento mensurável]`

WHEN o wsd_check.sh valida uma spec  
THEN ele SHALL emitir WARNING para critérios que não contenham WHEN, THEN e SHALL.

### R06 — TESTING.md com gate checks tiered

WHEN o instalador gera o repositório  
THEN ele SHALL criar `+specs/codebase/TESTING.md` com:
- comandos de gate por tier (Quick = unit, Full = unit+e2e, Build = tudo+lint)
- matriz de cobertura por camada
- flags de paralelismo (Parallel-Safe: Yes/No)

WHEN um agente executa uma task  
THEN ele SHALL consultar TESTING.md para o gate level correto  
E SHALL rodar o gate check correspondente antes de commitar.

### R07 — Auto-sizing mapeado ao risco

WHEN um agente classifica uma tarefa como L0  
THEN ele SHALL usar Quick mode: descrever → implementar → verificar → commitar  
sem pipeline de Specify/Design/Tasks.

WHEN um agente classifica uma tarefa como L1  
THEN ele SHALL rodar no mínimo Specify → Execute  
E PODERÁ incluir Design e Tasks se a complexidade exigir.

WHEN um agente classifica uma tarefa como L2  
THEN ele SHALL rodar as 4 fases completas (Specify + Design + Tasks + Execute)  
E SHALL aguardar aprovação humana explícita antes do Execute.

### R08 — Knowledge verification chain (Regra 11 da Constituição)

WHEN um agente pesquisa, projeta ou toma decisão técnica  
THEN ele SHALL seguir esta ordem obrigatória:
1. Codebase existente (código, convenções, padrões)
2. Docs do projeto (README, docs/, CONVENTIONS.md)
3. Ferramentas MCP disponíveis (Context7 ou equivalente)
4. Web search (docs oficiais, fontes reputadas)
5. Flagrar como incerto: "Não encontrei documentação — aqui está meu raciocínio, mas verifique"

WHEN nenhuma das etapas 1-4 resolve a dúvida  
THEN o agente SHALL dizer "não sei" — nunca inventar APIs, padrões ou comportamentos.

### R09 — Scope guardrail (Regra 12 da Constituição)

WHEN um agente nota algo que poderia melhorar fora da task atual  
THEN ele SHALL registrar em STATE.md (Deferred Ideas ou Lessons Learned)  
E SHALL não implementar a melhoria na sessão atual sem instrução explícita.

### R10 — Conventional Commits obrigatórios

WHEN um agente cria um commit em repositório WSD  
THEN o commit SHALL seguir Conventional Commits 1.0.0:
`<type>(<scope>): <description>` — imperativo, lowercase, sem ponto final

WHEN o commit introduz breaking change  
THEN ele SHALL incluir `!` após type/scope e footer `BREAKING CHANGE:`.

### R11 — Novos comandos de sessão

WHEN `--tools codex` ou `--tools claude-code` está ativo  
THEN o instalador SHALL gerar os seguintes comandos além de wsd-start e wsd-finish:
- `wsd-specify` — fase de especificação (clarifica requirements, escreve spec.md)
- `wsd-design` — fase de design (arquitetura, componentes, design.md)
- `wsd-tasks` — fase de tasks (tasks.md atômico com gates e dependências)

### R12 — Brownfield mapping

WHEN `wsd install --brownfield` é passado  
THEN o instalador SHALL guiar o preenchimento dos 7 docs de codebase/:
STACK, ARCHITECTURE, CONVENTIONS, STRUCTURE, TESTING, INTEGRATIONS, CONCERNS.

### R13 — Context loading strategy

WHEN um agente inicia qualquer sessão WSD  
THEN ele SHALL carregar no máximo ~15k tokens de contexto base:
- PROJECT.md (se existir)
- STATE.md (memória operacional)
- HANDOFF.md (se existir)

E SHALL carregar on-demand:
- docs de codebase/ apenas quando relevantes à task
- spec.md e tasks.md apenas da feature em execução

E NUNCA SHALL carregar múltiplas specs ou múltiplos docs de arquitetura simultaneamente.
