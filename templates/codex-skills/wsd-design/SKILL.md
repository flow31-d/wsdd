---
name: wsd-design
description: Run the Design phase for a WSD feature. Use when the user says wsd-design, desenhar arquitetura, design da feature, or asks to create a design document for an approved spec.
---

# WSD Design

## Purpose

Translate an approved spec into an architectural design. Output: `+specs/features/[slug]/design.md`.

## When to Skip

Skip this phase if:
- The change has no architectural decisions (≤3 files, obvious approach)
- No new patterns or components are introduced
- The team already knows exactly how to implement it

Go directly to `/wsd-tasks` in those cases.

## Procedure

1. **Read spec**: load `+specs/features/[slug]/spec.md` — all acceptance criteria must be clear.

2. **Knowledge chain** (mandatory order):
   - Check existing code for patterns already in use
   - Check `+specs/codebase/ARCHITECTURE.md` and CONVENTIONS.md
   - Check MCP tools if available
   - Web search for official docs
   - Flag as uncertain if nothing found

3. **Propose 2-3 design approaches** with trade-offs. Lead with recommendation.

4. **Present design sections** — scale to complexity, one section at a time:
   - Architecture overview
   - Components and responsibilities
   - Data flow / sequence
   - Error handling
   - Testing approach

5. **Get user approval** after each section. Revise if needed.

6. **Save to `+specs/features/[slug]/design.md`**.

7. **After approval**: offer to continue with `/wsd-tasks`.

## Boundary

Design only. No code, no scaffolding. Implementation starts in Execute phase.
