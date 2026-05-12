---
title: "03 — Ciclo Operacional WSD"
created: 05/05/2026
modified: 05/05/2026
tags:
  - x
  - wsd
  - ciclo
  - operacao
status: ativo
tipo: guia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/docs/02_matriz_risco]], [[wsd/docs/08_rotinas_sessao]], [[wsd/docs/07_git_governance]], [[wsd/docs/10_matriz_sincronizacao_notas]]"
otimizado_para_obsidian: true
---
# 03 — Ciclo Operacional WSD

[[wsd/wsd|← WSD]]

---


> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. Fase 1 — Abrir Sessão]]
3. [[#3. Fase 2 — Classificar]]
4. [[#4. Fase 3 — Preparar Contrato]]
5. [[#5. Fase 4 — Executar]]
6. [[#6. Fase 5 — Validar]]
7. [[#7. Fase 6 — Promover]]
8. [[#8. Fase 7 — Fechar Sessão]]
9. [[#9. Sincronização do Ciclo]]
10. [[#10. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 05/05/2026 13:29:54 -03 — Codex: Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes.
- 05/05/2026 14:13:39 -03 — Codex: Atualização do ciclo para recomendar o CLI local `+wsd/bin/wsd` e indicar sincronização obrigatória quando o fluxo mudar.
- 07/05/2026 — Codex: Planejamento do encaixe do MVP Git/GitHub Governance no ciclo operacional (`v0.1.10-alpha`).
- 07/05/2026 — Codex: Atualização do ciclo para refletir `v0.1.10-alpha` implementado com `wsd git preflight`, `doctor` e `pr-check`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. Fase 1 — Abrir Sessão

Objetivo: impedir que o agente comece cego.

Checklist:

```bash
git status --short --branch
git branch -vv
git remote -v
git remote show origin
```

Se existir WSD local:

```bash
./+wsd/bin/wsd start
bash scripts/wsd_check.sh --risk L0 .
```

Quando o módulo Git/GitHub Governance estiver instalado (`--git-policy basic|full`), a abertura deve incluir:

```bash
./+wsd/bin/wsd git preflight
./+wsd/bin/wsd git doctor
```

O agente deve reportar:

- repo;
- host;
- path;
- branch;
- upstream;
- worktree limpa/suja;
- specs existentes;
- risco estimado;
- próximo passo seguro.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. Fase 2 — Classificar

Classificar a tarefa como L0, L1 ou L2.

Perguntas:

- altera comportamento?
- toca produção?
- toca dados sensíveis?
- toca segredo?
- exige rollback?
- afeta usuário final?
- afeta deploy?
- afeta contrato público?
- mistura muitos módulos?

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. Fase 3 — Preparar Contrato

L0:

- Task Card ou descrição do pedido;
- validação proporcional.

L1:

- spec aprovada;
- branch;
- escopo;
- critérios de aceite;
- validação.

L2:

- spec aprovada;
- aprovação humana;
- rollback;
- health checks;
- plano operacional.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. Fase 4 — Executar

Durante execução:

- editar apenas escopo permitido;
- evitar refatorações não solicitadas;
- preservar mudanças preexistentes;
- não usar `git add .`;
- não registrar secrets;
- manter validação coerente com a spec.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. Fase 5 — Validar

Rodar comandos reais do repo.

Se um comando não puder rodar, registrar:

- comando;
- motivo;
- risco residual;
- alternativa executada.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. Fase 6 — Promover

Fluxo recomendado:

```bash
git diff --check
git status --short
git add <arquivos-especificos>
git commit -m "<tipo>: <resumo>"
git push -u origin <branch>
gh pr create
```

Para L1/L2, PR deve citar spec.

Quando o módulo Git/GitHub Governance estiver instalado, antes de abrir ou atualizar PR:

```bash
./+wsd/bin/wsd git pr-check
```

O `pr-check` deve ser o gate local antes do PR.
Neste alpha, a implementação prática garante branch dedicada, worktree limpa e commits à frente da base; `upstream` e `remote` entram como sinalização adicional quando disponíveis.
Spec/Issue e validação seguem obrigatórios no fluxo L1/L2, mas a checagem automatizada deles ainda fica no processo e nos checkers maiores, não no `pr-check` local.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. Fase 7 — Fechar Sessão

Checklist:

```bash
./+wsd/bin/wsd finish
git status --short --branch
git diff --stat
git diff --check
git log -1 --date=short --pretty='last=%ad | %h | %s'
```

Relatório final:

- o que mudou;
- onde mudou;
- validações;
- PR/commit/spec;
- pendências;
- risco residual;
- próximo passo.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 9. Sincronização do Ciclo

Ao alterar este ciclo, revisar:

- [[wsd/docs/08_rotinas_sessao|08 Rotinas de Sessão]];
- [[wsd/docs/07_git_governance|07 Git Governance]], se afetar branch, commit ou PR;
- `templates/local-wsd/bin/wsd`, se afetar comandos locais;
- `templates/codex-skills/wsd/SKILL.md`, se afetar comportamento de agente;
- [[wsd/docs/10_matriz_sincronizacao_notas|10 Matriz de Sincronização]].

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 10. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 05/05/2026 13:29:54 -03 | Codex | `x/wsd/docs/03_ciclo_operacional.md` | Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes. |
| 05/05/2026 14:13:39 -03 | Codex | `x/wsd/docs/03_ciclo_operacional.md` | Atualização do ciclo para recomendar o CLI local `+wsd/bin/wsd` e indicar sincronização obrigatória quando o fluxo mudar. |
| 07/05/2026 — | Codex | `x/wsd/docs/03_ciclo_operacional.md` | Planejamento do encaixe de `wsd git preflight`, `doctor` e `pr-check` no ciclo operacional da v0.1.10-alpha. |
| 07/05/2026 — | Codex | `x/wsd/docs/03_ciclo_operacional.md` | Atualização do ciclo para refletir `v0.1.10-alpha` implementado com Git namespace local. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
