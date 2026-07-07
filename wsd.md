---
title: "WSD — Hub do Método"
created: 05/05/2026
modified: 2026-07-07
tags:
  - wsd
  - hub
  - metodologia
status: ativo
tipo: hub
parent: "[[x]]"
links: "[[x]], [[wsd/README]], [[wsd/ROADMAP]], [[wsd/CHANGELOG]], [[wsd/AGENTS]], [[wsd/docs/10_matriz_sincronizacao_notas]]"
---
# WSD — Hub do Método

[[x|← x — Interface IA]]

Versão atual: **`v0.5.1`** — detalhes em [[wsd/CHANGELOG|CHANGELOG]]. Visão
geral e instalação: [[wsd/README|README]].

## Mapa

| Documento | Quando abrir | Responde |
|---|---|---|
| [[wsd/docs/00_planejamento_instalacao_wsd\|00 Planejamento]] | desenhar instalador | como instalar WSD por projeto |
| [[wsd/docs/01_constituicao\|01 Constituição]] | criar/adaptar regras | princípios invioláveis |
| [[wsd/docs/02_matriz_risco\|02 Matriz de Risco]] | classificar tarefa | quando usar L0, L1 ou L2 |
| [[wsd/docs/03_ciclo_operacional\|03 Ciclo Operacional]] | durante sessão | abrir, executar, fechar trabalho |
| [[wsd/docs/04_playbook_implantacao\|04 Playbook]] | colocar WSD em um repo | sequência de bootstrap |
| [[wsd/docs/05_contrato_artefatos\|05 Contrato de Artefatos]] | editar templates | formato de +context.json, specs, logs |
| [[wsd/docs/06_personalizacao_por_projeto\|06 Personalização]] | adaptar a um projeto | o que é global vs local |
| [[wsd/docs/07_git_governance\|07 Git Governance]] | mexer em branch/PR | política Git para agentes |
| [[wsd/docs/08_rotinas_sessao\|08 Rotinas de Sessão]] | início/fim de sessão | checklist operacional |
| [[wsd/docs/09_publicacao_github_privado\|09 Publicação]] | tag/release | como publicar e versionar |
| [[wsd/docs/10_matriz_sincronizacao_notas\|10 Matriz de Sincronização]] | antes de finalizar mudança | quais arquivos mudam juntos |
| [[wsd/docs/11_modulo_git_governance\|11 Módulo Git Governance]] | política Git instalável | módulo git-governance |
| [[wsd/docs/12_avaliacao_critica\|12 Avaliação Crítica]] | revisar o método | o que funciona e o que falta |
| [[wsd/docs/13_compatibilidade_claude_code\|13 Claude Code]] | suporte Claude Code | skills, hooks, diferenças Codex |
| [[wsd/docs/14_qualidade_desenvolvimento\|14 Qualidade]] | auto-sizing, WHEN/THEN/SHALL | padrões TLC adotados |
| [[wsd/docs/15_repositorio_publico_e_quick_start\|15 Repo Público]] | sync privado→wsdd | estratégia público × privado |
| [[wsd/docs/16_wdb_snapshot_integration\|16 WDB Snapshot]] | integrar dashboard | schema do snapshot |
| [[wsd/docs/17_snapshot_campos_explicados\|17 Snapshot Campos]] | entender snapshot | campo a campo em linguagem simples |
| [[wsd/docs/18_manual_leigo_comandos_wsdd\|18 Manual Leigo]] | usar sem conhecer o método | comandos em linguagem simples |
| [[wsd/docs/19_wsd_loop_automacao_inteligente\|19 WSD Loop]] | automação L0/L1 | contrato automation.loop e gates |

## Estado atual

O estado vivo do projeto (features em andamento, plano, ideias, concerns) está
em `+specs/project/` — gere a visão consolidada com `./+wsd/bin/wsd relatorio`.
Não há resumo de estado duplicado neste hub: fonte única.

## Decisões de design permanentes

- WSD não depende de projeto específico: Prescreve Mais, Koomplet Office etc.
  são perfis (`profiles/`), não a metodologia.
- Dogfooding: o WSD gerencia o próprio desenvolvimento com WSD (`+specs/`,
  `+wsd/` na raiz são gestão do toolkit; o que chega em projetos vem só de
  `templates/`).
- `archive/` guarda histórico e pesquisa; agentes não leem nem sincronizam.
- Modo padrão `full_auto`: executa e commita até o final; única pausa é
  worktree suja de terceiros (ver [[wsd/README|README]]).

## Regra para agentes

Antes de editar qualquer repositório que use WSD: seguir `AGENTS.md` e
`+context.json` do próprio repo. Antes de editar **este** pacote: seguir
[[wsd/AGENTS|AGENTS]] e a matriz [[wsd/docs/10_matriz_sincronizacao_notas|docs/10]].
