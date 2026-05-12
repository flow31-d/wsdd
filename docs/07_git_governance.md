---
title: "07 — Git Governance WSD"
created: 05/05/2026
modified: 05/05/2026
tags:
  - x
  - wsd
  - git
  - github
status: ativo
tipo: guia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/docs/01_constituicao]], [[wsd/docs/03_ciclo_operacional]], [[wsd/docs/10_matriz_sincronizacao_notas]], [[wsd/docs/11_modulo_git_governance]]"
otimizado_para_obsidian: true
---
# 07 — Git Governance WSD

[[wsd/wsd|← WSD]]

---


> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. Entrada Obrigatória]]
3. [[#3. Branch]]
4. [[#4. Commit]]
5. [[#5. PR]]
6. [[#6. Proibições]]
7. [[#7. Worktree Suja]]
8. [[#8. Clones Paralelos]]
9. [[#9. Git Hooks no Bootstrap]]
10. [[#10. Módulo Opcional `git-governance`]]
11. [[#11. Sincronização da Política Git]]
12. [[#12. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 05/05/2026 13:29:54 -03 — Codex: Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes.
- 05/05/2026 14:13:39 -03 — Codex: Inclusão de sincronização obrigatória entre política Git, AGENTS, ciclo operacional e templates de agentes.
- 05/05/2026 14:38:29 -03 — Codex: Registro de que a política Git avançada será tratada como módulo opcional `git-governance`.
- 07/05/2026 — Claude: Adição da Seção 9 (Git Hooks no Bootstrap) com `pre-commit`, `commit-msg`, `pre-push` instalados pelo bootstrap (v0.1.6-alpha).
- 07/05/2026 — Codex: Planejamento da `v0.1.10-alpha` como MVP Git/GitHub Governance antes da estabilização `v0.1.0`.
- 07/05/2026 — Codex: Marcação da `v0.1.10-alpha` como implementada com `--git-policy`, Git namespace local e templates GitHub no modo `full`.
- 12/05/2026 — Claude: Clarificação do padrão de branch por modo (`basic` vs `full`), decisão de idioma de commit (português obrigatório) e atualização de todos os exemplos para português.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. Entrada Obrigatória

Antes de editar:

```bash
git status --short --branch
git branch -vv
git remote -v
git remote show origin
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. Branch

Usar branch dedicada para mudanças não triviais.

Padrão por modo:

| Modo | Formato | Exemplo |
|---|---|---|
| `basic` (sem Issue) | `tipo/<slug>` | `feat/validacao-email`, `fix/carrinho-quantidade` |
| `full` (com Issue) | `issue-<numero>-<slug>` | `issue-42-validacao-email` |

O formato `issue-<numero>-<slug>` é o **padrão obrigatório** quando o módulo git-governance está em modo `full` — garante rastreabilidade Issue→branch→PR. Em modo `basic`, onde Issues são opcionais, usar `tipo/<slug>`.

O valor default do instalador é `issue-<number>-<slug>`, alinhado com a política Git da VPS.

Evitar trabalhar direto em `main` ou `master`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. Commit

**Conventional Commits 1.0.0 é obrigatório** em repositórios WSD.

### Idioma

**Description sempre em português.** Esta é uma decisão explícita: os repositórios WSD são operados em português e o idioma deve ser consistente entre agentes, PRs e histórico de commits. O formato Conventional Commits (tipo, escopo) permanece em inglês por convenção do spec, mas o texto descritivo é em português.

### Formato

```
<type>(<scope>): <descrição em português>

[corpo opcional em português]

[footer(s) opcional]
```

### Tipos

| Tipo | Quando usar |
|---|---|
| `feat` | Nova feature ou capacidade |
| `fix` | Correção de bug |
| `refactor` | Mudança de código sem bug fix nem feature |
| `docs` | Apenas documentação |
| `test` | Adicionar ou corrigir testes |
| `style` | Formatação, ponto-e-vírgula (sem mudança de lógica) |
| `perf` | Melhoria de performance |
| `build` | Build system ou dependências externas |
| `ci` | Arquivos de configuração de CI |
| `chore` | Tarefas de manutenção que não alteram src ou test |

### Regras de Description

- Modo imperativo ("adicionar", não "adicionado" ou "adiciona")
- Minúscula na primeira letra
- Sem ponto final
- Complete a frase: "Se aplicado, este commit irá _[sua description]_"

### Exemplos

```text
feat(auth): adicionar validação de e-mail no formulário de login
fix(carrinho): impedir quantidade negativa no decremento de item
docs: adicionar Regra 11 (cadeia de verificação de conhecimento) à Constituição
refactor(installer): renomear .specs → +specs nos perfis
test(installer): atualizar testes de instalação para estrutura +specs
fix(installer): não vendarizar meta-docs do toolkit em +wsd/ do projeto
docs(07): clarificar padrão de branch por modo e decidir idioma de commit
```

### Breaking Changes

Acrescentar `!` após type/scope e footer `BREAKING CHANGE:`:

```
feat(api)!: alterar formato de resposta do endpoint de autenticação

BREAKING CHANGE: endpoint de login agora retorna JWT no corpo em vez de cookie
```

### Regras de Escopo

- Uma task = um commit
- Commit contém apenas arquivos do escopo da task
- Nunca "enquanto estou aqui" — mudanças extras vão em commit separado ou STATE.md

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. PR

PR deve conter:

- resumo;
- escopo;
- spec relacionada;
- risco;
- validação;
- rollback para L2;
- pendências.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. Proibições

Sem decisão explícita:

- force push;
- apagar branch remota;
- mudar branch padrão;
- alterar visibilidade do repo;
- alterar secrets;
- alterar permissões;
- reset destrutivo;
- clean destrutivo;
- merge/rebase com worktree suja.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. Worktree Suja

Se houver sujeira:

1. listar arquivos;
2. identificar se são preexistentes;
3. decidir se a tarefa pode prosseguir;
4. usar `git add <arquivo>` seletivo;
5. não misturar alterações.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. Clones Paralelos

Quando um repo existe em mais de um host, declarar papéis:

- histórico compartilhado;
- clone operacional;
- clone laboratório;
- clone auditoria;
- clone deploy.

Exemplo genérico:

```text
GitHub = histórico compartilhado
Host A = desenvolvimento canônico
Host B = deploy/publicação
Host C = auditoria/laboratório
```

O `+context.json` deve ser a fonte local dessa decisão.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 9. Git Hooks no Bootstrap

A partir de `v0.1.6-alpha`, o instalador (`wsd-method install`) instala três hooks automaticamente:

| Hook | Função |
|---|---|
| `pre-commit` | Roda `scripts/wsd_check.sh --risk L0` antes de cada commit |
| `commit-msg` | Valida formato Conventional Commits 1.0.0 |
| `pre-push` | Roda `scripts/wsd_check.sh --risk L0` antes de push |

Localização:
- **Versioned** (auditável): `scripts/git-hooks/` — versionado junto ao projeto
- **Ativo**: `.git/hooks/` — onde o git os executa

Para reinstalar (ex.: após clonar o repo):

```bash
./+wsd/bin/wsd hooks
```

Para instalar sem hooks:

```bash
wsd-method install --no-git-hooks
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 10. Módulo Opcional `git-governance`

Esta nota define a política Git mínima do WSD.

A política avançada derivada de `Recursos/r.3.4_git_github` deve evoluir como módulo opcional:

- [[wsd/docs/11_modulo_git_governance|11 — Módulo Git Governance WSD]]

Regra: não transformar o WSD core em dependente de GitHub, `gh`, Issue ou topologia multi-host. Esses recursos devem ser ativados por instalação modular.

Entrega `v0.1.10-alpha`:

- Modos: `--git-policy none|basic|full`.
- Comandos: `./+wsd/bin/wsd git doctor`, `preflight`, `pr-check`.
- Artefatos: campos `git_governance` no `+context.json`, template de PR, templates simples de Issue e seção GitHub explícita no `AGENTS.md`.
- `pr-check` valida branch dedicada, worktree limpa e commits à frente da base antes do PR; `upstream`/`origin` viram sinalização adicional, não bloqueio absoluto neste alpha.
- Fora do primeiro MVP: `multi-host`, server-side hooks, OPA/Rego, bootstrap automático destrutivo ou alterações administrativas sensíveis no GitHub.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 11. Sincronização da Política Git

Ao alterar esta política, revisar:

- [[wsd/AGENTS|AGENTS]];
- [[wsd/docs/03_ciclo_operacional|03 Ciclo Operacional]];
- `templates/repo/AGENTS.md.template`;
- `templates/codex-skills/wsd/SKILL.md`;
- templates de PR/spec, se a exigência de PR ou spec mudar;
- [[wsd/docs/11_modulo_git_governance|11 Módulo Git Governance]], se a mudança afetar política avançada ou instalador modular;
- [[wsd/docs/10_matriz_sincronizacao_notas|10 Matriz de Sincronização]].

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 11. Sincronização da Política Git (cont.)

Ao alterar git hooks, revisar também:
- `templates/git-hooks/` — fonte dos três hooks;
- `templates/local-wsd/bin/wsd` — subcomando `hooks`;
- `templates/repo/AGENTS.md.template` — seção Git Hooks;
- `bin/wsd-method.js` — função `installGitHooks`;
- `scripts/wsd_self_check.sh` e `scripts/wsd_docs_check.sh`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 12. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 05/05/2026 13:29:54 -03 | Codex | `x/wsd/docs/07_git_governance.md` | Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes. |
| 05/05/2026 14:13:39 -03 | Codex | `x/wsd/docs/07_git_governance.md` | Inclusão de sincronização obrigatória entre política Git, AGENTS, ciclo operacional e templates de agentes. |
| 05/05/2026 14:38:29 -03 | Codex | `x/wsd/docs/07_git_governance.md` | Registro de que a política Git avançada será tratada como módulo opcional `git-governance`. |
| 07/05/2026 — | Claude | `x/wsd/docs/07_git_governance.md` | Adição da Seção 9 — Git Hooks no Bootstrap (`pre-commit`, `commit-msg`, `pre-push`) e atualização dos números de seção e índice (v0.1.6-alpha). |
| 07/05/2026 — | Codex | `x/wsd/docs/07_git_governance.md` | Planejamento da `v0.1.10-alpha` como MVP Git/GitHub Governance antes da estabilização. |
| 07/05/2026 — | Codex | `x/wsd/docs/07_git_governance.md` | Marcação da `v0.1.10-alpha` como implementada em instalador, CLI local e templates GitHub. |
| 12/05/2026 — | Claude | `+Apps/WSD/docs/07_git_governance.md` | Clarificação do padrão de branch por modo (`basic` = `tipo/<slug>`, `full` = `issue-<numero>-<slug>`), decisão explícita de idioma (português obrigatório na description) e atualização de todos os exemplos de commit. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
