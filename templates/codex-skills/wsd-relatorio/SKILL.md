---
name: wsd-relatorio
description: Generate or explain a WSD project report. Use when the user asks for a WSD report, project overview, current WSD state, active implementation status, planned execution order, ideas pipeline, concerns pipeline, or the agent's recommendation for next action.
---

# WSD Relatorio

Use this skill when the user asks for a "relatorio WSD", "geral do projeto", "estado atual", "o que esta em andamento", "ideias e concerns", or asks what should be done next in a WSD-managed repository.

## Command

Run from the project root:

```bash
./+wsd/bin/wsd relatorio
```

To save the generated Markdown inside the repo:

```bash
./+wsd/bin/wsd relatorio --save
```

The saved report path is:

```text
+specs/RELATORIO.md
```

## Contract

The Relatorio WSD must cover:

- current Git and WSD state;
- whether there is an implementation in progress;
- planned execution order inferred from concerns, ROADMAP, specs, and ideas;
- active ideas and whether they have pipeline rows;
- active concerns and whether they have pipeline rows;
- final agent recommendation.

## Agent Behavior

- Prefer the command output over manually scanning files.
- If the user asks for the report in chat, run `./+wsd/bin/wsd relatorio` and summarize or paste the relevant report.
- If the user asks to store it, run `./+wsd/bin/wsd relatorio --save`.
- After reading the command output, you may add your own short judgment, but clearly distinguish it from the generated report.
