---
title: "Changelog WSD"
created: 05/05/2026
modified: 2026-07-07
tags:
  - wsd
  - changelog
status: ativo
tipo: nota
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/README]]"
---
# Changelog WSD

Fonte única do histórico de versões do WSD. Janela ativa: últimas versões; o
restante vive em [CHANGELOG_ARCHIVE.md](CHANGELOG_ARCHIVE.md). Autoria e data
de cada mudança: `git log`.

## 0.5.0 — 07/07/2026

**Minor "lean core + full-auto"** — otimização estrutural completa do método
(revisão Claude Fable, spec `+specs/features/lean-core/spec.md`):

- **Fonte única de histórico**: seções "🔄 Atualizações" e tabelas "🕒 Registro
  de Alterações" removidas de todas as notas (preservadas em
  `archive/historico_notas_2026H1.md`); README de 38 KB → ~7 KB; CHANGELOG com
  janela ativa + `CHANGELOG_ARCHIVE.md`; `wsd_docs_check.sh` reescrito para
  validar coerência (versão em 2 fontes + guardas de regressão) em vez de
  duplicação.
- **AGENTS lean + progressive disclosure**: `AGENTS.md.template` reescrito
  (~110 linhas, gate de 150), com tabela "Intenção → Ação" para linguagem
  natural e guias on-demand vendorizados em `+wsd/guides/`
  (git, loop, party, sessao, lovable). Orçamento de contexto base ≤5k tokens
  documentado como regra do método.
- **Modo full-auto por padrão**: `workflow.approval_mode=full_auto` — o agente
  executa a tarefa inteira e fecha com commit sem pausa de aprovação; L2 exige
  validação reforçada + rollback documentado, mas não pausa. Única pausa
  obrigatória: worktree suja criada por outro agente/humano (decisão de merge é
  humana). `production_mutation_policy=allowed_with_rollback` como novo default;
  campo não-verificável `max_tokens_per_request` removido do contrato.
- **Compactação de memória**: convenção `+specs/project/archive/`;
  `wsd check`/`wsd finish`/`wsd relatorio` avisam quando STATE/CONCERNS incham
  (limiar ~150/120 linhas); STATE.md do próprio WSD compactado (138 → 78 linhas).
- **Snapshot/Node como fonte de leitura**: novo `+wsd/bin/wsd-report.cjs`
  concentra todo o parsing de markdown (modos `report`, `brief`, `bloat`);
  `wsd relatorio` e `start --brief` apenas delegam — elimina a família de bugs
  de parsing em bash (v0.4.6–v0.4.8).
- **Superfície de comandos reduzida**: aposentados `wsd codex-prompt`,
  `wsd codex`, `wsd codex-shortcuts`, `wsd shortcuts`, `/prompts:loop` e o
  espelho `.codex/skills/` (CLI de 2.430 → ~1.700 linhas). Linguagem natural +
  Intenção → Ação é a interface primária.
- **Gate de doc drift**: `docs-map.json` (código→docs) +
  `scripts/wsd_drift_check.sh` (warn-only) integrado ao docs_check.
- **Repo apresentável**: `xmodelos/`, `wsd_philo/`, `docs_lovable/`,
  `REVIEW_PRE_V1.md` e análises antigas movidos para `archive/` (regra: agentes
  não leem nem sincronizam).
- **Contrato coerente**: `permissions.write_paths` do WSD passa a incluir os
  arquivos de release (README, wsd.md, ROADMAP, CHANGELOG, package.json).

## 0.4.8 — 21/06/2026

**Patch — auditoria documental do finish.** Corrige o `./+wsd/bin/wsd finish` para rodar o auditor documental local em projetos que não possuem pasta raiz `docs/`.

Inclui:

- **Condição corrigida** — `_finish_docs_check` executa `scripts/wsd_docs_check.sh` sempre que o arquivo existir.
- **Skip mais preciso** — quando o auditor local não existe, a mensagem passa a informar `scripts/wsd_docs_check.sh ausente`.
- **Cobertura de regressão** — `test:install-finish-clean` simula repo sem `docs/` e confirma `WSD docs check: PASS`.
- **Caso real** — correção motivada pelo Portal Manhattan, que documenta em `+specs/` e scripts próprios, sem pasta raiz `docs/`.

## 0.4.7 — 21/06/2026

**Patch — contador de concerns no start brief.** Corrige a contagem `concerns_active` emitida por `./+wsd/bin/wsd start --brief`.

Inclui:

- **Regex corrigida** — o contador passa a reconhecer linhas `| CONC-### ... |` no `CONCERNS_PIPELINE.md`.
- **Cobertura de regressão** — `test:install-relatorio` agora valida `start --brief` com uma concern ativa.
- **Validação real via WDB** — o caso foi detectado ao atualizar o WSD do WDB.

## 0.4.6 — 21/06/2026

**Patch — relatório tolerante a acentos.** Corrige a leitura de seções do `wsd relatorio` em projetos que usam headings em português com acentos, como `## Preocupações Ativas`.

Inclui:

- **Normalização de headings** — o parser remove diacríticos ao localizar seções Markdown.
- **Cobertura de regressão** — `test:install-relatorio` agora usa `## Preocupações Ativas` e valida a contagem de concerns ativas.
- **Validação real via WDB** — o caso foi detectado ao atualizar o WSD do WDB.

## 0.4.5 — 21/06/2026

**Patch — update/adherence preservador.** Esta release corrige a atualização de projetos já instalados para que novas skills e comandos de agente cheguem aos repositórios sem reinstalação destrutiva.

Inclui:

- **`wsd update --help` sem efeitos colaterais** — pedir ajuda não executa mais update nem altera `+wsd/config.json`.
- **Update de aderência de agente** — `wsd-method update` garante arquivos novos em `.agents/skills`, `.codex/skills`, `.claude/commands` e `+wsd/hooks` de acordo com `+wsd/config.json#tools`.
- **Preservação de customizações** — arquivos existentes nesses destinos não são sobrescritos no update normal.
- **`test:install-update-adherence`** — simula um projeto antigo, remove artefatos novos, valida `update --help`, roda `wsd update` e confirma que os atalhos novos aparecem preservando arquivo customizado.

Documentação:

- README, wsd.md, docs/05, docs/09, docs/10, docs/15, docs/18, docs/19 e ROADMAP atualizados para `v0.4.5`.

## 0.4.4 — 21/06/2026

**Patch — relatório operacional WSD.** Esta release adiciona um comando de leitura consolidada para o operador pedir uma visão geral do projeto sem lembrar todos os arquivos WSD.

Inclui:

- **`wsd relatorio`** — imprime Markdown com estado Git/WSD, implementação em andamento, plano programado, ideias, concerns e sugestão do agente.
- **`wsd relatorio --save`** — salva a fotografia operacional em `+specs/RELATORIO.md`.
- **Aliases** — `report`, `status-report` e `resumo`.
- **Skill `wsd-relatorio`** — faz pedidos em linguagem natural como "relatório WSD" usarem o comando.
- **Comando Claude `/wsd-relatorio`** — atalho equivalente em Claude Code.
- **`test:install-relatorio`** — instala WSD em repo temporário, cria ROADMAP/spec/ideia/concern de fixture e valida relatório, `--save` e alias.

Documentação:

- README, wsd.md, docs/05, docs/08, docs/09, docs/10, docs/15, docs/18, ROADMAP e specs atualizados para `v0.4.4`.

---

Versões anteriores (0.1.0-alpha → 0.4.3): [CHANGELOG_ARCHIVE.md](CHANGELOG_ARCHIVE.md)
