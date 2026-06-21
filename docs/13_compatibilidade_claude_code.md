---
title: "13 — Compatibilidade WSD com Claude Code"
created: 06/05/2026
modified: 06/05/2026
tags:
  - x
  - wsd
  - claude-code
  - codex
  - skills
  - compatibilidade
  - hooks
status: ativo
tipo: referencia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/docs/12_avaliacao_critica]], [[wsd/docs/08_rotinas_sessao]], [[wsd/docs/01_constituicao]], [[r.3.7_spec_driven_development/r.3.7.9_enforcement_agentes_cli]], [[r.2.1_agentes_cli/r.2.1.1_claude_code_cli]]"
otimizado_para_obsidian: true
---

# 13 — Compatibilidade WSD com Claude Code

[[wsd/wsd|← WSD]]

---

> [!abstract] Objetivo
> Analisar as diferenças estruturais entre como o Codex e o Claude Code tratam skills, identificar o gap de compatibilidade do WSD, e propor o modelo de implementação para suporte completo ao Claude Code — incluindo templates de skills e configuração de hooks.

> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. Como o Codex Trata Skills]]
3. [[#3. Como o Claude Code Trata Skills]]
4. [[#4. Tabela Comparativa]]
5. [[#5. A Diferença Fundamental — O Gap de Governança]]
6. [[#6. Análise das Skills WSD Atuais]]
7. [[#7. Modelo de Compatibilidade Proposto]]
8. [[#8. Templates Claude Code]]
9. [[#9. Configuração de Hooks]]
10. [[#10. O que o Installer Precisa Gerar]]
11. [[#11. 🕒 Registro de Alterações por Agentes]]

---

## 1. 🔄 Atualizações

- 06/05/2026 — Claude: Criação do documento com análise comparativa completa Codex vs. Claude Code skills e proposta de compatibilidade para o WSD.
- 06/05/2026 14:41:06 -03 — Codex: Padronização da lista de geração do installer com checkboxes para acompanhar os artefatos necessários ao suporte Claude.
- 06/05/2026 — Claude: Implementação completa — `templates/claude-commands/` criado com `commands/wsd-start.md`, `commands/wsd-finish.md`, `hooks/pre-tool.sh` e `settings.json`; `installClaudeCommands()` adicionado ao `wsd-method.js`; suporte `--tools claude-code` e `--tools both` operacional; `AGENTS.md.template` atualizado com referências a `/wsd-start` e `/wsd-finish`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 2. Como o Codex Trata Skills

Skills do Codex ficam em `.agents/skills/<nome>/SKILL.md` no escopo do repositório, ou em `$HOME/.agents/skills/` no escopo do usuário. O WSD ainda espelha em `.codex/skills/` para compatibilidade com instalações antigas, mas o caminho principal atual é `.agents/skills/`.

### Modelo de funcionamento

**Injeção passiva por matching semântico.** O Codex lê as descrições de todas as skills presentes no diretório e as carrega automaticamente no contexto quando a intenção do usuário corresponde ao `description` do frontmatter. O agente não precisa ser instruído a "usar a skill X" — ele reconhece o contexto e injeta o conteúdo relevante.

```
Usuário: "iniciar WSD"
Codex: detecta match com description de wsd-start → carrega SKILL.md no contexto → executa procedimento
```

### Características específicas

- **Trigger**: `description` no frontmatter define a condição de ativação; o agente faz o match automaticamente
- **Escopo**: skills de governança como `wsd` ficam **sempre ativas** quando presentes no repo — são carregadas como extensão persistente do contexto do agente
- **Estrutura**: tipicamente um único `SKILL.md` por skill (flat)
- **Conteúdo**: imperativo e procedural — listas de comandos bash, checklists, regras binárias
- **Ferramentas**: sem restrição declarada — o agente usa qualquer ferramenta disponível
- **Sem interação obrigatória**: skills Codex executam e reportam sem necessariamente pedir confirmação

### O que isso significa para `wsd` (governança)

A skill `wsd` no Codex é um **runtime constraint** — um conjunto de regras que o agente carrega e aplica em toda operação enquanto está no repositório. É equivalente a um CLAUDE.md que o agente lê automaticamente, mas com granularidade de "carrego quando estou em contexto WSD".

---

## 3. Como o Claude Code Trata Comandos

Comandos slash do Claude Code ficam em `.claude/commands/<nome>.md` (por projeto) ou `~/.claude/commands/` (global).

### Modelo de funcionamento

**Invocação explícita por comando.** Os comandos não são carregados automaticamente. O Claude Code lê as descriptions disponíveis e executa o arquivo de comando quando o usuário chama `/nome-da-skill`.

```
[system-reminder mostra]: "wsd-start: Inicia sessão WSD. Use quando..."
Usuário: "wsd-start" ou "/wsd-start"
Claude Code: executa o comando `wsd-start.md` → conteúdo do Markdown é injetado no contexto da conversa
```

### Características específicas

- **Trigger**: `description` no frontmatter define **quando Claude deve chamar** o comando — é uma hint para o modelo, não uma condição técnica de auto-load
- **Invocação**: explícita via `/nome` no harness de comandos slash
- **Escopo**: comandos são injetados no contexto da conversa **no momento da invocação** — não são persistentes entre turns
- **Estrutura**: suporta múltiplos arquivos e nomes por diretório, conforme o sistema de comandos slash
- **Conteúdo**: pode ser imperativo (como Codex) ou interativo (multi-fase, perguntas ao usuário, bifurcações)
- **Ferramentas restritas**: campo `allowed-tools` no frontmatter restringe quais ferramentas o comando pode usar
- **argument-hint**: campo opcional que descreve que argumento o comando aceita
- **Interação**: comandos Claude Code com frequência pedem input do usuário, têm fases confirmáveis e estados

### Frontmatter completo suportado pelo Claude Code

```yaml
---
name: nome-da-skill
description: Quando e como usar esta skill. Triggers: "palavra1", "frase2", "/slash".
argument-hint: descrição do argumento aceito (opcional)
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
license: CC-BY-4.0           # opcional
metadata:
  author: nome
  version: 1.0.0
---
```

### Comandos como "slash commands"

Quando instalados em `.claude/commands/`, cada comando fica disponível como `/wsd-start` e `/wsd-finish` no REPL do Claude Code. O harness detecta o comando, executa o Markdown correspondente e injeta seu conteúdo. Isso é um shortcut de invocação explícita, não auto-load.

---

## 4. Tabela Comparativa

| Aspecto | Codex | Claude Code |
|---------|-------|-------------|
| **Modelo de ativação** | Passivo — auto-match por descrição | Explícito — `/comando` |
| **Governança contínua** | Sempre ativa enquanto presente | Não existe — precisa de outro mecanismo |
| **Trigger** | Matching semântico do description | Claude lê description e executa o comando quando solicitado |
| **Persistência** | Skill de governança persiste durante toda sessão | Conteúdo injetado apenas no momento da execução |
| **Estrutura de arquivos** | Single `SKILL.md` (flat) | `commands/*.md` por comando |
| **Restrição de ferramentas** | Sem mecanismo declarativo | `allowed-tools` no frontmatter |
| **Interatividade** | Procedural/imperativo | Pode ser interativo (fases, perguntas, bifurcações) |
| **Slash commands** | Built-ins e prompts customizados opcionais como `/prompts:loop`; workflows compartilhados devem usar skills | `/nome-do-comando`, incluindo `/loop status` |
| **Escopo projeto** | `.agents/skills/` (espelho legado `.codex/skills/`) | `.claude/commands/` |
| **Escopo global** | `$HOME/.agents/skills/` | `~/.claude/commands/` |
| **Argument hint** | Sem campo dedicado | `argument-hint` no frontmatter |

---

## 5. A Diferença Fundamental — O Gap de Governança

> [!important] Esta é a diferença que mais impacta o WSD
> O Codex suporta skills "sempre ativas" (governance). O Claude Code não tem esse conceito — skills são invocadas, não persistem.

O WSD tem skills de governança, fase e captura para Codex:

| Skill | Tipo no Codex | Equivalente em Claude Code |
|-------|---------------|---------------------------|
| `wsd` | Governance — sempre ativa no repo | **Não é um comando** → pertence ao `AGENTS.md` + hooks |
| `wsd-start` | Procedural — invocada ao início | Comando slash Claude Code — funciona bem |
| `wsd-finish` | Procedural — invocada ao final | Comando slash Claude Code — funciona bem |
| `wsd-idea` | Captura de ideia | `idea-{PROJECT_SLUG}` |
| `wsd-concern` | Captura de preocupação/risco | `concern-{PROJECT_SLUG}` |
| `wsd-loop` | Atalhos WSD Loop | `loop` |

### Por que `wsd` não pode ser uma skill em Claude Code

Uma skill de governança só funciona se estiver no contexto do agente em **toda** operação. No Claude Code:

1. Skills são injetadas uma vez por invocação — não persistem
2. Ninguém vai lembrar de chamar `/wsd` antes de cada operação
3. Mesmo que lembrem, o conteúdo não deve ser a única camada de enforcement

**A solução correta para Claude Code é dupla:**

**Camada 1 — AGENTS.md (contexto ao ler):** o Claude lê AGENTS.md por convenção ao iniciar sessão em um repo. O conteúdo de governança da regra `wsd` deve viver no AGENTS.md gerado pelo `wsd install`, não num comando.

**Camada 2 — Hooks (enforcement técnico):** hooks `PreToolUse` leem `+context.json` e bloqueiam operações em `forbidden_paths` ou sem spec aprovada para L1/L2. O enforcement não depende do agente lembrar de carregar nada.

Ver [[r.3.7_spec_driven_development/r.3.7.9_enforcement_agentes_cli#4. Nível 3 — Hooks PreToolUse|r.3.7.9 § Hooks PreToolUse]].

---

## 6. Análise das Skills WSD Atuais

### `wsd/SKILL.md` — Governança

**Conteúdo atual:**
- Entry checks (git status, branch, remote)
- Definição de L0/L1/L2
- Required behavior (8 regras)

**Status de compatibilidade:** ❌ Não adequada como comando slash Claude Code

**O que fazer:** mover conteúdo para o template `AGENTS.md` gerado pelo installer, com seção `## Governança WSD` explícita. O AGENTS.md é lido pelo Claude Code em toda sessão — é o veículo correto para regras persistentes.

---

### `wsd-start.md` — Abertura de sessão

**Conteúdo atual:** 5 passos procedurais (identificar repo → git state → wsd_check → discover specs/PRs → reportar).

**Status de compatibilidade:** ✅ Funciona bem como comando slash Claude Code

**Adaptações necessárias:**
1. `description` precisa incluir triggers em português e o slash command `/wsd-start`
2. Adicionar `allowed-tools: [Bash, Read]` para restringir escopo
3. Adicionar step de Read explícito de `+context.json` e `AGENTS.md`
4. Adicionar `argument-hint` para path opcional

---

### `wsd-finish.md` — Encerramento de sessão

**Conteúdo atual:** procedimento de relatório final Git + WSD.

**Status de compatibilidade:** ✅ Funciona bem como comando slash Claude Code

**Adaptações necessárias:**
1. `description` com triggers em português e `/wsd-finish`
2. Adicionar `allowed-tools: [Bash, Read, Write]` (precisa escrever no error_vault)
3. Adicionar prompt explícito ao usuário sobre `error_vault.json` — a adesão depende disso
4. Integrar com formato estruturado de entrada no vault

---

## 7. Modelo de Compatibilidade Proposto

```
wsd install --tools claudecode
```

Deve gerar:

```
.claude/
  settings.json          ← hooks PreToolUse + PreCompact + SessionStart + Stop
  commands/
    wsd-start.md         ← comando slash do wsd-start
    wsd-finish.md        ← comando slash do wsd-finish
    idea-{slug}.md       ← comando de captura de ideia
    concern-{slug}.md    ← comando de captura de preocupação

AGENTS.md                ← contém governança WSD (conteúdo da skill wsd)
```

A skill `wsd` não é gerada — seu conteúdo vai para AGENTS.md.

### Diferença de tratamento da governança

```
Codex:
  .agents/skills/wsd/SKILL.md → carregada automaticamente → regras sempre ativas
  .agents/skills/wsd-loop/SKILL.md → atalhos como "loop status"
  .agents/skills/wsd-concern/SKILL.md → captura semântica de preocupações

Claude Code:
  AGENTS.md                   → lido pelo Claude ao iniciar sessão → regras sempre lidas
  .claude/settings.json       → hooks PreToolUse + PreCompact + SessionStart → regras sempre enforçadas
  .claude/commands/concern-{slug}.md → captura explícita via slash command
```

---

## 8. Templates Claude Code

### 8.1 Template `wsd-start` para Claude Code

```markdown
---
name: wsd-start
description: Inicia sessão de desenvolvimento em repositório WSD. Use quando o usuário diz "wsd-start", "iniciar WSD", "abrir sessão", "começar trabalho", "start WSD", ou pede para iniciar trabalho em repositório governado por WSD. Triggers: "wsd-start", "/wsd-start", "iniciar wsd", "abrir sessão wsd".
argument-hint: caminho do repositório (opcional — usa diretório atual se omitido)
allowed-tools:
  - Bash
  - Read
---

# WSD Start

## Objetivo

Abrir sessão de desenvolvimento sem implementar mudanças.

## Procedimento

**1. Identificar repositório** a partir do argumento ou diretório atual.

**2. Executar estado Git:**

\```bash
git status --short --branch
git branch -vv
git remote -v
git remote show origin
\```

**3. Ler contexto do projeto:**

- Ler `AGENTS.md` se presente
- Ler `+context.json` se presente — identificar `write_paths`, `forbidden_paths`, `validation` e `wsd.risk_default`
- Ler `+specs/context/*.md` seletivamente (project-rules.md, active-debts.md)

**4. Se WSD presente, executar checker:**

\```bash
bash scripts/wsd_check.sh --risk L0 .
\```

**5. Descobrir specs e PRs:**

\```bash
find +specs/features -maxdepth 2 -name 'spec.md' 2>/dev/null | sort
gh pr list --state open --limit 20 2>/dev/null || true
\```

**6. Reportar:**

- repo e host canônico
- branch e upstream
- worktree limpa/suja
- contexto presente/ausente
- specs encontradas (id, título, status, risco)
- classificação inicial de risco da tarefa
- paths permitidos e proibidos do `+context.json`
- próxima ação segura

## Limite

Não implementar mudanças durante a rotina de abertura. Aguardar instrução explícita do usuário após o relatório.
```

---

### 8.2 Template `wsd-finish` para Claude Code

```markdown
---
name: wsd-finish
description: Encerra sessão de desenvolvimento WSD com relatório padronizado. Use quando o usuário diz "wsd-finish", "finalizar WSD", "encerrar sessão", "fechar trabalho", "fim WSD", "finish WSD". Triggers: "wsd-finish", "/wsd-finish", "encerrar wsd", "finalizar sessão wsd".
allowed-tools:
  - Bash
  - Read
  - Write
---

# WSD Finish

## Objetivo

Encerrar sessão com relatório padronizado Git e WSD, e oportunidade de registrar lições aprendidas.

## Procedimento

**1. Executar estado final:**

\```bash
git status --short --branch
git diff --stat
git diff --check
git log -1 --date=short --pretty='last=%ad | %h | %s'
\```

**2. Se WSD presente:**

\```bash
bash scripts/wsd_check.sh --risk L0 .
\```

**3. Se PR pode existir:**

\```bash
gh pr status 2>/dev/null || true
gh pr view --json number,title,state,isDraft,headRefName,baseRefName,url 2>/dev/null || true
\```

**4. Perguntar ao usuário:**

> Houve algum erro, comportamento inesperado ou lição aprendida nessa sessão que deva ser registrada?

Se sim, adicionar entrada em `+logs/error_vault.json` com os campos:
- `id`: `LESSON-YYYY-MM-DD-NNN`
- `data`: data atual
- `escopo`: arquivo ou módulo afetado
- `sintoma`: o que foi observado
- `causa`: o que causou
- `correcao`: o que foi feito
- `prevencao`: como evitar da próxima vez
- `ttl`: data de expiração ou `"permanent"`

**5. Relatório final — obrigatório:**

- repo e host
- branch e upstream
- estado limpo/sujo
- arquivos alterados
- commits criados
- links PR/spec usados
- validações executadas e resultado
- validações não executadas e motivo
- riscos ou bloqueadores residuais
- próximo passo seguro

## Limite

Não esconder estado sujo. Não executar `git add .`, `git stash`, `git reset`, `git clean` ou trocar branch apenas para deixar o relatório limpo.
```

---

### 8.3 Trecho de `AGENTS.md` com governança WSD (substitui skill `wsd`)

Esta seção deve ser adicionada ao template `AGENTS.md` gerado pelo `wsd install --tools claudecode`:

```markdown
## Governança WSD

Este repositório usa WSD (Wolff Spec Driven). Antes de qualquer edição:

**Classificar a tarefa:**
- L0: ajuste local pequeno e reversível → Task Card suficiente
- L1: feature, endpoint, integração, refatoração relevante → spec aprovada obrigatória
- L2: produção, deploy, banco, auth, secrets, dados sensíveis → spec aprovada + aprovação humana

**Regras operacionais:**
- Ler `+context.json` para `write_paths` e `forbidden_paths` antes de editar
- Não usar `git add .`
- Não esconder worktree suja (proibido: stash, reset, clean sem decisão explícita)
- Não registrar secrets em nenhum artefato (Git, spec, log, prompt)
- Não executar mutação em produção sem contexto L2 aprovado
- Validação deve ser executável — não inventar comandos de teste
- Ao final: deixar evidência auditável (branch, commit/diff, spec, validação executada)

**Iniciar sessão:** execute `/wsd-start` antes de trabalhar
**Encerrar sessão:** execute `/wsd-finish` ao terminar
```

---

## 9. Configuração de Hooks

O `wsd install --tools claudecode` deve gerar `.claude/settings.json` com:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash|Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "bash +wsd/hooks/pre-tool.sh",
            "timeout": 10
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Sessão encerrada. Execute /wsd-finish para registrar o estado final e lições aprendidas.' >&2",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

E o script `+wsd/hooks/pre-tool.sh`:

```bash
#!/bin/bash
# Hook WSD PreToolUse — lê +context.json e bloqueia forbidden_paths

TOOL_INPUT=$(cat)
TOOL_NAME=$(echo "$TOOL_INPUT" | jq -r '.tool_name // ""')
FILE_PATH=$(echo "$TOOL_INPUT" | jq -r \
  '.tool_input.file_path // .tool_input.path // .tool_input.command // ""')

# Se não há +context.json, libera
[ ! -f "+context.json" ] && exit 0

# Verifica forbidden_paths
FORBIDDEN=$(jq -r '.permissions.forbidden_paths[]? // empty' +context.json 2>/dev/null)
for fp in $FORBIDDEN; do
  if [[ "$FILE_PATH" == *"$fp"* ]]; then
    echo "WSD BLOCK: path '$FILE_PATH' está em forbidden_paths ($fp). Verifique +context.json." >&2
    exit 2
  fi
done

exit 0
```

> [!tip] Sobre o hook Stop
> O hook `Stop` dispara quando o Claude encerra a resposta. Usar para lembrar de `/wsd-finish` sem bloquear — é um lembrete, não um gate.

---

## 10. O que o Installer Precisa Gerar

Checklist do que `wsd install` deve gerar por agente:

- [x] `.agents/skills/wsd/SKILL.md` quando `--tools codex` estiver ativo.
- [x] `.agents/skills/wsd-start/SKILL.md` quando `--tools codex` estiver ativo.
- [x] `.agents/skills/wsd-finish/SKILL.md` quando `--tools codex` estiver ativo.
- [x] `.agents/skills/wsd-idea/SKILL.md` quando `--tools codex` estiver ativo.
- [x] `.agents/skills/wsd-concern/SKILL.md` quando `--tools codex` estiver ativo.
- [x] `.agents/skills/wsd-loop/SKILL.md` quando `--tools codex` estiver ativo.
- [x] `.codex/skills/*` espelhado para compatibilidade legado.
- [x] `.claude/commands/wsd-start.md` quando `--tools claude-code` estiver ativo.
- [x] `.claude/commands/wsd-finish.md` quando `--tools claude-code` estiver ativo.
- [x] `.claude/commands/idea-{PROJECT_SLUG}.md` quando `--tools claude-code` estiver ativo.
- [x] `.claude/commands/concern-{PROJECT_SLUG}.md` quando `--tools claude-code` estiver ativo.
- [x] `.claude/commands/loop.md` quando `--tools claude-code` estiver ativo (`/loop status`, `/loop on`, `/loop off`).
- [x] `.claude/settings.json` com hooks quando `--tools claude-code` estiver ativo.
- [x] `+wsd/hooks/pre-tool.sh` quando `--tools claude-code` estiver ativo.
- [x] `AGENTS.md` com seção WSD quando `--tools codex` ou `--tools claude-code` estiverem ativos.
- [x] `+context.json` quando `--tools codex` ou `--tools claude-code` estiverem ativos.

### Flag `--tools both`

- [x] `--tools both` gera os dois conjuntos sem conflito — `.agents/skills/`, espelho `.codex/skills/` e `.claude/commands/` coexistem no mesmo repositório.

### Estrutura final após `wsd install --tools claude-code`

```
+wsd/
  bin/wsd                  ← CLI local
  hooks/
    pre-tool.sh            ← hook de enforcement
.claude/
  settings.json            ← hooks configurados
  commands/
    loop.md
    wsd-start.md
    wsd-finish.md
AGENTS.md                  ← governança WSD + regras do projeto
+context.json              ← permissões, validação, host
+specs/
+logs/
  error_vault.json
scripts/
  wsd_check.sh
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 11. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 06/05/2026 — | Claude | `x/wsd/docs/13_compatibilidade_claude_code.md` | Criação com análise comparativa completa Codex vs. Claude Code skills, identificação do gap de governança e proposta de modelo de compatibilidade com templates e hooks. |
| 06/05/2026 14:41:06 -03 | Codex | `x/wsd/docs/13_compatibilidade_claude_code.md` | Padronização da lista de geração do installer com checkboxes para acompanhar os artefatos necessários ao suporte Claude. |
| 06/05/2026 — | Claude | `templates/claude-commands/`, `bin/wsd-method.js`, `templates/repo/AGENTS.md.template`, `docs/13_compatibilidade_claude_code.md` | Implementação completa: comandos slash Claude Code, função installClaudeCommands(), suporte --tools claude-code e --tools both, atualização de checklist e AGENTS.md template. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
