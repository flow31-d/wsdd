---
name: wsd-start
description: Start a Wolff Spec Driven development session. Use when the user says wsd-start, iniciar WSD, início WSD, start WSD, or asks to begin work in a repository governed by WSD.
---

# WSD Start

## Purpose

Open a development session without implementing changes.

## Procedure

1. Identify target repository from user text or current directory.
2. Run:

```bash
git status --short --branch
git branch -vv
git remote -v
git remote show origin
```

3. Load base context:

- Read `+specs/project/STATE.md` — summarize active decisions and blockers
- Read `+specs/HANDOFF.md` if it exists — summarize and ask "Continuar de onde parou?"
- Read `AGENTS.md` if present
- Read `.context.json` if present — identify write_paths, forbidden_paths, wsd.risk_default

4. If WSD exists, run:

```bash
bash scripts/wsd_check.sh --risk L0 .
```

5. Discover:

```bash
find +specs/features -maxdepth 2 -name 'spec.md' 2>/dev/null | sort
gh pr list --state open --limit 20 2>/dev/null || true
```

6. Auto-sizing: classify the task requested by the user:

- **L0 / Quick**: ≤3 files, local and reversible change → implement directly
- **L1**: feature, endpoint, integration, refactoring → `/wsd-specify` → (design) → (tasks) → implement
- **L2**: production, deploy, database, auth, secrets → 4 phases + await human approval

7. Report:

- repo;
- host/path;
- branch/upstream;
- worktree clean/dirty;
- context present/missing;
- specs found;
- initial risk classification;
- next safe action.

## Boundary

Do not implement changes during start routine unless the user explicitly asks after the opening report.

