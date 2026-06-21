---
description: Atalho WSD Loop. Use como /loop status, /loop on, /loop off, /loop auto status, /loop plan <feature>, /loop once <feature> ou /loop run <feature>.
argument-hint: "status | auto status|on|off | on | off | plan FEATURE | once FEATURE | run FEATURE"
allowed-tools:
  - Bash
  - Read
---

# /loop — WSD Loop

## Objetivo

Interpretar os argumentos do operador como comando curto do Ralph/WSD Loop.

Argumentos recebidos:

```text
$ARGUMENTS
```

## Mapeamento

- `status` -> `./+wsd/bin/wsd loop status`
- `auto status` -> `./+wsd/bin/wsd loop auto status`
- `auto on` ou `on` -> `./+wsd/bin/wsd loop auto on`
- `auto off` ou `off` -> `./+wsd/bin/wsd loop auto off`
- `plan FEATURE` -> `./+wsd/bin/wsd loop plan --feature FEATURE`
- `once FEATURE` -> `./+wsd/bin/wsd loop once --feature FEATURE`
- `run FEATURE` -> verificar `+context.json`, spec aprovada, worktree limpa e política L2 antes de executar.

## Regras

1. Para `status` e toggles `auto`, execute direto.
2. Para `plan`, `once` ou `run`, leia `+context.json` e `+specs/features/<feature>/spec.md` antes.
3. Nunca contorne aprovação humana L2.
4. Ao final, reporte o comando executado e o estado resultante.
