---
name: wsd
description: Govern development in repositories that use Wolff Spec Driven. Use when asked to operate, audit, report, bootstrap, customize, or enforce WSD artifacts such as AGENTS.md, +context.json, +specs, +specs/project/STATE.md, +specs/project/CONCERNS.md, +specs/project/CONCERNS_PIPELINE.md, scripts/wsd_check.sh, Git branches, PRs, validation gates, host topology, or L0/L1/L2 classification.
---

# WSD Governance

## Core Rule

Treat Git as the history layer and WSD as the intent/risk/validation layer. Do not edit a repository until repo, host, branch, dirty state, risk level, allowed paths, and required spec are clear.

## Entry Checks

```bash
git status --short --branch
git branch -vv
git remote -v
git remote show origin
```

If `+context.json` exists:

```bash
./+wsd/bin/wsd start --brief 2>/dev/null || true
bash scripts/wsd_check.sh --risk L0 .
```

If the user asks for a WSD report, project overview, current state, active plan, ideas, concerns, or what should be done next:

```bash
./+wsd/bin/wsd relatorio
```

## Risk

- L0: small local change; Task Card is enough.
- L1: feature, integration, automation, endpoint, structural change; approved spec required.
- L2: production, deploy, DB, auth, secrets, network, sensitive data, availability; human approval and rollback required.

## Required Behavior

- Respect `AGENTS.md`.
- Respect `+context.json`.
- Treat the `WSD Codex Bootstrap` section in `AGENTS.md` as the default startup contract when present.
- For report/overview requests, prefer `./+wsd/bin/wsd relatorio` over manually scanning each WSD file.
- Read `+specs/project/CONCERNS.md` and `+specs/project/CONCERNS_PIPELINE.md` before editing; check active concerns touching the target area.
- If a fragile component, risk, debt, workaround, unstable dependency, L2 area, or "needs verification" item appears, register it immediately in both concerns files.
- Load `+specs/context/*.md` selectively.
- If editing WSD documentation, templates, profiles, skills, installer, package version, or release notes, read `+wsd/docs/10_matriz_sincronizacao_notas.md` when present and update the related files listed there.
- Require approved spec for L1/L2.
- Do not use `git add .` manually. Exception: `./+wsd/bin/wsd finish` may stage and commit after gates.
- Do not hide dirty worktree.
- Do not store secrets.
- Report validation commands and results.
