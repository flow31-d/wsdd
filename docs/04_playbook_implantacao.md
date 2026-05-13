---
title: "04 — Playbook de Implantação WSD"
created: 05/05/2026
modified: 12/05/2026
tags:
  - x
  - wsd
  - implantacao
  - repositorios
status: ativo
tipo: guia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/docs/05_contrato_artefatos]], [[wsd/docs/06_personalizacao_por_projeto]], [[wsd/docs/10_matriz_sincronizacao_notas]], [[wsd/docs/14_qualidade_desenvolvimento]], [[wsd/templates/repo/AGENTS.md.template]]"
otimizado_para_obsidian: true
---
# 04 — Playbook de Implantação WSD

[[wsd/wsd|← WSD]]

---

> [!abstract] Objetivo
> Aplicar WSD em um repositório sem misturar metodologia global com detalhes locais do projeto.


> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. Passo 0 — Confirmar Escopo]]
3. [[#3. Passo 1 — Auditoria Inicial]]
4. [[#4. Passo 2 — Escolher Perfil]]
5. [[#5. Passo 3 — Instalar WSD]]
6. [[#6. Passo 4 — Revisar Arquivos Gerados]]
7. [[#7. Passo 5 — Ajustar `+context.json`]]
8. [[#8. Passo 6 — Atualizar `AGENTS.md`]]
9. [[#9. Passo 7 — Auto-sizing e Fluxo de 4 Fases]]
10. [[#10. Passo 8 — Criar Primeira Spec]]
11. [[#11. Passo 9 — Validar]]
12. [[#12. Passo 10 — Promover por PR]]
13. [[#13. Passo 11 — Registrar no Vault ou Playbook]]
14. [[#14. Sincronização Deste Playbook]]
15. [[#15. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 05/05/2026 13:29:54 -03 — Codex: Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes.
- 05/05/2026 14:13:39 -03 — Codex: Atualização do playbook para usar o instalador `wsd-method` como fluxo preferencial, mantendo cópia manual apenas como fallback.
- 06/05/2026 — Claude: Inserção do Passo 7 (Auto-sizing e fluxo de 4 fases TLC), tabela L0/L1/L2 → Quick/Specify+Execute/4 fases e ajuste dos paths para `+specs/` e `+logs/`.
- 07/05/2026 — Codex: Planejamento do uso de `--git-policy full` para projetos reais que valorizam GitHub após a `v0.1.10-alpha`.
- 07/05/2026 — Codex: Atualização do playbook para tratar `--git-policy full` como disponível na `v0.1.10-alpha`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. Passo 0 — Confirmar Escopo

Antes de implantar WSD, confirmar:

- o repo é próprio ou autorizado;
- há remote GitHub válido;
- há branch padrão conhecida;
- o host canônico está claro;
- a worktree não será misturada com alterações não relacionadas.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. Passo 1 — Auditoria Inicial

Rodar:

```bash
git status --short --branch
git branch -vv
git remote -v
git remote show origin
git log -1 --date=short --pretty='last=%ad | %h | %s'
```

Registrar:

- nome do repo;
- path local;
- remote;
- branch atual;
- branch padrão;
- sujeira local;
- stack técnica;
- comandos reais de validação.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. Passo 2 — Escolher Perfil

Usar `profiles/` como ponto de partida.

Perfis iniciais:

- `generic_node_frontend.profile.yaml`;
- `generic_python_api.profile.yaml`;
- `prescreve_mais.profile.yaml`;
- `koomplet_office.profile.yaml`.

Se nenhum perfil servir, criar um novo.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. Passo 3 — Instalar WSD

Fluxo preferencial da alpha:

```bash
bash /srv/CLI/+Apps/WSD/install.sh \
  --directory /path/to/project \
  --profile generic_node_frontend \
  --tools codex \
  --github skip \
  --yes
```

Também é possível rodar a partir do clone do WSD:

```bash
node bin/wsd-method.js install \
  --directory /path/to/project \
  --profile generic_node_frontend \
  --tools codex \
  --github skip \
  --yes
```

Na `v0.1.10-alpha`, projetos reais em andamento que valorizam GitHub podem usar o módulo Git/GitHub Governance:

```bash
node bin/wsd-method.js install \
  --directory /path/to/project \
  --profile generic_node_frontend \
  --tools codex \
  --github skip \
  --git-policy full \
  --yes
```

O modo `full` deve gerar política explícita de branch, remote, Issue, PR, `gh`, templates GitHub e comandos `./+wsd/bin/wsd git doctor|preflight|pr-check`.

Arquivos esperados (greenfield mínimo):

```text
+wsd/
AGENTS.md
+context.json
+specs/project/PROJECT.md
+specs/project/STATE.md
+specs/features/wsd-bootstrap/spec.md
+logs/
scripts/wsd_check.sh
```

Com `--brownfield`, também são gerados (preencher após install):

```text
+specs/codebase/STACK.md
+specs/codebase/ARCHITECTURE.md
+specs/codebase/CONVENTIONS.md
+specs/codebase/STRUCTURE.md
+specs/codebase/INTEGRATIONS.md
+specs/codebase/TESTING.md
```

> Nota: `CONCERNS.md` deixou de ser exclusivo do brownfield desde `v0.2.0` — agora é gerado em `+specs/project/CONCERNS.md` para todo install (greenfield e brownfield).

Cópia manual de `templates/repo/` só deve ser usada como fallback, quando o instalador não puder rodar.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. Passo 4 — Revisar Arquivos Gerados

O instalador renderiza placeholders automaticamente a partir do perfil, detecção Git e opções `--set`.

Mesmo assim, o agente deve revisar:

- `AGENTS.md`;
- `+context.json`;
- `+specs/project/PROJECT.md`;
- `+specs/project/STATE.md`;
- `+specs/features/wsd-bootstrap/spec.md`;
- `+specs/codebase/*.md` quando `--brownfield`;
- `scripts/wsd_check.sh`;
- `+wsd/config.json`;
- `.codex/skills/*/SKILL.md`, quando `--tools codex` for usado;
- `.claude/commands/*.md`, quando `--tools claude-code` for usado.

Campos essenciais que não podem ficar vazios ou genéricos:

- `{{PROJECT_NAME}}`
- `{{REPO_NAME}}`
- `{{GITHUB_REMOTE}}`
- `{{CANONICAL_HOST}}`
- `{{CANONICAL_PATH}}`
- `{{DEFAULT_BRANCH}}`
- `{{PROJECT_TYPE}}`
- `{{PRIMARY_LANGUAGE}}`
- `{{VALIDATION_COMMANDS}}`
- `{{FORBIDDEN_PATHS}}`
- `{{DEPLOY_POLICY}}`

Se algum placeholder sobreviver à instalação, corrigir o perfil, o comando `--set` ou o template na origem.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. Passo 5 — Ajustar `+context.json`

O `+context.json` deve declarar:

- identidade do ambiente;
- repo;
- paths permitidos;
- paths proibidos;
- ferramentas permitidas;
- política de secrets;
- política de branch;
- comandos de lint/test/build;
- docs de contexto.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. Passo 6 — Atualizar `AGENTS.md`

`AGENTS.md` deve ser curto o bastante para ser lido sempre e específico o bastante para evitar erro.

Deve conter:

- identidade operacional;
- host canônico;
- branch;
- remote;
- política de ambientes;
- comandos de entrada;
- WSD local;
- paths sensíveis;
- validação.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 9. Passo 7 — Auto-sizing e Fluxo de 4 Fases

Antes de criar specs ou implementar, classificar a tarefa para escolher o fluxo correto.

### Tabela de Auto-sizing

| Risco | Critério | Fluxo | Artefatos |
|---|---|---|---|
| **L0** | ≤3 arquivos, mudança local e reversível | **Quick mode** | `+specs/quick/<slug>.md` + commit |
| **L1** | feature, endpoint, integração, refatoração relevante | **Specify → Execute** | `+specs/features/<slug>/spec.md` + `tasks.md` + commits |
| **L2** | produção, deploy, banco, auth, secrets, dado sensível | **4 fases completas + aprovação humana** | `spec.md` + `design.md` + `tasks.md` + commits + PR |

### As 4 Fases TLC

```text
┌─────────┐    ┌────────┐    ┌───────┐    ┌─────────┐
│ Specify │───▶│ Design │───▶│ Tasks │───▶│ Execute │
└─────────┘    └────────┘    └───────┘    └─────────┘
   WHEN/THEN/    Abordagens     Tasks       RED/GREEN/
   SHALL         e arquitetura  atômicas    VERIFY
```

1. **Specify** (`/wsd-specify`) — clarificar requirements, user stories P1/P2/P3, acceptance criteria WHEN/THEN/SHALL. **HARD-GATE**: nenhum design/tasks/código antes de spec aprovada.
2. **Design** (`/wsd-design`) — abordagens (2–3), arquitetura, componentes, data flow, testing approach. **Pode pular** se feature ≤3 arquivos sem decisão arquitetural.
3. **Tasks** (`/wsd-tasks`) — quebrar em tarefas atômicas com gate level (quick/full/build), dependências, flag `[P]` para paralelas, commit por task.
4. **Execute** — implementar tasks na ordem, atualizar checkboxes, atualizar `STATE.md` quando surgir decisão/bloqueador/lição/ideia adiada.

### Quando pular fases

- **L0 / Quick**: vai direto para `+specs/quick/<slug>.md` com escopo, arquivos, verificação e commit.
- **L1 sem áreas cinzas**: pode pular Design e ir Specify → Tasks → Execute.
- **L2 sempre**: as 4 fases são obrigatórias, com aprovação humana entre Specify e Design.

Detalhes completos em [[wsd/docs/14_qualidade_desenvolvimento|14 — Qualidade de Desenvolvimento]].

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 10. Passo 8 — Criar Primeira Spec

O bootstrap do WSD é L1 quando altera governança do repo.

Usar:

```text
+specs/features/wsd-bootstrap/spec.md
```

Status pode ser `approved` se o operador humano já autorizou o bootstrap.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 11. Passo 9 — Validar

Rodar:

```bash
./+wsd/bin/wsd doctor
./+wsd/bin/wsd check
python3 -m json.tool +context.json
bash scripts/wsd_check.sh --risk L0 .
git diff --check
```

Se houver spec L1:

```bash
bash scripts/wsd_check.sh --risk L1 --spec +specs/features/wsd-bootstrap/spec.md .
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 12. Passo 10 — Promover por PR

Usar branch dedicada:

```bash
git switch -c docs/wsd-bootstrap
git add AGENTS.md +context.json +specs +logs scripts/wsd_check.sh
git commit -m "docs: bootstrap WSD governance"
git push -u origin docs/wsd-bootstrap
gh pr create
```

A mensagem de commit segue **Conventional Commits 1.0.0** (ver [[wsd/docs/07_git_governance|07 — Git Governance]]).

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 13. Passo 11 — Registrar no Vault ou Playbook

Se o repo faz parte da sua VPS, atualizar o playbook de Git correspondente.

Registrar:

- PR;
- merge commit;
- status WSD;
- comando checker;
- specs ativas.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 14. Sincronização Deste Playbook

Ao alterar este playbook, revisar sempre:

- [[wsd/README|README]], se o comando recomendado mudar;
- [[wsd/docs/00_planejamento_instalacao_wsd|00 Planejamento]], se houver alteração de instalador, flags ou modo GitHub;
- [[wsd/docs/08_rotinas_sessao|08 Rotinas]], se os comandos locais mudarem;
- [[wsd/docs/10_matriz_sincronizacao_notas|10 Matriz de Sincronização]], se surgir nova dependência documental;
- `bin/wsd-method.js`, `install.sh` e `package.json`, se a documentação descrever comportamento ainda não implementado.

Rodar:

```bash
bash scripts/wsd_docs_check.sh
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 15. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 05/05/2026 13:29:54 -03 | Codex | `x/wsd/docs/04_playbook_implantacao.md` | Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes. |
| 05/05/2026 14:13:39 -03 | Codex | `x/wsd/docs/04_playbook_implantacao.md` | Atualização do playbook para usar o instalador `wsd-method` como fluxo preferencial, mantendo cópia manual apenas como fallback. |
| 06/05/2026 — | Claude | `x/wsd/docs/04_playbook_implantacao.md` | Inserção do Passo 7 (Auto-sizing + 4 fases TLC), tabela L0/L1/L2 → Quick/Specify+Execute/4 fases, ajuste de paths para `+specs/` e `+logs/`, link para Conventional Commits. |
| 07/05/2026 — | Codex | `x/wsd/docs/04_playbook_implantacao.md` | Planejamento do uso de `--git-policy full` para projetos reais que valorizam GitHub após a `v0.1.10-alpha`. |
| 07/05/2026 — | Codex | `x/wsd/docs/04_playbook_implantacao.md` | Atualização do playbook para `--git-policy full` disponível no instalador. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
