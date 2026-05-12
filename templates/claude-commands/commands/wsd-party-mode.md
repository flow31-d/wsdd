---
description: Abre sessão Party Mode WSD com orquestração multi-agente. Use quando o usuário diz "party mode", "debate multi-agente", "abrir party", "wsd-party-mode", ou quando uma spec L1/L2 precisa de múltiplas perspectivas (SPECIFY, DESIGN, RISK, CODE REVIEW).
argument-hint: contexto da sessão (opcional — ex: "DESIGN cache layer", "RISK L2 migration", "SPECIFY feature X")
allowed-tools:
  - Bash
  - Read
---

# WSD Party Mode

## Objetivo

Orquestrar discussão multi-agente com os especialistas WSD para decisões de spec,
arquitetura, risco e code review. Cada agente tem voz, estilo e expertise distintos.

## Quando Usar

- Spec é **L1 ou L2** (não L0 trivial)
- Fase **SPECIFY** ou **DESIGN** (não em EXECUTE)
- Há **trade-offs, riscos ou múltiplos ângulos** relevantes
- ~20 min disponíveis para debate estruturado

**Não usar:** L0 trivial, hotfix urgente, fase EXECUTE, quando já decidido.

## Procedimento

**1. Carregar manifest de agentes:**

```bash
cat +wsd/party-mode/agents-wsd.csv
```

**2. Detectar contexto WSD atual:**

```bash
cat +specs/project/STATE.md 2>/dev/null | tail -20
cat +specs/HANDOFF.md 2>/dev/null | head -30
```

**3. Identificar contexto da sessão** a partir do argumento ou da detecção acima:

| Contexto | Agentes Selecionados |
|---|---|
| SPECIFY / Brainstorm | analyst + pm + brainstorming-coach |
| DESIGN / Arquitetura | architect + dev + module-builder |
| RISK L1 | qa + architect + pm |
| RISK L2 (obrigatório) | tea + test-architect + sys-architect |
| CODE REVIEW | dev + test-architect + architect |
| PROCESS / Ciclo | wsd-master + scrum-master + workflow-builder |
| L0 / Quick | quick-flow + dev (máx 2) |

**4. Carregar step-01 (inicialização):**

```bash
cat +wsd/party-mode/steps/step-01-agent-loading.md
```

Seguir as instruções do step-01: apresentar boas-vindas com amostra de agentes,
aguardar confirmação do usuário antes de iniciar o debate.

**5. Executar debate (step-02):**

```bash
cat +wsd/party-mode/steps/step-02-discussion-orchestration.md
```

Para cada mensagem do usuário:
- Selecionar 2-3 agentes mais relevantes pelo contexto
- Responder em personagem com voz e estilo distintos
- Habilitar cross-talk natural entre agentes
- Apresentar opção `[E] encerrar` após cada round

**6. Encerramento (step-03):**

```bash
cat +wsd/party-mode/steps/step-03-graceful-exit.md
```

Ao detectar trigger de saída (`/encerrar`, `/sair`, `end party`, `goodbye`):
- Fazer farewell em personagem de cada agente participante
- Oferecer gerar `PARTY_ANALYSIS.md`

**7. Gerar output (se aceito):**

Salvar em `+specs/features/<slug>/PARTY_ANALYSIS.md` usando o template:

```bash
cat +wsd/party-mode/templates/PARTY_ANALYSIS.md.template
```

## Regras de Personagem

- Cada agente mantém voz, tom e estilo documentados no manifest
- Agentes se referenciam mutuamente por nome
- Divergências são explicitadas como tensões, não suprimidas
- Consensos são documentados claramente antes de avançar
- Perguntas diretas ao usuário encerram o round — aguardar resposta antes de continuar

## Limite

Não implementar código nem alterar arquivos do projeto durante a sessão Party Mode.
O output é análise e recomendação — a implementação segue no ciclo WSD normal.
