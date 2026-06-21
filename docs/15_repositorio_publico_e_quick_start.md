---
title: "15 — Repositório Público e Quick Start"
created: 11/05/2026
modified: 15/06/2026
tags:
  - x
  - wsd
  - github
  - publico
  - quickstart
  - sincronizacao
status: ativo
tipo: guia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/README]], [[wsd/docs/09_publicacao_github_privado]], [[wsd/docs/10_matriz_sincronizacao_notas]], [[wsd/CHANGELOG]], [[wsd/ROADMAP]]"
otimizado_para_obsidian: true
---
# 15 — Repositório Público e Quick Start

[[wsd/wsd|← WSD]]

---

> [!abstract] Objetivo
> Documentar a estratégia de coexistência entre o contexto privado (desenvolvimento/teste local) e o repositório GitHub público (distribuição), com regras de compatibilidade e workflow de sync.

> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. Situação Atual]]
3. [[#3. Quick Start via GitHub]]
4. [[#4. Estratégia Privado × Público]]
5. [[#5. O Que Vai no Público vs No Privado]]
6. [[#6. Workflow de Sync]]
7. [[#7. Regras de Compatibilidade]]
8. [[#8. Checklist de Release Pública]]
9. [[#9. npm Registry (Opção Futura)]]
10. [[#10. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 11/05/2026 — Claude: Criação do documento. Quick start via GitHub, estratégia privado × público, workflow de sync, regras de compatibilidade e checklist de release pública.
- 12/05/2026 — Claude (Opus 4.7): Adicionada linha de pré-requisito "Obsidian (recomendado)" em 3.1, com explicação da renderização visual de frontmatter/callouts/wikilinks. Refs WSD-006 + decisão D-002 Opção A.
- 30/05/2026 18:15:09 -03 — Codex: Atualização do checklist público para `npm test` com 11 gates, incluindo o novo `test:install-version`.
- 30/05/2026 — Codex: Correção do canal público canônico para `flow31-d/wsdd`, registro de fechamento da `v0.3.1` e ajuste do gate de perfis para validar conteúdo final de `bin/`, `profiles/` e `templates/`.
- 15/06/2026 — Codex: Atualização para `v0.4.0` e `npm test` com 13 gates, incluindo `test:install-loop` e `test:install-codex-adherence`.
- 17/06/2026 — Codex: Atualização para `v0.4.1` com atalhos WSD Loop para Codex/Claude/shell.
- 21/06/2026 — Codex: Atualização para `v0.4.3` e `npm test` com 14 gates, incluindo `test:install-finish-clean`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. Situação Atual

O WSD possui repositório GitHub público em:

```
https://github.com/flow31-d/wsdd
```

O desenvolvimento acontece localmente em `/srv/CLI/+Apps/wsd` (contexto privado). O repositório público é o canal de distribuição — qualquer usuário com Node.js ≥ 20 pode instalar o WSD a partir dele sem nenhuma conta ou registro.

O documento [[wsd/docs/09_publicacao_github_privado|09 — Publicação]] cobre o histórico de publicação e o processo de criação de tags. Este documento (15) cobre a estratégia de manutenção contínua: o que vai para o público, como sincronizar e como garantir que os dois contextos permaneçam compatíveis.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. Quick Start via GitHub

Usuários com Node.js ≥ 20 podem instalar o WSD diretamente do repositório público, sem npm publish e sem criar conta em registry:

```bash
npx github:flow31-d/wsdd install
```

O `npx` baixa o repositório e executa o `bin/wsd-method.js` (entrada definida em `package.json#bin`). A estrutura de diretórios é preservada no download temporário, então `WSD_ROOT = path.resolve(__dirname, '..')` resolve corretamente e encontra `templates/`, `schemas/`, `party-mode/`.

Variações:

```bash
# Com opções explícitas (greenfield)
npx github:flow31-d/wsdd install --tools claude-code --git-policy basic --yes

# Brownfield
npx github:flow31-d/wsdd install --tools both --git-policy full --brownfield --yes

# Versão específica via tag Git
npx github:flow31-d/wsdd#v0.4.3 install
```

### 3.1 Pré-requisitos do usuário

| Requisito | Obrigatório | Uso |
|---|---|---|
| Node.js ≥ 20 | Sim | Executa o installer |
| Git | Recomendado | `--init-git` no projeto-alvo |
| `gh` CLI | Opcional | `--git-policy full` com templates GitHub |
| [Obsidian](https://obsidian.md) | Recomendado | Leitura ótima das notas geradas — frontmatter, callouts (`> [!info]`, `> [!abstract]`) e wikilinks (`[[outra-nota]]`) renderizam visualmente. Sem Obsidian, o conteúdo é legível mas aparece como texto cru |

### 3.2 Limitações do quick start via GitHub

- Versionamento via `#tag` Git (não `@tag` npm) — menos ergonômico mas funcional
- Sem tags automáticas `@latest` ou `@next` — gerenciamento manual
- Requer que o repositório GitHub seja público — se o repo se tornar privado, o quick start quebra

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. Estratégia Privado × Público

```
Privado (local /srv/CLI/+Apps/wsd)
  │
  ├── Desenvolvimento e experimentos
  ├── Perfis de projetos internos (koomplet_office, prescreve_mais, ...)
  ├── +specs/ e STATE operacional do WSD
  ├── +imbox/ (inbox de notas)
  └── Testes completos antes de qualquer push
        │
        ▼  [npm test passa + checklist OK]
Público (github.com/flow31-d/wsdd)
  │
  ├── Core do método (CLI, templates, schemas, party-mode)
  ├── Perfis públicos (generic_node_frontend, generic_python_api, lovable_tanstack_start)
  ├── Documentação pública (README, CHANGELOG, ROADMAP, docs/)
  └── Quick start: npx github:flow31-d/wsdd install
```

**Regra de ouro:** o público é sempre um snapshot testado do privado. Nunca alterar o público sem antes validar localmente. Nunca adicionar ao público o que é específico de projeto interno.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. O Que Vai no Público vs No Privado

### 5.1 Vai para o público (GitHub)

- `bin/wsd-method.js` — somente com perfis públicos (`generic_node_frontend`, `generic_python_api`, `lovable_tanstack_start`)
- `templates/` — todos os templates (genéricos por natureza)
- `schemas/` — schema canônico do `+context.json`
- `party-mode/` — sistema de agentes WSD-aware
- `scripts/` — checkers e git-hooks
- `profiles/` — somente perfis genéricos
- `docs/` — documentação operacional (exceto notas com dados de infraestrutura interna)
- `AGENTS.md`, `README.md`, `CHANGELOG.md`, `ROADMAP.md`, `CONTRIBUTING.md`
- `install.sh`, `package.json`
- `examples/` — somente exemplos com dados fictícios

### 5.2 Fica no privado (local)

- Perfis específicos de projetos internos em `bin/wsd-method.js` (ex: `koomplet_office`, `prescreve_mais`)
- `+specs/` — specs e STATE operacional do WSD (informação de processo interno)
- `+imbox/` — inbox de notas não categorizadas
- `wsd_philo/` — base filosófica/pesquisa (referência histórica, não contrato público)
- Dados de hosts, paths canônicos e topologias de infraestrutura privada

### 5.3 Gate de perfis antes do push

Os perfis internos estão hardcoded no WSD privado. Verificar o conteúdo final do clone público antes de qualquer commit no `wsdd`:

```bash
rg -n 'koomplet|prescreve|flow31-d/koomplet|GitKoomplet/prescreve' bin profiles templates
```

Se retornar algo, avaliar se o dado é sensível. Perfis internos devem ser removidos ou substituídos por dados fictícios antes do push. Não usar `git diff` como único gate, porque linhas removidas aparecem no diff e podem gerar falso positivo.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. Workflow de Sync

### 6.1 Para qualquer push ao público

```bash
# 1. Testar tudo localmente
npm test                          # 14 gates de instalação PASS
bash scripts/wsd_docs_check.sh    # sincronização documental
bash scripts/wsd_self_check.sh    # consistência interna

# 2. Revisar o staging
git diff --staged bin/wsd-method.js | grep -E 'koomplet|prescreve'  # deve ser vazio
rg -n 'API_KEY|SECRET|TOKEN|PRIVATE KEY|BEGIN.*KEY' .               # deve ser vazio

# 3. Commitar com Conventional Commits 1.0.0
git add <arquivos específicos>    # nunca git add -A sem revisar
git commit -m "feat|fix|docs|chore: descrição"

# 4. Push
git push origin main
```

### 6.2 Para releases (versão nova)

```bash
# 1. Executar workflow 6.1 completo
# 2. Bumpar versão
#    - package.json#version
#    - README.md (seção Status)
#    - CHANGELOG.md (nova seção)
#    - ROADMAP.md (itens fechados com [x])
#    - docs/09_publicacao_github_privado.md (versão atual)
#    - esta nota se houver mudança de estratégia

# 3. Confirmar tudo ainda passa
npm test

# 4. Tag e push
git tag v<versão>
git push origin main
git push origin v<versão>

# 5. GitHub Release (versões estáveis)
gh release create v<versão> --title "WSD v<versão>" --notes "$(cat CHANGELOG.md | ...)"
```

### 6.3 Branches

```
feat/<slug>    # nova feature — desenvolver, testar, merge em main, push
fix/<slug>     # bug fix — idem
docs/<slug>    # só documentação — pode ir direto em main se npm test passa
```

Nunca push de branch de feature para o remoto público sem merge em main local com testes passando.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. Regras de Compatibilidade

1. **Público é sempre subset testado do privado.** Nunca feature exclusiva no público que não exista e seja testada no privado.
2. **`npm test` (14 gates) é o gate mínimo** para qualquer push, incluindo docs.
3. **Versão do `package.json` é fonte de verdade.** README, CHANGELOG, docs/09 e esta nota devem citar a mesma versão após qualquer release.
4. **Perfis internos não chegam ao público.** Gate de `git diff --staged` antes de cada commit.
5. **Nenhuma mudança de API sem bump de versão.** Alterações em flags do CLI, schema do `+context.json` ou contrato de templates requerem entrada no CHANGELOG e nova `vX.Y.Z`.
6. **Tags são imutáveis.** Nunca reescrever tag já publicada — criar nova tag corrija com sufixo ou `+1`.
7. **O privado testa primeiro.** Se uma mudança não passou nos 14 gates localmente, não vai para o público, mesmo que pareça trivial.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. Checklist de Release Pública

Antes de `git push` e `git tag`:

- [ ] `npm test` — 14/14 gates PASS
- [ ] `bash scripts/wsd_docs_check.sh` — sem erros
- [ ] `bash scripts/wsd_self_check.sh` — sem erros
- [ ] `package.json#version` atualizado
- [ ] `README.md` reflete a versão e status
- [ ] `CHANGELOG.md` tem seção da nova versão
- [ ] `ROADMAP.md` com itens fechados marcados `[x]`
- [ ] `docs/09_publicacao_github_privado.md` com versão atual e nova tag listada
- [ ] Esta nota atualizada se a estratégia mudou
- [ ] Gate de perfis: `rg -n 'koomplet|prescreve|flow31-d/koomplet|GitKoomplet/prescreve' bin profiles templates` → vazio
- [ ] Gate de secrets: `rg -n 'API_KEY|SECRET|TOKEN|PRIVATE KEY' .` → vazio
- [ ] `.gitignore` está correto e `+specs/`, `+imbox/`, `wsd_philo/` não estão no staging

### 8.1 Registro de Fechamento — `v0.3.1`

- [x] WSD privado publicado em `flow31-d/WSD`, `main` em `158a1e3`.
- [x] Tag privada `v0.3.1` publicada.
- [x] `wsdd` público publicado em `flow31-d/wsdd`, `main` em `f6d92fc`.
- [x] Tag pública `v0.3.1` publicada.
- [x] GitHub Release pública criada: `https://github.com/flow31-d/wsdd/releases/tag/v0.3.1`.
- [x] `npm test` passou no WSD privado e no clone público.
- [x] Payload público revisado sem referências privadas em `bin/`, `profiles/` e `templates/`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 9. npm Registry (Opção Futura)

Se surgir demanda por um comando ainda mais limpo sem o prefixo `github:`:

```bash
npx wsd-method install
```

Para isso, seria necessário:

1. Remover `"private": true` do `package.json`
2. Adicionar campo `"files"` ao `package.json` excluindo `+specs/`, `+imbox/`, `wsd_philo/` e perfis internos
3. `npm publish --access public`

Vantagens sobre GitHub: `@latest` e `@next` automáticos, versionamento semântico limpo, sem dependência do GitHub estar público.

Desvantagem: mais um registry externo para manter; o quick start via GitHub já cobre o caso de uso solo e times pequenos sem overhead adicional.

**Decisão atual (30/05/2026):** manter `"private": true` no pacote e usar `npx github:flow31-d/wsdd` como quick start padrão. npm registry fica como opção futura se houver adoção externa real.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 10. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 11/05/2026 — | Claude | `x/wsd/docs/15_repositorio_publico_e_quick_start.md` | Criação do documento. Quick start via GitHub, estratégia privado × público, workflow de sync, regras de compatibilidade e checklist de release pública. |
| 30/05/2026 18:15:09 -03 | Codex | `+Apps/wsd/docs/15_repositorio_publico_e_quick_start.md` | Atualização do gate público mínimo para 11/11 gates de `npm test`, incluindo version inventory. |
| 15/06/2026 | Codex | `+Apps/wsd/docs/15_repositorio_publico_e_quick_start.md` | Atualização do gate público mínimo para 13/13 gates de `npm test`, incluindo WSD Loop e Codex Adherence Pack. |
| 21/06/2026 | Codex | `+Apps/wsd/docs/15_repositorio_publico_e_quick_start.md` | Atualização do gate público mínimo para 14/14 gates de `npm test`, incluindo finish clean close. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
