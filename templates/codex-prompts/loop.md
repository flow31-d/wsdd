---
description: WSD Codex Loop Shortcut: status, auto on/off, plan, once, run
argument-hint: "status | auto status|on|off | on | off | plan FEATURE | once FEATURE | run FEATURE"
---

# WSD Codex Loop Shortcut

Use WSDD in this repository and interpret `$ARGUMENTS` as a short WSD Loop request.

Valid mappings:

- `status` -> run `./+wsd/bin/wsd loop status`
- `auto status` -> run `./+wsd/bin/wsd loop auto status`
- `auto on` or `on` -> run `./+wsd/bin/wsd loop auto on`
- `auto off` or `off` -> run `./+wsd/bin/wsd loop auto off`
- `plan FEATURE` -> run `./+wsd/bin/wsd loop plan --feature FEATURE`
- `once FEATURE` -> run `./+wsd/bin/wsd loop once --feature FEATURE`
- `run FEATURE` -> only run after checking `+context.json`, approved spec, clean-worktree requirements, and L2 approval policy.

Before any write or execution beyond status/toggle:

1. Read `AGENTS.md`, `+context.json`, and the feature spec.
2. Classify risk L0/L1/L2.
3. Do not bypass L2 human approval.
4. Report the exact command and result.

If `$ARGUMENTS` is empty, show current loop status and the available mappings.
