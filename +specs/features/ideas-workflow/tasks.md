---
title: "Tasks — Ideas Workflow (v0.1.2)"
created: 2026-05-11
modified: 2026-05-11
type: tasks
status: implemented
feature_slug: ideas-workflow
tags:
  - wsd
  - ideas
  - pipeline
---

# Tasks — Ideas Workflow

Referência: `+specs/features/ideas-workflow/spec.md`

---

## T1 — Criar `templates/specs/IDEAS.md.template`

- [x] Criar `templates/specs/IDEAS.md.template`
- [x] Conteúdo: cabeçalho com `{{project_name}}`, bloco de instruções de uso (como invocar
      `/idea-{{project_slug}}`), seção de formato padrão (campos: Data, Motivação, Descrição,
      Impacto esperado, Status), espaço comentado para IDEA-001 como exemplo
- [x] Garantir que `{{project_slug}}` aparece na instrução de invocação do comando
- [x] Verificar que markdown é válido sem ideias preenchidas

Cobre: AC-1

---

## T2 — Criar `templates/specs/IDEAS_PIPELINE.md.template`

- [x] Criar `templates/specs/IDEAS_PIPELINE.md.template`
- [x] Conteúdo: cabeçalho com `{{project_name}}`, tabela de status possíveis (raw →
      detalhada → spec-criada → em-roadmap → implementada → descartada), tabela de sugestão
      de etapa por complexidade (L0: task card / L1: /wsd-specify + ROADMAP / L2:
      /wsd-specify + /wsd-design + ROADMAP), tabela Pipeline vazia com colunas
      (ID | Título | Status | Etapa sugerida | WSD artefato | Notas),
      bloco de Instruções para Agentes com as 6 regras de progressão
- [x] Confirmar que `{{project_name}}` e `{{project_slug}}` são usados corretamente

Cobre: AC-2

---

## T3 — Criar `templates/claude-commands/commands/wsd-idea.md`

- [x] Criar `templates/claude-commands/commands/wsd-idea.md`
- [x] Frontmatter: `description`, `argument-hint: "[descreva sua ideia]"`, `allowed-tools: [Read, Edit, Write]`
- [x] Corpo (instruções para o agente):
  - Se ideia passada como argumento: usar. Se não: perguntar ao operador ("Qual é a sua ideia?")
  - Perguntar motivação se não for óbvio ("Por que isso importa para o projeto?")
  - Determinar próximo ID: ler `+specs/project/IDEAS.md`, localizar último `## IDEA-{N}`,
    usar N+1 (se IDEAS.md vazio, começar em 001)
  - Escrever ideia em `+specs/project/IDEAS.md` no formato exato do AC-6
  - Estimar complexidade (L0/L1/L2) com base no escopo descrito pelo operador
  - Adicionar linha em `+specs/project/IDEAS_PIPELINE.md` com status `raw` e etapa sugerida
  - Confirmar ao operador: "Ideia IDEA-{N} — {título} registrada. Sugestão de etapa: {etapa}."
- [x] Incluir seção Regras: nunca sobrescrever ideias, sempre incrementar ID, ser fiel à voz
      do operador sem interpretar demais, sugestão de etapa é orientativa
- [x] O arquivo no template usa `{{project_name}}` no corpo para personalizar a confirmação;
      o installer salva como `idea-{{project_slug}}.md` (ver T5)

Cobre: AC-4, AC-6, AC-7

---

## T4 — Criar `templates/codex-skills/wsd-idea/SKILL.md`

- [x] Criar `templates/codex-skills/wsd-idea/SKILL.md`
- [x] Adaptar o conteúdo do T3 para o formato Codex (sem frontmatter YAML)
- [x] Incluir seção de ativação: "Use quando o operador menciona 'tenho uma ideia', 'registrar ideia', 'nova ideia' ou invoca a skill diretamente"
- [x] Manter os mesmos passos de captura, incremento de ID e atualização do pipeline
- [x] O installer copia como `.codex/skills/wsd-idea/SKILL.md` (nome fixo, sem rename)

Cobre: AC-5

---

## T5 — Atualizar `bin/wsd-method.js`

### T5a — Adicionar `project_slug` como variável de template

- [x] Após capturar `project_name` (interativo ou de perfil), computar:
      `project_slug = project_name.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9-]/g, '')`
- [x] Disponibilizar `{{project_slug}}` em todos os calls de `renderTemplate()`
- [x] Adicionar `project_slug` ao `+context.json` gerado (novo campo ao lado de `project_name`)

Cobre: AC-3

### T5b — Copiar `IDEAS.md` e `IDEAS_PIPELINE.md` no install

- [x] Localizar a função que copia `STATE.md` e `PROJECT.md` para `+specs/project/`
- [x] Adicionar: renderizar e copiar `IDEAS.md.template` → `+specs/project/IDEAS.md`
- [x] Adicionar: renderizar e copiar `IDEAS_PIPELINE.md.template` → `+specs/project/IDEAS_PIPELINE.md`
- [x] Garantir que ocorre em greenfield e brownfield
- [x] Registrar no log de instalação

Cobre: AC-1, AC-2

### T5c — Instalar skill `/idea-{project_slug}` (Claude Code)

- [x] Em `installClaudeCommands()`: após copiar os comandos wsd-*, adicionar cópia especial de
      `wsd-idea.md` com rename dinâmico para `idea-{project_slug}.md`
- [x] Renderizar `{{project_name}}` e `{{project_slug}}` no conteúdo antes de salvar
- [x] Verificar que o arquivo salvo tem o nome correto (ex: `idea-koomplet-office.md`)

Cobre: AC-4

### T5d — Instalar skill `wsd-idea` (Codex)

- [x] Em `installCodexSkills()`: copiar `templates/codex-skills/wsd-idea/` → `.codex/skills/wsd-idea/`
- [x] Renderizar `{{project_name}}` e `{{project_slug}}` no SKILL.md

Cobre: AC-5

---

## T6 — Atualizar `templates/repo/AGENTS.md.template`

- [x] Localizar seção de artefatos de projeto no template
- [x] Adicionar `+specs/project/IDEAS.md` e `+specs/project/IDEAS_PIPELINE.md` como artefatos
      de planejamento de ideias
- [x] Adicionar regra: ao avançar ideia para spec ou ROADMAP, atualizar status em
      `IDEAS_PIPELINE.md` — campo "WSD artefato" deve conter o caminho do artefato criado
- [x] Mencionar a skill `/idea-{{project_slug}}` como ponto de entrada para novas ideias

Cobre: AC-9

---

## T7 — Atualizar `npm test`

### T7a — `test:install` (Codex)
- [x] Adicionar `test -f "$tmpdir/+specs/project/IDEAS.md"` na cadeia de assertions
- [x] Adicionar `test -f "$tmpdir/+specs/project/IDEAS_PIPELINE.md"`

### T7b — `test:install-claude` (Claude Code)
- [x] Adicionar `test -f "$tmpdir/+specs/project/IDEAS.md"`
- [x] Adicionar `test -f "$tmpdir/+specs/project/IDEAS_PIPELINE.md"`
- [x] Adicionar verificação de `idea-*.md` em `.claude/commands/`:
      `ls "$tmpdir/.claude/commands/idea-"*.md >/dev/null`

### T7c — `test:install-brownfield`
- [x] Adicionar mesmas verificações de IDEAS.md e IDEAS_PIPELINE.md

Cobre: AC-10

---

## T8 — Sync documental

- [x] `CHANGELOG.md`: adicionar seção `0.1.2` descrevendo os 3 componentes (IDEAS.md,
      IDEAS_PIPELINE.md, skill `/idea-{project_slug}`)
- [x] `ROADMAP.md` (WSD próprio): marcar `ideas-workflow` como entregue com `[x]` na Fase 5
- [x] `README.md`: atualizar versão para `v0.1.2` e listar os novos artefatos instalados
      na seção "Ideia Central" ou "Uso Oficial"
- [x] `docs/05_contrato_artefatos.md`: adicionar `+specs/project/IDEAS.md` e
      `+specs/project/IDEAS_PIPELINE.md` na lista de artefatos padrão; documentar `project_slug`
      como novo campo do `+context.json`
- [x] `docs/10_matriz_sincronizacao_notas.md`: adicionar linhas para os novos artefatos e
      para a skill `/idea-{project_slug}` na Matriz Obrigatória
- [x] `+specs/project/STATE.md` (WSD próprio): registrar decisão e marcar task como concluída
- [x] `schemas/context.schema.json`: adicionar campo `project_slug` (type string, pattern
      `^[a-z0-9-]+$`) como campo obrigatório ao lado de `project_name`

Cobre: consistência documental e contrato de artefatos

---

## T9 — Bump de versão

- [x] `package.json`: `0.1.1` → `0.1.2`
- [x] Confirmar que `npm test` passa com todos os novos gates

Cobre: release patch

---

## Ordem de Execução

```
T1 → T2 → T3 → T4            (templates: independentes entre si, podem ser paralelos)
                ↓
              T5a              (project_slug no installer: pré-requisito para T5b/T5c/T5d)
                ↓
         T5b + T5c + T5d      (copies no installer: podem ser paralelos)
                ↓
           T6 + T7             (AGENTS.md e testes: podem ser paralelos)
                ↓
               T8              (sync documental: após tudo testado)
                ↓
               T9              (bump de versão: sempre por último)
```

**Atenção:** T5a deve vir antes de T5b/T5c/T5d porque `project_slug` precisa estar disponível
para renderização dos templates. T9 sempre por último — nunca bumpar antes de todos os
testes passarem.
