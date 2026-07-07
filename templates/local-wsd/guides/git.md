# Guia — Git/GitHub Governance (on-demand)

Leia este guia antes de operar branch, PR, push ou sincronização. As políticas
concretas do projeto estão em `+context.json` → `git_governance`.

## Regras por modo

- **none**: só a política Git mínima do WSD core (este guia, seção "Sempre").
- **basic**: rodar `./+wsd/bin/wsd git preflight` antes de operações arriscadas,
  push ou troca de branch. Hooks `pre-commit`/`commit-msg`/`pre-push` ativos.
- **full**: tudo do basic + `./+wsd/bin/wsd git pr-check` antes de criar ou
  atualizar PR; PR deve referenciar Issue/spec quando aplicável; templates em `.github/`.

## Sempre

1. Entrada: `git status --short --branch && git remote -v`.
2. Worktree suja que você não criou → **pausa obrigatória** (ver AGENTS.md).
   Sujeira da própria sessão → seguir normalmente e fechar com `wsd finish`.
3. Branch nova nasce da branch principal declarada; nomenclatura conforme
   `git_governance.branch_naming`.
4. Sync: `git pull --ff-only` (ou o declarado em `sync_policy`).
5. Commits: Conventional Commits 1.0.0, imperativo, lowercase, sem ponto final.
6. Proibido sem decisão humana explícita: `git reset --hard`, `git clean -fd`,
   force push em branch compartilhada, apagar branch/tag de terceiros.

## Comandos

```bash
./+wsd/bin/wsd git doctor      # diagnóstico: remote, branch, upstream, gh
./+wsd/bin/wsd git preflight   # gate antes de operações arriscadas
./+wsd/bin/wsd git pr-check    # valida branch/commits/PR (modo full)
./+wsd/bin/wsd hooks           # reinstala git hooks após clone
```

## Git hooks instalados

- `pre-commit` — valida contrato WSD antes de cada commit
- `commit-msg` — valida Conventional Commits 1.0.0
- `pre-push` — valida estado WSD antes de push

Fonte versionada: `scripts/git-hooks/`.
