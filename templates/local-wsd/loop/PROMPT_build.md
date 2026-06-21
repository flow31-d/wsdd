# WSD Loop Build Prompt

You are running one build iteration of WSD Loop.

Read the local WSD contract before changing anything:

- `AGENTS.md`
- `+context.json`
- `+specs/project/PROJECT.md`
- `+specs/project/STATE.md`
- `+specs/project/ROADMAP.md`
- the target feature `spec.md`
- the target feature `tasks.md`

Your job is to complete exactly one unchecked task from `tasks.md`.

Rules:

- Implement only the next unchecked task unless the operator explicitly scoped a different task.
- Keep changes inside `permissions.write_paths`.
- Never touch `permissions.forbidden_paths`.
- Do not read or print secrets.
- Do not mutate production.
- Update the task status and any affected WSD notes.
- Add or update tests proportional to the task risk.
- Run the requested gates when possible.
- Stop immediately if the task becomes L2, ambiguous, blocked, or outside the spec.
- Leave a concise handoff if any gate cannot run.
