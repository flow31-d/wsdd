---
title: "WSD — Wolff Spec Driven"
created: 05/05/2026
modified: 2026-07-07
tags:
  - wsd
  - sdd
  - agentes
status: ativo
tipo: hub
parent: "[[x]]"
links: "[[wsd/wsd]], [[wsd/CHANGELOG]], [[wsd/docs/01_constituicao]], [[wsd/docs/04_playbook_implantacao]]"
---
# WSD — Wolff Spec Driven

**Versão atual: `v0.5.1`** — histórico completo em [CHANGELOG.md](CHANGELOG.md).

WSD é um kit pessoal de Spec Driven Development para agentes de código (Codex,
Claude Code e equivalentes). Ele transforma repositórios em ambientes
previsíveis: o agente sabe onde está, qual risco assume, quais paths pode
tocar, como validar, como compactar memória e como fechar a sessão com commit —
tudo sem o operador precisar digitar comandos.

## Ideia central

```text
WSD global   = método comum (este repositório)
WSD template = arquivos copiáveis (templates/)
WSD adapter  = personalização por repositório (+context.json, AGENTS.md)
WSD session  = abrir → classificar risco → executar → validar → commitar → fechar
```

Cada projeto instalado recebe: `AGENTS.md` (contrato lean, ≤150 linhas),
`+context.json` (contrato de máquina validado por JSON Schema),
`+specs/project/` (PROJECT, STATE, ROADMAP, IDEAS, IDEAS_PIPELINE, CONCERNS,
CONCERNS_PIPELINE), `+specs/features/<slug>/` (specs WHEN/THEN/SHALL),
`+wsd/` (CLI vendorizado + guias on-demand) e `scripts/wsd_check.sh`.

## Modo de operação padrão: full-auto

Desde a `v0.5.0`, `workflow.approval_mode` default é **`full_auto`**: o agente
executa a tarefa inteira e fecha com commit, sem pausar para aprovação humana.
L2 continua exigindo rigor extra (spec, validação reforçada e rollback
documentado), mas não pausa.

**Única pausa obrigatória**: worktree suja que o agente da sessão atual não
criou (outro agente ou humano deixou mudanças pendentes). Nesse caso o agente
para e pede decisão humana antes de qualquer merge/limpeza — para não destruir
trabalho em andamento.

## Instalação

Requisitos: Node.js v20+. Git detectado e usado se presente.

```bash
# Quick start (sem clone)
npx github:flow31-d/wsdd install --directory /path/to/project --tools both --git-policy basic --yes

# A partir do clone local
bash install.sh --directory /path/to/project --tools both --git-policy basic --github skip --yes

# Brownfield (código existente): adiciona +specs/codebase/ com 7 docs
bash install.sh --directory /path/to/project --tools both --git-policy full --github existing --brownfield --yes
```

## Uso diário

O operador fala em linguagem natural; o agente mapeia via tabela
"Intenção → Ação" do `AGENTS.md` instalado. Exemplos: "me dá uma geral do
projeto" → `wsd relatorio`; "vamos fazer X" → classifica risco e segue o fluxo;
"anota essa preocupação" → registra concern; "fecha por hoje" → `wsd finish`.

CLI vendorizado (backend determinístico que o agente chama):

```bash
./+wsd/bin/wsd start [--brief]   # abre sessão / contexto compacto
./+wsd/bin/wsd check             # valida contrato WSD (gates L0/L1/L2)
./+wsd/bin/wsd relatorio         # visão geral: estado, plano, ideias, concerns
./+wsd/bin/wsd finish            # fecha: gates, HANDOFF, snapshot, commit, worktree limpa
./+wsd/bin/wsd compact           # arquiva memória resolvida/antiga (auto no finish)
./+wsd/bin/wsd doctor|version|update|hooks|snapshot
./+wsd/bin/wsd git doctor|preflight|pr-check
./+wsd/bin/wsd loop plan|once|run|status|auto   # automação L0/L1 (Ralph/WSD Loop)
./+wsd/bin/wsd party status|list-agents|when-to-use
```

Comandos de agente instalados: skills Codex em `.agents/skills/` e slash
commands Claude Code em `.claude/commands/` (`/wsd-start`, `/wsd-specify`,
`/wsd-design`, `/wsd-tasks`, `/wsd-finish`, `/wsd-relatorio`,
`/wsd-party-mode`, `/loop`, `/idea-<slug>`, `/concern-<slug>`).

## Risco e proporcionalidade

| Risco | Quando | O que fazer |
|---|---|---|
| **L0** | ≤3 arquivos, local, reversível | implementar → validar → commitar |
| **L1** | feature, integração, refatoração relevante | spec WHEN/THEN/SHALL → implementar → validar → commitar |
| **L2** | produção, banco, auth, secrets, dados sensíveis | 4 fases + validação reforçada + rollback documentado → commitar |

## Eficiência de tokens (regras do método)

- Contexto base de sessão ≤5k tokens: `AGENTS.md` + `PROJECT.md` + seção ativa
  de `STATE.md` + concerns ativas. Todo o resto é on-demand.
- Detalhes por subsistema vivem em `+wsd/guides/` (git, loop, party, lovable,
  sessão) e só são lidos quando a tarefa toca o tema.
- Memória compacta: `wsd compact` arquiva mecanicamente entradas resolvidas de
  `STATE.md`/`CONCERNS*` em `+specs/project/archive/` (nada é apagado; IDs
  preservados). O `wsd finish` compacta sozinho quando uma nota passa do limiar
  (linhas ou ~tokens); `wsd check`/`relatorio` avisam.
- Histórico não se duplica: versão vive em `package.json` + `CHANGELOG.md`;
  autoria/data vivem no git. Notas não mantêm tabelas manuais de histórico.

## Estrutura do pacote

```text
wsd/
├── README.md · wsd.md · CHANGELOG.md (+_ARCHIVE) · ROADMAP.md · AGENTS.md
├── bin/wsd-method.js        # installer/updater
├── docs/                    # metodologia (00–19)
├── docs-map.json            # mapa código→docs (gate de doc drift)
├── templates/               # repo/, specs/, local-wsd/, codex-skills/, claude-commands/, modules/
├── schemas/                 # context.schema.json
├── profiles/ · scripts/ · party-mode/ · examples/
├── +specs/ · +wsd/          # dogfooding: WSD gerencia o próprio WSD
└── archive/                 # histórico/pesquisa — agentes não leem nem sincronizam
```

## Validação contínua

```bash
npm test                        # gates de instalação
bash scripts/wsd_docs_check.sh  # coerência documental (versão em 2 fontes + drift)
bash scripts/wsd_self_check.sh  # consistência interna
```

## Princípios

- Intenção antes de edição. Risco define rigor.
- Git registra histórico; spec registra contrato. Nenhuma informação vive em
  dois lugares.
- Agente não inventa validação e não esconde worktree suja.
- Execução é full-auto até o commit; a única pausa é worktree suja de terceiros.
- Segredo nunca entra em Git, spec, prompt, log ou Obsidian.
- Memória ativa curta; histórico no arquivo, não no caminho de leitura.

Antes de editar este pacote, leia [AGENTS.md](AGENTS.md) e a matriz de
sincronização em [[wsd/docs/10_matriz_sincronizacao_notas|docs/10]].
