---
title: "14 — Qualidade de Desenvolvimento WSD (TLC Integration)"
created: 06/05/2026
modified: 06/05/2026
tags:
  - x
  - wsd
  - qualidade
  - tlc
  - spec-driven
status: ativo
tipo: guia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/docs/01_constituicao]], [[wsd/docs/02_matriz_risco]], [[wsd/docs/04_playbook_implantacao]], [[wsd/docs/07_git_governance]], [[wsd/docs/08_rotinas_sessao]], [[wsd/docs/12_avaliacao_critica]]"
otimizado_para_obsidian: true
---
# 14 — Qualidade de Desenvolvimento WSD (TLC Integration)

[[wsd/wsd|← WSD]]

---

> [!abstract] Objetivo
> Consolidar os padrões de qualidade que o WSD herdou da metodologia **TLC Spec-Driven** (Tech Leads Club) na versão `v0.1.4-alpha`. Reúne em um único lugar os mecanismos que evitam alucinação, scope creep, validação fraca e perda de contexto entre sessões.


> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. Auto-sizing por Risco]]
3. [[#3. STATE.md — Memória Operacional]]
4. [[#4. HANDOFF.md — Continuidade entre Sessões]]
5. [[#5. WHEN/THEN/SHALL — Acceptance Criteria]]
6. [[#6. TESTING.md — Tiered Gate Checks]]
7. [[#7. Knowledge Verification Chain]]
8. [[#8. Scope Guardrail]]
9. [[#9. Conventional Commits]]
10. [[#10. Por que TLC e não Superpowers]]
11. [[#11. Sincronização Desta Nota]]

## 1. 🔄 Atualizações

Histórico completo desta nota: `git log --follow -- <arquivo>` e [CHANGELOG.md](../CHANGELOG.md). Seções de histórico manual foram removidas na v0.5.0 (lean-core); conteúdo preservado em `archive/historico_notas_2026H1.md`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. Auto-sizing por Risco

A primeira decisão de qualquer tarefa é **escolher o fluxo correto** com base no risco. Pular fases é tão prejudicial quanto pular validação — mas excesso de cerimônia em mudanças triviais é desperdício.

### Tabela

| Risco | Critério | Fluxo | Artefatos | Aprovação |
|---|---|---|---|---|
| **L0** | ≤3 arquivos, mudança local e reversível | Quick mode | `+specs/quick/<slug>.md` + commit | nenhuma |
| **L1** | feature, endpoint, integração, refatoração | Specify → (Design opcional) → Tasks → Execute | `spec.md` + `tasks.md` + commits | revisão de PR |
| **L2** | produção, deploy, banco, auth, secrets | 4 fases completas | `spec.md` + `design.md` + `tasks.md` + commits + PR | humana entre Specify e Design |

### Regras

- **Nunca subir** o nível por escolha de agente — só o operador humano sobe risco.
- **Pode descer**: se durante Specify ficar claro que o escopo é L0, fechar com `+specs/quick/`.
- **L1 sem áreas cinzas** pode pular Design; sempre roda Specify e Tasks.
- **L2 nunca pula nada**, mesmo se "parece simples".

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. STATE.md — Memória Operacional

`+specs/project/STATE.md` é a **memória operacional** do repositório. Substitui o antigo `+logs/error_vault.json` como ponto único de verdade sobre o que está vivo no projeto.

### Seções obrigatórias

| Seção | Conteúdo |
|---|---|
| **Decisões** | Escolhas técnicas/produto com data, justificativa e impacto |
| **Bloqueadores Ativos** | Itens que impedem progresso, com responsável e prazo |
| **Lições Aprendidas** | Falhas e acertos recorrentes que devem informar futuras decisões |
| **Ideias Adiadas** | Sugestões fora do escopo atual (alimentadas pela Regra 12) |
| **Todos Ativos** | Tarefas pendentes pequenas que não justificam spec própria |

### Quando atualizar

- **Sempre** durante `wsd-finish`, perguntando ao usuário (ver [[wsd/docs/08_rotinas_sessao#4. Fim de Sessão|08 — Rotinas]]).
- Quando uma **decisão** for tomada durante a execução.
- Quando uma **ideia adjacente** surgir (Regra 12 — scope guardrail).
- Quando um **bloqueador** for identificado.

### Regra de durabilidade

STATE.md é **versionado em git**. Não usar para secrets, dados sensíveis, nem para ruído de execução. É memória de **decisão**, não de log.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. HANDOFF.md — Continuidade entre Sessões

`+specs/HANDOFF.md` é o **passe de bastão** entre sessões. Resolve o problema de "outra IA (ou eu mesmo amanhã) não sabe onde parei".

### Estrutura

```markdown
# HANDOFF — <data ISO>

## Feature/Task atual
<id, título, status>

## Concluído nesta sessão
- item 1
- item 2

## Em andamento
- item (`arquivo:linha` quando aplicável)

## Próximos passos
- 1.
- 2.

## Branch e estado
- branch: <nome>
- uncommitted: <lista>

## Referências
- spec: ...
- STATE.md decisões: ...
```

### Quando gerar

- **Sempre** em `wsd-finish` se a sessão produziu mudanças não totalmente fechadas.
- Quando **interromper** trabalho L1/L2 antes do PR.

### Quando ler

- **Sempre** em `wsd-start`, perguntando "continuar de onde parou?".

HANDOFF é **temporário** — sobrescrito a cada sessão. Decisões duradouras vão para STATE.md.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. WHEN/THEN/SHALL — Acceptance Criteria

Toda spec L1/L2 (`+specs/features/<slug>/spec.md`) precisa de **acceptance criteria no formato WHEN/THEN/SHALL**. Sem isso, a spec é apenas "intenção" e abre espaço para alucinação.

### Formato

```markdown
- WHEN <contexto/gatilho>
  THEN o sistema SHALL <comportamento observável>
```

### Exemplos

```markdown
- WHEN o usuário tenta logar com email inválido
  THEN o sistema SHALL retornar 400 com mensagem "email format invalid"
  AND o sistema SHALL NOT criar registro em audit_log

- WHEN o cron de sincronização roda às 02:00
  THEN o sistema SHALL processar até 10.000 registros pendentes
  AND o sistema SHALL gravar status `success` ou `partial` em sync_runs
```

### Regras

- **Observável**: critério precisa ser verificável por teste, log, ou inspeção direta.
- **Sem ambiguidade**: "deve funcionar bem" → ❌; "SHALL retornar HTTP 200 em <500ms" → ✅.
- **Negação explícita**: `SHALL NOT` é tão importante quanto `SHALL`.
- **Cobertura**: golden path + 2-3 edge cases + 1-2 error paths.

### Anti-padrão: "ghost spec"

Spec sem WHEN/THEN/SHALL é **ghost spec**. Pode ser detectada com:

```bash
grep -L 'SHALL' +specs/features/*/spec.md
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. TESTING.md — Tiered Gate Checks

`+specs/codebase/TESTING.md` define **três níveis** de validação. O nível certo é decidido por task, não por sessão.

### Os 3 tiers

| Tier | Tempo | Escopo | Quando rodar |
|---|---|---|---|
| **Quick** | < 30s | lint + unit testes do módulo afetado | a cada task atômica |
| **Full** | < 5min | toda a suíte de testes + tipos | antes de commit em feature branch |
| **Build** | variável | build de produção + integração + smoke | antes de merge para `main` |

### Estrutura recomendada

```markdown
## Gate Check Commands

| Tier | Command | Time |
|---|---|---|
| quick | npm run lint && npm test -- --findRelatedTests | < 30s |
| full | npm test && npm run typecheck | < 5min |
| build | npm run build && npm run e2e:smoke | ~10min |

## Coverage Matrix

| Layer | Test type | Parallel-safe |
|---|---|---|
| utils | unit | ✅ |
| api | integration | ✅ |
| db migrations | sequential | ❌ |
```

### Regra dura

- **Saída ≠ 0 = STOP**. Não comitar com gate vermelho.
- **Skip silencioso = bug**. Logar `SKIP: <motivo>` é obrigatório se um teste for desativado.
- **Parallel-Safe = false** invalida flag `[P]` na task correspondente.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. Knowledge Verification Chain

Implementada como **Regra 11** da Constituição (ver [[wsd/docs/01_constituicao#12. Regra 11 — Pesquisa Segue a Cadeia de Verificação|01 — Constituição]]).

### Os 5 passos em ordem

1. **Codebase existente** — código, padrões, convenções já em uso.
2. **Docs do projeto** — README, `+specs/codebase/`, `+specs/project/`.
3. **Ferramentas MCP** — Context7 ou equivalente para APIs.
4. **Web search** — documentação oficial, fontes reputadas.
5. **Flagrar como incerto** — "Não encontrei. Aqui está meu raciocínio, verifique antes de usar."

### Por que importa

APIs, comportamentos e padrões inventados causam **falhas em cascata** por todo o fluxo (design → tasks → implementação). O custo de detectar a alucinação tarde é exponencialmente maior que o custo de admitir incerteza cedo.

**Nunca pular para o passo 5 se 1–4 estão disponíveis.**

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. Scope Guardrail

Implementada como **Regra 12** da Constituição (ver [[wsd/docs/01_constituicao#13. Regra 12 — Escopo é Inviolável Durante Execução|01 — Constituição]]).

### A pergunta única

> **"Isto está na definição da minha task?"**

- Sim → implementar.
- Não → registrar em `+specs/project/STATE.md` na seção *Ideias Adiadas* ou *Todos Ativos*.

### Exceção

Se o item não-escopo for um **bug ativo bloqueador**, registrar como bloqueador e decidir com o operador antes de agir.

### Anti-padrão: "já que estou aqui"

A frase "já que estou aqui" é a principal causa de:

- diffs grandes e difíceis de revisar;
- bugs introduzidos sem rastreabilidade;
- testes que cobrem mais do que a task pretendia.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 9. Conventional Commits

Padrão **obrigatório** desde `v0.1.4-alpha` (ver [[wsd/docs/07_git_governance#4. Commit|07 — Git Governance]]).

### Formato

```text
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Tipos principais

`feat`, `fix`, `refactor`, `docs`, `test`, `style`, `perf`, `build`, `ci`, `chore`.

### Regras de Description

- imperativo ("add", não "added");
- lowercase na primeira letra;
- sem ponto final;
- complete a frase: *"If applied, this commit will _<sua description>_"*.

### Regras de Escopo

- **Uma task = um commit** — herda da quebra de tasks.md;
- commit contém apenas arquivos do escopo da task;
- mudanças "enquanto estou aqui" vão em commit separado **ou** em STATE.md (Regra 12).

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 10. Por que TLC e não Superpowers

Resumo da decisão tomada em 06/05/2026 (registrada em `+specs/project/STATE.md`).

| Critério | TLC Spec-Driven | Superpowers |
|---|---|---|
| Auto-sizing | ✅ L0/L1/L2 → Quick/Specify+Execute/4 fases | ❌ sempre roda pipeline completo |
| Memória cross-session | ✅ STATE.md + HANDOFF.md | parcial |
| Acceptance format | ✅ WHEN/THEN/SHALL | livre |
| Tiered gate checks | ✅ Quick/Full/Build | unificado |
| Brownfield support | ✅ 7 docs em `+specs/codebase/` | ❌ |
| Knowledge chain | ✅ explícita 5 passos | implícita |
| Scope guardrail | ✅ Regra de "is this in my task?" | ❌ |
| Brainstorm HARD-GATE | parcial | ✅ forte |

TLC ganhou pelo **auto-sizing** (evita cerimônia em L0) e pelo **suporte brownfield** (já temos repos legados). Adotamos do Superpowers o conceito de HARD-GATE de planejamento.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 11. Sincronização Desta Nota

Ao alterar esta nota, revisar sempre:

- [[wsd/docs/01_constituicao|01 — Constituição]] (Regras 11 e 12);
- [[wsd/docs/02_matriz_risco|02 — Matriz de Risco]] (mapeamento L0/L1/L2);
- [[wsd/docs/04_playbook_implantacao|04 — Playbook]] (Passo 7 — Auto-sizing);
- [[wsd/docs/07_git_governance|07 — Git Governance]] (Conventional Commits);
- [[wsd/docs/08_rotinas_sessao|08 — Rotinas de Sessão]] (STATE.md/HANDOFF.md);
- [[wsd/docs/10_matriz_sincronizacao_notas|10 — Matriz de Sincronização]];
- `templates/repo/AGENTS.md.template`;
- `templates/repo/+specs/codebase/TESTING.md.template`;
- `templates/specs/feature-spec.md.template` (WHEN/THEN/SHALL);
- skills `wsd-specify`, `wsd-design`, `wsd-tasks` (Codex e Claude Code).

[[#📑 Índice|⬆️ Voltar ao Índice]]
