---
title: "19 — WSD Loop: Automação Inteligente"
created: 2026-06-15
modified: 2026-06-17
tags:
  - x
  - wsd
  - loop
  - automacao
  - agentes
status: ativo
tipo: guia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/README]], [[wsd/CHANGELOG]], [[wsd/docs/03_ciclo_operacional]], [[wsd/docs/08_rotinas_sessao]], [[wsd/docs/10_matriz_sincronizacao_notas]]"
otimizado_para_obsidian: true
---
# 19 — WSD Loop: Automação Inteligente

> [!note] Atualização v0.5.0 (lean-core)
> Os comandos `wsd codex-prompt`, `wsd codex`, `wsd codex-shortcuts`, `wsd shortcuts`,
> o prompt `/prompts:loop` e o espelho `.codex/skills/` foram **aposentados**. O caminho
> atual é linguagem natural + tabela Intenção → Ação do `AGENTS.md`, skills em
> `.agents/skills/` e guias on-demand em `+wsd/guides/`. Menções abaixo a esses
> comandos são históricas.


[[wsd/wsd|← WSD]]

---

> [!abstract] Objetivo
> Documentar o `wsd loop` e o Codex Adherence Pack, camadas do WSD `v0.4.0` criadas para reduzir aprovações e prompts manuais em tarefas L0/L1 sem remover gates, limites de risco e rastreabilidade.

## 1. 🔄 Atualizações

Histórico completo desta nota: `git log --follow -- <arquivo>` e [CHANGELOG.md](../CHANGELOG.md). Seções de histórico manual foram removidas na v0.5.0 (lean-core); conteúdo preservado em `archive/historico_notas_2026H1.md`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. Modelo Mental

O WSD Loop adapta a ideia de ciclos curtos de agente para o contrato WSD:

1. `plan` prepara ou revisa tarefas a partir de uma spec.
2. `once` executa uma tarefa por iteração.
3. `run` repete `once` com limite explícito.
4. Gates WSD, CI, permissões de path e risco decidem se a iteração pode ser concluída.

O loop não substitui o método. Ele automatiza o caminho entre uma spec aprovada e tarefas pequenas, mantendo o agente preso ao `+context.json`.

## 3. Contrato no `+context.json`

Projetos WSD passam a declarar:

```json
"automation": {
  "loop": {
    "enabled": true,
    "default_max_iterations": 3,
    "allowed_risks": ["L0", "L1"],
    "auto_use": false,
    "require_clean_worktree": true,
    "auto_commit": true,
    "auto_push": false,
    "one_task_per_iteration": true,
    "stop_on_repeated_gate_failure": true,
    "require_human_for_l2": true
  }
}
```

Defaults:

- L0/L1 podem rodar com automação.
- `auto_use=false` por padrão: o loop só roda quando pedido ou sugerido.
- L2 fica bloqueado salvo `--human-approved` e inclusão explícita em `allowed_risks`.
- Auto-commit é permitido depois dos gates.
- Auto-push é desligado.
- Worktree precisa estar limpa no início.

## 4. Comandos

```bash
./+wsd/bin/wsd loop plan --feature minha-feature
./+wsd/bin/wsd loop once --feature minha-feature --agent-cmd 'codex exec ...'
./+wsd/bin/wsd loop run --feature minha-feature --agent-cmd 'codex exec ...' --max-iterations 3
./+wsd/bin/wsd loop auto status
./+wsd/bin/wsd loop auto on
./+wsd/bin/wsd loop auto off
./+wsd/bin/wsd loop status
./+wsd/bin/wsd loop stop
./+wsd/bin/wsd shortcuts status
```

Sem `--agent-cmd`, `plan` e `once` apenas geram prompts auditáveis em `+logs/wsd-loop/`.

`loop auto on|off` altera `automation.loop.auto_use` no `+context.json`. Essa é a opção fixa do WSDD para ativar ou desativar o uso automático do Ralph/WSD Loop por agentes.

## 5. Gates de Cada Iteração

Quando `once` executa um agente real, a ordem é:

1. preflight de Git, Node, `+context.json`, `scripts/wsd_check.sh` e worktree limpa;
2. validação de spec, tasks e risco;
3. execução do agente com `WSD_LOOP_PROMPT`, `WSD_LOOP_FEATURE`, `WSD_LOOP_MODE` e `WSD_LOOP_RISK`;
4. validação de paths alterados contra `permissions.write_paths` e `permissions.forbidden_paths`;
5. `git diff --check`;
6. `scripts/wsd_check.sh --risk L0 .`;
7. gate L1/L2 com `--spec`, quando aplicável;
8. comandos `ci.lint_commands`, `ci.test_commands` e `ci.build_commands`;
9. auto-commit se `automation.loop.auto_commit=true`.

## 6. Quando Usar

Use para:

- specs L0/L1 já aprovadas;
- tarefas repetíveis e pequenas;
- correções de docs, testes, UI ou código com gates claros;
- ciclos em que o operador quer aprovar apenas decisões importantes.

Não use para:

- produção;
- segredos;
- migrações destrutivas;
- mudança L2 sem aprovação explícita;
- tarefas sem spec ou sem critério de aceite.

## 7. Relação com Ralph Loop

O WSD Loop usa a mesma intuição operacional: agente em ciclo curto, com feedback contínuo e parada quando a validação falha. A diferença é que o WSD prende o ciclo a artefatos próprios: spec, tasks, matriz de risco, `+context.json`, gates locais e Git.

## 8. Codex Adherence Pack

O fluxo comum do operador continua válido: abrir o Codex na pasta do projeto e pedir a tarefa. O WSD reforça isso com quatro peças:

1. `AGENTS.md` gerado com a seção `WSD Codex Bootstrap`;
2. skills repo-locales em `.agents/skills/`, incluindo `wsd-loop`, com espelho legado em `.agents/skills/`;
3. `./+wsd/bin/wsd start --brief` para contexto operacional compacto;

Comandos:

```bash
./+wsd/bin/wsd start --brief
```


No Claude Code, o WSD instala `.claude/commands/loop.md`, então o atalho é literalmente `/loop status`, `/loop on` ou `/loop off`.


O WSD não usa hooks internos do Codex como base obrigatória nesta versão. Aderência principal fica em `AGENTS.md` + `.agents/skills/`, porque é o mecanismo compartilhável por repositório; prompts globais (``/loop` (Claude Code) ou skill `wsd-loop` (Codex)`) são opcionais por usuário, e hooks ficam como ideia futura em `+specs/project/IDEAS.md`.

## 9. Próximas Evoluções

As próximas features sugeridas ficam em `+specs/project/IDEAS.md`:

- auto-PR e GitHub Issues;
- dashboard de runs;
- sandbox forte para AFK;
- adapters multi-agente;
- checkpoints L2 assistidos.
- adapter de hooks Codex.

## 10. Registro de Alterações por Agentes

| Data | Agente | Arquivo | Alteração |
|---|---|---|---|
| 15/06/2026 | Codex | `docs/19_wsd_loop_automacao_inteligente.md` | Criação da fonte de verdade do WSD Loop `v0.4.0`. |
| 15/06/2026 | Codex | `docs/19_wsd_loop_automacao_inteligente.md` | Inclusão do Codex Adherence Pack na mesma entrega `v0.4.0`. |
| 17/06/2026 | Codex | `docs/19_wsd_loop_automacao_inteligente.md` | Inclusão de atalhos de agente para WSD Loop em Codex/Claude/shell (`v0.4.1`). |
| 21/06/2026 | Codex | `docs/19_wsd_loop_automacao_inteligente.md` | Nota de compatibilidade com `v0.4.2`: WSD Loop mantém contrato, e concerns passam a ter pipeline próprio antes de automações longas. |
| 21/06/2026 | Codex | `docs/19_wsd_loop_automacao_inteligente.md` | Nota de compatibilidade com `v0.4.3`: `wsd finish` fecha limpo após gates e commit automático. |
| 21/06/2026 | Codex | `docs/19_wsd_loop_automacao_inteligente.md` | Nota de compatibilidade com `v0.4.4`: `wsd relatorio` consolida estado, plano, ideias e concerns antes ou depois do loop. |
| 21/06/2026 | Codex | `docs/19_wsd_loop_automacao_inteligente.md` | Nota de compatibilidade com `v0.4.5`: `wsd update` propaga novos atalhos de agente preservando customizações. |
| 21/06/2026 | Codex | `docs/19_wsd_loop_automacao_inteligente.md` | Nota de compatibilidade com `v0.4.6`: `wsd relatorio` reconhece headings acentuados. |
| 21/06/2026 | Codex | `docs/19_wsd_loop_automacao_inteligente.md` | Nota de compatibilidade com `v0.4.7`: `start --brief` conta concerns ativas do pipeline. |
| 21/06/2026 | Codex | `docs/19_wsd_loop_automacao_inteligente.md` | Nota de compatibilidade com `v0.4.8`: `wsd finish` roda auditor documental local sem depender de pasta `docs/`. |
