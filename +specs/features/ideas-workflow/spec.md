---
title: "Spec — Ideas Workflow (v0.1.2)"
created: 2026-05-11
modified: 2026-05-11
type: spec
status: implemented
risk_level: L1
feature_slug: ideas-workflow
version: v0.1.2
tags:
  - wsd
  - ideas
  - skill
  - pipeline
  - installer
---

# Spec — Ideas Workflow

## Contexto

O WSD cobre bem o ciclo de desenvolvimento (specify → design → tasks → execute), mas não tem
um ponto de entrada para ideias brutas do operador humano. Hoje, uma ideia nova precisa virar
uma spec diretamente — pulando a etapa de captura informal, maturação e triagem.

O fluxo desejado é em três camadas:

```
Operador tem ideia
       ↓
  /idea-{slug}   ←  skill personalizada por projeto
       ↓
  IDEAS.md        ←  notebook de ideias brutas (captura fiel, sem julgamento)
       ↓
  IDEAS_PIPELINE.md  ←  controle de progressão: ideia → detalhada → spec → roadmap → entregue
       ↓
  /wsd-specify, ROADMAP.md, etc.  ←  fluxo WSD normal
```

**Componentes do sistema:**

1. **`+specs/project/IDEAS.md`** — notebook de captura. Ideias numeradas (IDEA-001, IDEA-002...),
   formato estruturado, fiel à voz do operador. Não é spec; é matéria-prima.

2. **`+specs/project/IDEAS_PIPELINE.md`** — índice de controle. Resumo de cada ideia com
   status de progressão no WSD, sugestão de etapa e link para artefato gerado.

3. **Skill `/idea-{project_slug}`** — comando slash Claude Code (e skill Codex) com nome
   personalizado para o projeto. O agente captura a ideia do operador, estrutura, salva em
   IDEAS.md e atualiza o pipeline.

**Sobre o `project_slug`:** derivado de `project_name` pelo installer
(`toLowerCase().replace(/\\s+/g, '-').replace(/[^a-z0-9-]/g, '')`). Disponível como
variável `{{project_slug}}` nos templates (novo campo, análogo ao `{{project_name}}` existente).

## Fora de Escopo

- Triagem automática ou scoring de ideias por IA sem ação do operador
- Versionamento de ideias (histórico de edições)
- Notificações ou lembretes de ideias pendentes
- Integração com ferramentas externas (Notion, Linear, GitHub Issues)
- Deduplicação automática de ideias similares

---

## Acceptance Criteria

### AC-1 — `IDEAS.md` criado no install

WHEN `wsd-method install` é executado em qualquer projeto (greenfield ou brownfield),
THEN `+specs/project/IDEAS.md` deve existir no diretório instalado,
SHALL conter: instruções de uso no topo, seção de formato padrão, área de captura com espaço
para IDEA-001 como exemplo comentado, e instrução de como invocar a skill.

### AC-2 — `IDEAS_PIPELINE.md` criado no install

WHEN `wsd-method install` é executado,
THEN `+specs/project/IDEAS_PIPELINE.md` deve existir no diretório instalado,
SHALL conter: tabela de status possíveis (raw → detalhada → spec-criada → em-roadmap →
implementada → descartada), tabela de sugestão de etapa por complexidade (L0/L1/L2),
tabela Pipeline vazia pronta para preenchimento e bloco de Instruções para Agentes.

### AC-3 — `project_slug` disponível como variável de template

WHEN `wsd-method install` processa templates,
THEN a variável `{{project_slug}}` SHALL estar disponível em todos os templates renderizados,
SHALL ser derivada de `project_name`: lowercase, espaços → hífens, caracteres não-alfanuméricos
removidos (ex: "Koomplet Office" → "koomplet-office", "My App!" → "my-app").

### AC-4 — Skill `/idea-{project_slug}` instalada (Claude Code)

WHEN `wsd-method install --tools claude-code` ou `--tools both` é executado,
THEN `.claude/commands/idea-{{project_slug}}.md` deve existir com o nome real do projeto
(ex: `.claude/commands/idea-koomplet-office.md`),
SHALL o arquivo conter: descrição do comando, instruções para capturar o título e motivação
da ideia do operador, lógica de incremento de ID (ler último IDEA-N de IDEAS.md e usar N+1),
formato exato de escrita em IDEAS.md e instrução de atualizar IDEAS_PIPELINE.md após salvar.

### AC-5 — Skill `wsd-idea` instalada (Codex)

WHEN `wsd-method install --tools codex` ou `--tools both` é executado,
THEN `.codex/skills/wsd-idea/SKILL.md` deve existir,
SHALL ter conteúdo equivalente ao comando Claude Code do AC-4 adaptado para o formato
de skill Codex (sem frontmatter YAML, com seção de ativação e comportamento esperado).

### AC-6 — Formato padrão de captura em `IDEAS.md`

WHEN a skill `/idea-{project_slug}` é invocada e o operador descreve uma ideia,
THEN o agente SHALL escrever em `IDEAS.md` usando o formato:
```
## IDEA-{N} — {título em uma linha}

**Data:** DD/MM/AAAA
**Motivação:** {por que isso importa para o projeto}
**Descrição:** {o que o operador quer — fiel à voz original}
**Impacto esperado:** {o que muda para o usuário ou sistema}
**Status:** `raw`
```
SHALL o ID `N` ser o próximo número disponível (último ID existente + 1, começando em 001),
SHALL o agente nunca reescrever ou editar ideias existentes — apenas acrescentar.

### AC-7 — Pipeline atualizado junto com `IDEAS.md`

WHEN a skill captura uma nova ideia e escreve em `IDEAS.md`,
THEN o agente SHALL imediatamente adicionar linha em `IDEAS_PIPELINE.md` na tabela Pipeline,
SHALL a linha conter: ID com link âncora para seção em IDEAS.md, título resumido (≤ 60 chars),
status `raw`, sugestão de etapa (L0/L1/L2 estimada pelo agente) e campo WSD artefato vazio.

### AC-8 — Progressão de status rastreável em `IDEAS_PIPELINE.md`

WHEN uma ideia avança no fluxo WSD (spec criada, entra no ROADMAP, etc.),
THEN o agente responsável pela etapa SHALL atualizar o status da linha correspondente
em `IDEAS_PIPELINE.md` e preencher o campo "WSD artefato" com o caminho do artefato criado,
SHALL os status válidos serem apenas: `raw`, `detalhada`, `spec-criada`, `em-roadmap`,
`implementada`, `descartada` (qualquer outro valor é inválido).

### AC-9 — `IDEAS.md` e `IDEAS_PIPELINE.md` mencionados no `AGENTS.md` gerado

WHEN `wsd-method install` gera o `AGENTS.md` do projeto,
THEN SHALL mencionar ambos os arquivos como artefatos de planejamento de ideias,
SHALL incluir a regra: ao avançar uma ideia para spec ou ROADMAP, atualizar o status em
`IDEAS_PIPELINE.md`.

### AC-10 — Testes de instalação automáticos

WHEN `npm run test:install` é executado,
THEN SHALL verificar que `+specs/project/IDEAS.md` existe no diretório instalado,
SHALL verificar que `+specs/project/IDEAS_PIPELINE.md` existe,
SHALL verificar que `.claude/commands/idea-*.md` existe (glob) para test:install-claude.
