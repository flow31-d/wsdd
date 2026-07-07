# Guia — WSD Loop / automação iterativa (on-demand)

Leia antes de usar `wsd loop`. Contrato: `+context.json` → `automation.loop`.

## Política

- `automation.loop.auto_use=true`: para tarefa L0/L1 elegível, com spec
  aprovada e worktree limpa, preferir WSD Loop antes de executar manualmente.
- `automation.loop.auto_use=false` (default): não disparar loop por conta
  própria; apenas sugerir quando fizer sentido.
- O loop nunca roda L2 sem `--human-approved` explícito
  (`require_human_for_l2=true` — automação não-supervisionada mantém o gate
  mesmo em projetos full-auto).
- Gates por iteração: paths permitidos, risco, CI declarado em `ci.*`; commit
  automático só após gates passarem; `stop_on_repeated_gate_failure=true`.

## Comandos

```bash
./+wsd/bin/wsd loop status                       # estado atual do loop
./+wsd/bin/wsd loop auto status|on|off           # toggle de auto-uso
./+wsd/bin/wsd loop plan --feature <slug>        # prepara plano de iterações
./+wsd/bin/wsd loop once --feature <slug> --agent-cmd '<cmd>'   # 1 iteração
./+wsd/bin/wsd loop run --feature <slug> --agent-cmd '<cmd>' --max-iterations 3
./+wsd/bin/wsd loop stop                         # remove lock/estado
```

Prompts vendorizados: `+wsd/loop/PROMPT_plan.md` e `+wsd/loop/PROMPT_build.md`.
No Claude Code, `/loop status|on|off` mapeia para os comandos acima; no Codex,
a skill `wsd-loop` faz o mesmo a partir de pedidos em linguagem natural.

Requisitos para rodar: spec clara com WHEN/THEN/SHALL, tasks atômicas,
worktree limpa e gates configurados em `+context.json`.
