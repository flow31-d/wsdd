---
description: Gera relatório WSD com estado atual, implementação em andamento, plano, ideias, concerns e sugestão do agente.
allowed-tools:
  - Bash
  - Read
  - Write
---

# /wsd-relatorio

Generate a Relatorio WSD for the current project.

Run:

```bash
./+wsd/bin/wsd relatorio
```

Use `--save` only when the user asks to store the report:

```bash
./+wsd/bin/wsd relatorio --save
```

The Relatorio WSD summarizes:

- current Git and WSD state;
- in-progress implementation, if any;
- planned execution order inferred from concerns, ROADMAP, specs, and ideas;
- active ideas and pipeline status;
- active concerns and pipeline status;
- final agent recommendation.

After running the command, answer the user with the report and a short practical next-step recommendation.
