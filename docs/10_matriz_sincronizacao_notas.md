---
title: "10 — Matriz de Sincronização de Notas WSD"
created: 05/05/2026
modified: 15/06/2026
tags:
  - x
  - wsd
  - sincronizacao
  - documentacao
  - agentes
status: ativo
tipo: guia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/README]], [[wsd/ROADMAP]], [[wsd/AGENTS]], [[wsd/CHANGELOG]], [[wsd/docs/04_playbook_implantacao]], [[wsd/docs/08_rotinas_sessao]], [[wsd/docs/09_publicacao_github_privado]], [[wsd/docs/11_modulo_git_governance]], [[wsd/docs/12_avaliacao_critica]], [[wsd/docs/13_compatibilidade_claude_code]], [[wsd/docs/15_repositorio_publico_e_quick_start]], [[wsd/docs/19_wsd_loop_automacao_inteligente]]"
otimizado_para_obsidian: true
---
# 10 — Matriz de Sincronização de Notas WSD

[[wsd/wsd|← WSD]]

---

> [!abstract] Objetivo
> Impedir que o WSD evolua em um arquivo e fique desatualizado em outro. Todo agente que editar documentação, instalador, templates, skills, perfis ou release do WSD deve consultar esta matriz antes de finalizar.

> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. Regra Central]]
3. [[#3. Fontes de Verdade]]
4. [[#4. Matriz Obrigatória de Sincronização]]
5. [[#5. Grupos Mínimos de Atualização]]
6. [[#6. Checklist Para Agentes]]
7. [[#7. Validação Automatizada]]
8. [[#8. Regras de Registro em Notas]]
9. [[#9. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 05/05/2026 14:13:39 -03 — Codex: Criação da matriz obrigatória de sincronização para manter README, hub, roadmap, changelog, docs operacionais, scripts e templates alinhados.
- 05/05/2026 14:38:29 -03 — Codex: Inclusão do módulo `git-governance` como fonte de verdade para evolução opcional da política Git no WSD.
- 06/05/2026 11:31:14 -03 — Codex: Inclusão da nota `12 — Avaliação Crítica` como documento de acompanhamento que precisa permanecer coerente com hub, roadmap e regras de foco do método.
- 06/05/2026 11:52:30 -03 — Codex: Inclusão da nota `13 — Compatibilidade WSD com Claude Code` como documento de referência para a evolução do suporte Claude.
- 06/05/2026 12:50:21 -03 — Codex: Padronização do roadmap para usar `- [ ]` e `- [x]` em listas controláveis de acompanhamento.
- 06/05/2026 14:41:06 -03 — Codex: Inclusão das notas `00`, `11`, `12` e `13` como documentos com listas controláveis padronizadas por checkbox.
- 06/05/2026 — Claude: Adição de `templates/claude-commands/` às linhas de sincronização de rotinas e regras para agentes; nova linha para o diretório `claude-commands/**`.
- 07/05/2026 — Claude: Inclusão do schema canônico `schemas/context.schema.json` e do validador `templates/local-wsd/bin/wsd-validate-context.js` na matriz (v0.1.5-alpha).
- 07/05/2026 — Claude: Inclusão de `templates/git-hooks/` em "Fontes de Verdade" e "Matriz Obrigatória" (v0.1.6-alpha).
- 07/05/2026 — Codex: Expansão da matriz para o MVP Git/GitHub Governance planejado na v0.1.10-alpha.
- 07/05/2026 — Codex: Marcação do MVP Git/GitHub Governance como implementado e inclusão de testes/checkers como validação obrigatória do módulo.
- 11/05/2026 — Claude: Adição de `docs/15_repositorio_publico_e_quick_start.md` como nova fonte de verdade para estratégia privado × público, quick start via GitHub e compatibilidade de release.
- 30/05/2026 18:15:09 -03 — Codex: Atualização do gate público mínimo de `npm test` de 7 para 11 gates após inclusão de `test:install-version`.
- 15/06/2026 — Codex: Inclusão de `docs/19_wsd_loop_automacao_inteligente.md`, `templates/local-wsd/loop/` e `automation.loop` na matriz de sincronização da v0.4.0.
- 17/06/2026 — Codex: Inclusão de `templates/codex-prompts/`, `.agents/skills` e atalhos WSD Loop na matriz de sincronização da v0.4.1.
- 15/06/2026 — Codex: Inclusão do Codex Adherence Pack (`WSD Codex Bootstrap`, `codex-prompt`, `codex`, `start --brief`) na matriz de sincronização.
- 21/06/2026 — Codex: Inclusão de `CONCERNS_PIPELINE.md`, `wsd-concern` e `/concern-{PROJECT_SLUG}` na matriz de sincronização da v0.4.2.
- 21/06/2026 — Codex: Inclusão do contrato de finish limpo (`wsd finish`) na matriz de sincronização da v0.4.3.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. Regra Central

Nenhuma alteração relevante no WSD deve ser feita em apenas um arquivo quando ela afeta mais de uma camada.

Antes de finalizar, o agente deve responder:

- o que mudou: versão, instalador, regra, template, skill, perfil, release ou exemplo;
- qual nota é a fonte de verdade daquele tema;
- quais notas derivadas precisam ser atualizadas;
- qual script ou template precisa refletir a mesma decisão;
- qual validação prova que a documentação não ficou divergente.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. Fontes de Verdade

| Tema | Fonte principal | Arquivos derivados que devem acompanhar |
|---|---|---|
| Visão geral e uso rápido | [[wsd/README|README]] | [[wsd/wsd]], [[wsd/ROADMAP]], [[wsd/CHANGELOG]] |
| Mapa do método | [[wsd/wsd|Hub WSD]] | README, AGENTS, docs novas |
| Planejamento e fases | [[wsd/ROADMAP|Roadmap]] | README, CHANGELOG, docs de implantação |
| Instalação e CLI | [[wsd/docs/00_planejamento_instalacao_wsd|00 Planejamento]], [[wsd/docs/04_playbook_implantacao|04 Playbook]] | `bin/wsd-method.js`, `install.sh`, `package.json`, README |
| Rotinas de sessão | [[wsd/docs/08_rotinas_sessao|08 Rotinas]] | `templates/local-wsd/bin/wsd`, `templates/codex-skills/`, `templates/codex-prompts/`, `templates/claude-commands/`, `templates/repo/AGENTS.md.template` |
| Contrato dos artefatos | [[wsd/docs/05_contrato_artefatos|05 Contrato]] | `templates/repo/`, `scripts/wsd_check.sh`, `scripts/wsd_self_check.sh`, `schemas/context.schema.json`, `templates/local-wsd/bin/wsd-validate-context.js` |
| Git e PR | [[wsd/docs/07_git_governance|07 Git Governance]] | AGENTS, templates de spec/PR, README quando alterar fluxo público |
| Git hooks no bootstrap | `templates/git-hooks/` | `bin/wsd-method.js`, `templates/local-wsd/bin/wsd`, `templates/repo/AGENTS.md.template`, `docs/07_git_governance.md`, `scripts/wsd_self_check.sh`, `scripts/wsd_docs_check.sh` |
| Módulo Git Governance | [[wsd/docs/11_modulo_git_governance|11 Módulo Git Governance]] | docs/00, docs/03, docs/04, docs/05, docs/07, docs/08, README, hub, ROADMAP, `bin/wsd-method.js`, `templates/repo/`, `templates/modules/`, `templates/local-wsd/`, scripts do módulo |
| Avaliação crítica do método | [[wsd/docs/12_avaliacao_critica|12 Avaliação Crítica]] | wsd.md, ROADMAP, README quando a conclusão de uso mudar, esta matriz |
| Personalização por projeto | [[wsd/docs/06_personalizacao_por_projeto|06 Personalização]] | `profiles/`, `examples/`, README se perfil virar oficial |
| Publicação e versões | [[wsd/docs/09_publicacao_github_privado|09 Publicação]], [[wsd/CHANGELOG|CHANGELOG]] | `package.json`, README, ROADMAP, Git tags/releases |
| Estratégia público × privado e quick start | [[wsd/docs/15_repositorio_publico_e_quick_start|15 Repositório Público e Quick Start]] | docs/09, README (quick start), `package.json` se mudar política npm, STATE se houver decisão nova |
| Automação inteligente WSD Loop | [[wsd/docs/19_wsd_loop_automacao_inteligente|19 WSD Loop]] | README, wsd.md, ROADMAP, CHANGELOG, docs/08, docs/05, `templates/local-wsd/bin/wsd`, `templates/local-wsd/loop/`, `bin/wsd-method.js`, `schemas/context.schema.json`, `package.json`, `+specs/project/IDEAS.md` |
| Aderência Codex | [[wsd/docs/19_wsd_loop_automacao_inteligente|19 WSD Loop]], [[wsd/docs/08_rotinas_sessao|08 Rotinas]] | README, wsd.md, ROADMAP, CHANGELOG, AGENTS, `templates/repo/AGENTS.md.template`, `templates/local-wsd/bin/wsd`, `.agents/skills`, `templates/codex-skills/`, `templates/codex-prompts/`, `package.json`, scripts de validação |
| Regras para agentes | [[wsd/AGENTS|AGENTS]] | `templates/codex-skills/`, `templates/claude-commands/`, `templates/repo/AGENTS.md.template`, esta matriz |
| Política de contribuição | `CONTRIBUTING.md` (raiz) | AGENTS, docs/07 (Git policy), docs/09 (releases), `+specs/project/STATE.md` quando lições novas surgirem |

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. Matriz Obrigatória de Sincronização

| Se o agente alterar | Deve revisar e, se necessário, atualizar |
|---|---|
| `package.json` `version` | README, CHANGELOG, ROADMAP, docs/09, release/tag Git |
| `bin/wsd-method.js` | README, docs/00, docs/04, docs/08, CHANGELOG, scripts de validação |
| `install.sh` | README, docs/04, docs/09, CHANGELOG |
| `templates/local-wsd/bin/wsd` | docs/08, README, CHANGELOG, templates Codex relacionados |
| `templates/local-wsd/loop/` | docs/19, docs/08, README, CHANGELOG, `bin/wsd-method.js`, `scripts/wsd_self_check.sh` |
| `wsd codex-prompt`, `wsd codex` ou `start --brief` | docs/19, docs/08, README, wsd.md, CHANGELOG, `templates/repo/AGENTS.md.template`, `scripts/test_install_codex_adherence.sh`, `scripts/wsd_self_check.sh`, `scripts/wsd_docs_check.sh` |
| `templates/codex-skills/*/SKILL.md` | docs/08, AGENTS, templates/repo/AGENTS.md.template |
| `templates/claude-commands/**` | docs/08, AGENTS, templates/repo/AGENTS.md.template, bin/wsd-method.js, CHANGELOG |
| `templates/repo/AGENTS.md.template` | AGENTS, docs/05, docs/07, docs/08 |
| `templates/repo/+context.json.template` | docs/05, docs/06, profiles, scripts/wsd_check.sh, `schemas/context.schema.json`, `templates/local-wsd/bin/wsd-validate-context.js` |
| `schemas/context.schema.json` | docs/05, `templates/repo/+context.json.template`, `templates/local-wsd/bin/wsd-validate-context.js`, `scripts/wsd_self_check.sh`, profiles relevantes |
| `automation.loop` em `+context.json` | docs/19, docs/05, README, `templates/repo/+context.json.template`, `schemas/context.schema.json`, `templates/local-wsd/bin/wsd`, `bin/wsd-method.js` |
| `automation.loop.auto_use` | docs/19, docs/08, docs/05, README, CHANGELOG, `templates/repo/AGENTS.md.template`, `templates/local-wsd/bin/wsd`, `schemas/context.schema.json`, testes `test_install_loop.sh` e `test_install_codex_adherence.sh` |
| `templates/git-hooks/` | docs/07, `bin/wsd-method.js`, `templates/local-wsd/bin/wsd`, `templates/repo/AGENTS.md.template`, `scripts/wsd_self_check.sh`, `scripts/wsd_docs_check.sh` |
| `+specs` ou templates de spec | docs/02, docs/03, docs/05, docs/07 |
| `profiles/*.profile.yaml` | docs/06, README se perfil for recomendado, examples relacionados |
| `examples/*.md` | docs/06, ROADMAP se o exemplo for piloto de fase |
| docs novas em `docs/` | wsd.md, README se forem entrada pública, esta matriz se forem fonte de verdade |
| `docs/12_avaliacao_critica.md` | wsd.md, ROADMAP, esta matriz, README se a avaliação alterar a posição pública do WSD |
| `docs/13_compatibilidade_claude_code.md` | wsd.md, README, esta matriz, AGENTS se mudar o runtime Claude |
| listas controláveis em docs/00, docs/11, docs/12 e docs/13 | esta matriz, ROADMAP, README se a convenção virar padrão público do método |
| roadmap com checkboxes | ROADMAP, esta matriz, README se a convenção virar padrão público do método |
| política Git | AGENTS, docs/03, docs/07, templates/repo/AGENTS.md.template, `CONTRIBUTING.md` (raiz) |
| `CONTRIBUTING.md` (raiz) | AGENTS (link), docs/10 (esta matriz), `+specs/project/STATE.md` se decisão estrutural de fluxo mudar |
| módulo `git-governance` | README, wsd.md, ROADMAP, docs/00, docs/03, docs/04, docs/05, docs/07, docs/08, docs/11, templates/repo, templates/modules, templates/local-wsd/bin/wsd, bin/wsd-method.js, scripts/wsd_docs_check.sh |
| política de sessão | docs/03, docs/08, `templates/local-wsd/bin/wsd`, skills Codex |
| publicação GitHub | docs/09, docs/15, README, CHANGELOG, package version, tags/releases |
| estratégia público × privado (separação de conteúdo, perfis, workflow) | docs/15, STATE.md (decisão), docs/09 (link), esta matriz |
| WSD Loop / automação iterativa | docs/19, docs/08, docs/05, README, wsd.md, ROADMAP, CHANGELOG, `+specs/features/wsd-loop/`, `+specs/project/IDEAS.md`, `templates/local-wsd/bin/wsd`, `templates/local-wsd/loop/`, `bin/wsd-method.js`, `package.json`, scripts de validação |
| Concerns / preocupações ativas | docs/05, docs/08, docs/10, README, wsd.md, ROADMAP, CHANGELOG, `+specs/project/CONCERNS.md`, `+specs/project/CONCERNS_PIPELINE.md`, `templates/repo/+specs/project/CONCERNS*.md.template`, `templates/codex-skills/wsd-concern/`, `templates/claude-commands/commands/wsd-concern.md`, `templates/repo/AGENTS.md.template`, `bin/wsd-method.js`, `templates/local-wsd/bin/wsd`, `templates/local-wsd/bin/wsd-snapshot.cjs`, `package.json`, scripts de validação |
| `wsd finish` / fechamento limpo | docs/05, docs/08, docs/10, docs/13, docs/18, README, wsd.md, ROADMAP, CHANGELOG, `templates/local-wsd/bin/wsd`, `templates/codex-skills/wsd-finish/SKILL.md`, `templates/claude-commands/commands/wsd-finish.md`, `templates/repo/AGENTS.md.template`, `package.json`, `scripts/test_install_finish_clean.sh`, `scripts/wsd_self_check.sh`, `scripts/wsd_docs_check.sh` |

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. Grupos Mínimos de Atualização

Quando a mudança for de versão ou release, atualizar no mínimo:

- `package.json`;
- `README.md`;
- `CHANGELOG.md`;
- `ROADMAP.md`;
- `docs/09_publicacao_github_privado.md`.

Quando for push para o repositório público, executar o checklist de `docs/15_repositorio_publico_e_quick_start.md` seção 8 — inclui os 14 gates de `npm test`, verificação de perfis privados e gate de secrets.

Quando a mudança for de instalação ou uso, atualizar no mínimo:

- `README.md`;
- `docs/00_planejamento_instalacao_wsd.md`;
- `docs/04_playbook_implantacao.md`;
- `docs/08_rotinas_sessao.md`;
- `CHANGELOG.md`.

Quando a mudança for no WSD Loop, atualizar no mínimo:

- `docs/19_wsd_loop_automacao_inteligente.md`;
- `docs/08_rotinas_sessao.md`;
- `docs/05_contrato_artefatos.md`;
- `README.md`, `wsd.md`, `ROADMAP.md` e `CHANGELOG.md`;
- `templates/local-wsd/bin/wsd`;
- `templates/local-wsd/loop/`;
- `templates/repo/+context.json.template`;
- `schemas/context.schema.json`;
- `bin/wsd-method.js`;
- `package.json` e checkers.

Quando a mudança for no Codex Adherence Pack, atualizar no mínimo:

- `docs/19_wsd_loop_automacao_inteligente.md`;
- `docs/08_rotinas_sessao.md`;
- `README.md`, `wsd.md`, `ROADMAP.md` e `CHANGELOG.md`;
- `AGENTS.md` e `templates/repo/AGENTS.md.template`;
- `templates/local-wsd/bin/wsd`;
- `scripts/test_install_codex_adherence.sh`;
- `package.json` e checkers.

Quando a mudança for de regra para agentes, atualizar no mínimo:

- `AGENTS.md`;
- `docs/01_constituicao.md` se a regra for permanente;
- `docs/03_ciclo_operacional.md` se afetar fluxo;
- `docs/07_git_governance.md` se afetar Git;
- `templates/repo/AGENTS.md.template`;
- `templates/codex-skills/wsd/SKILL.md`.

Quando a mudança for no módulo Git/GitHub Governance, atualizar no mínimo:

- `docs/11_modulo_git_governance.md`;
- `docs/07_git_governance.md`;
- `docs/03_ciclo_operacional.md`;
- `docs/08_rotinas_sessao.md`;
- `docs/00_planejamento_instalacao_wsd.md`;
- `README.md`, `wsd.md` e `ROADMAP.md`;
- `templates/repo/+context.json.template`;
- `templates/repo/AGENTS.md.template`;
- `templates/local-wsd/bin/wsd`;
- `bin/wsd-method.js`;
- testes e checkers quando o comportamento for implementado.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. Checklist Para Agentes

Antes de commit ou PR, o agente deve:

1. Ler esta matriz quando mexer em docs, scripts, templates, profiles, skills, release ou package.
2. Atualizar as seções `## 1. 🔄 Atualizações` das notas alteradas.
3. Atualizar as tabelas `🕒 Registro de Alterações por Agentes` das notas alteradas.
4. Confirmar que `README.md`, `wsd.md` e `ROADMAP.md` contam a mesma história.
5. Confirmar que links de skills apontam para `SKILL.md`, não para arquivos antigos inexistentes.
6. Confirmar que `wsd.md`, `ROADMAP.md` e `docs/12_avaliacao_critica.md` continuam coerentes entre si quando a avaliação mudar.
7. Confirmar que `wsd.md`, `README.md` e `docs/13_compatibilidade_claude_code.md` continuam coerentes quando o suporte Claude mudar.
8. Confirmar que listas controláveis do `ROADMAP.md` usam `- [ ]` e `- [x]` para pendências e concluídos.
9. Confirmar que `docs/00_planejamento_instalacao_wsd.md`, `docs/11_modulo_git_governance.md`, `docs/12_avaliacao_critica.md` e `docs/13_compatibilidade_claude_code.md` usam checkbox nas listas controláveis.
10. Rodar `bash scripts/wsd_docs_check.sh`.
11. Rodar `bash scripts/wsd_self_check.sh`.
12. Rodar um teste de instalação quando a mudança afetar instalador, templates ou scripts.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. Validação Automatizada

O WSD possui validação documental:

```bash
bash scripts/wsd_docs_check.sh
```

O self-check do pacote também deve chamar esse checker:

```bash
bash scripts/wsd_self_check.sh
```

O objetivo do checker não é substituir revisão humana. Ele serve para bloquear desalinhamentos óbvios:

- versão atual ausente em notas centrais;
- links antigos para arquivos de skill inexistentes;
- README sem instalador atual;
- hub sem link para matriz de sincronização;
- pacote sem script de teste de instalação funcional.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. Regras de Registro em Notas

Toda nota WSD otimizada para Obsidian deve manter:

- frontmatter com `otimizado_para_obsidian: true`;
- índice literal;
- seção `## 1. 🔄 Atualizações`;
- seção final `🕒 Registro de Alterações por Agentes`.

Ao editar uma nota, registrar a data e hora local da VPS no formato:

```text
DD/MM/AAAA HH:MM:SS -03 — Agente: resumo objetivo
```

Se criar uma nota nova, atualizar:

- `wsd.md`;
- o `links:` do frontmatter do hub quando aplicável;
- esta matriz, se a nova nota virar fonte de verdade ou documento derivado obrigatório.

Se mover ou renomear `.md`, usar `/usr/local/bin/obsidian`; nunca `mv` ou `rename`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 9. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 05/05/2026 14:13:39 -03 | Codex | `x/wsd/docs/10_matriz_sincronizacao_notas.md` | Criação da matriz obrigatória de sincronização para manter README, hub, roadmap, changelog, docs operacionais, scripts e templates alinhados. |
| 05/05/2026 14:38:29 -03 | Codex | `x/wsd/docs/10_matriz_sincronizacao_notas.md` | Inclusão do módulo `git-governance` como fonte de verdade para evolução opcional da política Git no WSD. |
| 07/05/2026 — | Claude | `x/wsd/docs/10_matriz_sincronizacao_notas.md` | Inclusão do schema canônico `schemas/context.schema.json` e validador `wsd-validate-context.js` em "Fontes de Verdade" e "Matriz Obrigatória" (v0.1.5-alpha). |
| 07/05/2026 — | Claude | `x/wsd/docs/10_matriz_sincronizacao_notas.md` | Inclusão de `templates/git-hooks/` em "Fontes de Verdade" e "Matriz Obrigatória" (v0.1.6-alpha). |
| 07/05/2026 — | Codex | `x/wsd/docs/10_matriz_sincronizacao_notas.md` | Expansão da matriz para o MVP Git/GitHub Governance planejado na v0.1.10-alpha. |
| 07/05/2026 — | Codex | `x/wsd/docs/10_matriz_sincronizacao_notas.md` | Marcação do MVP Git/GitHub Governance como implementado e validado por testes/checkers. |
| 11/05/2026 — | Claude | `x/wsd/docs/10_matriz_sincronizacao_notas.md` | Adição de `docs/15` como nova fonte de verdade (estratégia público × privado e quick start). Nova linha na Matriz Obrigatória e Grupos Mínimos. |
| 30/05/2026 18:15:09 -03 | Codex | `+Apps/wsd/docs/10_matriz_sincronizacao_notas.md` | Atualização do checklist público para `npm test` com 11 gates, incluindo `test:install-version`. |
| 15/06/2026 | Codex | `+Apps/wsd/docs/10_matriz_sincronizacao_notas.md` | Inclusão do WSD Loop como fonte de verdade, matriz de artefatos e grupo mínimo de sincronização. |
| 15/06/2026 | Codex | `+Apps/wsd/docs/10_matriz_sincronizacao_notas.md` | Inclusão do Codex Adherence Pack e atualização do checklist público para 13 gates. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
