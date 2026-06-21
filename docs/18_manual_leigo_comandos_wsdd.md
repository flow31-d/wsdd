---
title: "18 — Manual Leigo dos Comandos WSDD"
created: 13/05/2026
modified: 15/06/2026
tags:
  - x
  - wsd
  - wsdd
  - comandos
  - manual
status: ativo
tipo: guia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/README]], [[wsd/docs/04_playbook_implantacao]], [[wsd/docs/08_rotinas_sessao]], [[wsd/docs/15_repositorio_publico_e_quick_start]], [[wsd/docs/17_snapshot_campos_explicados]]"
otimizado_para_obsidian: true
---
# 18 — Manual Leigo dos Comandos WSDD

[[wsd/wsd|← WSD]]

---

> [!abstract] Objetivo
> Explicar, em linguagem simples, os comandos principais para instalar e usar o WSDD/WSD no dia a dia.

> [!info] Versão coberta
> Versão coberta: **`v0.4.6`** do WSD/WSDD, com inventário de versão por projeto via `wsd version`, automação L0/L1 via `wsd loop`, aderência Codex via `wsd codex-prompt`, atalhos Codex/Claude/shell, relatório geral via `wsd relatorio`, pipeline de preocupações via `CONCERNS_PIPELINE.md`, fechamento limpo via `wsd finish` e `wsd update` preservador.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. Antes de Começar]]
3. [[#3. O Que é WSDD em Uma Frase]]
4. [[#4. Instalar em Um Projeto]]
5. [[#5. Comandos Que Você Vai Usar Sempre]]
6. [[#6. Comandos de Git]]
7. [[#7. Comandos de Party Mode]]
8. [[#8. Comandos de Agente]]
9. [[#9. Comandos de Manutenção]]
10. [[#10. Fluxos Prontos]]
11. [[#11. Problemas Comuns]]
12. [[#12. Cola Rápida]]
13. [[#13. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

- 13/05/2026 — Codex: Criação do manual leigo com os comandos principais da release pública `wsdd v0.2.1`.
- 30/05/2026 18:15:09 -03 — Codex: Atualização para `v0.3.1`, incluindo o comando `wsd version` para saber qual versão do WSD está instalada em cada projeto.
- 15/06/2026 — Codex: Inclusão dos comandos `wsd loop` da `v0.4.0` para automação com menos aprovações.
- 15/06/2026 — Codex: Inclusão dos comandos `wsd codex-prompt`, `wsd codex` e `start --brief`.
- 21/06/2026 — Codex: Inclusão do comando `wsd relatorio` da `v0.4.4`.
- 21/06/2026 — Codex: Atualização para `v0.4.5`: `wsd update` passa a trazer novos atalhos de agente sem sobrescrever arquivos customizados.
- 21/06/2026 — Codex: Atualização para `v0.4.6`: `wsd relatorio` passa a reconhecer headings acentuados em português.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. Antes de Começar

Você precisa ter:

| Ferramenta | Precisa? | Para quê |
|---|---:|---|
| Node.js 20 ou maior | Sim | Rodar o instalador do WSDD |
| Git | Sim, na prática | Versionar o projeto |
| GitHub CLI (`gh`) | Opcional | Criar/ver PRs pelo terminal |
| Obsidian | Opcional, recomendado | Ler as notas geradas com visual melhor |

Para conferir se tem Node:

```bash
node --version
```

Para conferir se tem Git:

```bash
git --version
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. O Que é WSDD em Uma Frase

WSDD instala uma "pasta de regras" no projeto para que você e os agentes saibam:

- onde estão;
- o que pode ou não pode ser mexido;
- qual tarefa está ativa;
- como validar antes de commitar;
- como fechar a sessão deixando rastro.

Depois da instalação, o comando principal passa a ser:

```bash
./+wsd/bin/wsd
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. Instalar em Um Projeto

### 4.1 Instalação mais simples

Entre na pasta do projeto e rode:

```bash
npx github:flow31-d/wsdd#v0.4.6 install --init-git
```

Use essa forma quando você quer responder às perguntas na tela. Se aparecer um valor entre colchetes, apertar Enter aceita o padrão.

### 4.2 Projeto novo, sem perguntas

Use quando você quer instalar rápido com escolhas padrão:

```bash
npx github:flow31-d/wsdd#v0.4.6 install \
  --directory . \
  --init-git \
  --tools both \
  --git-policy basic \
  --github skip \
  --yes
```

O que isso faz:

| Opção | Significado simples |
|---|---|
| `--directory .` | Instala na pasta atual |
| `--init-git` | Cria Git se ainda não existir |
| `--tools both` | Instala suporte para Codex e Claude Code |
| `--git-policy basic` | Ativa regras básicas de Git e commits |
| `--github skip` | Não tenta criar repo no GitHub |
| `--yes` | Não pergunta nada; usa padrões |

### 4.3 Projeto que já existe

Use `--brownfield` quando o projeto já tem código:

```bash
npx github:flow31-d/wsdd#v0.4.6 install \
  --directory . \
  --tools both \
  --git-policy full \
  --github existing \
  --brownfield \
  --yes
```

`--brownfield` cria notas extras em `+specs/codebase/` para documentar stack, arquitetura, convenções, estrutura, integrações e testes.

### 4.4 Instalação mais leve

Se você quiser menos arquivos dentro de `+wsd/`:

```bash
npx github:flow31-d/wsdd#v0.4.6 install \
  --directory . \
  --init-git \
  --tools both \
  --git-policy basic \
  --github skip \
  --no-docs \
  --no-party-mode \
  --no-examples \
  --yes
```

Use essa forma se você quer só o essencial operacional.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. Comandos Que Você Vai Usar Sempre

Rode estes comandos dentro da pasta do projeto.

### 5.1 Ver se a instalação está boa

```bash
./+wsd/bin/wsd doctor
```

Use quando:

- acabou de instalar;
- clonou o projeto em outra máquina;
- algo parece quebrado.

### 5.2 Ver qual versão do WSD está instalada

```bash
./+wsd/bin/wsd version
```

Use quando:

- você tem vários projetos com WSD aplicado;
- quer saber se um repo está atrasado em relação à fonte WSD;
- vai registrar status de implantação.

Para varrer vários projetos:

```bash
./+wsd/bin/wsd version --inventory --path /srv/CLI/+Apps --max-depth 4
```

Para saída legível por automação:

```bash
./+wsd/bin/wsd version --json --inventory --path /srv/CLI
```

### 5.3 Começar uma sessão de trabalho

```bash
./+wsd/bin/wsd start
```

Ele mostra estado do Git, branch, remote, checks básicos e últimos arquivos de contexto.

Use antes de pedir trabalho para um agente.

Para uma saída curta, boa para agentes e scripts:

```bash
./+wsd/bin/wsd start --brief
```

### 5.4 Validar o projeto

```bash
./+wsd/bin/wsd check
```

Esse é o comando de segurança. Ele verifica se o contrato WSD mínimo está de pé.

Você também pode informar risco:

```bash
./+wsd/bin/wsd check --risk L0
./+wsd/bin/wsd check --risk L1
./+wsd/bin/wsd check --risk L2
```

Regra simples:

| Risco | Quando usar                                                |
| ----- | ---------------------------------------------------------- |
| `L0`  | Ajuste pequeno, doc, texto, configuração simples           |
| `L1`  | Feature normal, endpoint, integração, refatoração moderada |
| `L2`  | Mudança estrutural, segurança, dados sensíveis, produção   |

### 5.5 Pedir um relatório geral

```bash
./+wsd/bin/wsd relatorio
```

Use quando você quer entender rapidamente:

- estado atual do Git e do WSD;
- se há implementação pela metade;
- se existe plano em ordem para executar;
- quais ideias estão ativas e se têm pipeline;
- quais concerns estão ativas e se têm pipeline;
- qual próximo passo o agente sugere.

Para salvar em arquivo:

```bash
./+wsd/bin/wsd relatorio --save
```

Isso cria:

```text
+specs/RELATORIO.md
```

Também funcionam os aliases:

```bash
./+wsd/bin/wsd report
./+wsd/bin/wsd status-report
./+wsd/bin/wsd resumo
```

### 5.6 Fechar uma sessão

```bash
./+wsd/bin/wsd finish
```

Ele:

- mostra estado final;
- roda validações e gates de aprovação;
- revisa documentação WSD quando o auditor documental está disponível;
- gera `+specs/HANDOFF.md`;
- pode perguntar lições, decisões e bloqueadores;
- atualiza `+wsd/snapshot.json` quando possível.
- cria commit de fechamento por padrão;
- só termina aprovado se o `git status` ficar limpo.

Use antes de parar o trabalho ou trocar de agente.

Se algum gate falhar, o comando para e mostra o motivo. Ele não usa `git reset`, `git stash`, `git clean`, `--no-verify`, auto-push ou auto-merge.

### 5.7 Gerar snapshot para dashboard

```bash
./+wsd/bin/wsd snapshot
```

Isso gera:

```text
+wsd/snapshot.json
```

Esse arquivo é lido por ferramentas como o WDB.

### 5.8 Automatizar uma feature com WSD Loop

```bash
./+wsd/bin/wsd loop plan --feature minha-feature
./+wsd/bin/wsd loop once --feature minha-feature --agent-cmd 'comando-do-agente'
./+wsd/bin/wsd loop run --feature minha-feature --agent-cmd 'comando-do-agente' --max-iterations 3
```

Em linguagem simples:

- `plan` prepara o prompt e as tarefas;
- `once` faz uma iteração;
- `run` repete várias iterações com limite;
- `status` mostra o último estado;
- `stop` remove um lock local se precisar parar.

Use para tarefas L0/L1 com spec clara. Para L2, o WSD exige aprovação explícita.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. Comandos de Git

### 6.1 Diagnóstico Git

```bash
./+wsd/bin/wsd git doctor
```

Mostra:

- modo de governança Git;
- branch atual;
- upstream;
- remote;
- branch principal;
- se `gh` está disponível.

### 6.2 Checar antes de começar operação Git

```bash
./+wsd/bin/wsd git preflight
```

Use antes de mexer em branch, sincronizar ou preparar commit.

Ele falha se a worktree estiver suja. Isso é bom: evita misturar mudanças sem perceber.

### 6.3 Checar antes de abrir PR

```bash
./+wsd/bin/wsd git pr-check
```

Use antes de abrir Pull Request.

Ele verifica se:

- você está em branch dedicada;
- há commits à frente da branch principal;
- a worktree está limpa;
- a configuração Git faz sentido.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. Comandos de Party Mode

Party Mode é o modo multi-agente. Ele ajuda quando a tarefa pede debate, arquitetura, risco ou revisão.

### 7.1 Ver se está instalado

```bash
./+wsd/bin/wsd party status
```

### 7.2 Listar agentes disponíveis

```bash
./+wsd/bin/wsd party list-agents
```

### 7.3 Saber quando usar

```bash
./+wsd/bin/wsd party when-to-use
```

Regra simples:

- tarefa pequena: não precisa;
- feature moderada: pode ajudar;
- arquitetura, risco alto ou revisão importante: use.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. Comandos de Agente

Se você estiver usando Claude Code, os comandos aparecem como slash commands:

```text
/wsd-start
/wsd-specify
/wsd-design
/wsd-tasks
/wsd-finish
/wsd-relatorio
/wsd-party-mode
/loop status
/loop on
/loop off
/idea-NOME_DO_PROJETO
/concern-NOME_DO_PROJETO
```

Se você estiver usando Codex, peça em linguagem natural:

```text
Use wsd-start neste projeto.
Crie uma spec WSD para esta feature.
Rode wsd-design para esta mudança.
Quebre isso em tasks WSD.
Finalize a sessão com wsd-finish.
Faça um relatório WSD do projeto.
loop status
loop auto on
loop auto off
Registre esta preocupação: preciso conferir ...
```

Ou use um comando curto do WSD:

```bash
./+wsd/bin/wsd codex-prompt --task "minha tarefa"
./+wsd/bin/wsd codex --task "minha tarefa"
./+wsd/bin/wsd codex-shortcuts status
```

`codex-prompt` só mostra o texto que você pode colar no Codex. `codex` tenta abrir o Codex já apontado para o projeto.

Se quiser um atalho slash no Codex CLI, rode uma vez:

```bash
./+wsd/bin/wsd codex-shortcuts install
```

Depois reinicie o Codex se necessário e use:

```text
/prompts:loop status
/prompts:loop on
/prompts:loop off
```

Observação: no Codex o comando customizado fica no namespace `/prompts:...`; `/loop status` puro é comando de Claude Code via `.claude/commands/loop.md`.

Para fazer o Codex preferir Ralph/WSD Loop automaticamente quando a tarefa for L0/L1 e tiver spec:

```bash
./+wsd/bin/wsd loop auto on
```

Para desligar:

```bash
./+wsd/bin/wsd loop auto off
```

O fluxo normal é:

```text
start → specify → design → tasks → implementar → check → finish
```

Para tarefa pequena, pode ser:

```text
start → implementar → check → finish
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 9. Comandos de Manutenção

### 9.1 Reinstalar hooks Git

```bash
./+wsd/bin/wsd hooks
```

Use quando:

- clonou o repo de novo;
- `.git/hooks/` sumiu;
- `doctor` avisou que hooks estão faltando.

### 9.2 Atualizar a pasta `+wsd/`

```bash
./+wsd/bin/wsd update
```

Esse comando atualiza a parte vendorizada do WSD no projeto e adiciona novos atalhos de agente quando eles ainda não existem. Ele preserva:

- `+context.json`;
- `AGENTS.md`;
- `+specs/`;
- `scripts/wsd_check.sh`;
- `scripts/git-hooks/`.
- arquivos customizados já existentes em `.agents/skills/`, `.codex/skills/`, `.claude/commands/` e `+wsd/hooks/`.

Se ele reclamar de `wsd_source`, reinstale a versão desejada por cima com `--force`:

```bash
npx github:flow31-d/wsdd#v0.4.6 install \
  --directory . \
  --force
```

### 9.3 Ver opções do instalador

```bash
npx github:flow31-d/wsdd#v0.4.6 install --list-options
```

### 9.4 Ver ajuda do instalador

```bash
npx github:flow31-d/wsdd#v0.4.6 help
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 10. Fluxos Prontos

### 10.1 Comecei o dia

```bash
./+wsd/bin/wsd doctor
./+wsd/bin/wsd start
```

Depois leia o que aparecer e só então peça trabalho ao agente.

### 10.2 Vou fazer uma mudança pequena

```bash
./+wsd/bin/wsd start
# fazer a mudança
./+wsd/bin/wsd check --risk L0
./+wsd/bin/wsd finish
```

### 10.3 Vou fazer uma feature

```bash
./+wsd/bin/wsd start
# pedir ao agente: wsd-specify
# pedir ao agente: wsd-design, se a feature for complexa
# pedir ao agente: wsd-tasks
# implementar
./+wsd/bin/wsd check --risk L1
./+wsd/bin/wsd git preflight
./+wsd/bin/wsd finish
```

### 10.4 Vou abrir PR

```bash
./+wsd/bin/wsd check --risk L1
./+wsd/bin/wsd git pr-check
```

Se os dois passarem, o projeto está em melhor estado para PR.

### 10.5 Vou parar agora e continuar depois

```bash
./+wsd/bin/wsd finish
```

Na próxima sessão:

```bash
./+wsd/bin/wsd start
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 11. Problemas Comuns

### "target is not a Git repository"

O projeto ainda não tem Git. Use:

```bash
git init -b main
```

Ou rode o install com:

```bash
--init-git
```

### "worktree is dirty"

Há arquivos modificados sem commit. Veja:

```bash
git status --short --branch
```

Decida se vai commitar, descartar ou separar a mudança. Não ignore esse aviso.

### "missing: .git/hooks/..."

Reinstale hooks:

```bash
./+wsd/bin/wsd hooks
```

### "node missing"

Instale Node.js 20 ou maior. Sem Node, parte dos validadores do WSD não roda.

### "gh not authenticated"

Só importa se você usa GitHub pelo terminal. Confira:

```bash
gh auth status
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 12. Cola Rápida

```bash
# Instalar WSDD v0.4.6 na pasta atual
npx github:flow31-d/wsdd#v0.4.6 install --init-git

# Ver se está tudo certo
./+wsd/bin/wsd doctor

# Ver versão instalada
./+wsd/bin/wsd version

# Inventariar vários projetos
./+wsd/bin/wsd version --inventory --path /srv/CLI/+Apps --max-depth 4

# Começar trabalho
./+wsd/bin/wsd start

# Contexto curto para agente/script
./+wsd/bin/wsd start --brief

# Relatorio geral do projeto
./+wsd/bin/wsd relatorio

# Prompt curto para Codex seguir WSDD
./+wsd/bin/wsd codex-prompt --task "minha tarefa"

# Atalhos Codex e terminal
./+wsd/bin/wsd codex-shortcuts status
./+wsd/bin/wsd shortcuts status

# Ligar/desligar Ralph/WSD Loop automatico
./+wsd/bin/wsd loop auto status
./+wsd/bin/wsd loop auto on
./+wsd/bin/wsd loop auto off

# Validar
./+wsd/bin/wsd check

# Validar por risco
./+wsd/bin/wsd check --risk L0
./+wsd/bin/wsd check --risk L1
./+wsd/bin/wsd check --risk L2

# Fechar sessão
./+wsd/bin/wsd finish

# Git
./+wsd/bin/wsd git doctor
./+wsd/bin/wsd git preflight
./+wsd/bin/wsd git pr-check

# Party mode
./+wsd/bin/wsd party status
./+wsd/bin/wsd party list-agents
./+wsd/bin/wsd party when-to-use

# Manutenção
./+wsd/bin/wsd hooks
./+wsd/bin/wsd update
./+wsd/bin/wsd snapshot
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 13. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 13/05/2026 — | Codex | `x/wsd/docs/18_manual_leigo_comandos_wsdd.md` | Criação do manual leigo para instalação e uso diário do WSDD `v0.2.1`, incluindo comandos de install, sessão, check, Git, Party Mode, manutenção e troubleshooting. |
| 30/05/2026 18:15:09 -03 | Codex | `+Apps/wsd/docs/18_manual_leigo_comandos_wsdd.md` | Atualização para `v0.3.1`: inclusão de `wsd version`, inventário multi-repo e exemplos de saída JSON para automação. |
| 15/06/2026 | Codex | `+Apps/wsd/docs/18_manual_leigo_comandos_wsdd.md` | Atualização para `v0.4.0`: inclusão de `wsd loop` e exemplos de automação L0/L1. |
| 15/06/2026 | Codex | `+Apps/wsd/docs/18_manual_leigo_comandos_wsdd.md` | Inclusão de `wsd codex-prompt`, `wsd codex` e `start --brief`. |
| 17/06/2026 | Codex | `+Apps/wsd/docs/18_manual_leigo_comandos_wsdd.md` | Inclusão de atalhos WSD Loop para Codex (`/prompts:loop`), Claude Code (`/loop status`) e shell (`shortcuts`). |
| 21/06/2026 | Codex | `+Apps/wsd/docs/18_manual_leigo_comandos_wsdd.md` | Atualização para `v0.4.4`: inclusão de `wsd relatorio`, `/wsd-relatorio` e exemplos de relatório geral. |
| 21/06/2026 | Codex | `+Apps/wsd/docs/18_manual_leigo_comandos_wsdd.md` | Atualização para `v0.4.5`: `wsd update` preservador e exemplos de instalação com nova tag. |
| 21/06/2026 | Codex | `+Apps/wsd/docs/18_manual_leigo_comandos_wsdd.md` | Atualização para `v0.4.6`: relatório tolerante a headings acentuados. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
