---
title: "AGENTS — WSD"
created: 05/05/2026
modified: 15/06/2026
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
> Veja [`CONTRIBUTING.md`](CONTRIBUTING.md) — define onde corrigir (projeto-alvo vs `flow31-d/WSD`), fluxo de Issue/PR e convenções de versionamento. Vale para qualquer agente: Codex, Claude Code, ou humano.


> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. Identidade]]
3. [[#3. WSD Codex Bootstrap]]
4. [[#4. Regras ao Editar Este Pacote]]
5. [[#5. Convenções]]
6. [[#6. Segurança]]
7. [[#7. Fluxo de Edição]]
8. [[#8. Sincronização Obrigatória]]
9. [[#9. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 05/05/2026 13:29:54 -03 — Codex: Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes.
- 05/05/2026 14:13:39 -03 — Codex: Inclusão de regra operacional para agentes consultarem a matriz de sincronização antes de finalizar alterações no WSD.
- 15/06/2026 — Codex: Inclusão de regra de sincronização para WSD Loop (`docs/19`, `automation.loop`, prompts e CLI).
- 15/06/2026 — Codex: Inclusão do bloco WSD Codex Bootstrap para aderência automática quando o Codex abre o repo.
- 15/06/2026 — Codex: Inclusão da política `automation.loop.auto_use` para ligar/desligar uso automático do Ralph/WSD Loop.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. Identidade

Este diretório contém o pacote WSD, Wolff Spec Driven. Ele é um template e uma metodologia para governar desenvolvimento com agentes em repositórios privados.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. WSD Codex Bootstrap

Quando o Codex abrir este repositório, assumir que este `AGENTS.md` já está ativo. O operador não precisa pedir "leia o WSDD" nem listar arquivos manualmente.

Ao iniciar qualquer tarefa:

1. Tratar `AGENTS.md` como contrato operacional.
2. Ler `+context.json` antes de editar e respeitar paths permitidos/proibidos.
3. Consultar `+specs/project/STATE.md` e `+specs/HANDOFF.md`, se existir.
4. Rodar `./+wsd/bin/wsd start --brief` quando disponível.
5. Classificar a tarefa como L0, L1 ou L2 antes de implementar.
6. Exigir spec aprovada para L1/L2; L2 exige aprovação humana explícita e rollback.
7. Verificar `automation.loop.auto_use` em `+context.json`.
8. Antes de finalizar mudanças relevantes, rodar `git diff --check`, `bash scripts/wsd_docs_check.sh` e `bash scripts/wsd_self_check.sh`.

Política Ralph/WSD Loop:

- Se `automation.loop.auto_use=true`, então para tarefas L0/L1 elegíveis, com spec aprovada e worktree limpa, usar WSD Loop automaticamente antes de executar manualmente.
- Se houver feature slug: rodar `./+wsd/bin/wsd loop plan --feature <slug>` quando precisar planejar e `./+wsd/bin/wsd loop once --feature <slug>` para gerar o prompt de iteração.
- Se o operador usar `./+wsd/bin/wsd codex --exec --feature <slug>`, o launcher pode executar `loop run` com Codex Exec.
- Se `automation.loop.auto_use=false`, não disparar loop por conta própria; apenas sugerir quando fizer sentido.
- Nunca aplicar auto-use a L2 sem aprovação humana explícita.

Comandos curtos para aderência Codex:

```bash
./+wsd/bin/wsd codex-prompt --task "descreva a tarefa"
./+wsd/bin/wsd codex --task "descreva a tarefa"
./+wsd/bin/wsd codex --exec --feature <slug>
./+wsd/bin/wsd loop auto status
./+wsd/bin/wsd loop auto on
./+wsd/bin/wsd loop auto off
./+wsd/bin/wsd codex-shortcuts status
./+wsd/bin/wsd shortcuts status
```

No Codex, skills compartilhadas do projeto ficam em `.agents/skills/` (espelhadas em `.codex/skills/` para compatibilidade). Para WSD Loop, pedidos curtos como `loop status`, `loop auto on` e `loop auto off` devem mapear para `./+wsd/bin/wsd loop ...`; se o operador instalar prompts opcionais com `codex-shortcuts install`, o atalho do TUI é `/prompts:loop status`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. Regras ao Editar Este Pacote

- Manter o WSD genérico.
- Não inserir dados sensíveis, tokens, chaves, URLs privadas não necessárias ou segredos.
- Não hardcodar Prescreve Mais, Koomplet Office ou outro projeto dentro dos templates genéricos; usar `profiles/` e `examples/`.
- Preservar placeholders `{{...}}` nos arquivos `.template`.
- Validar JSON e YAML após alterações.
- Usar `scripts/wsd_check.sh` antes de considerar o pacote pronto.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. Convenções

- Documentos metodológicos vivem em `docs/`.
- Templates copiáveis vivem em `templates/`.
- Perfis de projeto vivem em `profiles/`.
- Exemplos concretos vivem em `examples/`.
- Scripts de apoio vivem em `scripts/`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. Segurança

WSD nunca deve armazenar:

- secrets reais;
- API keys;
- certificados privados;
- `.env` reais;
- dumps de logs sensíveis;
- dados pessoais ou clínicos;
- credenciais GitHub.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. Fluxo de Edição

1. Entender se a mudança é no método, no template, no perfil ou no exemplo.
2. Alterar somente a camada correta.
3. Rodar validações.
4. Consultar [[wsd/docs/10_matriz_sincronizacao_notas|10 — Matriz de Sincronização de Notas WSD]].
5. Atualizar README/hub se criar novo documento.
6. Atualizar notas e arquivos derivados indicados pela matriz.
7. Rodar `bash scripts/wsd_docs_check.sh`.
8. Rodar `bash scripts/wsd_self_check.sh`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. Sincronização Obrigatória

Todo agente que alterar `README.md`, `wsd.md`, `ROADMAP.md`, `CHANGELOG.md`, `docs/`, `templates/`, `profiles/`, `scripts/`, `bin/wsd-method.js`, `install.sh` ou `package.json` deve:

- abrir a matriz de sincronização;
- revisar o grupo mínimo de notas relacionado ao tipo de mudança;
- atualizar `## 1. 🔄 Atualizações` e a tabela final das notas editadas;
- corrigir links antigos ou apontando para arquivos inexistentes;
- manter `README.md`, `wsd.md` e `ROADMAP.md` coerentes entre si;
- quando alterar WSD Loop, sincronizar `docs/19`, `templates/local-wsd/bin/wsd`, `templates/local-wsd/loop/`, schema, README, roadmap, changelog e testes;
- executar os checkers documentais antes do commit.

Comandos mínimos:

```bash
bash scripts/wsd_docs_check.sh
bash scripts/wsd_self_check.sh
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 9. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 05/05/2026 13:29:54 -03 | Codex | `x/wsd/AGENTS.md` | Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes. |
| 05/05/2026 14:13:39 -03 | Codex | `x/wsd/AGENTS.md` | Inclusão de regra operacional para agentes consultarem a matriz de sincronização antes de finalizar alterações no WSD. |
| 15/06/2026 | Codex | `+Apps/wsd/AGENTS.md` | Inclusão de regra explícita de sincronização para alterações no WSD Loop. |
| 15/06/2026 | Codex | `+Apps/wsd/AGENTS.md` | Inclusão do WSD Codex Bootstrap e comandos curtos `wsd codex-prompt`/`wsd codex`. |
| 15/06/2026 | Codex | `+Apps/wsd/AGENTS.md` | Inclusão da política `automation.loop.auto_use` para auto-uso do Ralph/WSD Loop. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
