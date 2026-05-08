---
name: wsd-finish
description: Finish a Wolff Spec Driven development session. Use when the user says wsd-finish, finalizar WSD, fim WSD, finish WSD, encerrar sessão, or asks to close work in a WSD-governed repository.
---

# WSD Finish

## Purpose

Close a development session with a standardized Git and WSD report.

## Procedure

Run:

```bash
git status --short --branch
git diff --stat
git diff --check
git log -1 --date=short --pretty='last=%ad | %h | %s'
```

If WSD exists:

```bash
bash scripts/wsd_check.sh --risk L0 .
```

If PR may exist:

```bash
gh pr status 2>/dev/null || true
gh pr view --json number,title,state,isDraft,headRefName,baseRefName,url 2>/dev/null || true
```

4. Ask the user:

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
- List: items in progress (file:line if applicable)
- List: immediate next steps
- Current branch and files with uncommitted changes
- Relevant references to STATE.md

Report:

- repo and host;
- branch and upstream;
- clean/dirty state;
- changed files;
- commits created;
- PR/spec links;
- validation commands run and result;
- validation not run and reason;
- risks or blockers;
- next safe step.

## Boundary

Do not hide dirty state. Do not auto-commit, auto-merge, clean, reset, stash, or switch branches just to make the report clean.

