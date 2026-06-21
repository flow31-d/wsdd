---
name: wsd-loop
description: Operate the Ralph/WSD Loop in a WSD repository. Use when the user says loop status, /loop status, WSD Loop, Ralph Loop, loop auto on, loop auto off, ligar loop, desligar loop, loop plan, loop once, or asks to automate L0/L1 work with fewer approvals.
---

# WSD Loop

## Purpose

Map short operator intents to the local WSD Loop CLI while preserving WSD risk gates.

## Commands

Interpret the user's short request:

- `loop status` or `/loop status` -> `./+wsd/bin/wsd loop status`
- `loop auto status` -> `./+wsd/bin/wsd loop auto status`
- `loop auto on`, `loop on`, `ligar loop` -> `./+wsd/bin/wsd loop auto on`
- `loop auto off`, `loop off`, `desligar loop` -> `./+wsd/bin/wsd loop auto off`
- `loop plan <feature>` -> `./+wsd/bin/wsd loop plan --feature <feature>`
- `loop once <feature>` -> `./+wsd/bin/wsd loop once --feature <feature>`
- `loop run <feature>` -> ask for confirmation unless the user already approved the run and the feature has an approved spec.

## Procedure

1. Confirm the repository has `+context.json` and `+wsd/bin/wsd`.
2. For status and auto toggle commands, run the mapped command directly.
3. For `plan`, `once`, or `run`, read `+context.json` and `+specs/features/<feature>/spec.md` first.
4. Refuse to bypass L2 approval. If the feature risk is L2, ask for explicit human approval before running loop execution.
5. Report the exact command run and the resulting loop state.

## Notes

Codex CLI custom slash commands are not project-local WSD artifacts. In Codex, this skill is the shared repo-local shortcut; optional user-global prompts can be installed with `./+wsd/bin/wsd codex-shortcuts install`.
