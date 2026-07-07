---
title: "11 — Módulo Git Governance WSD"
created: 05/05/2026
modified: 06/05/2026
tags:
  - x
  - wsd
  - git
  - github
  - modulo
  - governanca
status: ativo
tipo: guia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/docs/00_planejamento_instalacao_wsd]], [[wsd/docs/07_git_governance]], [[wsd/docs/10_matriz_sincronizacao_notas]], [[r.3.4_git_github/r.3.4_git_github]], [[r.3.4_git_github/r.3.4.6_politica_git_para_agentes]], [[r.3.4_git_github/r.3.4.7_politica_de_issues_e_planejamento]], [[r.3.4_git_github/r.3.4.4_topologia_dlp_oct_git]]"
otimizado_para_obsidian: true
---
# 11 — Módulo Git Governance WSD

[[wsd/wsd|← WSD]]

---

> [!abstract] Status
> Módulo implementado no MVP `v0.1.10-alpha`. Esta nota é o **registro de decisão** do módulo git-governance: o que foi implementado, o que foi adiado e por quê. O que está planejado está marcado com `[ ]`; o que foi entregue está com `[x]`.

> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. Decisão]]
3. [[#3. Separação Entre Core e Módulo]]
4. [[#4. Fontes Importadas da Política Git]]
5. [[#5. Princípios a Incorporar]]
6. [[#6. Perguntas do Instalador]]
7. [[#7. Modos de Instalação]]
8. [[#8. Artefatos a Gerar]]
9. [[#9. Campos Novos no `+context.json`]]
10. [[#10. Comandos Locais Planejados]]
11. [[#11. Integração com Agentes]]
12. [[#12. Integração com Issues e PRs]]
13. [[#13. Topologia Multi-Host]]
14. [[#14. Scripts do Módulo]]
15. [[#15. Fase Recomendada de Implementação]]
16. [[#16. Critérios de Aceite]]
17. [[#17. Fora de Escopo Inicial]]
18. [[#18. Sincronização Obrigatória]]

## 1. 🔄 Atualizações

Histórico completo desta nota: `git log --follow -- <arquivo>` e [CHANGELOG.md](../CHANGELOG.md). Seções de histórico manual foram removidas na v0.5.0 (lean-core); conteúdo preservado em `archive/historico_notas_2026H1.md`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. Decisão

O WSD deve manter uma governança Git mínima no core e oferecer um módulo opcional mais completo chamado `git-governance`.

Decisão prática:

```text
WSD core
= spec, risco, sessão, validação, contexto, agentes e segurança Git mínima

WSD git-governance module
= Git/GitHub, branch, issue, PR, remote, gh, auditoria, topologia, bootstrap e playbook por repo
```

O core não deve ficar dependente de GitHub ou `gh`. O módulo `git-governance` pode exigir `gh`, remotes GitHub e política de PR quando o usuário escolher esse nível de rigor.

Decisão de priorização em 07/05/2026:

- implementar `v0.1.10-alpha` antes da estabilização `v0.1.0`;
- entregar um MVP útil para projeto real em andamento;
- priorizar GitHub, branch, Issue, PR, remote, upstream e `gh`;
- adiar `multi-host`, server-side hooks, OPA/Rego e bootstrap administrativo sensível.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. Separação Entre Core e Módulo

O core do WSD deve continuar instalável em projetos simples, inclusive sem GitHub remoto configurado.

Regras mínimas que permanecem no core:

- checar `git status --short --branch` antes de editar;
- não usar `git add .` manualmente; `./+wsd/bin/wsd finish` é a via aprovada para staging/commit após gates;
- não esconder worktree suja;
- exigir spec aprovada para L1/L2;
- registrar validação executada;
- impedir secrets em Git, specs e logs;
- manter branch/PR como recomendação para mudanças relevantes.

Regras avançadas que entram no módulo:

- validar `gh auth status`;
- validar `gh config get git_protocol`;
- preferir remote HTTPS;
- criar ou conectar repositório GitHub;
- padronizar Issue, branch e PR;
- auditar repositórios locais;
- auditar topologia DLP/Oct/GitHub;
- gerar templates de Issue e PR;
- bloquear fluxo quando host canônico não confere;
- registrar playbook Git por projeto.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. Fontes Importadas da Política Git

| Fonte | Princípio reaproveitado |
|---|---|
| [[r.3.4_git_github/r.3.4.0_controle_cli_total_github|r.3.4.0 Controle CLI GitHub]] | operação Git/GitHub por CLI, `gh` autenticado, HTTPS como padrão e redução de dependência do site |
| [[r.3.4_git_github/r.3.4.2_fluxo_operacional_git_github|r.3.4.2 Fluxo Operacional]] | auditoria, bootstrap, criação de repo, PR, `gh repo view`, inventário e sinais de atenção |
| [[r.3.4_git_github/r.3.4.4_topologia_dlp_oct_git|r.3.4.4 Topologia DLP + Oct]] | distinção entre control plane, execution plane, clone de laboratório e histórico compartilhado |
| [[r.3.4_git_github/r.3.4.6_politica_git_para_agentes|r.3.4.6 Política Git para Agentes]] | branch dedicada, commits pequenos, PR, segurança operacional, `pull --ff-only`, proibição de operações destrutivas |
| [[r.3.4_git_github/r.3.4.7_politica_de_issues_e_planejamento|r.3.4.7 Política de Issues]] | Issue como container de contexto, ligação Issue/branch/PR e dispensa apenas para L0 mínimo |
| [[r.3.4_git_github/r.3.4.8_catalogo_de_scripts_git_github|r.3.4.8 Catálogo de Scripts]] | scripts precisam ser descobertos por agentes e documentados quando mudam |
| [[r.3.4_git_github/r.3.4.9_repositorios/r.3.4.9_repositorios|r.3.4.9 Repositórios Operacionais]] | playbook prático por repositório para reduzir leitura inicial e risco de host errado |

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. Princípios a Incorporar

| Política atual | Aplicação no WSD |
|---|---|
| GitHub é histórico compartilhado | `repository.clone_policy.canonical_history = "GitHub"` |
| Máquina operacional correta deve ser respeitada | `environment.canonical_host` e `repository.clone_policy.operational_clone` |
| DLP/Oct/control plane/execution plane | suporte a topologia multi-host no módulo |
| `gh` autenticado e HTTPS preferencial | `wsd git doctor` valida `gh auth status`, protocolo e remote |
| Novos repositórios em `main` | pergunta de branch principal no instalador e warning para legado |
| `master` legado só com decisão registrada | `legacy_branch_allowed` no contexto |
| Issue → branch → PR | política e templates gerados pelo módulo |
| Commits pequenos e intencionais | regra em `AGENTS.md` e template de PR |
| Worktree suja bloqueia ações perigosas | `wsd git preflight` antes de pull, merge, rebase, push e PR |
| Inventário e auditoria | `wsd git audit` e documentação local |
| Playbook por repo | seção Git gerada em `AGENTS.md` e contexto em `+specs/project/PROJECT.md` |

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. Perguntas do Instalador

O instalador deve perguntar:

```text
Deseja instalar o módulo de Governança Git/GitHub?
- não
- básico
- completo
```

Perguntas adicionais quando o módulo for ativado:

- GitHub deve ser pulado, usado como repo existente ou configurado em modo assistido?
- Qual é o owner/repo?
- O remote deve ser HTTPS?
- Qual é a branch principal?
- A branch é legado `master` documentado?
- Mudanças L1/L2 exigem Issue?
- Mudanças relevantes exigem PR?
- Branches devem seguir `issue-<numero>-<slug>`?
- Commits devem seguir Conventional Commits?
- Deve gerar templates de Issue?
- Deve gerar template de PR?
- Qual é o host canônico?
- Existe clone operacional local diferente do caminho atual?

Perguntas de topologia `multi-host`, clone laboratório/auditoria, clone de deploy e criação automática de repo com `gh` ficam fora do MVP `v0.1.10-alpha`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. Modos de Instalação

### `none`

Não instala o módulo. Mantém apenas a segurança Git mínima do WSD core.

Uso:

```bash
wsd-method install --modules core
```

### `basic`

Instala política Git local sem exigir GitHub completo.

Inclui:

- regras de branch;
- regras de commit;
- proteção de worktree suja;
- `wsd git preflight`;
- seção Git em `AGENTS.md`;
- campos `git_governance` no `+context.json`.

### `full`

Instala governança GitHub completa para projeto com repo remoto.

Inclui `basic` mais:

- `gh` opcional/validável;
- remote GitHub;
- política de Issue/PR;
- templates `.github/`;
- `wsd git doctor`;
- `wsd git pr-check`.

### `multi-host`

Instala governança para topologia DLP/Oct/GitHub ou equivalente.

Inclui `full` mais:

- campos de topologia;
- validação de host canônico;
- clone operacional;
- clone auditoria/laboratório;
- clone deploy, quando existir;
- instrução para agentes não confundirem plano de controle com plano operacional.

Status: planejado, mas fora do MVP `v0.1.10-alpha`. O primeiro alpha deve aceitar no máximo `none|basic|full`; `multi-host` fica para alpha posterior.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. Artefatos a Gerar

Estrutura planejada dentro do pacote WSD:

```text
templates/modules/git-governance/
├── README.md
├── git_policy.md
├── issue_policy.md
├── topology_policy.md
├── commands.md
├── .github/
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── ISSUE_TEMPLATE/
│       ├── task.md
│       ├── bug.md
│       └── decision.md
└── scripts/
    ├── wsd_git_doctor.sh
    ├── wsd_git_audit.sh
    ├── wsd_git_preflight.sh
    └── wsd_github_bootstrap.sh
```

Arquivos gerados ou alterados no projeto alvo:

```text
AGENTS.md
+context.json
+specs/project/PROJECT.md
+specs/project/PROJECT.md
.github/PULL_REQUEST_TEMPLATE.md
.github/ISSUE_TEMPLATE/task.md
.github/ISSUE_TEMPLATE/bug.md
.github/ISSUE_TEMPLATE/decision.md
scripts/wsd_git_doctor.sh
scripts/wsd_git_audit.sh
scripts/wsd_git_preflight.sh
scripts/wsd_github_bootstrap.sh
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 9. Campos Novos no `+context.json`

Bloco planejado:

```json
"git_governance": {
  "enabled": true,
  "mode": "full",
  "remote_protocol": "https",
  "github_cli_required": false,
  "default_branch": "main",
  "legacy_branch_allowed": false,
  "issue_policy": "required_for_l1_l2",
  "pr_policy": "required_for_relevant_changes",
  "sync_policy": "pull_ff_only",
  "dirty_worktree_policy": "declare_and_halt_for_risky_ops",
  "branch_naming": "issue-<number>-<slug>",
  "commit_style": "conventional_commits"
}
```

Bloco planejado para topologia:

```json
"clone_topology": {
  "canonical_history": "GitHub",
  "control_plane": "",
  "execution_plane": "",
  "operational_clone": "",
  "audit_lab_clone": "",
  "deploy_clone": "",
  "host_check_policy": "warn_or_halt_by_risk"
}
```

Regra: se `mode = "multi-host"`, `execution_plane` e `operational_clone` devem ser explícitos.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 10. Comandos Locais Planejados

O CLI local deve ganhar namespace Git:

```bash
./+wsd/bin/wsd git doctor
./+wsd/bin/wsd git preflight
./+wsd/bin/wsd git pr-check
```

Funções:

- `git doctor`: valida `git`, branch, remote, upstream, `gh`, protocolo, repo GitHub e contexto;
- `git preflight`: bloqueia operações arriscadas com worktree suja ou host errado;
- `git pr-check`: valida branch dedicada, worktree limpa e commits à frente da base antes de promoção; `origin`/`upstream` ficam como sinalização adicional.

Comandos futuros fora do MVP:

- `git audit`: mostra estado local, dirty state, último commit, remote e fetch dry-run;
- `git bootstrap`: cria/conecta repo GitHub quando autorizado, sem alterar visibilidade, secrets, default branch ou permissões sem decisão explícita.

Quando o módulo estiver ativo, `./+wsd/bin/wsd start` deve chamar `git preflight` em modo informativo. Para L1/L2, o checker deve poder exigir preflight limpo.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 11. Integração com Agentes

Quando instalado, `AGENTS.md` deve declarar:

- modo do módulo Git;
- branch principal;
- remote esperado;
- host canônico;
- topologia de clones;
- política de Issue;
- política de PR;
- comandos Git obrigatórios de entrada;
- comandos proibidos sem decisão explícita;
- como agir em worktree suja;
- como nomear branch e commit.

Skills Codex locais devem reforçar:

- usar `wsd git preflight` no início;
- não abrir PR sem spec/Issue quando a política exigir;
- não sincronizar DLP/Oct sem confirmar host;
- não usar `reset`, `clean`, `stash`, `rebase`, `merge`, `pull` ou force push para esconder estado local.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 12. Integração com Issues e PRs

Política planejada:

- L0 pode usar Task Card ou descrição do pedido;
- L1 deve usar Issue ou spec aprovada;
- L2 deve usar spec aprovada, aprovação humana e rollback;
- PR deve referenciar Issue/spec quando existir;
- PR deve declarar risco, validação e rollback quando aplicável.

Templates planejados:

- `task.md`: trabalho planejado;
- `bug.md`: falha observada;
- `decision.md`: decisão de branch, remote, topologia, visibilidade ou exceção;
- `PULL_REQUEST_TEMPLATE.md`: resumo, escopo, risco, spec/Issue, validação, rollback e pendências.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 13. Topologia Multi-Host

O modo `multi-host` deve generalizar o padrão DLP/Oct/GitHub:

```text
GitHub = histórico compartilhado
Control plane = documentação, auditoria, agentes e laboratório
Execution plane = operação real do projeto
Deploy clone = publicação ou serviço final, quando existir
```

Regras:

- o agente deve declarar em qual host está;
- o agente deve comparar host atual com `canonical_host`;
- se o host não for canônico, a tarefa deve ser tratada como laboratório/auditoria;
- para L1/L2, operar no host canônico ou registrar decisão explícita;
- após merge no GitHub, o clone operacional deve sincronizar com `pull --ff-only`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 14. Scripts do Módulo

Scripts planejados:

| Script | Função |
|---|---|
| `wsd_git_doctor.sh` | validar Git, remote, branch, upstream, `gh`, protocolo e repo GitHub |
| `wsd_git_preflight.sh` | checar estado antes de edição, pull, merge, rebase, push ou PR |
| `wsd_git_audit.sh` | auditar repo atual e produzir resumo legível por agente |
| `wsd_github_bootstrap.sh` | criar/conectar GitHub remoto em modo autorizado |

Regras:

- scripts devem ser gerados dentro do projeto;
- não devem depender de paths da VPS;
- scripts com topologia DLP/Oct devem aceitar configuração via `+context.json`;
- operações destrutivas não entram no primeiro alpha do módulo.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 15. O Que Foi Implementado e O Que Está Planejado

### Implementado no MVP `v0.1.10-alpha`

Objetivo cumprido: tornar GitHub parte explícita do contrato operacional, reduzir risco de agente trabalhar na branch/remote/host errado, criar caminho repetível para PRs com spec/Issue/risco/validação, manter core funcionando sem GitHub.

- [x] `--git-policy none|basic|full` no instalador.
- [x] Campo `git_governance` no `+context.json`.
- [x] Seção Git/GitHub gerada no `AGENTS.md`.
- [x] `./+wsd/bin/wsd git doctor` — valida `git`, branch, remote, upstream, `gh`, protocolo e contexto.
- [x] `./+wsd/bin/wsd git preflight` — bloqueia operações arriscadas com worktree suja.
- [x] `./+wsd/bin/wsd git pr-check` — valida branch dedicada, worktree limpa e commits à frente da base.
- [x] Template `.github/PULL_REQUEST_TEMPLATE.md`.
- [x] Templates de Issue: `task.md`, `bug.md`, `decision.md`.
- [x] Testes de install para `none`, `basic` e `full` (gates 4, 5, 6 do `npm test`).
- [x] Templates do módulo em `templates/modules/git-governance/`.
- [x] Documentação sincronizada: README, hub, ROADMAP, docs/00, docs/03, docs/07, docs/08, docs/10.

### Validação histórica antes da promoção para `v0.1.0` estável

- [x] Testar em projeto real em andamento — concluído antes da estabilização inicial.

### Planejado para versões futuras

- [ ] `wsd git audit` — inspecionar estado local, dirty state, último commit, remote e fetch dry-run.
- [ ] `wsd git bootstrap` — criar/conectar repo GitHub quando autorizado.
- [ ] Modo `multi-host` — topologia DLP/Oct/GitHub com validação de host canônico.
- [ ] Server-side hooks.
- [ ] OPA/Rego para policy-as-code.
- [ ] Operações administrativas GitHub (visibilidade, secrets, branch default, permissões) — fora do escopo por risco.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 16. Critérios de Aceite

O módulo só deve ser considerado pronto quando:

- [x] O instalador aceitar `--git-policy none|basic|full`.
- [x] O modo `none` continuar funcionando sem GitHub.
- [x] O modo `basic` gerar política local sem exigir `gh`.
- [x] O modo `full` validar ou orientar `gh` e GitHub.
- [x] `AGENTS.md` gerado orientar o agente sem depender desta conversa.
- [x] `+context.json` declarar política Git e topologia.
- [x] `./+wsd/bin/wsd git doctor` rodar em instalação temporária.
- [x] `./+wsd/bin/wsd git preflight` detectar worktree suja.
- [x] `./+wsd/bin/wsd git pr-check` validar branch dedicada, worktree limpa e commits à frente da base antes de PR.
- [x] Templates de PR e Issue serem gerados no modo `full`.
- [x] `npm run test:install` continuar passando.
- [x] Novo teste de instalação do módulo Git Governance passar.
- [x] `bash scripts/wsd_self_check.sh` continuar passando.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 17. Fora de Escopo Inicial

Não implementar no primeiro alpha:

- merge automático;
- rebase automático;
- force push;
- delete de branch/tag;
- mudança automática de branch padrão;
- alteração de visibilidade de repo;
- gerenciamento de secrets;
- deploy;
- sincronização remota DLP/Oct autônoma;
- GitHub Actions obrigatório.
- topologia `multi-host` obrigatória.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 18. Sincronização Obrigatória

Ao evoluir este módulo, consultar [[wsd/docs/10_matriz_sincronizacao_notas|10 Matriz de Sincronização]] — ela é a fonte canônica dos grupos de arquivos que devem ser revisados por tipo de mudança.

Resumo dos arquivos de maior impacto:

| Mudança | Arquivos críticos |
|---|---|
| Installer / flags | `bin/wsd-method.js`, `docs/00`, `docs/04` |
| Campos `+context.json` | `templates/repo/+context.json.template`, `docs/05` |
| Regra Git | `docs/07`, `templates/repo/AGENTS.md.template` |
| Comandos CLI locais | `templates/local-wsd/bin/wsd`, `docs/08` |
| Qualquer mudança | `scripts/wsd_docs_check.sh`, `scripts/wsd_self_check.sh` |

[[#📑 Índice|⬆️ Voltar ao Índice]]
