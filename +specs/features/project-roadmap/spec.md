---
title: "Spec — Project ROADMAP (v0.1.1)"
created: 2026-05-11
modified: 2026-05-11
type: spec
status: implemented
risk_level: L1
feature_slug: project-roadmap
version: v0.1.1
tags:
  - wsd
  - roadmap
  - installer
  - artefatos
---

# Spec — Project ROADMAP

## Contexto

O WSD instala `+specs/project/PROJECT.md` e `+specs/project/STATE.md` como artefatos padrão.
Falta um documento de visão consolidada: uma única fonte que mostra todas as features do projeto —
planejadas, especificadas, em andamento, entregues e descartadas — com link para cada spec.

Hoje, para saber o status geral de um projeto WSD, é necessário abrir cada
`+specs/features/<slug>/spec.md` individualmente. Isso quebra o fluxo de planejamento
e dificulta a priorização por parte do operador humano e do agente.

O `ROADMAP.md` é o backlog vivo do projeto: uma tabela de features com status rastreável,
linking para specs e instruções para que o agente o mantenha atualizado automaticamente.

## Fora de Escopo

- Automação de atualização do ROADMAP.md por hook ou watcher
- Integração com GitHub Projects ou Jira
- Geração de gráfico de progresso ou métricas
- Validação de consistência entre status do ROADMAP.md e frontmatter das specs (fica para versão futura)

---

## Acceptance Criteria

### AC-1 — ROADMAP.md criado no install

WHEN `wsd-method install` é executado em qualquer projeto (greenfield ou brownfield),
THEN o arquivo `+specs/project/ROADMAP.md` deve existir no diretório instalado,
SHALL conter: legenda de status, tabela de Features Ativas, seção Backlog, seção Concluídas, seção Descartadas e bloco de Instruções para Agentes.

### AC-2 — Template com variável de projeto

WHEN o installer renderiza o ROADMAP.md,
THEN o cabeçalho SHALL exibir o nome do projeto a partir de `{{project_name}}` (mesmo mecanismo de `+context.json.template`),
SHALL o arquivo ser válido markdown independente do valor da variável.

### AC-3 — Instrução em `/wsd-specify` para atualizar ROADMAP.md

WHEN um agente executa `/wsd-specify` para criar uma nova spec,
THEN o comando SHALL instruir o agente a adicionar uma linha em `+specs/project/ROADMAP.md` com status `specified` e link para a nova spec,
SHALL a instrução aparecer na seção de encerramento do comando (após a criação da spec).

### AC-4 — ROADMAP.md mencionado no AGENTS.md gerado

WHEN `wsd-method install` gera o `AGENTS.md` do projeto,
THEN o arquivo SHALL mencionar `+specs/project/ROADMAP.md` como artefato obrigatório de planejamento,
SHALL incluir a regra: ao mudar status de feature, atualizar tanto o frontmatter da spec quanto a linha no ROADMAP.md.

### AC-5 — `wsd check` avisa se ROADMAP.md ausente em L1/L2

WHEN `wsd check` é executado em projeto com `risk_level` L1 ou L2,
THEN SHALL emitir `warn:` se `+specs/project/ROADMAP.md` não existir,
SHALL não emitir erro em L0 (task card não exige planejamento formal de features).

### AC-6 — Teste de instalação automático

WHEN `npm run test:install` ou `npm run test:install-claude` é executado,
THEN SHALL verificar que `+specs/project/ROADMAP.md` existe no diretório instalado,
SHALL o teste falhar se o arquivo estiver ausente.
