# Guia — Party Mode (on-demand)

Sistema de orquestração multi-agente para decisões de spec, arquitetura, risco
e code review. 26 agentes WSD-aware, 2-3 selecionados automaticamente por
contexto por sessão.

## Quando usar

- Spec L1/L2 com trade-offs não óbvios.
- Fases SPECIFY (brainstorm) ou DESIGN (arquitetura) — nunca em EXECUTE.
- Antes de decisão L2 com impacto de produção.

## Quando pular

L0 trivial, hotfix urgente, decisão já tomada, tarefa em EXECUTE.

## Comandos

```bash
./+wsd/bin/wsd party status       # verifica instalação
./+wsd/bin/wsd party list-agents  # lista os 26 agentes
./+wsd/bin/wsd party when-to-use  # decision tree
```

No Claude Code: `/wsd-party-mode`. Assets em `+wsd/party-mode/`; referência
completa em `+wsd/party-mode/WHEN_TO_USE.md`. Output de cada sessão:
`+specs/features/<slug>/PARTY_ANALYSIS.md`.
