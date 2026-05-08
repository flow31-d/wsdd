---
title: "Spec — Party Mode Integration (v0.1.11-alpha)"
created: 2026-05-07
modified: 2026-05-07
type: spec
status: implemented
risk_level: L1
feature_slug: party-mode-integration
version: v0.1.11-alpha
tags:
  - wsd
  - party-mode
  - cli
  - claude-code
---

# Spec — Party Mode Integration

## Contexto

O sistema Party Mode WSD existe em `x/wsd/party-mode/` com 26 agentes, manifest CSV,
workflow, steps e templates completos (v0.1.10-alpha). O gap atual: não é instalado
pelo `wsd-method install` nem exposto como comando Claude Code ou subcomando `wsd`.

Esta spec cobre a integração CLI completa antes da estabilização v0.1.0.

## Fora de Escopo

- Streaming interativo de agentes no terminal
- Métricas automáticas de rework prevenido
- Integração com GitHub Discussions ou PR reviews automáticos
- Scoring de conformidade ("essa spec recebeu debate suficiente?")

---

## Acceptance Criteria

### AC-1 — Comando Claude Code instalado

WHEN `wsd-method install --tools claude-code` ou `--tools both` é executado em um diretório,
THEN o arquivo `.claude/commands/wsd-party-mode.md` deve existir no diretório instalado,
SHALL ser executável como slash command `/wsd-party-mode` no Claude Code e carregar o workflow com os steps do party-mode.

### AC-2 — Assets do party-mode vendorizados no projeto

WHEN `wsd-method install` é executado (independente de `--tools`),
THEN o diretório `.wsd/party-mode/` deve existir no projeto instalado com: `agents-wsd.csv`, todos os 26 arquivos de `agents/`, `steps/`, `templates/` e `workflow.md`,
SHALL o comando `/wsd-party-mode` referenciar os assets via `.wsd/party-mode/` sem caminhos absolutos.

### AC-3 — Subcomando `wsd party` no CLI local

WHEN `.wsd/bin/wsd party` é executado sem subcomando,
THEN exibir ajuda com os subcomandos disponíveis: `list-agents`, `when-to-use`, `status`,
SHALL `wsd party list-agents` listar os 26 agentes com nome e domínio a partir do CSV local.

WHEN `.wsd/bin/wsd party when-to-use` é executado,
THEN exibir a decision tree resumida (L0→skip, L2 obrigatório, outros opt-in),
SHALL a saída caber em um terminal de 80 colunas.

WHEN `.wsd/bin/wsd party status` é executado,
THEN reportar se party-mode está instalado (assets presentes) e quantos agentes estão disponíveis,
SHALL retornar exit 0 se instalado, exit 1 se assets ausentes.

### AC-4 — Seção Party Mode no AGENTS.md gerado

WHEN `wsd-method install` gera o `AGENTS.md` do projeto instalado,
THEN o arquivo deve conter uma seção "## Party Mode" com: link para `WHEN_TO_USE.md`, comandos básicos e contextos onde usar (SPECIFY/DESIGN/RISK L1/RISK L2),
SHALL o conteúdo usar as políticas do `party-mode/WHEN_TO_USE.md` como fonte canônica.

### AC-5 — Teste de instalação automático

WHEN `npm run test:install-party-mode` é executado,
THEN deve: instalar WSD em tmpdir com `--tools claude-code`, verificar presença de `.claude/commands/wsd-party-mode.md`, verificar `.wsd/party-mode/agents-wsd.csv`, verificar que `wsd party status` retorna exit 0,
SHALL o teste passar sem intervenção manual.

### AC-6 — `npm test` inclui o novo gate

WHEN `npm test` é executado,
THEN `test:install-party-mode` deve fazer parte do pipeline,
SHALL falhar o pipeline se qualquer assertion do AC-5 não passar.

### AC-7 — Sem dependências externas no projeto instalado

WHEN o projeto instalado está em modo offline (sem acesso a internet ou ao source WSD),
THEN `/wsd-party-mode` e `wsd party` devem funcionar usando apenas os assets em `.wsd/party-mode/`,
SHALL nenhum path absoluto para `x/wsd/` ser embutido nos arquivos instalados.
