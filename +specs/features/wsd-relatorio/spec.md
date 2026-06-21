---
title: WSD Relatorio
status: done
risk: L1
owner: Codex
created: 2026-06-21
updated: 2026-06-21
---

# WSD Relatorio

## Contexto

O operador precisa pedir uma visão geral do projeto sem lembrar quais arquivos WSD devem ser lidos. O comando deve consolidar estado atual, implementação em andamento, ordem provável de execução, ideias, concerns e uma recomendação prática.

## Acceptance Criteria

- WHEN o operador rodar `./+wsd/bin/wsd relatorio` THEN o CLI SHALL imprimir um relatório Markdown com estado Git/WSD, implementações em andamento, plano programado, ideias, concerns e sugestão do agente.
- WHEN o operador rodar `./+wsd/bin/wsd relatorio --save` THEN o CLI SHALL salvar o mesmo relatório em `+specs/RELATORIO.md`.
- WHEN o relatório encontrar ideias ou concerns sem pipeline THEN ele SHALL indicar explicitamente o desalinhamento.
- WHEN o relatório encontrar feature `in-progress`, spec aberta ou concern ativa THEN ele SHALL refletir isso na sugestão final.
- WHEN agentes Codex ou Claude receberem pedido de relatório WSD THEN os artefatos instalados SHALL apontar para `./+wsd/bin/wsd relatorio`.

## Fora de Escopo

- Não usar modelo externo para gerar julgamento livre.
- Não alterar automaticamente ROADMAP, IDEAS ou CONCERNS.
- Não commitar ou limpar worktree.
