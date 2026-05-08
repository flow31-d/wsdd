---
name: wsd-tasks
description: Run the Tasks phase for a WSD feature. Use when the user says wsd-tasks, criar tasks, quebrar em tasks, or asks to create an implementation plan from an approved spec or design.
---

# WSD Tasks

## Purpose

Break approved spec/design into atomic, verifiable tasks. Output: `+specs/features/[slug]/tasks.md`.

## When to Skip

Skip if there are ≤3 obvious steps. In that case, list steps inline at the start of Execute.

Safety valve: if inline listing reveals >5 steps or complex dependencies → STOP and create tasks.md.

## Procedure

1. **Read inputs:**
   - `+specs/features/[slug]/spec.md` — acceptance criteria
   - `+specs/features/[slug]/design.md` — if it exists
   - `+specs/codebase/TESTING.md` — gate check commands and coverage matrix

2. **Map file structure**: which files will be created or modified. Lock decomposition decisions here.

3. **Break into atomic tasks** — one task = one deliverable:
   - One component, one function, one endpoint, one file change
   - Independently verifiable
   - Independently committable (one commit per task)

4. **Co-locate tests**: each task that creates a layer with required test type MUST include writing those tests in the same task. Tests are NOT separate tasks.

5. **Assign gate level** per task:
   - Unit tests only → Quick
   - E2E or integration → Full
   - Last task of phase or no tests → Build

6. **Define dependencies**: what must be done before each task.

7. **Mark parallel tasks [P]**: only when Parallel-Safe in TESTING.md allows it.

8. **Save to `+specs/features/[slug]/tasks.md`**.

## Scope Guardrail

If you notice improvements outside the current feature scope while creating tasks: log in STATE.md (Deferred Ideas). Do not add to tasks.md.
