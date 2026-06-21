---
title: "WSD — Wolff Spec Driven"
created: 05/05/2026
modified: 15/06/2026
tags:
  - x
  - wsd
  - hub
  - metodologia
  - agentes
status: ativo
tipo: hub
parent: "[[x]]"
links: "[[x]], [[wsd/README]], [[wsd/ROADMAP]], [[wsd/CHANGELOG]], [[wsd/AGENTS]], [[wsd/docs/00_planejamento_instalacao_wsd]], [[wsd/docs/01_constituicao]], [[wsd/docs/02_matriz_risco]], [[wsd/docs/03_ciclo_operacional]], [[wsd/docs/04_playbook_implantacao]], [[wsd/docs/05_contrato_artefatos]], [[wsd/docs/06_personalizacao_por_projeto]], [[wsd/docs/07_git_governance]], [[wsd/docs/08_rotinas_sessao]], [[wsd/docs/09_publicacao_github_privado]], [[wsd/docs/10_matriz_sincronizacao_notas]], [[wsd/docs/11_modulo_git_governance]], [[wsd/docs/12_avaliacao_critica]], [[wsd/docs/13_compatibilidade_claude_code]], [[wsd/docs/14_qualidade_desenvolvimento]], [[wsd/docs/15_repositorio_publico_e_quick_start]], [[wsd/docs/16_wdb_snapshot_integration]], [[wsd/docs/17_snapshot_campos_explicados]], [[wsd/docs/18_manual_leigo_comandos_wsdd]]"
otimizado_para_obsidian: true
---
# WSD — Wolff Spec Driven

[[x|← x — Interface IA]]

---

> [!abstract] Papel do Hub
> Este hub organiza o pacote WSD como metodologia pessoal reutilizável para desenvolvimento com agentes em múltiplos repositórios privados.


> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. Mapa]]
3. [[#3. Estado Atual]]
4. [[#4. Artefatos Copiáveis]]
5. [[#5. Decisão de Design]]
6. [[#6. Matriz de Sincronização]]
7. [[#7. Regra para Agentes]]
8. [[#8. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 05/05/2026 13:29:54 -03 — Codex: Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes.
- 05/05/2026 14:13:39 -03 — Codex: Alinhamento do hub à versão `v0.1.2-alpha`, inclusão de status operacional, CLI atual e matriz de sincronização documental obrigatória.
- 05/05/2026 14:38:29 -03 — Codex: Inclusão da nota `11 — Módulo Git Governance WSD` no mapa do método e no fluxo de governança futura.
- 06/05/2026 11:31:14 -03 — Codex: Registro da reavaliação da nota `12 — Avaliação Crítica` com foco Codex-first e suporte Claude Code em evolução.
- 06/05/2026 11:38:28 -03 — Codex: Inclusão das pastas auxiliares `+imbox/` como inbox de notas e `wsd_philo/` como base filosófica e de pesquisa do método.
- 06/05/2026 11:52:30 -03 — Codex: Registro da nota `13 — Compatibilidade WSD com Claude Code` no mapa do método e no fluxo de evolução do suporte Claude.
- 06/05/2026 — Claude: Atualização para `v0.1.3-alpha` — suporte Claude Code operacional, foco atual atualizado para piloto no `koomplet-office`.
- 06/05/2026 — Claude: Atualização para `v0.1.4-alpha` — integração TLC: doc 14 no mapa, regra para agentes atualizada para `+specs/project/`, regras 11 e 12, novos comandos slash `/wsd-specify`, `/wsd-design`, `/wsd-tasks`.
- 07/05/2026 — Claude: Atualização para `v0.1.5-alpha` — JSON Schema 2020-12 canônico para `+context.json` em `schemas/context.schema.json`, validador `wsd-validate-context.js` integrado a `wsd_check.sh`.
- 07/05/2026 — Claude: Atualização para `v0.1.6-alpha` — ghost spec detector em `wsd_check.sh` e git hooks no bootstrap (`pre-commit`, `commit-msg`, `pre-push`). Fecha a Fase 3.
- 07/05/2026 — Claude: Atualização para `v0.1.7-alpha` — `wsd finish` automatizado: HANDOFF.md gerado pelo CLI + prompts interativos para STATE.md. Fecha o último item da Fase 3.
- 07/05/2026 — Claude: Atualização para `v0.1.8-alpha` — instalação interativa rica (linguagem, path canônico, comandos test/build/lint, forbidden_paths), `wsd update` real via `wsd_source`, WHEN+THEN+SHALL todos obrigatórios no ghost scan.
- 07/05/2026 — Codex: Atualização para `v0.1.9-alpha` — saneamento documental operacional; `wsd_philo/` preservado como referência histórica/pesquisa, não fonte de gate.
- 07/05/2026 — Codex: Planejamento da próxima frente `v0.1.10-alpha` — MVP Git/GitHub Governance antes da estabilização `v0.1.0`.
- 07/05/2026 — Codex: Atualização para `v0.1.10-alpha` — MVP Git/GitHub Governance implementado em installer, contexto, templates, CLI local, templates GitHub e testes.
- 07/05/2026 — Claude: Atualização para `v0.1.11-alpha` — Party Mode Integration: `installPartyMode` no CLI, comando Claude Code `/wsd-party-mode`, subcomando `wsd party status|list-agents|when-to-use`, seção Party Mode no `AGENTS.md` e `test:install-party-mode` no pipeline. Fase 3.5 fechada; Fase 4 (estabilização `v0.1.0`) é o próximo foco.
- 07/05/2026 — Claude: Release **`v0.1.0`** estável — Fase 4 concluída. Drop do sufixo `-alpha`, README com seção "Uso Oficial" expandida, ROADMAP Fase 4 fechada, modo manutenção estável.
- 13/05/2026 — Codex: Inclusão da nota `18 — Manual Leigo dos Comandos WSDD` no mapa do método como entrada prática para uso diário da release pública `v0.2.1`.
- 13/05/2026 — Claude (Opus 4.7): Atualização para `v0.3.0` (minor — reforço do contrato operacional): versão atual e Foco Atual atualizados; novas entradas em Estado Atual descrevendo `wsd_check.sh` reescrito validando 6 notas obrigatórias, `+context.json` com blocos formais `environment`/`repository`/`permissions`/`workflow` + `clone_policy`, artefatos `+specs/project/` preenchidos, `REVIEW_PRE_V1.md` tracker e `docs/18` manual leigo.
- 30/05/2026 18:15:09 -03 — Codex: Atualização para `v0.3.1` com `wsd version`, inventário multi-repo e regra prática para agentes verificarem a versão WSD instalada em projetos.
- 15/06/2026 — Codex: Atualização para `v0.4.0` com `wsd loop`, contrato `automation.loop`, Codex Adherence Pack e nota `19 — WSD Loop`.
- 17/06/2026 — Codex: Atualização para `v0.4.1` com atalhos WSD Loop para Codex/Claude/shell e skills Codex no caminho `.agents/skills`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. Mapa

| Documento | Quando abrir | Responde |
|---|---|---|
| [[wsd/docs/00_planejamento_instalacao_wsd|00 Planejamento de Instalação]] | ao desenhar instalador, GitHub opcional e agentes | como instalar WSD local por projeto |
| [[wsd/docs/01_constituicao|01 Constituição]] | antes de criar ou adaptar regras | quais princípios não podem ser quebrados |
| [[wsd/docs/02_matriz_risco|02 Matriz de Risco]] | ao classificar tarefa | quando usar L0, L1 ou L2 |
| [[wsd/docs/03_ciclo_operacional|03 Ciclo Operacional]] | durante uma sessão | como abrir, executar e fechar trabalho |
| [[wsd/docs/04_playbook_implantacao|04 Playbook de Implantação]] | ao colocar WSD em um repo | sequência de bootstrap |
| [[wsd/docs/05_contrato_artefatos|05 Contrato de Artefatos]] | ao editar templates | formato de `+context.json`, specs e logs |
| [[wsd/docs/06_personalizacao_por_projeto|06 Personalização]] | ao adaptar para um projeto | o que é global e o que é local |
| [[wsd/docs/07_git_governance|07 Git Governance]] | ao mexer em branch/PR | política Git para agentes |
| [[wsd/docs/08_rotinas_sessao|08 Rotinas de Sessão]] | no início/fim do dia | checklist operacional |
| [[wsd/docs/09_publicacao_github_privado|09 Publicação GitHub]] | antes de tag/release ou publicação | como publicar e versionar o repo privado |
| [[wsd/docs/10_matriz_sincronizacao_notas|10 Matriz de Sincronização]] | antes de finalizar qualquer mudança documental ou operacional | quais notas e arquivos devem mudar juntos |
| [[wsd/docs/11_modulo_git_governance|11 Módulo Git Governance]] | ao planejar ou implementar política Git opcional instalável | como transformar `r.3.4_git_github` em módulo WSD |
| [[wsd/docs/12_avaliacao_critica|12 Avaliação Crítica]] | ao revisar o estado do método ou planejar evolução | o que funciona, o que falta e o roadmap de enforcement |
| [[wsd/docs/13_compatibilidade_claude_code|13 Compatibilidade Claude Code]] | ao implementar suporte Claude Code ou entender diferenças com Codex | modelo de skills, gap de governança, templates e hooks |
| [[wsd/docs/14_qualidade_desenvolvimento|14 Qualidade de Desenvolvimento]] | ao usar auto-sizing, STATE.md, WHEN/THEN/SHALL, TESTING.md tiered, knowledge chain ou Conventional Commits | padrões TLC adotados na v0.1.4-alpha |
| [[wsd/docs/15_repositorio_publico_e_quick_start|15 Repositório Público e Quick Start]] | ao sincronizar WSD privado → wsdd público ou usar `npx github:flow31-d/wsdd install` | estratégia privado × público, checklist de sync, regras de compatibilidade |
| [[wsd/docs/16_wdb_snapshot_integration|16 WDB Snapshot Integration]] | ao integrar snapshot com dashboard externo | schema v1, localização de arquivos, polling |
| [[wsd/docs/17_snapshot_campos_explicados|17 O que contém o Snapshot]] | ao entender o que cada campo do snapshot significa | explicação detalhada de todos os blocos em linguagem acessível |
| [[wsd/docs/18_manual_leigo_comandos_wsdd|18 Manual Leigo dos Comandos WSDD]] | ao instalar ou usar WSDD sem conhecer o método | comandos principais explicados em linguagem simples |
| [[wsd/docs/19_wsd_loop_automacao_inteligente|19 WSD Loop: Automação Inteligente]] | ao automatizar tarefas L0/L1 com poucas aprovações ou reforçar aderência Codex | contrato `automation.loop`, comandos `wsd loop`, `wsd codex-prompt`, `wsd codex` e gates de iteração |

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. Estado Atual

Versão atual do pacote: **`v0.4.1`** (patch — atalhos de agente/terminal para WSD Loop em cima do Codex Adherence Pack).

O WSD já possui:

- `package.json` com binário `wsd-method` e `npm test` (13 gates);
- `bin/wsd-method.js` com `install`, `doctor`, `help`, `update`, `--list-options`, flag `--brownfield` e `--git-policy none|basic|full`;
- `install.sh` como wrapper local;
- instalação vendorizada em `+wsd/`;
- `templates/local-wsd/bin/wsd` com `start`, `start --brief`, `check`, `finish`, `doctor`, `version`, `update`, `hooks`, `snapshot`, `lovable`, namespace `git doctor|preflight|pr-check`, namespace `party status|list-agents|when-to-use`, `loop plan|once|run|status|stop`, `codex-prompt` e `codex`;
- 8 skills Codex em `.agents/skills/` (`wsd`, `wsd-start`, `wsd-finish`, `wsd-specify`, `wsd-design`, `wsd-tasks`, `wsd-idea`, `wsd-loop`), espelhadas em `.codex/skills/` para compatibilidade;
- 8 comandos slash Claude Code em `.claude/commands/` (`loop`, `wsd-start`, `wsd-finish`, `wsd-specify`, `wsd-design`, `wsd-tasks`, `wsd-party-mode`, `idea-{PROJECT_SLUG}`), `.claude/settings.json` com hooks e `+wsd/hooks/pre-tool.sh`;
- atalhos WSD Loop para agentes: `codex-shortcuts` oferece `/prompts:loop status` no Codex e `/loop status` fica disponível no Claude Code;
- `--tools both` gera os dois conjuntos sem conflito;
- matriz e checker de sincronização documental (com 20+ assertions TLC);
- estrutura `+specs/` expandida (project/, codebase/, features/, quick/) substituindo `.specs/`;
- STATE.md como memória operacional (substitui `+logs/error_vault.json`) e HANDOFF.md como passe entre sessões;
- 4 fases TLC + auto-sizing por risco (L0/L1/L2);
- Conventional Commits 1.0.0 como padrão obrigatório;
- plano do módulo opcional `git-governance` (absorvido pela v0.1.4 via Conventional Commits);
- JSON Schema canônico em `schemas/context.schema.json` + validador `wsd-validate-context.js` vendorizado no install (v0.1.5);
- ghost spec detector em `wsd_check.sh` — specs `approved`/`implemented` sem WHEN/THEN/SHALL bloqueadas em L1/L2 (v0.1.6);
- git hooks no bootstrap (`pre-commit`, `commit-msg`, `pre-push`) instalados por `wsd-method install`; subcomando `wsd hooks` para reinstalar após clone (v0.1.6);
- `wsd finish` automatizado: gera `+specs/HANDOFF.md` (branch, commits recentes, arquivos uncommitted, specs) + prompts interativos para STATE.md (lições, decisões, bloqueadores) (v0.1.7);
- instalação interativa rica: linguagem principal, path canônico, comandos test/build/lint, forbidden_paths (v0.1.8);
- `wsd update` real: atualiza `+wsd/` vendor tree via `wsd_source` em `+wsd/config.json` sem tocar em arquivos do projeto (v0.1.8);
- validação WHEN+THEN+SHALL completa: todos os três keywords obrigatórios em ghost scan e L1/L2 (v0.1.8).
- saneamento documental operacional: `docs/00` e `docs/12` alinhados ao estado real; `wsd_philo/` preservado como histórico/pesquisa (v0.1.9).
- MVP Git/GitHub Governance implementado: `--git-policy none|basic|full`, bloco `git_governance` no `+context.json`, seção Git/GitHub no `AGENTS.md`, templates `.github/` no modo `full` e testes de instalação para `none`, `basic` e `full` (v0.1.10).
- Party Mode Integration: `installPartyMode` copia 26 agentes para `+wsd/party-mode/`, comando Claude Code `/wsd-party-mode`, subcomando `wsd party status|list-agents|when-to-use`, seção `## Party Mode` no `AGENTS.md` gerado e `test:install-party-mode` no pipeline `npm test` (7/7 gates PASS) (v0.1.11).
- Release **`v0.1.0`** estável (07/05/2026): API estável após validação brownfield + fechamento de todas as fases. Modo manutenção. Documentação oficial expandida no README.
- Releases patch **`v0.1.1` → `v0.1.4`** (08–12/05/2026): bug fixes, sync `wsdd` público, CJS/ESM fix, governance gaps, snapshot spec, hotfix WSD-001 (templates faltantes no `wsdd`).
- Release **`v0.2.0`** (13/05/2026): primeiro minor pós-`v0.1.0`, marco "estável adotável". 8 features funcionais + UX polish do install interativo. Resolve D-001 (Opção B+) e D-002 (Opção A). 9/9 npm test + 27/27 e2e + piloto operacional `flow31-d/worc`.
- Release **`v0.2.1`** (13/05/2026): patch cosmético — mensagem "Refreshed" do `wsd update` agora dinâmica via `config.modules`. Detectado no piloto worc logo após v0.2.0.
- Release **`v0.3.0`** (13/05/2026): minor — reforço do contrato operacional WSD. `scripts/wsd_check.sh` reescrito (185 linhas) validando as 6 notas obrigatórias de `+specs/project/` como L0-required (antes só STATE.md era checada — WSD-001 escapou). `+context.json` ganha blocos formais `environment`, `repository` (+ `clone_policy` canônico), `permissions` e `workflow`. Artefatos `+specs/project/` preenchidos com conteúdo real. `templates/local-wsd/bin/wsd-snapshot.cjs` propaga novos campos. Inclui `REVIEW_PRE_V1.md` (tracker pré-v1) e `docs/18_manual_leigo_comandos_wsdd.md` (manual leigo). 9/9 npm test PASS.
- Release **`v0.3.1`** (30/05/2026): patch — inventário de versão WSD por projeto. `./+wsd/bin/wsd version` mostra versão instalada, fonte, versão da fonte e status de alinhamento; `--inventory --path <dir>` varre múltiplos repos com `+wsd/config.json`; `--json` permite automação. `npm test` inclui `test:install-version`.
- Release **`v0.3.2`** (13/06/2026): patch — versão carimbada no snapshot. `templates/local-wsd/bin/wsd-snapshot.cjs` grava `wsd_version` em cada `+wsd/snapshot.json`, permitindo que consumidores que já leem snapshots (ex.: Zelador) detectem deriva de versão passivamente, sem abrir `+wsd/config.json` por repo.
- Release **`v0.3.3`** (13/06/2026): patch — publicação pública. Leva ao `wsdd` público a feature de `wsd_version` no snapshot (privada na v0.3.2). O público estava em v0.3.1; passa a ter o carimbo de versão e a detecção passiva de deriva.
- Release **`v0.4.0`** (15/06/2026): minor — WSD Loop + Codex Adherence Pack. Adiciona `automation.loop` no `+context.json`, opção fixa `automation.loop.auto_use`, prompts vendorizados em `+wsd/loop/`, subcomando `wsd loop plan|once|run|status|stop|auto`, bloco `WSD Codex Bootstrap` no `AGENTS.md`, `wsd start --brief`, `wsd codex-prompt`, `wsd codex`, gates de paths/risco/CI antes de auto-commit e testes `test:install-loop` + `test:install-codex-adherence`.
- Release **`v0.4.1`** (17/06/2026): patch — instala skills Codex em `.agents/skills/`, adiciona `wsd-loop`, prompt opcional `/prompts:loop`, comando Claude `/loop`, atalhos shell `wsd()`/`wl()` via `wsd shortcuts shell` e reforça `wsd-idea`/`IDEAS_PIPELINE`.

Foco atual: **`v0.4.1` em preparação pública** (17/06/2026). Próximas frentes estão em `+specs/project/IDEAS.md`: auto-PR, dashboard de runs, sandbox forte, adapters multi-agente, checkpoints L2 assistidos e adapter de hooks Codex.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. Artefatos Copiáveis

- `templates/repo/`: kit para copiar para um repositório alvo.
- `templates/specs/`: modelos de Task Card, spec L1, spec L2, ADR e PR.
- `templates/codex-skills/`: modelos de skills Codex para governar WSD.
- `templates/local-wsd/`: CLI local instalada em `+wsd/bin/wsd`.
- `profiles/`: perfis de projeto para renderizar/adaptar templates.
- `scripts/`: scripts de verificação e bootstrap.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. Decisão de Design

WSD não deve depender de um projeto específico. Prescreve Mais e Koomplet Office são perfis, não a metodologia.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. Matriz de Sincronização

Antes de editar README, ROADMAP, CHANGELOG, AGENTS, docs, templates, scripts, profiles, installer ou versão, o agente deve abrir:

- [[wsd/docs/10_matriz_sincronizacao_notas|10 — Matriz de Sincronização de Notas WSD]]

Essa nota define quais arquivos precisam ser revisados juntos e quais comandos devem ser rodados antes de commit/PR.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. Regra para Agentes

Antes de editar qualquer repositório que use WSD, o agente deve encontrar e respeitar:

1. `AGENTS.md`;
2. `+context.json`;
3. `+specs/project/PROJECT.md` (visão e regras) e `+specs/project/STATE.md` (decisões e bloqueadores ativos);
4. `+specs/codebase/*.md` quando o repositório for brownfield;
5. spec aprovada para L1/L2 com WHEN/THEN/SHALL em `+specs/features/<slug>/spec.md`;
6. `+specs/codebase/TESTING.md` para escolher gate level (Quick/Full/Build);
7. comandos de validação reais;
8. `./+wsd/bin/wsd version` quando precisar confirmar qual WSD está instalado naquele repo;
9. `./+wsd/bin/wsd loop status` e `docs/19` quando usar automação iterativa;
10. `./+wsd/bin/wsd codex-prompt` ou `./+wsd/bin/wsd codex` quando quiser reforçar aderência Codex com comando curto;
11. matriz de sincronização, quando a mudança afetar documentação, versão, installer, templates, profiles ou skills.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 05/05/2026 13:29:54 -03 | Codex | `x/wsd/wsd.md` | Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes. |
| 05/05/2026 14:13:39 -03 | Codex | `x/wsd/wsd.md` | Alinhamento do hub à versão `v0.1.2-alpha`, inclusão de status operacional, CLI atual e matriz de sincronização documental obrigatória. |
| 05/05/2026 14:38:29 -03 | Codex | `x/wsd/wsd.md` | Inclusão da nota `11 — Módulo Git Governance WSD` no mapa do método e no fluxo de governança futura. |
| 06/05/2026 — | Claude | `x/wsd/wsd.md` | Atualização do Estado Atual para `v0.1.3-alpha` com suporte Claude Code operacional e novo foco no piloto `koomplet-office`. |
| 06/05/2026 — | Claude | `x/wsd/wsd.md` | Atualização para `v0.1.4-alpha`: doc 14 no mapa, regra para agentes refeita com `+specs/project/`, `+specs/codebase/` e WHEN/THEN/SHALL, novos comandos `/wsd-specify`, `/wsd-design`, `/wsd-tasks`, foco em piloto brownfield. |
| 07/05/2026 — | Claude | `x/wsd/wsd.md` | Generalização do "foco atual": após validação operacional concluída, manter o repositório do método limpo de detalhes específicos de projetos-alvo. Detalhes operacionais ficam no `+specs/project/STATE.md` de cada projeto que adota WSD. |
| 07/05/2026 — | Claude | `x/wsd/wsd.md` | Atualização para `v0.1.5-alpha`: JSON Schema canônico em `schemas/context.schema.json` + validador `wsd-validate-context.js` no estado atual do método. |
| 07/05/2026 — | Claude | `x/wsd/wsd.md` | Atualização para `v0.1.6-alpha`: ghost spec detector, git hooks no bootstrap, estado atual e foco reposicionados para Fase 4. |
| 07/05/2026 — | Claude | `x/wsd/wsd.md` | Atualização para `v0.1.7-alpha`: `wsd finish` automatizado (HANDOFF.md + prompts STATE.md). Foco: Fase 4. |
| 07/05/2026 — | Claude | `x/wsd/wsd.md` | Atualização para `v0.1.8-alpha`: instalação interativa rica, `wsd update` real via `wsd_source`, WHEN+THEN+SHALL completo no ghost scan. |
| 07/05/2026 — | Codex | `x/wsd/wsd.md` | Atualização para `v0.1.9-alpha`: saneamento documental operacional e classificação de `wsd_philo/` como histórico/pesquisa. |
| 07/05/2026 — | Codex | `x/wsd/wsd.md` | Planejamento da próxima frente `v0.1.10-alpha`: MVP Git/GitHub Governance antes da estabilização. |
| 07/05/2026 — | Codex | `x/wsd/wsd.md` | Atualização para `v0.1.10-alpha`: MVP Git/GitHub Governance implementado e Fase 4 reposicionada como próxima frente. |
| 07/05/2026 — | Claude | `x/wsd/wsd.md` | Atualização para `v0.1.11-alpha`: Party Mode Integration entregue (CLI, slash command, subcomando, AGENTS.md, gate de teste). Fase 3.5 fechada; Fase 4 é o próximo foco. |
| 07/05/2026 — | Claude | `x/wsd/wsd.md` | Release **`v0.1.0`** estável: Fase 4 concluída, drop do sufixo `-alpha`, modo manutenção estável. Todas as fases do roadmap fechadas. |
| 13/05/2026 — | Codex | `x/wsd/wsd.md` | Inclusão da nota `18 — Manual Leigo dos Comandos WSDD` no mapa e nos links do hub. |
| 30/05/2026 18:15:09 -03 | Codex | `+Apps/wsd/wsd.md` | Atualização para `v0.3.1`: estado atual, foco, mapa e regra para agentes passam a mencionar `wsd version` e inventário de versão por projeto. |
| 15/06/2026 | Codex | `+Apps/wsd/wsd.md` | Atualização para `v0.4.0`: mapa inclui `docs/19`, estado atual menciona `wsd loop`, Codex Adherence Pack e regra de agentes inclui automação iterativa. |
| 17/06/2026 | Codex | `+Apps/wsd/wsd.md` | Atualização para `v0.4.1`: atalhos WSD Loop para Codex/Claude/shell e `.agents/skills` como caminho atual do Codex. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
