---
title: "Tasks — Party Mode Integration (v0.1.11-alpha)"
created: 2026-05-07
modified: 2026-05-07
type: tasks
status: implemented
feature_slug: party-mode-integration
tags:
  - wsd
  - party-mode
---

# Tasks — Party Mode Integration

Referência: `+specs/features/party-mode-integration/spec.md`

---

## T1 — Criar comando Claude Code `wsd-party-mode.md`

- [x] Criar `templates/claude-commands/commands/wsd-party-mode.md`
- [x] Conteúdo: adaptar `party-mode/workflow.md` para slash command, com referência a `.wsd/party-mode/steps/`
- [x] Verificar que a estrutura segue o padrão de `wsd-start.md` (frontmatter description, argument-hint, allowed-tools)

Cobre: AC-1

---

## T2 — Copiar assets party-mode no install

- [x] Adicionar `installPartyMode(directory, settings, force)` em `bin/wsd-method.js`
- [x] Função copia `party-mode/` do source WSD para `.wsd/party-mode/` no projeto instalado
- [x] Chamar `installPartyMode` dentro de `install()` após `installGitGovernanceModule`
- [x] Registrar no `installVendorTree` / log de instalação que party-mode foi instalado

Cobre: AC-2, AC-7

---

## T3 — Subcomando `wsd party` no CLI local

- [x] Adicionar case `party)` em `templates/local-wsd/bin/wsd`
- [x] Subcomandos: `list-agents`, `when-to-use`, `status`
- [x] `list-agents`: parsear `.wsd/party-mode/agents-wsd.csv` com python3, exibir nome/domínio/icon
- [x] `when-to-use`: exibir decision tree resumida (inline no script, sem depender de arquivo externo)
- [x] `status`: verificar existência de `.wsd/party-mode/agents-wsd.csv` e contar agentes

Cobre: AC-3, AC-7

---

## T4 — Seção Party Mode no AGENTS.md.template

- [x] Adicionar seção `## Party Mode` em `templates/repo/AGENTS.md.template`
- [x] Incluir: quando usar (L1/L2, SPECIFY/DESIGN/RISK), comandos básicos (`/wsd-party-mode`, `wsd party status`), link para `.wsd/party-mode/WHEN_TO_USE.md`

Cobre: AC-4

---

## T5 — Teste de instalação `test:install-party-mode`

- [x] Adicionar `"test:install-party-mode"` em `package.json`
- [x] Script instala em tmpdir com `--tools claude-code`, verifica: `.claude/commands/wsd-party-mode.md`, `.wsd/party-mode/agents-wsd.csv`, `wsd party status` exit 0
- [x] Adicionar `test:install-party-mode` ao script `test` principal

Cobre: AC-5, AC-6

---

## T6 — Bump de versão e sync documental

- [x] `package.json`: `0.1.10-alpha` → `0.1.11-alpha`
- [x] `CHANGELOG.md`: adicionar seção `0.1.11-alpha`
- [x] `README.md`: atualizar versão e status
- [x] `wsd.md`: atualizar referência de versão
- [x] `ROADMAP.md`: marcar party-mode como entregue, ajustar Fase 4
- [x] `+specs/project/STATE.md`: atualizar Todos Ativos e Decisões

Cobre: consistência documental

---

## Ordem de Execução Recomendada

T2 → T3 → T1 → T4 → T5 → T6

(Assets precisam existir antes de testar; comando Claude depende de assets; template AGENTS.md é independente; testes validam tudo antes do sync documental.)
