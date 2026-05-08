---
title: "Spec — Git/GitHub Governance MVP (v0.1.10-alpha)"
created: 07/05/2026
modified: 07/05/2026
feature: git-governance-mvp
risco: L1
status: approved
owner: lpo
---

# Spec — Git/GitHub Governance MVP (v0.1.10-alpha)

## Problema

O WSD ja possui politica Git minima, Conventional Commits e hooks locais. A proxima frente planejada exige tornar GitHub, branch, remote, upstream, Issue e PR parte explicita do contrato operacional sem transformar o core em dependente de GitHub ou `gh`.

Hoje `--git-policy`, `git_governance`, `wsd git doctor|preflight|pr-check` e templates `.github/` existem apenas como plano documental. Projetos reais que valorizam GitHub ainda dependem de convencao manual para checar branch errada, remote ausente, worktree suja, Issue/spec para L1/L2 e PR bem documentado.

## Goals

- [ ] `wsd-method install` aceita `--git-policy none|basic|full`.
- [ ] O modo `none` preserva o comportamento atual e nao exige GitHub.
- [ ] O modo `basic` gera politica Git local e comandos `wsd git` sem exigir `gh`.
- [ ] O modo `full` gera templates de PR/Issue e orienta validacao GitHub/`gh`.
- [ ] `.context.json` renderizado declara `git_governance`.
- [ ] `AGENTS.md` renderizado orienta agentes sobre o modo Git/GitHub escolhido.
- [ ] `.wsd/bin/wsd` suporta `git doctor`, `git preflight` e `git pr-check`.
- [ ] Testes de instalacao cobrem `none`, `basic` e `full`.

## Fora de Escopo

| Item | Motivo |
|---|---|
| `multi-host` | Adiado para alpha posterior; MVP aceita apenas `none|basic|full`. |
| `wsd git audit` | Planejado, mas nao necessario para primeiro uso em projeto real. |
| `wsd git bootstrap` criando repo | Operacao administrativa sensivel; exige decisao explicita futura. |
| Server-side hooks | Complexidade alta e fora do uso solo imediato. |
| OPA/Rego | Modulo avancado para multi-agente/time, fora do MVP. |
| Alterar visibilidade, secrets, branch default, delete repo ou permissoes GitHub | Operacoes destrutivas/sensiveis proibidas no primeiro alpha. |

---

## User Stories

### P1: Operador instalando WSD sem GitHub

**Como** operador, **quero** manter `--git-policy none` como caminho valido **para que** projetos locais ou sem remote continuem recebendo o WSD core sem depender de GitHub.

**Acceptance Criteria:**

1. WHEN `wsd-method install --git-policy none --github skip` roda THEN o instalador SHALL concluir sem exigir `gh`, remote GitHub ou templates `.github/`.
2. WHEN `--git-policy none` e usado THEN o `.context.json` SHALL declarar `git_governance.enabled = false` e `mode = "none"`.
3. WHEN `npm test` roda THEN as suites existentes SHALL continuar passando sem alterar o comportamento default do core.

### P1: Operador instalando politica local basica

**Como** operador, **quero** usar `--git-policy basic` **para que** agentes tenham preflight de branch/upstream/worktree sem exigir GitHub CLI.

**Acceptance Criteria:**

4. WHEN `wsd-method install --git-policy basic` roda THEN o instalador SHALL gerar `git_governance.enabled = true`, `mode = "basic"` e campos de branch, sync, dirty worktree e commit style.
5. WHEN `--git-policy basic` e usado THEN `AGENTS.md` SHALL conter uma secao Git/GitHub com comandos `./.wsd/bin/wsd git doctor` e `./.wsd/bin/wsd git preflight`.
6. WHEN `./.wsd/bin/wsd git preflight` roda em worktree suja THEN o comando SHALL reportar a sujeira e sair com codigo diferente de zero.

### P1: Operador instalando governanca GitHub completa

**Como** operador, **quero** usar `--git-policy full` **para que** PRs e Issues tenham templates e checks locais antes da promocao.

**Acceptance Criteria:**

7. WHEN `wsd-method install --git-policy full` roda THEN o instalador SHALL gerar `.github/PULL_REQUEST_TEMPLATE.md`.
8. WHEN `wsd-method install --git-policy full` roda THEN o instalador SHALL gerar `.github/ISSUE_TEMPLATE/task.md`, `bug.md` e `decision.md`.
9. WHEN `./.wsd/bin/wsd git doctor` roda em modo `full` sem `gh` THEN o comando SHALL emitir warning e nao falhar por padrao.
10. WHEN `./.wsd/bin/wsd git pr-check` roda em `main` ou `master` THEN o comando SHALL falhar informando que PR deve sair de branch dedicada.
11. WHEN `./.wsd/bin/wsd git pr-check` roda sem diff local e sem commits ahead THEN o comando SHALL falhar informando que nao ha mudanca pronta para PR.

### P2: Manutencao do pacote WSD

**Como** mantenedor, **quero** testes e docs sincronizados **para que** a entrega `v0.1.10-alpha` nao fique apenas documental.

**Acceptance Criteria:**

12. WHEN `npm test` roda THEN SHALL incluir suites para `--git-policy none`, `basic` e `full`.
13. WHEN `bash scripts/wsd_self_check.sh` roda THEN SHALL confirmar a presenca dos templates/scripts do modulo Git Governance.
14. WHEN a entrega for concluida THEN README, hub, ROADMAP, CHANGELOG, docs/00, docs/03, docs/04, docs/05, docs/07, docs/08, docs/10, docs/11, docs/12 e STATE.md SHALL estar coerentes com `v0.1.10-alpha`.

---

## Escopo de Execucao

**Paths permitidos:**

- `bin/wsd-method.js`
- `package.json`
- `templates/local-wsd/bin/wsd`
- `templates/repo/.context.json.template`
- `templates/repo/AGENTS.md.template`
- `templates/modules/git-governance/`
- `scripts/wsd_docs_check.sh`
- `scripts/wsd_self_check.sh`
- `schemas/context.schema.json`
- `README.md`, `wsd.md`, `ROADMAP.md`, `CHANGELOG.md`
- `docs/00_planejamento_instalacao_wsd.md`
- `docs/03_ciclo_operacional.md`
- `docs/04_playbook_implantacao.md`
- `docs/05_contrato_artefatos.md`
- `docs/07_git_governance.md`
- `docs/08_rotinas_sessao.md`
- `docs/10_matriz_sincronizacao_notas.md`
- `docs/11_modulo_git_governance.md`
- `docs/12_avaliacao_critica.md`
- `+specs/project/STATE.md`
- `+specs/features/git-governance-mvp/`

**Paths proibidos:**

- `wsd_philo/`
- `+wsd/`
- arquivos de secrets, `.env`, chaves ou credenciais reais
- `+specs/analise_party_mode_integracao.md` (mudanca preexistente nao relacionada)

## Riscos e Mitigacoes

| Risco | Probabilidade | Mitigacao |
|---|---|---|
| `--git-policy full` falhar em ambientes sem `gh` | Media | `doctor` emite warning por padrao; o contexto declara `github_cli_required`. |
| Quebrar installs existentes | Media | `none`/default preserva comportamento e testes existentes continuam rodando. |
| Schema rejeitar contexto antigo sem bloco Git | Baixa | `git_governance` fica opcional no schema, mas o template novo sempre declara o bloco. |
| `pr-check` ser rigido demais para repos locais | Media | Checks de PR ficam concentrados em comando explicito, nao em `pre-commit`. |

## Rollback

L1 — sem rollback operacional formal. Se a feature bloquear installs legitimos:

1. Reverter o commit da `v0.1.10-alpha`;
2. Manter docs em `v0.1.9-alpha`;
3. Preservar o plano em `docs/11_modulo_git_governance.md` para nova tentativa menor.

---

> **Nota para agente:** Esta spec e L1 e esta `approved`. Implementar pelas tasks em `tasks.md`, sem tocar no arquivo preexistente `+specs/analise_party_mode_integracao.md`.
