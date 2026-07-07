---
title: "AGENTS — WSD"
created: 05/05/2026
modified: 2026-07-07
tags:
  - wsd
  - agentes
status: ativo
tipo: guia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/README]], [[wsd/docs/01_constituicao]], [[wsd/docs/10_matriz_sincronizacao_notas]]"
---
# Instruções para Agentes — WSD

Este repositório é o pacote WSD (Wolff Spec Driven): metodologia + installer +
templates para governar desenvolvimento com agentes. Ele se auto-governa com
WSD (dogfooding).

## Modo de operação

`workflow.approval_mode = full_auto`: execute a tarefa inteira e feche com
commit, sem pausar para aprovação humana. L2 exige spec, validação reforçada e
rollback documentado — mas não pausa.

**Única pausa obrigatória**: worktree suja que você não criou nesta sessão
(outro agente/humano deixou mudanças). Pare e peça decisão humana antes de
merge, stash, reset ou qualquer limpeza.

## Intenção → Ação

| Operador pede | Você faz |
|---|---|
| "uma geral", "como está o projeto" | `./+wsd/bin/wsd relatorio` e resume |
| "vamos fazer/implementar X" | classifica risco; L1/L2 → spec WHEN/THEN/SHALL primeiro |
| "anota essa ideia" | registra em `+specs/project/IDEAS.md` + `IDEAS_PIPELINE.md` |
| "anota essa preocupação/risco" | registra `CONC-###` em `CONCERNS.md` + `CONCERNS_PIPELINE.md` |
| "fecha por hoje", "encerra" | `./+wsd/bin/wsd finish` |
| "atualiza o wsd do projeto Y" | `node bin/wsd-method.js update --directory <Y>` |

## Ao iniciar qualquer tarefa

1. `git status --short --branch` — se houver sujeira de terceiros, aplicar a pausa acima.
2. Ler `+context.json` (paths permitidos/proibidos) e `+specs/project/STATE.md`.
3. Conferir concerns ativas que tocam a área (`CONCERNS.md`).
4. Classificar L0/L1/L2 e agir proporcionalmente (tabela no [README](README.md)).

## Regras invioláveis

- Manter o WSD genérico: nada de projeto específico em templates (usar `profiles/`).
- Preservar placeholders `{{...}}` nos `.template`; validar JSON/YAML após editar.
- Nunca armazenar secrets, API keys, `.env` reais, dados pessoais/clínicos.
- Não usar `git add .` manualmente (exceção: `wsd finish` após gates).
- `archive/` é histórico — não ler para contexto, não sincronizar, não editar.
- Histórico não se duplica: versão só em `package.json` + `CHANGELOG.md`;
  autoria/data só no git. Não criar tabelas manuais de histórico em notas.
- Fora de escopo → registrar em STATE.md/IDEAS.md, não implementar.

## Antes de finalizar mudanças

1. Consultar a matriz [[wsd/docs/10_matriz_sincronizacao_notas|docs/10]] quando
   a mudança tocar installer, templates, CLI, skills, versão ou release.
2. Rodar os gates:

```bash
bash scripts/wsd_docs_check.sh
bash scripts/wsd_self_check.sh
npm test                        # quando tocar installer/CLI/templates
```

3. Commit em Conventional Commits 1.0.0; fechar com worktree limpa.

## Guias on-demand (ler só quando a tarefa toca o tema)

- Git/PR/branch → `docs/07_git_governance.md`
- WSD Loop/automação → `docs/19_wsd_loop_automacao_inteligente.md`
- Release/publicação → `RELEASING.md` + `docs/09_publicacao_github_privado.md`
- Sync privado → público (`wsdd`) → `docs/15_repositorio_publico_e_quick_start.md`
- Bug em projeto que usa WSD → `CONTRIBUTING.md` (onde corrigir e como propagar)
