---
name: wsd-finish
description: Finish a Wolff Spec Driven development session with approval gates, WSD docs audit when available, HANDOFF.md, snapshot, and a clean worktree. Use when the user says wsd-finish, finalizar WSD, fim WSD, finish WSD, encerrar sessão, fechar limpo, or asks to close work in a WSD-governed repository.
---

# WSD Finish

## Purpose

Close a development session with approval gates and a clean Git worktree.

## Procedure

Prefer the local command:

```bash
./+wsd/bin/wsd finish
```

The command runs:

```bash
git status --short --branch
git diff --stat
git diff --check
git log -1 --date=short --pretty='last=%ad | %h | %s'
```

It also runs, when available:

```bash
bash scripts/wsd_check.sh --risk L0 .
bash scripts/wsd_docs_check.sh
```

If PR may exist:

```bash
gh pr status 2>/dev/null || true
gh pr view --json number,title,state,isDraft,headRefName,baseRefName,url 2>/dev/null || true
```

4. Ask the user when interactive:

> Houve decisões, bloqueadores ou lições aprendidas nessa sessão?

If yes, update `+specs/project/STATE.md`:
- New decision → Decisões table
- Active blocker → Bloqueadores Ativos table
- Lesson learned → Lições Aprendidas table
- Out-of-scope idea → Ideias Adiadas table

5. Generate `+specs/HANDOFF.md` with:
- Date and time ISO
- Current feature/task and summarized status
- List: items completed in this session
- List: changes captured by finish
- List: immediate next steps
- Current branch and approval gates
- Relevant references to STATE.md

6. Let `wsd finish` create the closing commit by default.
   It must only succeed with a clean `git status --short`.

Report:

- repo and host;
- branch and upstream;
- clean final state;
- changed files;
- commits created;
- PR/spec links;
- validation commands run and result;
- validation not run and reason;
- risks or blockers;
- next safe step.

## Boundary

Do not use `git reset`, `git stash`, `git clean`, `git commit --no-verify`, auto-push, or auto-merge to fake a clean close.
If gates, hooks, or sensitive path checks fail, stop and report the blocker.
