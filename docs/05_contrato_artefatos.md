---
title: "05 — Contrato de Artefatos WSD"
created: 05/05/2026
modified: 15/06/2026
tags:
  - x
  - wsd
  - artefatos
  - schemas
status: ativo
tipo: referencia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/docs/04_playbook_implantacao]], [[wsd/docs/06_personalizacao_por_projeto]], [[wsd/docs/10_matriz_sincronizacao_notas]]"
otimizado_para_obsidian: true
---
# 05 — Contrato de Artefatos WSD

[[wsd/wsd|← WSD]]

---


> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. `+context.json`]]
3. [[#3. `AGENTS.md`]]
4. [[#4. `+specs/*.spec.yaml`]]
5. [[#5. `+specs/context/*.md`]]
6. [[#6. `+specs/project/` — Artefatos de Planejamento]]
7. [[#7. `+logs/error_vault.json`]]
8. [[#8. `scripts/wsd_check.sh`]]
9. [[#9. `+wsd/` — Vendor Tree]]
10. [[#10. Sincronização de Artefatos]]
11. [[#11. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 05/05/2026 13:29:54 -03 — Codex: Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes.
- 05/05/2026 14:13:39 -03 — Codex: Inclusão da regra de sincronização entre contrato, templates, checker e notas derivadas.
- 07/05/2026 — Claude: Documentação do schema canônico `schemas/context.schema.json` e do validador `wsd-validate-context.js` (v0.1.5-alpha).
- 07/05/2026 — Codex: Planejamento do bloco `git_governance` no `+context.json` para o MVP Git/GitHub Governance (`v0.1.10-alpha`).
- 07/05/2026 — Codex: Marcação do bloco `git_governance` como implementado na `v0.1.10-alpha` e validado pelo schema canônico.
- 11/05/2026 — Claude: Adição da seção `+specs/project/` com ROADMAP.md, IDEAS.md e IDEAS_PIPELINE.md (v0.1.1/v0.1.2). Adição da seção `+wsd/` vendor tree. Renúmeração de seções.
- 12/05/2026 — Claude (Opus 4.7): Adição de `CONCERNS.md` à seção `+specs/project/` (v0.2.0). Antes era `+specs/codebase/CONCERNS.md` condicional a brownfield. Refs WSD-010.
- 21/06/2026 — Codex: Adição de `CONCERNS_PIPELINE.md` à seção `+specs/project/` (v0.4.2), com regra de captura em par `CONCERNS.md` + pipeline.
- 21/06/2026 — Codex: `wsd finish` passa a fechar sessão com gates, docs audit quando disponível, HANDOFF.md, snapshot, commit automático e worktree limpo (`v0.4.3`).
- 21/06/2026 — Codex: `wsd relatorio` passa a gerar relatório operacional opcional em `+specs/RELATORIO.md` (`v0.4.4`).
- 13/05/2026 — Codex: Contrato mínimo operacional passa a exigir snapshot WSD válido, ROADMAP/STATE estruturados e separação entre dirty de fonte e dirty gerado.
- 30/05/2026 18:15:09 -03 — Codex: Atualização do contrato da vendor tree para incluir `wsd version` como leitor de metadados de `+wsd/config.json`.
- 15/06/2026 — Codex: Inclusão do bloco `automation.loop`, prompts `+wsd/loop/` e estado local do WSD Loop no contrato de artefatos.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. `+context.json`

Função: declarar ambiente, permissões, ferramentas e validações.

Campos mínimos:

```json
{
  "$schema": "wsd/context/v1",
  "project": {},
  "environment": {},
  "repository": {},
  "permissions": {},
  "workflow": {},
  "automation": {},
  "wsd": {},
  "ci": {}
}
```

Regras:

- JSON válido;
- sem comentários;
- sem secrets;
- paths relativos quando possível;
- comandos reais;
- host canônico explícito.

### Schema canônico (v0.1.5-alpha)

A partir de `v0.1.5-alpha`, o contrato é validado por um JSON Schema 2020-12:

- **Schema canônico:** `schemas/context.schema.json` (`$id: wsd/context/v1`).
- **Validador:** `templates/local-wsd/bin/wsd-validate-context.js` — pure-JS zero-deps, vendorizado em `+wsd/bin/wsd-validate-context.js` no install.
- **Gate:** `scripts/wsd_check.sh` chama o validador após o JSON syntax check; falha com path JSON-pointer (ex.: `/permissions/write_paths: missing required property`).
- **Fallback:** se Node ausente, o gate emite `warn:` e segue (syntax check continua hard-fail).

Required mínimo: `$schema` (const `wsd/context/v1`), `project`, `environment`, `repository`, `permissions`, `workflow`, `wsd`. Enums fortes: `permissions.secrets_policy`, `workflow.production_mutation_policy`, `repository.repo_type`.

### Bloco `git_governance` (v0.1.10-alpha)

O MVP Git/GitHub Governance adiciona um bloco opcional ao `+context.json`. Instalações novas sempre renderizam o bloco; instalações antigas continuam válidas sem ele.

```json
"git_governance": {
  "enabled": true,
  "mode": "full",
  "remote_protocol": "https",
  "github_cli_required": false,
  "default_branch": "main",
  "issue_policy": "required_for_l1_l2",
  "pr_policy": "required_for_relevant_changes",
  "sync_policy": "pull_ff_only",
  "dirty_worktree_policy": "declare_and_halt_for_risky_ops",
  "branch_naming": "issue-<number>-<slug>",
  "commit_style": "conventional_commits"
}
```

Esse bloco é aceito por `schemas/context.schema.json`. O core continua funcionando sem GitHub quando `mode = "none"` ou quando o bloco estiver ausente em instalações antigas.

### Bloco `automation.loop` (v0.4.0)

O WSD Loop adiciona um bloco opcional de automação. Instalações novas renderizam o bloco por padrão; instalações antigas continuam válidas sem ele até adotarem o loop.

```json
"automation": {
  "loop": {
    "enabled": true,
    "default_max_iterations": 3,
    "allowed_risks": ["L0", "L1"],
    "auto_use": false,
    "require_clean_worktree": true,
    "auto_commit": true,
    "auto_push": false,
    "one_task_per_iteration": true,
    "stop_on_repeated_gate_failure": true,
    "require_human_for_l2": true
  }
}
```

Esse bloco é aceito por `schemas/context.schema.json` e lido por `./+wsd/bin/wsd loop`. A política padrão permite automação L0/L1, mantém L2 dependente de aprovação explícita, desliga auto-push e deixa `auto_use=false` até o operador ligar com `./+wsd/bin/wsd loop auto on`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. `AGENTS.md`

Função: instrução local para agentes.

Deve responder:

- o que é este repo;
- onde ele vive;
- como abrir sessão;
- o que é proibido;
- como validar;
- onde estão specs e contexto;
- como o Codex deve fazer bootstrap WSDD sem o operador listar arquivos manualmente.

A partir da `v0.4.0`, o template instalável deve conter a seção `WSD Codex Bootstrap`, mencionando `+context.json`, `+specs/project/STATE.md`, `+specs/HANDOFF.md`, classificação L0/L1/L2 e os comandos `wsd codex-prompt`/`wsd codex`.

A partir da `v0.4.1`, skills Codex instaláveis devem usar `.agents/skills/` como caminho principal e `.codex/skills/` como espelho de compatibilidade. Atalhos globais de prompt do Codex são opcionais por usuário e instalados via `wsd codex-shortcuts install`, não durante o bootstrap do projeto.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. `+specs/*.spec.yaml`

Função: contrato de tarefa L1/L2.

Campos mínimos:

```yaml
schema_version: "wsd/spec/v1"
metadata:
  id: "TASK-001"
  title: ""
  severity: "L1"
  status: "approved"
  risk_score: 5
intent:
  description: ""
execution_bounds:
  allowed_scopes: []
  forbidden_scopes: []
acceptance_criteria: []
validation_commands: []
risk_assessment: []
rollback_plan: []
```

Status aceitos:

- `draft`
- `approved`
- `implemented`
- `verified`
- `closed`
- `superseded`

Regra: `draft` bloqueia promoção L1/L2.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. `+specs/context/*.md`

Função: contexto curado, pequeno e confiável.

Arquivos recomendados:

- `project-rules.md`;
- `product-architecture-summary.md`;
- `active-debts.md`;
- `environment-git-policy.md`.

O objetivo é evitar que agentes carreguem documentação inteira, BMad completo ou histórico irrelevante.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. `+specs/project/` — Artefatos de Planejamento

Artefatos criados automaticamente pelo installer em todos os projetos (greenfield e brownfield):

### `+specs/project/STATE.md`
Memória operacional: decisões, lições, bloqueadores, ideias adiadas, todos ativos. Atualizado por `wsd finish` com prompts interativos quando stdin é TTY.

### `+specs/project/PROJECT.md`
Definição imutável do projeto: nome, tipo, objetivos, contexto de negócio.

### `+specs/project/ROADMAP.md` (v0.1.1)
Visão consolidada de features: tabela com status (`planned`, `specified`, `in-progress`, `done`, `blocked`, `discarded`), link para specs, instruções para agentes. Atualizado sempre que uma spec muda de status.

### `+specs/project/IDEAS.md` (v0.1.2)
Notebook de captura fiel de ideias brutas. Cada ideia recebe um ID sequencial permanente (`IDEA-001`, `IDEA-002` …). Populado via skill `/idea-{project_slug}` — nunca editado diretamente.

### `+specs/project/IDEAS_PIPELINE.md` (v0.1.2)
Índice de controle de progressão das ideias: `raw → detalhada → spec-criada → em-roadmap → implementada → descartada`. Atualizado sempre que uma ideia avança de etapa.

### `+specs/project/CONCERNS.md` (v0.2.0, reforçado em v0.4.2)
Preocupações ativas, componentes frágeis, dívidas técnicas, áreas L2 (que exigem aprovação humana), riscos conhecidos e itens que precisam ser conferidos. Sempre gerado pelo installer (greenfield e brownfield). Desde `v0.4.2`, deve manter a seção `Preocupacoes Ativas` no topo com IDs permanentes `CONC-###`, categoria, severidade, status, área/arquivo, plano e owner. Antes do `v0.2.0`, esta nota era condicional a `--brownfield` e ficava em `+specs/codebase/CONCERNS.md`; o argumento para o move é que todo projeto eventualmente terá concerns, e fazer a nota parte do contrato padrão evita perda de memória de fragilidades.

### `+specs/project/CONCERNS_PIPELINE.md` (v0.4.2)
Pipeline de resolução das preocupações registradas em `CONCERNS.md`. Cada concern ativa deve ter uma linha com status (`active`, `triaged`, `mitigating`, `verifying`, `resolved`, `accepted-risk`, `obsolete`), etapa, plano, próximo passo, gate/evidência, owner e data de revisão. Fechamento `resolved` exige evidência verificável; fechamento `accepted-risk` exige decisão explícita do operador.

**Regra de manutenção:** ao criar uma spec via `/wsd-specify`, o agente deve adicionar linha no ROADMAP.md com status `specified` e atualizar o IDEAS_PIPELINE.md se a spec originou de uma ideia. Quando identificar concerns durante o trabalho (componente frágil tocado, dívida técnica descoberta, área que precisa de aprovação humana, workaround, dependência instável ou item "precisa conferir"), atualizar `CONCERNS.md` e `CONCERNS_PIPELINE.md` na mesma sessão.

### `+specs/RELATORIO.md` (opcional, v0.4.4)
Relatório operacional gerado por `./+wsd/bin/wsd relatorio --save`. Consolida estado Git/WSD, implementação em andamento, plano programado, ideias, concerns, alinhamento dos pipelines e sugestão do agente. Não é criado automaticamente no install e não substitui `STATE.md`, `ROADMAP.md`, `IDEAS.md` ou `CONCERNS.md`; é uma fotografia de leitura para orientação humana.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. `+logs/error_vault.json`

Função: memória operacional estruturada.

Modelo:

```json
{
  "$schema": "wsd/error-vault/v1",
  "lessons": []
}
```

Cada lição deve conter:

- id;
- data;
- escopo;
- sintoma;
- causa;
- correção;
- prevenção;
- validade/TTL quando aplicável.

Não registrar logs longos ou secrets.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. `scripts/wsd_check.sh`

Função: checker local mínimo e gate de compatibilidade com dashboards/zeladores.

Deve validar:

- repo Git;
- `+context.json` como JSON válido e, quando possível, contra `+wsd/schemas/context.schema.json`;
- presença das 7 notas obrigatórias de `+specs/project/`: `PROJECT.md`, `STATE.md`, `ROADMAP.md`, `IDEAS.md`, `IDEAS_PIPELINE.md`, `CONCERNS.md`, `CONCERNS_PIPELINE.md`;
- estrutura mínima de `ROADMAP.md` (`Features Ativas`, `Backlog`) e `STATE.md` (`Bloqueadores Ativos`);
- geração e JSON válido de `+wsd/snapshot.json`;
- spec exigida para L1/L2;
- status da spec;
- coerência ROADMAP → spec para L1/L2;
- placeholders não substituídos.

O snapshot é parte do contrato porque WDB/Zelador e outros consumidores operacionais não devem depender de leitura manual de várias notas. `scripts/wsd_check.sh` deve gerar o snapshot ao final do check e falhar se ele não puder ser criado.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 9. `+wsd/` — Vendor Tree

O diretório `+wsd/` é criado pelo installer e contém o WSD vendorizado para uso local no projeto. É versionado no repositório (exceto estado efêmero como snapshot, last-check e estado do loop).

Estrutura principal:

| Caminho | Função |
|---|---|
| `+wsd/bin/wsd` | CLI local — `wsd start`, `start --brief`, `check`, `finish`, `relatorio`, `doctor`, `version`, `update`, `git`, `party`, `snapshot`, `loop`, `codex-prompt`, `codex` |
| `+wsd/bin/wsd-validate-context.cjs` | Validador zero-deps do `+context.json` contra o schema |
| `+wsd/bin/wsd-snapshot.cjs` | Gerador do `+wsd/snapshot.json` (resumo do estado do projeto) |
| `+wsd/schemas/context.schema.json` | JSON Schema 2020-12 canônico do `+context.json` |
| `+wsd/config.json` | Metadados da instalação: versão, source, ferramentas, data; lido por `wsd version` |
| `+wsd/loop/` | Prompts base do WSD Loop (`PROMPT_plan.md`, `PROMPT_build.md`) e estado local ignorado |
| `+wsd/docs/` | Documentação operacional do método (01–16) |
| `+wsd/party-mode/` | Sistema de orquestração multi-agente (agents, steps, templates) |
| `+wsd/templates/` | Templates de specs, comandos e repo (somente leitura) |
| `+wsd/profiles/` | Perfis de projeto (python_api, node_frontend, etc.) |

**Arquivos ignorados:** `+wsd/snapshot.json` (estado efêmero), `+wsd/.last-check.json` (timestamp do último check), `+wsd/loop/state.json`, `+wsd/loop/lock` e `+logs/wsd-loop/`.

**Versão instalada:** via `wsd version` — lê `version`, `installed_at` e `wsd_source` de `+wsd/config.json`; quando possível, compara com `wsd_source/package.json`.

**Atualização:** via `wsd update` — lê `wsd_source` de `+wsd/config.json` e atualiza `+wsd/bin/`, `+wsd/schemas/`, `+wsd/templates/` sem tocar em artefatos do projeto.

### Contrato `wsd finish` (v0.4.3)

`./+wsd/bin/wsd finish` é o fechamento aprovado de sessão. O comando deve:

- rodar `git diff --check`;
- rodar `scripts/wsd_check.sh --risk L0 .` quando disponível;
- rodar `scripts/wsd_docs_check.sh` quando o auditor documental do WSD estiver disponível na raiz do método;
- gerar `+specs/HANDOFF.md` com gates, alterações capturadas e próximos passos;
- atualizar snapshot quando possível;
- criar commit de fechamento por padrão;
- terminar com `git status --short` vazio.

### Contrato `wsd relatorio` (v0.4.4)

`./+wsd/bin/wsd relatorio` é leitura operacional. O comando deve:

- imprimir Markdown no terminal por padrão;
- salvar em `+specs/RELATORIO.md` quando usado com `--save`;
- consolidar Git, `+context.json`, ROADMAP, specs, STATE, IDEAS/IDEAS_PIPELINE e CONCERNS/CONCERNS_PIPELINE;
- indicar implementações em andamento, plano programado, ideias e concerns sem pipeline;
- terminar com sugestão de próximo passo baseada nos sinais WSD.

O comando não deve usar `git reset`, `git stash`, `git clean`, `git commit --no-verify`, auto-push ou auto-merge. Se gate, hook ou path sensível falhar, o fechamento não está aprovado.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 10. Sincronização de Artefatos

Ao alterar qualquer contrato desta nota, revisar:

- `templates/repo/`;
- `templates/repo/AGENTS.md.template`;
- `scripts/wsd_check.sh`;
- `scripts/wsd_self_check.sh`;
- [[wsd/docs/04_playbook_implantacao|04 Playbook]];
- [[wsd/docs/10_matriz_sincronizacao_notas|10 Matriz de Sincronização]].

Se o contrato alterar `+context.json`, também revisar `profiles/*.profile.yaml` E `schemas/context.schema.json` (e suas validações em `scripts/wsd_self_check.sh`).

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 11. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 05/05/2026 13:29:54 -03 | Codex | `x/wsd/docs/05_contrato_artefatos.md` | Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes. |
| 05/05/2026 14:13:39 -03 | Codex | `x/wsd/docs/05_contrato_artefatos.md` | Inclusão da regra de sincronização entre contrato, templates, checker e notas derivadas. |
| 07/05/2026 — | Claude | `x/wsd/docs/05_contrato_artefatos.md` | Documentação do schema canônico `schemas/context.schema.json` e validador `wsd-validate-context.js` na seção `+context.json` e na regra de sincronização de artefatos (v0.1.5-alpha). |
| 07/05/2026 — | Codex | `x/wsd/docs/05_contrato_artefatos.md` | Marcação do bloco `git_governance` como implementado e validado pelo schema na `v0.1.10-alpha`. |
| 11/05/2026 — | Claude | `x/wsd/docs/05_contrato_artefatos.md` | Adição das seções: `+specs/project/` (ROADMAP.md, IDEAS.md, IDEAS_PIPELINE.md — v0.1.1/v0.1.2) e `+wsd/` vendor tree (estrutura, arquivos ignorados, `wsd update`). Renúmeração de seções 6→11. Fix: referências `.js` → `.cjs` para wsd-validate-context e wsd-snapshot (v0.1.3). |
| 30/05/2026 18:15:09 -03 | Codex | `+Apps/wsd/docs/05_contrato_artefatos.md` | Inclusão de `wsd version` no contrato da vendor tree e explicitação do uso de `+wsd/config.json` como fonte de versão instalada. |
| 15/06/2026 | Codex | `+Apps/wsd/docs/05_contrato_artefatos.md` | Inclusão do contrato `automation.loop`, prompts `+wsd/loop/` e ignores locais do WSD Loop `v0.4.0`. |
| 17/06/2026 | Codex | `+Apps/wsd/docs/05_contrato_artefatos.md` | Inclusão do contrato de skills Codex em `.agents/skills/` e prompts opcionais `codex-shortcuts` (`v0.4.1`). |
| 21/06/2026 | Codex | `+Apps/wsd/docs/05_contrato_artefatos.md` | Inclusão de `CONCERNS_PIPELINE.md` como artefato obrigatório e regra de manutenção em par com `CONCERNS.md` (`v0.4.2`). |
| 21/06/2026 | Codex | `+Apps/wsd/docs/05_contrato_artefatos.md` | Inclusão do contrato `wsd finish` limpo com gates, docs audit e commit de fechamento (`v0.4.3`). |
| 21/06/2026 | Codex | `+Apps/wsd/docs/05_contrato_artefatos.md` | Inclusão do contrato `wsd relatorio` e do artefato opcional `+specs/RELATORIO.md` (`v0.4.4`). |

[[#📑 Índice|⬆️ Voltar ao Índice]]
