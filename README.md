# wsdd — Wolff Spec Driven Development

> Kit pessoal de Spec Driven Development para agentes de código (Codex, Claude Code).
> Versão `v0.1.0` estável, em modo de manutenção.

`wsdd` é a **versão pública** do método **WSD (Wolff Spec Driven)**: um conjunto de templates, scripts, skills de agente e CLI vendorizado que transforma repositórios em ambientes previsíveis para agentes CLI editarem código com governança real (risco, scope, validação, rastreabilidade).

O objetivo não é criar burocracia — é impedir que agentes editem código sem saber **onde estão**, **qual risco assumem**, **quais paths podem tocar**, **como validar** e **como deixar rastreabilidade**.

## Sobre este repo

Este é um **espelho público sanitizado** do desenvolvimento privado em `flow31-d/WSD`. Aqui não há perfis de clientes específicos, decisões internas (`+specs/project/STATE.md`) nem o histórico de commits do desenvolvimento original — apenas o método, código, templates e exemplos genéricos.

Existe para:

- **revisão por pares** — outros devs analisarem arquitetura e dar feedback;
- **uso por terceiros** — qualquer dev pode instalar `wsdd` em seus projetos;
- **transparência metodológica** — mostrar o estado real de um SDD pessoal evoluído.

Para contribuir, ver [`CONTRIBUTING.md`](CONTRIBUTING.md).

> **Nota Obsidian**: os arquivos `.md` deste repo foram escritos para visualização no Obsidian (índices navegáveis, callouts, links literais). No GitHub renderizam normalmente, mas alguns elementos (callouts `> [!info]`) viram blockquotes simples.

---

## Ideia central

```
WSD global   = método comum
WSD template = arquivos copiáveis
WSD adapter  = personalização por repositório
WSD session  = rotina de início, execução e encerramento
```

Cada repositório que adota WSD recebe um pacote local com:

```
.wsd/                            ← CLI vendorizado, hooks, schemas
AGENTS.md                        ← regras para agentes
CLAUDE.md                        ← (opcional) instruções específicas Claude
.context.json                    ← contrato runtime do projeto
+specs/project/PROJECT.md        ← visão e regras do projeto
+specs/project/STATE.md          ← memória operacional viva
+specs/features/<slug>/spec.md   ← spec WHEN/THEN/SHALL por feature
+specs/codebase/*.md             ← (brownfield) docs gerados pelo agente
+logs/                           ← logs de sessão
scripts/wsd_check.sh             ← gate determinístico
```

---

## Estrutura do pacote

```
wsdd/
├── README.md          ← este arquivo
├── wsd.md             ← hub do método (visão geral, mapa de docs)
├── ROADMAP.md         ← fases concluídas (1, 2, 3, 3.5, 4)
├── CHANGELOG.md       ← histórico de versões
├── AGENTS.md          ← regras para agentes editando este repo
├── CONTRIBUTING.md    ← fluxo de bug fix e contribuição
├── package.json
├── install.sh         ← wrapper local do installer
├── bin/
│   └── wsd-method.js  ← installer principal
├── docs/              ← 14 docs metodológicas
├── templates/
│   ├── repo/          ← arquivos copiados para projetos cliente
│   ├── specs/         ← templates de spec L0/L1/L2
│   ├── local-wsd/     ← CLI vendorizado (.wsd/bin/wsd)
│   ├── codex-skills/  ← skills Codex
│   ├── claude-commands/ ← slash commands Claude Code
│   ├── claude-skills/
│   ├── git-hooks/     ← pre-commit, commit-msg, pre-push
│   └── modules/       ← módulos opcionais (.github/, etc.)
├── profiles/          ← perfis de configuração (Node, Python)
├── scripts/           ← validação e bootstrap
├── party-mode/        ← 26 agentes para debate multi-perspectiva
├── schemas/           ← JSON Schema do .context.json
└── examples/          ← exemplos de uso
```

---

## Uso oficial

`v0.1.0` é a primeira release estável. Fluxo recomendado:

### Greenfield (projeto novo)

```bash
bash install.sh \
  --directory /path/to/project \
  --tools both \
  --git-policy basic \
  --github skip \
  --yes
```

### Brownfield (código existente)

```bash
bash install.sh \
  --directory /path/to/project \
  --tools both \
  --git-policy full \
  --github existing \
  --brownfield \
  --yes
```

`--brownfield` gera `+specs/codebase/` com 7 docs (STACK, ARCHITECTURE, CONVENTIONS, STRUCTURE, INTEGRATIONS, CONCERNS, TESTING) que o agente preenche após o install lendo o código real.

### Ciclo de sessão

Dentro do projeto após o install, rotina diária:

```bash
./.wsd/bin/wsd doctor      # verifica saúde (uma vez)
./.wsd/bin/wsd start       # abre sessão
# ... trabalho do agente: /wsd-specify, /wsd-design, /wsd-tasks, /wsd-party-mode ...
./.wsd/bin/wsd check       # valida gates antes do commit
./.wsd/bin/wsd finish      # fecha sessão (gera HANDOFF.md, atualiza STATE.md)
```

### Comandos disponíveis após o install

- **Codex** (`--tools codex`): 6 skills em `.codex/skills/` — `wsd`, `wsd-start`, `wsd-finish`, `wsd-specify`, `wsd-design`, `wsd-tasks`.
- **Claude Code** (`--tools claude-code`): 6 slash commands em `.claude/commands/` — `wsd-start`, `wsd-finish`, `wsd-specify`, `wsd-design`, `wsd-tasks`, `wsd-party-mode`. Hooks `PreToolUse|PreCompact|SessionStart|Stop` em `.claude/settings.json`.
- **CLI vendorizado** (`./.wsd/bin/wsd`): `start`, `check`, `finish`, `doctor`, `update`, `hooks`, `git doctor|preflight|pr-check`, `party status|list-agents|when-to-use`.

### Política Git

- `--git-policy none`: sem governança Git extra (default mínimo).
- `--git-policy basic`: pre-commit / commit-msg / pre-push hooks + Conventional Commits 1.0.0 obrigatório.
- `--git-policy full`: tudo do `basic` + templates `.github/PULL_REQUEST_TEMPLATE.md` e `ISSUE_TEMPLATE/{task,bug,decision}.md`, `wsd git pr-check` validando branch/commits/PR.

### Validação contínua

Após qualquer mudança no código `wsdd`:

```bash
npm test                              # 7 gates de instalação
bash scripts/wsd_docs_check.sh        # sincronização documental
bash scripts/wsd_self_check.sh        # consistência interna
```

---

## Princípios

- Intenção antes de edição.
- Risco define rigor.
- Git registra histórico; spec registra contrato.
- Agente não inventa validação.
- Agente não esconde worktree suja.
- Segredo nunca entra em Git, spec, prompt, log ou Obsidian.
- Produção exige regra explícita, rollback e decisão humana.

---

## Status

Versão atual: **`v0.1.0`** (release estável). Histórico completo em [`CHANGELOG.md`](CHANGELOG.md).

A série `v0.1.0-alpha` → `v0.1.11-alpha` está consolidada; entregas principais:

- `v0.1.4-alpha` — integração TLC Spec-Driven (auto-sizing L0/L1/L2, STATE.md, HANDOFF.md, WHEN/THEN/SHALL, TESTING.md tiered, Conventional Commits, `--brownfield`).
- `v0.1.5-alpha` — JSON Schema 2020-12 para `.context.json` + validador pure-JS zero-deps.
- `v0.1.6-alpha` — ghost spec detector + git hooks no bootstrap.
- `v0.1.7-alpha` — `wsd finish` automatizado (HANDOFF.md + prompts STATE.md).
- `v0.1.8-alpha` — instalação interativa rica + `wsd update` real.
- `v0.1.10-alpha` — MVP Git/GitHub Governance.
- `v0.1.11-alpha` — Party Mode Integration (26 agentes).
- **`v0.1.0`** — release estável; modo de manutenção.

### Fases do roadmap (todas concluídas)

1. Aprimorar o WSD — série `v0.1.x-alpha`.
2. Validar operacionalmente em projeto brownfield real.
3. Ajustar a partir das lições da validação operacional.
3.5. Party Mode Integration.
4. Consolidar release oficial em `v0.1.0`.

### Próximas frentes (opt-in conforme demanda real)

- Server-side hook como módulo opcional (enforcement inquebrável).
- OPA/Rego como módulo avançado (multi-agente e times).
- Migração para `ajv` quando a complexidade do JSON Schema crescer.

Bugs descobertos em uso real geram patches `v0.1.x` (sem alpha). Novas features grandes vão para `v0.2.0` após validação em piloto.

---

## Instalação local (a partir do clone)

Direto via Node:

```bash
node bin/wsd-method.js install \
  --directory /path/to/project \
  --profile generic_node_frontend \
  --tools codex \
  --github skip \
  --yes
```

Pelo wrapper local:

```bash
bash install.sh --directory /path/to/project --tools codex --github skip --yes
```

Para projetos que valorizam PR/Issue no GitHub:

```bash
bash install.sh \
  --directory /path/to/project \
  --tools codex \
  --github existing \
  --git-policy full \
  --yes
```

Após instalar:

```bash
./.wsd/bin/wsd doctor
./.wsd/bin/wsd check
./.wsd/bin/wsd start
./.wsd/bin/wsd finish
```

`--tools both` instala simultaneamente skills Codex + slash commands Claude Code.

---

## Documentação

| Arquivo | Quando abrir |
|---|---|
| [`docs/01_constituicao.md`](docs/01_constituicao.md) | Antes de criar ou adaptar regras |
| [`docs/02_matriz_risco.md`](docs/02_matriz_risco.md) | Ao classificar tarefa (L0/L1/L2) |
| [`docs/03_ciclo_operacional.md`](docs/03_ciclo_operacional.md) | Durante uma sessão |
| [`docs/04_playbook_implantacao.md`](docs/04_playbook_implantacao.md) | Ao colocar wsdd em um repo |
| [`docs/05_contrato_artefatos.md`](docs/05_contrato_artefatos.md) | Ao editar templates |
| [`docs/07_git_governance.md`](docs/07_git_governance.md) | Ao mexer em branch/PR |
| [`docs/13_compatibilidade_claude_code.md`](docs/13_compatibilidade_claude_code.md) | Suporte Claude Code |
| [`docs/10_matriz_sincronizacao_notas.md`](docs/10_matriz_sincronizacao_notas.md) | Matriz de sincronização de notas — antes de finalizar qualquer mudança documental |
| [`docs/14_qualidade_desenvolvimento.md`](docs/14_qualidade_desenvolvimento.md) | Padrões TLC adotados na v0.1.4 |
| [`AGENTS.md`](AGENTS.md) | Regras para agentes editando este repo |
| [`CONTRIBUTING.md`](CONTRIBUTING.md) | Fluxo de bug fix e PR |

---

## Licença

Sem licença pública declarada por enquanto — uso pessoal/educacional. Forks e estudos são bem-vindos; uso comercial requer combinação prévia com o autor.
