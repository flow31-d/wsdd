---
title: "05 — Contrato de Artefatos WSD"
created: 05/05/2026
modified: 05/05/2026
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
2. [[#2. `.context.json`]]
3. [[#3. `AGENTS.md`]]
4. [[#4. `+specs/*.spec.yaml`]]
5. [[#5. `+specs/context/*.md`]]
6. [[#6. `+logs/error_vault.json`]]
7. [[#7. `scripts/wsd_check.sh`]]
8. [[#8. Sincronização de Artefatos]]
9. [[#9. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 05/05/2026 13:29:54 -03 — Codex: Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes.
- 05/05/2026 14:13:39 -03 — Codex: Inclusão da regra de sincronização entre contrato, templates, checker e notas derivadas.
- 07/05/2026 — Claude: Documentação do schema canônico `schemas/context.schema.json` e do validador `wsd-validate-context.js` (v0.1.5-alpha).
- 07/05/2026 — Codex: Planejamento do bloco `git_governance` no `.context.json` para o MVP Git/GitHub Governance (`v0.1.10-alpha`).
- 07/05/2026 — Codex: Marcação do bloco `git_governance` como implementado na `v0.1.10-alpha` e validado pelo schema canônico.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. `.context.json`

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
- **Validador:** `templates/local-wsd/bin/wsd-validate-context.js` — pure-JS zero-deps, vendorizado em `.wsd/bin/wsd-validate-context.js` no install.
- **Gate:** `scripts/wsd_check.sh` chama o validador após o JSON syntax check; falha com path JSON-pointer (ex.: `/permissions/write_paths: missing required property`).
- **Fallback:** se Node ausente, o gate emite `warn:` e segue (syntax check continua hard-fail).

Required mínimo: `$schema` (const `wsd/context/v1`), `project`, `environment`, `repository`, `permissions`, `workflow`, `wsd`. Enums fortes: `permissions.secrets_policy`, `workflow.production_mutation_policy`, `repository.repo_type`.

### Bloco `git_governance` (v0.1.10-alpha)

O MVP Git/GitHub Governance adiciona um bloco opcional ao `.context.json`. Instalações novas sempre renderizam o bloco; instalações antigas continuam válidas sem ele.

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

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. `AGENTS.md`

Função: instrução local para agentes.

Deve responder:

- o que é este repo;
- onde ele vive;
- como abrir sessão;
- o que é proibido;
- como validar;
- onde estão specs e contexto.

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

## 6. `+logs/error_vault.json`

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

## 7. `scripts/wsd_check.sh`

Função: checker local mínimo.

Deve validar:

- repo Git;
- `.context.json`;
- `+logs/error_vault.json`;
- spec exigida para L1/L2;
- status da spec;
- forbidden paths básicos;
- placeholders não substituídos.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. Sincronização de Artefatos

Ao alterar qualquer contrato desta nota, revisar:

- `templates/repo/`;
- `templates/repo/AGENTS.md.template`;
- `scripts/wsd_check.sh`;
- `scripts/wsd_self_check.sh`;
- [[wsd/docs/04_playbook_implantacao|04 Playbook]];
- [[wsd/docs/10_matriz_sincronizacao_notas|10 Matriz de Sincronização]].

Se o contrato alterar `.context.json`, também revisar `profiles/*.profile.yaml` E `schemas/context.schema.json` (e suas validações em `scripts/wsd_self_check.sh`).

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 9. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 05/05/2026 13:29:54 -03 | Codex | `x/wsd/docs/05_contrato_artefatos.md` | Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes. |
| 05/05/2026 14:13:39 -03 | Codex | `x/wsd/docs/05_contrato_artefatos.md` | Inclusão da regra de sincronização entre contrato, templates, checker e notas derivadas. |
| 07/05/2026 — | Claude | `x/wsd/docs/05_contrato_artefatos.md` | Documentação do schema canônico `schemas/context.schema.json` e validador `wsd-validate-context.js` na seção `.context.json` e na regra de sincronização de artefatos (v0.1.5-alpha). |
| 07/05/2026 — | Codex | `x/wsd/docs/05_contrato_artefatos.md` | Marcação do bloco `git_governance` como implementado e validado pelo schema na `v0.1.10-alpha`. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
