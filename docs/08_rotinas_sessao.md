---
title: "08 — Rotinas de Sessão WSD"
created: 05/05/2026
modified: 15/06/2026
tags:
  - x
  - wsd
  - sessao
  - rotina
status: ativo
tipo: guia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/docs/03_ciclo_operacional]], [[wsd/docs/10_matriz_sincronizacao_notas]], [[wsd/templates/codex-skills/wsd-start/SKILL.md]], [[wsd/templates/codex-skills/wsd-finish/SKILL.md]], [[wsd/templates/local-wsd/bin/wsd]]"
otimizado_para_obsidian: true
---
# 08 — Rotinas de Sessão WSD

[[wsd/wsd|← WSD]]

---


> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. Início de Sessão]]
3. [[#3. Execução]]
4. [[#4. Fim de Sessão]]
5. [[#5. Regra de Continuidade]]
6. [[#6. Skills Codex Locais]]
7. [[#7. Sincronização Destas Rotinas]]
8. [[#8. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 05/05/2026 13:29:54 -03 — Codex: Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes.
- 05/05/2026 14:13:39 -03 — Codex: Alinhamento das rotinas ao CLI local `+wsd/bin/wsd` e correção dos links das skills Codex para `SKILL.md`.
- 06/05/2026 — Claude: Adição da seção 6.2 com comandos slash Claude Code, hook e settings; atualização da lista de sincronização para incluir `templates/claude-commands/`.
- 06/05/2026 — Claude: Integração de `STATE.md` e `HANDOFF.md` no fluxo de início e fim de sessão, auto-sizing inicial, e novos comandos de fase (`/wsd-specify`, `/wsd-design`, `/wsd-tasks`).
- 07/05/2026 — Claude: Atualização da seção 4 para refletir `wsd finish` automatizado (`v0.1.7-alpha`): HANDOFF.md gerado pelo CLI e prompts interativos para STATE.md.
- 07/05/2026 — Codex: Planejamento dos comandos Git/GitHub Governance no início, execução e promoção de sessão (`v0.1.10-alpha`).
- 07/05/2026 — Codex: Atualização das rotinas para refletir comandos Git/GitHub Governance implementados na `v0.1.10-alpha`.
- 30/05/2026 18:15:09 -03 — Codex: Inclusão de `wsd version` na rotina de início quando for necessário confirmar a versão WSD aplicada no projeto.
- 15/06/2026 — Codex: Inclusão do `wsd loop` como rotina opcional para automatizar execução L0/L1 com gates e poucas aprovações.
- 15/06/2026 — Codex: Inclusão do Codex Adherence Pack: `WSD Codex Bootstrap`, `start --brief`, `codex-prompt` e `codex`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. Início de Sessão

Comando curto recomendado dentro do projeto:

```bash
./+wsd/bin/wsd start
```

Contexto compacto para agentes ou wrappers:

```bash
./+wsd/bin/wsd start --brief
```

No Codex, o fluxo normal continua sendo abrir a sessão já na pasta do projeto e pedir a tarefa. O `AGENTS.md` gerado pelo WSD contém a seção `WSD Codex Bootstrap`, que instrui o agente a ler `+context.json`, `STATE.md`, `HANDOFF.md` e classificar risco sem o operador precisar listar esses arquivos.

Quando houver dúvida sobre qual WSD está aplicado no repo, rodar antes ou logo após o start:

```bash
./+wsd/bin/wsd version
```

O agente deve:

1. identificar repo e host canônico;
2. confirmar a versão WSD instalada quando isso afetar a tarefa;
3. rodar checks Git;
4. detectar `+context.json`;
5. carregar `+specs/project/STATE.md` (decisões ativas, bloqueadores) e `+specs/HANDOFF.md` se existir (perguntar "continuar de onde parou?");
6. rodar checker L0;
7. listar specs ativas em `+specs/features/`;
8. **auto-sizing**: classificar a tarefa do usuário como L0/L1/L2 e propor fluxo (Quick / Specify+Execute / 4 fases);
9. indicar próximo passo seguro.

Quando o módulo Git/GitHub Governance estiver instalado em modo `basic` ou `full`, o início de sessão também deve rodar `./+wsd/bin/wsd git preflight` e, para tarefas L1/L2, `./+wsd/bin/wsd git doctor`.

Saída esperada:

```text
Repo:
Host:
Path:
Branch/upstream:
Worktree:
WSD version:
Context:
STATE.md:
HANDOFF.md:
Specs:
Risco/auto-size:
Próximo passo:
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. Execução

Prompt recomendado quando o usuário pedir uma tarefa:

```text
Use WSD. Classifique a tarefa, confira spec se necessário, execute só o escopo permitido e valide.
```

Alternativa com comando curto:

```bash
./+wsd/bin/wsd codex-prompt --task "descreva a tarefa"
./+wsd/bin/wsd codex --task "descreva a tarefa"
./+wsd/bin/wsd codex --exec --feature <slug>
```

`codex-prompt` só imprime o prompt WSDD. `codex` chama o Codex CLI apontando para o repo atual; `--exec` usa modo não interativo. Para testar sem depender do Codex instalado, usar `./+wsd/bin/wsd codex --dry-run --task "..."`.

Para ligar/desligar uso automático do Ralph/WSD Loop:

```bash
./+wsd/bin/wsd loop auto status
./+wsd/bin/wsd loop auto on
./+wsd/bin/wsd loop auto off
```

Com `automation.loop.auto_use=true`, o agente deve preferir WSD Loop para L0/L1 elegível, com spec aprovada e worktree limpa. Com `false`, o loop continua manual/sugerido.

O agente deve:

- aplicar matriz de risco e auto-sizing;
- escolher fluxo conforme o risco (ver [[wsd/docs/04_playbook_implantacao#9. Passo 7 — Auto-sizing e Fluxo de 4 Fases|Passo 7 do Playbook]]):
  - **L0**: Quick — implementar direto, registrar em `+specs/quick/<slug>.md`;
  - **L1**: `/wsd-specify` → (opcional `/wsd-design`) → `/wsd-tasks` → Execute;
  - **L2**: `/wsd-specify` → `/wsd-design` → `/wsd-tasks` → Execute, com aprovação humana entre fases;
- exigir spec aprovada para L1/L2 antes de implementar;
- abrir branch quando necessário;
- editar somente escopo permitido;
- aplicar **scope guardrail** (Regra 12): ideias adjacentes vão em `+specs/project/STATE.md` na seção *Ideias Adiadas*;
- validar com gate level apropriado (quick/full/build, ver `+specs/codebase/TESTING.md`);
- commitar conforme **Conventional Commits 1.0.0**;
- preparar PR quando solicitado ou quando o fluxo exigir;
- quando `git-governance` estiver ativo, rodar `./+wsd/bin/wsd git pr-check` antes de criar ou atualizar PR.
  Neste alpha, `pr-check` trata `upstream` e `remote` como sinais adicionais; o bloqueio principal é branch dedicada, worktree limpa e commits à frente da base.
  Spec/Issue e validação seguem no fluxo L1/L2 e nos checkers do projeto, não no `pr-check` local.

### 3.1 Automação com WSD Loop (v0.4.0)

Quando a spec L0/L1 já estiver clara e o operador quiser reduzir aprovações, usar:

```bash
./+wsd/bin/wsd loop plan --feature <slug>
./+wsd/bin/wsd loop once --feature <slug> --agent-cmd '<comando do agente>'
./+wsd/bin/wsd loop run --feature <slug> --agent-cmd '<comando do agente>' --max-iterations 3
./+wsd/bin/wsd loop auto on
```

Regras:

- `plan` e `once` sem `--agent-cmd` apenas geram prompts auditáveis em `+logs/wsd-loop/`;
- `run` exige `--agent-cmd`;
- L2 exige `--human-approved` e só roda se `automation.loop.allowed_risks` incluir `L2`;
- cada iteração valida paths, risco, `git diff --check`, WSD gates e CI antes de auto-commit.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. Fim de Sessão

Comando curto recomendado dentro do projeto:

```bash
./+wsd/bin/wsd finish
```

A partir da `v0.1.7-alpha`, o CLI executa automaticamente:

1. Estado Git: `git status`, `git diff --stat`, `git diff --check`, `git log -1`.
2. Checker L0 (se `scripts/wsd_check.sh` presente).
3. Gera `+specs/HANDOFF.md` com: branch atual, último commit, últimos 5 commits, arquivos uncommitted e specs abertas.
4. Prompts interativos em terminal (se `python3` disponível e stdin interativo):
   - **Lições aprendidas** → tabela `## Lições Aprendidas` em `STATE.md`;
   - **Decisões arquiteturais ou de método** → tabela `## Decisões`;
   - **Bloqueadores ativos** → tabela `## Bloqueadores Ativos`.

Após o CLI, o agente/operador deve:

- Revisar `+specs/HANDOFF.md` e preencher a seção **Próximos Passos**.
- Confirmar status de PR se houver (`gh pr status`).
- **Não** executar `git add .`, `git stash`, `git reset` ou trocar branch apenas para deixar relatório limpo.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. Regra de Continuidade

Se a sessão terminar com worktree suja, isso deve ficar explícito. Não limpar, stashear ou trocar branch apenas para produzir relatório bonito.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. Skills Locais por Agente

### 6.1 Codex (`--tools codex`)

Quando o WSD for instalado com `--tools codex`, o projeto recebe:

```text
.agents/skills/wsd/SKILL.md
.agents/skills/wsd-start/SKILL.md
.agents/skills/wsd-finish/SKILL.md
.agents/skills/wsd-specify/SKILL.md
.agents/skills/wsd-design/SKILL.md
.agents/skills/wsd-tasks/SKILL.md
.agents/skills/wsd-loop/SKILL.md
```

O instalador também espelha essas skills em `.codex/skills/` para compatibilidade com setups antigos. O caminho principal atual para Codex é `.agents/skills/`.

Uso prático:

- `wsd-start`: rotina de abertura sem implementar mudanças (carrega STATE.md/HANDOFF.md, auto-sizing);
- `wsd`: governança durante execução, classificação L0/L1/L2 e enforcement de spec (sempre ativa);
- `wsd-specify`: fase Specify — clarificação + WHEN/THEN/SHALL em `+specs/features/<slug>/spec.md` (HARD-GATE);
- `wsd-design`: fase Design — abordagens e arquitetura em `+specs/features/<slug>/design.md` (pode pular para casos simples);
- `wsd-tasks`: fase Tasks — quebra em `+specs/features/<slug>/tasks.md` atômico com gate level por task;
- `wsd-loop`: atalhos de Ralph/WSD Loop como `loop status`, `loop auto on`, `loop auto off`, `loop plan <feature>`;
- `wsd-finish`: relatório de fechamento, atualização de STATE.md, geração de HANDOFF.md.

### 6.2 Claude Code (`--tools claude-code`)

Quando o WSD for instalado com `--tools claude-code`, o projeto recebe:

```text
.claude/commands/wsd-start.md
.claude/commands/wsd-finish.md
.claude/commands/wsd-specify.md
.claude/commands/wsd-design.md
.claude/commands/wsd-tasks.md
.claude/commands/loop.md
.claude/settings.json              ← hooks PreToolUse, PreCompact, SessionStart, Stop
+wsd/hooks/pre-tool.sh             ← enforcement de forbidden_paths
```

Uso prático:

- `/wsd-start`: abre sessão com git state, `+context.json`, STATE.md/HANDOFF.md, specs e risco inicial (auto-sizing);
- `/wsd-specify`: cria `+specs/features/<slug>/spec.md` com WHEN/THEN/SHALL (HARD-GATE);
- `/wsd-design`: cria `+specs/features/<slug>/design.md` (pode pular em casos simples);
- `/wsd-tasks`: cria `+specs/features/<slug>/tasks.md` atômico;
- `/loop status`: consulta estado do Ralph/WSD Loop; `/loop on` e `/loop off` alternam `automation.loop.auto_use`;
- `/wsd-finish`: fecha sessão, atualiza STATE.md, gera HANDOFF.md.

A governança (conteúdo da skill `wsd` do Codex) vive no `AGENTS.md` gerado + hooks — não em comando persistente, porque Claude Code usa comandos slash sob demanda.

Os comandos não substituem o CLI local. Eles orientam o comportamento do agente; o CLI local executa checks padronizados.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. Sincronização Destas Rotinas

Ao alterar comandos de sessão, revisar sempre:

- `templates/local-wsd/bin/wsd`;
- `templates/codex-skills/wsd/SKILL.md`;
- `templates/codex-skills/wsd-start/SKILL.md`;
- `templates/codex-skills/wsd-finish/SKILL.md`;
- `templates/codex-skills/wsd-specify/SKILL.md`;
- `templates/codex-skills/wsd-design/SKILL.md`;
- `templates/codex-skills/wsd-tasks/SKILL.md`;
- `templates/codex-skills/wsd-loop/SKILL.md`;
- `templates/claude-commands/commands/wsd-start.md`;
- `templates/claude-commands/commands/wsd-finish.md`;
- `templates/claude-commands/commands/wsd-specify.md`;
- `templates/claude-commands/commands/wsd-design.md`;
- `templates/claude-commands/commands/wsd-tasks.md`;
- `templates/claude-commands/commands/loop.md`;
- `templates/claude-commands/hooks/pre-tool.sh`;
- `templates/claude-commands/settings.json`;
- `templates/repo/AGENTS.md.template`;
- [[wsd/docs/03_ciclo_operacional|03 Ciclo Operacional]];
- [[wsd/docs/10_matriz_sincronizacao_notas|10 Matriz de Sincronização]].

Rodar:

```bash
bash scripts/wsd_docs_check.sh
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 05/05/2026 13:29:54 -03 | Codex | `x/wsd/docs/08_rotinas_sessao.md` | Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes. |
| 05/05/2026 14:13:39 -03 | Codex | `x/wsd/docs/08_rotinas_sessao.md` | Alinhamento das rotinas ao CLI local `+wsd/bin/wsd` e correção dos links das skills Codex para `SKILL.md`. |
| 06/05/2026 — | Claude | `x/wsd/docs/08_rotinas_sessao.md` | Adição da seção 6.2 com comandos slash Claude Code (`/wsd-start`, `/wsd-finish`, hook, settings) e atualização da lista de sincronização. |
| 06/05/2026 — | Claude | `x/wsd/docs/08_rotinas_sessao.md` | Integração de STATE.md/HANDOFF.md no início e fim de sessão, auto-sizing inicial, scope guardrail na execução, e novos comandos de fase (`/wsd-specify`, `/wsd-design`, `/wsd-tasks`) em Codex e Claude Code. |
| 07/05/2026 — | Claude | `x/wsd/docs/08_rotinas_sessao.md` | Atualização da seção 4 (Fim de Sessão) para refletir `wsd finish` automatizado: HANDOFF.md gerado automaticamente pelo CLI e prompts interativos para STATE.md (v0.1.7-alpha). |
| 07/05/2026 — | Codex | `x/wsd/docs/08_rotinas_sessao.md` | Planejamento dos comandos `wsd git preflight`, `doctor` e `pr-check` nas rotinas de sessão da v0.1.10-alpha. |
| 07/05/2026 — | Codex | `x/wsd/docs/08_rotinas_sessao.md` | Atualização das rotinas para comandos `wsd git` implementados na v0.1.10-alpha. |
| 30/05/2026 18:15:09 -03 | Codex | `+Apps/wsd/docs/08_rotinas_sessao.md` | Inclusão do `wsd version` como checagem opcional de início de sessão para rastrear a versão WSD aplicada no repo. |
| 15/06/2026 | Codex | `+Apps/wsd/docs/08_rotinas_sessao.md` | Inclusão do fluxo opcional `wsd loop plan|once|run` para automação L0/L1 governada por gates. |
| 15/06/2026 | Codex | `+Apps/wsd/docs/08_rotinas_sessao.md` | Inclusão do Codex Adherence Pack: `start --brief`, `codex-prompt`, `codex` e bootstrap via `AGENTS.md`. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
