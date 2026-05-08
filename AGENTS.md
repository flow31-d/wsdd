---
title: "AGENTS — WSD"
created: 05/05/2026
modified: 05/05/2026
tags:
  - x
  - wsd
  - agentes
status: ativo
tipo: guia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/README]], [[wsd/docs/01_constituicao]], [[wsd/docs/04_playbook_implantacao]], [[wsd/docs/10_matriz_sincronizacao_notas]]"
otimizado_para_obsidian: true
---
# Instruções para Agentes — WSD

[[wsd/wsd|← WSD]]

---

> [!tip] Achou bug em projeto que usa WSD?
> Veja [`CONTRIBUTING.md`](CONTRIBUTING.md) — define onde corrigir (projeto-alvo vs `flow31-d/wsdd`), fluxo de Issue/PR e convenções de versionamento. Vale para qualquer agente: Codex, Claude Code, ou humano.


> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. Identidade]]
3. [[#3. Regras ao Editar Este Pacote]]
4. [[#4. Convenções]]
5. [[#5. Segurança]]
6. [[#6. Fluxo de Edição]]
7. [[#7. Sincronização Obrigatória]]
8. [[#8. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 05/05/2026 13:29:54 -03 — Codex: Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes.
- 05/05/2026 14:13:39 -03 — Codex: Inclusão de regra operacional para agentes consultarem a matriz de sincronização antes de finalizar alterações no WSD.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. Identidade

Este diretório contém o pacote WSD, Wolff Spec Driven. Ele é um template e uma metodologia para governar desenvolvimento com agentes em repositórios privados.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. Regras ao Editar Este Pacote

- Manter o WSD genérico.
- Não inserir dados sensíveis, tokens, chaves, URLs privadas não necessárias ou segredos.
- Não hardcodar Exemplo SaaS A, Exemplo SaaS B ou outro projeto dentro dos templates genéricos; usar `profiles/` e `examples/`.
- Preservar placeholders `{{...}}` nos arquivos `.template`.
- Validar JSON e YAML após alterações.
- Usar `scripts/wsd_check.sh` antes de considerar o pacote pronto.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. Convenções

- Documentos metodológicos vivem em `docs/`.
- Templates copiáveis vivem em `templates/`.
- Perfis de projeto vivem em `profiles/`.
- Exemplos concretos vivem em `examples/`.
- Scripts de apoio vivem em `scripts/`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. Segurança

WSD nunca deve armazenar:

- secrets reais;
- API keys;
- certificados privados;
- `.env` reais;
- dumps de logs sensíveis;
- dados pessoais ou clínicos;
- credenciais GitHub.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. Fluxo de Edição

1. Entender se a mudança é no método, no template, no perfil ou no exemplo.
2. Alterar somente a camada correta.
3. Rodar validações.
4. Consultar [[wsd/docs/10_matriz_sincronizacao_notas|10 — Matriz de Sincronização de Notas WSD]].
5. Atualizar README/hub se criar novo documento.
6. Atualizar notas e arquivos derivados indicados pela matriz.
7. Rodar `bash scripts/wsd_docs_check.sh`.
8. Rodar `bash scripts/wsd_self_check.sh`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. Sincronização Obrigatória

Todo agente que alterar `README.md`, `wsd.md`, `ROADMAP.md`, `CHANGELOG.md`, `docs/`, `templates/`, `profiles/`, `scripts/`, `bin/wsd-method.js`, `install.sh` ou `package.json` deve:

- abrir a matriz de sincronização;
- revisar o grupo mínimo de notas relacionado ao tipo de mudança;
- atualizar `## 1. 🔄 Atualizações` e a tabela final das notas editadas;
- corrigir links antigos ou apontando para arquivos inexistentes;
- manter `README.md`, `wsd.md` e `ROADMAP.md` coerentes entre si;
- executar os checkers documentais antes do commit.

Comandos mínimos:

```bash
bash scripts/wsd_docs_check.sh
bash scripts/wsd_self_check.sh
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 05/05/2026 13:29:54 -03 | Codex | `x/wsd/AGENTS.md` | Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes. |
| 05/05/2026 14:13:39 -03 | Codex | `x/wsd/AGENTS.md` | Inclusão de regra operacional para agentes consultarem a matriz de sincronização antes de finalizar alterações no WSD. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
