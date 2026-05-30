---
title: "09 — Publicação do WSD em GitHub Privado"
created: 05/05/2026
modified: 30/05/2026
tags:
  - x
  - wsd
  - github
  - privado
status: ativo
tipo: guia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/PRIVATE_USE_NOTICE]], [[wsd/README]], [[wsd/CHANGELOG]], [[wsd/docs/10_matriz_sincronizacao_notas]], [[wsd/docs/15_repositorio_publico_e_quick_start]]"
otimizado_para_obsidian: true
---
# 09 — Publicação do WSD em GitHub Privado

[[wsd/wsd|← WSD]]

---


> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. Pré-Flight]]
3. [[#3. Estado Atual do Repositório Fonte]]
4. [[#4. Criar Repositório Privado]]
5. [[#5. Tags e Releases]]
6. [[#6. Política de Evolução]]
7. [[#7. Cuidados]]
8. [[#8. Sincronização de Release]]
9. [[#9. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 05/05/2026 13:29:54 -03 — Codex: Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes.
- 05/05/2026 14:13:39 -03 — Codex: Atualização da nota para refletir o repositório privado existente, versão `v0.1.3-alpha` e sincronização obrigatória de release.
- 07/05/2026 — Claude: Atualização para `v0.1.6-alpha` — ghost spec detector + git hooks no bootstrap. Tags e versão atualizadas.
- 07/05/2026 — Claude: Atualização para `v0.1.7-alpha` — `wsd finish` automatizado (HANDOFF.md + prompts STATE.md). Tags e versão atualizadas.
- 07/05/2026 — Claude: Atualização para `v0.1.8-alpha` — instalação interativa rica, `wsd update` real, WHEN+THEN+SHALL completo. Tags e versão atualizadas.
- 07/05/2026 — Codex: Atualização para `v0.1.9-alpha` — saneamento documental operacional. Tags e versão atualizadas.
- 07/05/2026 — Codex: Atualização para `v0.1.10-alpha` — MVP Git/GitHub Governance. Tags e versão atualizadas.
- 07/05/2026 — Claude: Atualização para `v0.1.11-alpha` — Party Mode Integration (slash command, subcomando `wsd party`, AGENTS.md, gate de teste). Tags e versão atualizadas.
- 07/05/2026 — Claude: Release **`v0.1.0`** estável — Fase 4 concluída. Versão atual e tag de exemplo atualizadas. Lista de tags alpha consolidada como histórico.
- 13/05/2026 — Claude (Opus 4.7): Atualização para `v0.3.0` (minor — reforço do contrato operacional WSD): versão atual atualizada para `v0.3.0`; nova entrada na lista de Release estável (`v0.3.0` minor com `wsd_check.sh` reescrito, `+context.json` com blocos formais, artefatos `+specs/project/` preenchidos, `REVIEW_PRE_V1.md` + `docs/18` manual leigo).
- 11/05/2026 — Claude: Adição de link para `docs/15_repositorio_publico_e_quick_start.md` — novo documento de estratégia privado × público e quick start via GitHub.
- 30/05/2026 18:15:09 -03 — Codex: Atualização para `v0.3.1` (patch — inventário de versão WSD por projeto): versão atual atualizada e release estável adicionada com `wsd version`, inventário multi-repo e saída JSON.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. Pré-Flight

Antes de subir:

```bash
cd /srv/CLI/+Apps/wsd
bash scripts/wsd_self_check.sh
rg -n 'API[_]KEY|SEC[R]ET|TOK[E]N|PASS[W]ORD|PRIVA[T]E KEY|BEGI[N] .*KEY|s[k]-' .
```

Confirmar:

- nenhum segredo;
- placeholders preservados;
- JSON válido;
- scripts executáveis;
- README atualizado;
- `.gitignore` presente.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. Estado Atual do Repositório Fonte

Repositório privado atual:

```text
https://github.com/flow31-d/WSD
```

Branch principal:

```text
main
```

Versão atual do pacote:

```text
v0.3.1
```

Tags alpha já usadas:

- `v0.1.0-alpha`: documentação e templates iniciais;
- `v0.1.1-alpha`: instalador local e suporte Codex;
- `v0.1.2-alpha`: matriz/checker de sincronização documental;
- `v0.1.3-alpha`: suporte operacional ao Claude Code;
- `v0.1.4-alpha`: integração TLC Spec-Driven (auto-sizing, STATE.md/HANDOFF.md, WHEN/THEN/SHALL, TESTING.md tiered, Conventional Commits, `--brownfield`);
- `v0.1.5-alpha`: JSON Schema 2020-12 para `+context.json` (`schemas/context.schema.json`) + validador zero-deps `wsd-validate-context.js` integrado a `wsd_check.sh`;
- `v0.1.6-alpha`: ghost spec detector em `wsd_check.sh` + git hooks no bootstrap (`pre-commit`, `commit-msg`, `pre-push`) instalados pelo `wsd-method install`. Subcomando `wsd hooks` para reinstalar. Flag `--no-git-hooks` para opt-out.
- `v0.1.7-alpha`: `wsd finish` automatizado — gera `+specs/HANDOFF.md` + prompts interativos para STATE.md (lições, decisões, bloqueadores). Fecha o último item da Fase 3.
- `v0.1.8-alpha`: instalação interativa rica (linguagem, path, test/build/lint, forbidden_paths), `wsd update` real via `wsd_source`, WHEN+THEN+SHALL todos obrigatórios no ghost scan e L1/L2.
- `v0.1.9-alpha`: saneamento documental operacional (`docs/00`, `docs/12`, README, hub, ROADMAP, CHANGELOG, STATE), com `wsd_philo/` preservado como referência histórica/pesquisa.
- `v0.1.10-alpha`: MVP Git/GitHub Governance (`--git-policy none|basic|full`, `git_governance`, `wsd git doctor|preflight|pr-check`, templates PR/Issue e testes por modo).
- `v0.1.11-alpha`: Party Mode Integration — `installPartyMode` (26 agentes em `+wsd/party-mode/`), comando Claude Code `/wsd-party-mode`, subcomando `wsd party status|list-agents|when-to-use`, seção `## Party Mode` no `AGENTS.md` gerado e `test:install-party-mode` no pipeline `npm test` (7/7 PASS). Fase 3.5 fechada.

Release estável:

- **`v0.1.0`** (07/05/2026): primeira release estável. Consolida toda a série alpha em API estável após validação operacional brownfield e fechamento de todas as fases (1, 2, 3, 3.5, 4). Sem mudanças de API vs `v0.1.11-alpha`. Documentação oficial em README seção "Uso Oficial". Modo de manutenção: `v0.1.x` para bug fixes, `v0.2.0` para novas features grandes após piloto.
- **`v0.1.1` → `v0.1.4`** (08–12/05/2026): patches pós-`v0.1.0` — bug fixes, sync `wsdd` público, CJS/ESM fix (`.cjs`), `RELEASING.md`, spec retroativa `project-snapshot`, hotfix WSD-001 (templates faltantes no `wsdd` público).
- **`v0.2.0`** (13/05/2026): primeiro minor pós-`v0.1.0`, marco "estável adotável". 8 features funcionais + UX polish do install interativo (WSD-002, WSD-003, WSD-004 L0+L1, WSD-006, WSD-007, WSD-009, WSD-010, WSD-013). Resolve D-001 (Opção B+) e D-002 (Opção A). 9/9 npm test + 27/27 e2e + piloto operacional `flow31-d/worc`.
- **`v0.2.1`** (13/05/2026): patch cosmético — `wsd update` agora monta a lista "Refreshed: +wsd/{...}" dinamicamente a partir de `config.modules`, refletindo módulos efetivamente copiados. Sem mudança de comportamento. Detectado durante validação do piloto worc logo após v0.2.0.
- **`v0.3.0`** (13/05/2026): minor — reforço do contrato operacional WSD. `scripts/wsd_check.sh` reescrito (185 linhas) valida as 6 notas obrigatórias de `+specs/project/` como L0-required (PROJECT/STATE/ROADMAP/IDEAS/IDEAS_PIPELINE/CONCERNS) — antes só `STATE.md` era checada, gap que permitiu WSD-001 escapar. `+context.json` ganha blocos formais (`environment`, `repository` com `clone_policy` canônico, `permissions` com write/forbidden paths/tool_allowlist/secrets_policy/limites, `workflow` com approval_mode/branch_policy/incident_mode/issue_policy/production_mutation_policy). Artefatos `+specs/project/` preenchidos com conteúdo real do WSD. Templates instaláveis (`templates/local-wsd/bin/wsd-snapshot.cjs` +81, `templates/repo/scripts/wsd_check.sh` +45) propagam mudanças para projetos cliente. Inclui `REVIEW_PRE_V1.md` (1131 linhas, tracker formal pré-v1) e `docs/18_manual_leigo_comandos_wsdd.md` (568 linhas, manual leigo dos comandos `wsdd`). Path rename `+Apps/WSD` → `+Apps/wsd` consolidado (PR #33). 9/9 npm test PASS.
- **`v0.3.1`** (30/05/2026): patch — inventário de versão WSD por projeto. `./+wsd/bin/wsd version` lê `+wsd/config.json`, mostra versão instalada, data, fonte, versão da fonte e status de alinhamento. `--inventory --path <dir>` varre múltiplos projetos com WSD aplicado; `--json` expõe saída estruturada para automações. `npm test` inclui `test:install-version`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. Criar Repositório Privado

Esta seção vale para recriar o WSD em outro namespace ou publicar um pacote derivado. O repositório fonte atual já existe.

Exemplo:

```bash
gh repo create WSD --private --source=. --remote=origin --push
```

Ou manual:

```bash
git init
git add .
git commit -m "docs: initial WSD toolkit"
git branch -M main
git remote add origin https://github.com/<usuario-ou-org>/WSD.git
git push -u origin main
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. Tags e Releases

Formato alpha:

```bash
git tag v0.1.0
git push origin v0.1.0
```

Antes de tag/release, confirmar que `package.json`, README, CHANGELOG, ROADMAP e esta nota citam a mesma versão.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. Política de Evolução

Usar branches:

```text
docs/<slug>
feat/<slug>
fix/<slug>
```

Versões sugeridas:

- `v0.1.x`: ajustes de documentação e templates;
- `v0.2.x`: bootstrap automatizado;
- `v0.3.x`: skills instaláveis;
- `v1.0.0`: contrato estável.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. Cuidados

Mesmo privado, tratar o repositório como se pudesse vazar no futuro.

Não commitar:

- `.env`;
- chaves;
- secrets;
- dados de clientes;
- logs reais sensíveis;
- paths internos que não sejam necessários para exemplo.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. Sincronização de Release

> [!tip] Quick Start
> Usuários podem instalar o WSD diretamente do repositório público sem nenhuma configuração adicional: `npx github:flow31-d/WSD install`. O fluxo completo de distribuição — incluindo regras de compatibilidade privado × público, checklist de release e separação de conteúdo — está em [[wsd/docs/15_repositorio_publico_e_quick_start|15 — Repositório Público e Quick Start]].

Toda release/tag do WSD deve revisar:

- `package.json`;
- [[wsd/README|README]];
- [[wsd/CHANGELOG|CHANGELOG]];
- [[wsd/ROADMAP|ROADMAP]];
- esta nota;
- GitHub release/tag;
- [[wsd/docs/10_matriz_sincronizacao_notas|10 Matriz de Sincronização]], se o release alterar regra documental.

Rodar antes de publicar:

```bash
bash scripts/wsd_docs_check.sh
bash scripts/wsd_self_check.sh
npm run test:install
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 9. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 05/05/2026 13:29:54 -03 | Codex | `x/wsd/docs/09_publicacao_github_privado.md` | Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes. |
| 05/05/2026 14:13:39 -03 | Codex | `x/wsd/docs/09_publicacao_github_privado.md` | Atualização da nota para refletir o repositório privado existente, versão `v0.1.3-alpha` e sincronização obrigatória de release. |
| 07/05/2026 — | Claude | `x/wsd/docs/09_publicacao_github_privado.md` | Atualização para `v0.1.6-alpha`: versão atual, tag de exemplo e lista de tags alpha atualizada. |
| 07/05/2026 — | Claude | `x/wsd/docs/09_publicacao_github_privado.md` | Atualização para `v0.1.7-alpha`: versão atual, tag de exemplo e lista de tags alpha atualizada. |
| 07/05/2026 — | Claude | `x/wsd/docs/09_publicacao_github_privado.md` | Atualização para `v0.1.8-alpha`: versão atual, tag de exemplo e lista de tags alpha atualizada. |
| 07/05/2026 — | Codex | `x/wsd/docs/09_publicacao_github_privado.md` | Atualização para `v0.1.9-alpha`: versão atual, tag de exemplo e lista de tags alpha atualizada. |
| 07/05/2026 — | Codex | `x/wsd/docs/09_publicacao_github_privado.md` | Atualização para `v0.1.10-alpha`: versão atual, tag de exemplo e lista de tags alpha atualizada. |
| 07/05/2026 — | Claude | `x/wsd/docs/09_publicacao_github_privado.md` | Atualização para `v0.1.11-alpha`: versão atual, tag de exemplo e lista de tags alpha atualizada com Party Mode Integration. |
| 07/05/2026 — | Claude | `x/wsd/docs/09_publicacao_github_privado.md` | Release **`v0.1.0`** estável: versão atual, tag de exemplo e seção de release estável adicionadas. Lista de tags alpha mantida como histórico. |
| 30/05/2026 18:15:09 -03 | Codex | `+Apps/wsd/docs/09_publicacao_github_privado.md` | Atualização para `v0.3.1`: versão atual e histórico de releases passam a registrar `wsd version` e inventário multi-repo. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
