---
title: "WDB — Integração com Snapshots de Projeto"
created: 11/05/2026
modified: 11/05/2026
tags:
  - wsd
  - wdb
  - snapshot
  - dashboard
status: ativo
tipo: referencia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/docs/05_contrato_artefatos]]"
otimizado_para_obsidian: true
---

# WDB — Integração com Snapshots de Projeto

[[wsd/wsd|← WSD]]

---

> [!abstract] Visão Geral
> Cada projeto WSD pode gerar um arquivo `+wsd/snapshot.json` com visão geral do estado atual do projeto. O `wdb` (dashboard da VPS) lê esses arquivos para apresentar cards de status por projeto.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. Como Funciona]]
3. [[#3. Localização dos Arquivos]]
4. [[#4. Schema do Snapshot]]
5. [[#5. Como o wdb Consome]]
6. [[#6. Quando o Snapshot é Gerado]]
7. [[#7. Regras para os Agentes]]
8. [[#8. 🕒 Registro de Alterações por Agentes]]

---

## 1. 🔄 Atualizações

- 11/05/2026 — Claude: Criação do documento. Definição do schema v1, estratégia de arquivo único por projeto, integração via polling do wdb.

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 2. Como Funciona

```text
Projeto WSD
  └── +wsd/
        └── snapshot.json   ← gerado por: wsd snapshot
                                atualizado por: git post-commit hook + wsd finish

wdb (dashboard)
  └── lê snapshot.json de cada projeto configurado
  └── apresenta cards de status
  └── polling a cada 2-3 minutos (crontab)
```

Não há histórico acumulado. O `snapshot.json` é sempre sobrescrito com o estado atual. Se precisar de histórico, isso é opt-in e requer feature separada.

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 3. Localização dos Arquivos

Cada projeto tem **um único arquivo**, sempre no mesmo path:

```
/path/para/o/projeto/+wsd/snapshot.json
```

Exemplos reais na VPS:

```
/srv/CLI/+Apps/wdb/+wsd/snapshot.json
/srv/CLI/+Apps/WSD/+wsd/snapshot.json
/srv/projetos/meu-app/+wsd/snapshot.json
```

> [!tip] Configuração do wdb
> O `wdb` deve manter uma lista de paths absolutos para ler. Exemplo de config:
> ```json
> {
>   "snapshot_paths": [
>     "/srv/CLI/+Apps/WSD/+wsd/snapshot.json",
>     "/srv/projetos/meu-app/+wsd/snapshot.json"
>   ]
> }
> ```

O **slug do projeto** (`project.slug`) e o **nome** (`project.name`) estão dentro do JSON — o wdb não precisa inferir identidade pelo path.

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 4. Schema do Snapshot

Versão: `wsd/project-snapshot/v1`

```json
{
  "schema": "wsd/project-snapshot/v1",
  "generated_at": "2026-05-11T14:30:00-03:00",

  "project": {
    "name": "Meu Projeto",
    "slug": "meu-projeto",
    "type": "generic_node_frontend"
  },

  "git": {
    "branch": "feat/nova-feature",
    "is_dirty": true,
    "ahead_count": 3,
    "last_commit_message": "feat: adiciona tela de login"
  },

  "session": {
    "handoff_exists": true,
    "open_specs": ["auth-flow", "dashboard-ui"]
  },

  "roadmap": {
    "total": 8,
    "by_status": {
      "planned": 3,
      "in-progress": 2,
      "done": 2,
      "cancelled": 1
    },
    "items": [
      { "id": "auth-flow",    "title": "Autenticação OAuth2",  "status": "in-progress" },
      { "id": "dashboard-ui", "title": "Dashboard principal",   "status": "in-progress" }
    ]
  },

  "ideas": {
    "total": 12,
    "by_status": {
      "raw": 7,
      "spec-criada": 2,
      "implementada": 3
    },
    "items": [
      { "id": "IDEA-001", "title": "Dark mode no dashboard",  "status": "raw" },
      { "id": "IDEA-002", "title": "Exportar relatório PDF",  "status": "spec-criada" }
    ]
  },

  "state": {
    "active_blockers": 1,
    "total_decisions": 15
  },

  "health": {
    "last_check_passed": true,
    "ghost_specs_detected": 0
  }
}
```

### Regras do schema

| Campo | Tipo | Fonte |
|---|---|---|
| `schema` | string fixo | `"wsd/project-snapshot/v1"` |
| `generated_at` | ISO-8601 | timestamp de geração |
| `project.name` | string | `+context.json` |
| `project.slug` | string | derivado de `project.name` |
| `project.type` | string | `+context.json` |
| `git.branch` | string | `git branch --show-current` |
| `git.is_dirty` | boolean | `git status --porcelain` |
| `git.ahead_count` | number | `git rev-list --count @{u}..HEAD` |
| `git.last_commit_message` | string ≤ 72 chars | `git log -1 --format=%s` |
| `session.handoff_exists` | boolean | `test -f +specs/HANDOFF.md` |
| `session.open_specs` | string[] | specs com status `in-progress` no ROADMAP |
| `roadmap.items[].title` | string ≤ 60 chars | cabeçalho da feature no ROADMAP.md |
| `ideas.items[].title` | string ≤ 60 chars | título da ideia em IDEAS_PIPELINE.md |
| `state.active_blockers` | number | contagem em STATE.md |
| `health.last_check_passed` | boolean | resultado do último `wsd check` |
| `health.ghost_specs_detected` | number | specs aprovadas sem WHEN/THEN/SHALL |

> [!warning] Limite de título: 60 caracteres
> Agentes devem escrever títulos de features e ideias com **no máximo 60 caracteres**. O gerador do snapshot trunca automaticamente, mas títulos longos indicam falta de clareza — o limite é uma restrição de qualidade, não só de UI.

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 5. Como o wdb Consome

O wdb deve:

1. Ler a lista de `snapshot_paths` da própria config
2. Para cada path: ler o JSON e verificar `schema === "wsd/project-snapshot/v1"`
3. Se o arquivo não existir ou for inválido: mostrar card de erro com label "snapshot ausente"
4. Exibir card por projeto com os campos disponíveis
5. Usar `generated_at` para mostrar "há X minutos" e alertar se > 30 minutos (snapshot desatualizado)

### Sugestão de card no dashboard

```
┌─────────────────────────────────────────────┐
│ Meu Projeto                    feat/auth ●  │
│ Roadmap: 2/8 done  Ideas: 7 raw  ⚠ 1 bloco │
│ in-progress: Autenticação OAuth2             │
│              Dashboard principal             │
│ atualizado há 3 min                         │
└─────────────────────────────────────────────┘
```

Legenda de ícones sugerida:
- `●` — branch suja (is_dirty = true)
- `⚠` — blockers ou ghost specs
- `📋` — handoff aberto (sessão incompleta)

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 6. Quando o Snapshot é Gerado

| Gatilho | Como |
|---|---|
| `wsd snapshot` | comando manual |
| `wsd finish` | automático ao fechar sessão |
| git post-commit hook | automático a cada commit |

### Polling do wdb

Recomendação: **crontab a cada 2-3 minutos**.

```cron
*/2 * * * * /caminho/para/wdb/scripts/refresh-snapshots.sh
```

O script de refresh pode simplesmente recarregar os JSONs em memória ou gravar em cache. Não precisa de daemon — o `wsd` gera o arquivo, o wdb lê quando quiser.

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 7. Regras para os Agentes

- **Não editar `+wsd/snapshot.json` manualmente** — sempre gerado pelo CLI `wsd snapshot`
- **Títulos ≤ 60 chars** em ROADMAP.md e IDEAS_PIPELINE.md — o snapshot usa esses títulos
- O arquivo `+wsd/snapshot.json` deve ser adicionado ao `.gitignore` do projeto — é estado local, não versionado
- Se `wsd check` falhar, `health.last_check_passed` será `false` — não mascarar falhas

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 8. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 11/05/2026 — | Claude | `+Apps/WSD/docs/16_wdb_snapshot_integration.md` | Criação do documento. Schema v1, localização de arquivo único por projeto, integração via polling crontab, regras de título ≤ 60 chars. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
