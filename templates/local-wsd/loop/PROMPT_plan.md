# WSD Loop Plan Prompt

You are running the planning phase of WSD Loop.

Read the local WSD contract before changing anything:

- `AGENTS.md`
- `+context.json`
- `+specs/project/PROJECT.md`
- `+specs/project/STATE.md`
- `+specs/project/ROADMAP.md`
- `+specs/project/CONCERNS.md`
- the target feature `spec.md`

Your output must be a concrete task plan for the target feature.

Rules:

- Do not implement code in plan mode.
- Create or update `+specs/features/<feature>/tasks.md`.
- Keep tasks atomic enough for one loop iteration each.
- Mark risk and expected gates for each task.
- Stop and report if the requested work is L2, touches forbidden paths, needs secrets, changes production, or lacks a clear spec.
- Prefer the existing project patterns and local WSD docs over generic advice.
- End with the next single task that should be executed by build mode.
