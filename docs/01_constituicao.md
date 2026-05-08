---
title: "01 — Constituição WSD"
created: 05/05/2026
modified: 05/05/2026
tags:
  - x
  - wsd
  - constituicao
  - agentes
status: ativo
tipo: guia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/docs/02_matriz_risco]], [[wsd/docs/05_contrato_artefatos]], [[wsd/docs/07_git_governance]], [[wsd/docs/10_matriz_sincronizacao_notas]]"
otimizado_para_obsidian: true
---
# 01 — Constituição WSD

[[wsd/wsd|← WSD]]

---

> [!abstract] Objetivo
> Definir as regras permanentes que todo agente deve respeitar ao trabalhar em um repositório governado por WSD.


> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. Regra 1 — Intenção Antes de Execução]]
3. [[#3. Regra 2 — Git é Histórico, Spec é Contrato]]
4. [[#4. Regra 3 — Risco Define Rigor]]
5. [[#5. Regra 4 — Agente Não Esconde Sujeira]]
6. [[#6. Regra 5 — Validação Deve Ser Real]]
7. [[#7. Regra 6 — Segredos Nunca Entram em Memória Longa]]
8. [[#8. Regra 7 — Produção Não é Área de Experimentação]]
9. [[#9. Regra 8 — Projeto Tem Adapter Próprio]]
10. [[#10. Regra 9 — Documentação Não Substitui Estado Atual]]
11. [[#11. Regra 10 — Saída Deve Ser Auditável]]
12. [[#12. Regra 11 — Pesquisa Segue a Cadeia de Verificação]]
13. [[#13. Regra 12 — Escopo é Inviolável Durante Execução]]
12. [[#12. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 05/05/2026 13:29:54 -03 — Codex: Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes.
- 05/05/2026 14:13:39 -03 — Codex: Reforço da regra de documentação atualizada com referência à matriz de sincronização do WSD.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. Regra 1 — Intenção Antes de Execução

Nenhum agente deve editar código antes de saber:

- qual é o repositório;
- qual é o host canônico;
- qual é a branch de trabalho;
- se a worktree já estava suja;
- qual é o objetivo da tarefa;
- qual é o risco operacional;
- quais arquivos pode alterar;
- como validar a entrega.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. Regra 2 — Git é Histórico, Spec é Contrato

Git registra o que mudou. Spec registra por que mudou, até onde pode ir, como validar e como reverter.

Uma mudança relevante sem spec vira memória fraca. Uma spec sem commit vira intenção sem execução. WSD exige os dois quando o risco justificar.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. Regra 3 — Risco Define Rigor

WSD usa três níveis:

- **L0**: ajuste pequeno, local, reversível.
- **L1**: feature, refatoração relevante, automação, integração ou mudança estrutural.
- **L2**: produção, dados sensíveis, autenticação, secrets, deploy, banco, rede, disponibilidade ou risco financeiro/legal.

Quanto maior o risco, maior a necessidade de aprovação, rollback, evidência e revisão.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. Regra 4 — Agente Não Esconde Sujeira

Se a worktree está suja, o agente deve declarar o estado antes de trabalhar.

Proibido usar estes comandos para esconder ou contornar sujeira local sem decisão explícita:

- `git add .`
- `git stash`
- `git reset`
- `git clean`
- `git checkout --`
- `git switch` para fugir de alterações
- `git pull` com worktree suja
- `git merge` ou `git rebase` com escopo incerto
- force push

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. Regra 5 — Validação Deve Ser Real

O agente não deve inventar comandos de teste. Se não há teste formal, deve registrar isso e executar a melhor validação proporcional existente.

Exemplos de validação real:

- `npm test`
- `npm run build`
- `pytest`
- `ruff check`
- `docker compose config`
- smoke test documentado
- health check não destrutivo

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. Regra 6 — Segredos Nunca Entram em Memória Longa

Não registrar secrets em:

- Git;
- Obsidian;
- specs;
- issues;
- PRs;
- prompts;
- logs;
- `error_vault.json`;
- screenshots;
- exemplos.

Secrets devem viver em mecanismos próprios: env vars, secret manager, GitHub Actions Secrets, arquivos locais ignorados ou cofres.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. Regra 7 — Produção Não é Área de Experimentação

Agentes podem preparar:

- branch;
- PR;
- script;
- plano de rollback;
- checklist;
- documentação;
- validação de pré-deploy.

Agentes não devem executar mutação direta em produção sem autorização humana explícita e contexto L2 aprovado.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 9. Regra 8 — Projeto Tem Adapter Próprio

WSD global não sabe tudo sobre um projeto.

Cada repo deve declarar seu adapter local:

- `AGENTS.md`;
- `.context.json`;
- `+specs/context/*.md`;
- `+logs/error_vault.json`;
- scripts de validação.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 10. Regra 9 — Documentação Não Substitui Estado Atual

Antes de agir, agente deve ler documentação, mas confirmar com comandos reais.

Documentação desatualizada deve ser corrigida no mesmo ciclo quando afetar a execução.

Se a correção afetar mais de uma nota ou arquivo operacional, o agente deve seguir [[wsd/docs/10_matriz_sincronizacao_notas|10 — Matriz de Sincronização de Notas WSD]] antes de finalizar.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 11. Regra 10 — Saída Deve Ser Auditável

Ao final de uma tarefa, deve existir evidência suficiente para outro agente continuar:

- branch;
- commit ou diff;
- spec usada;
- validação executada;
- validação não executada e motivo;
- risco residual;
- próximo passo seguro.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 12. Regra 11 — Pesquisa Segue a Cadeia de Verificação

Ao pesquisar, projetar ou tomar qualquer decisão técnica, o agente deve seguir esta ordem obrigatória:

1. **Codebase existente** — código, padrões e convenções já em uso no repositório.
2. **Docs do projeto** — README, docs/, `+specs/codebase/`, `+specs/project/`.
3. **Ferramentas MCP disponíveis** — Context7 ou equivalente para consulta de APIs e bibliotecas.
4. **Web search** — documentação oficial, fontes reputadas, padrões da comunidade.
5. **Flagrar como incerto** — "Não encontrei documentação para X. Aqui está meu raciocínio, mas verifique antes de usar."

**Nunca pular para o passo 5 se os passos 1-4 estão disponíveis.**

**Nunca inventar APIs, padrões ou comportamentos.** Incerteza explícita é sempre preferível a fabricação — APIs inventadas causam falhas em cascata por todo o fluxo design → tasks → implementação.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 13. Regra 12 — Escopo é Inviolável Durante Execução

Durante a execução de qualquer tarefa, o agente pode notar melhorias, refatorações ou ideias adjacentes. A regra é simples:

- **"Isto está na definição da minha task?"** — Se não, não implementar.
- Registrar em `+specs/project/STATE.md` na seção **Ideias Adiadas** ou **Todos Ativos**.
- Nunca fazer mudanças "já que estou aqui" sem instrução explícita.

**Por que importa:** scope creep durante implementação é a principal causa de bugs introduzidos sem rastreabilidade, diffs difíceis de revisar e testes que cobrem mais do que a task pretendia.

**Exceção:** se algo encontrado durante a task for um bug ativo que bloqueie o objetivo, registrá-lo como bloqueador no STATE.md e decidir com o operador antes de agir.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 14. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 05/05/2026 13:29:54 -03 | Codex | `x/wsd/docs/01_constituicao.md` | Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes. |
| 05/05/2026 14:13:39 -03 | Codex | `x/wsd/docs/01_constituicao.md` | Reforço da regra de documentação atualizada com referência à matriz de sincronização do WSD. |
| 06/05/2026 — | Claude | `x/wsd/docs/01_constituicao.md` | Adição da Regra 11 (Knowledge Verification Chain) e Regra 12 (Scope Guardrail) como parte da integração TLC v0.1.4-alpha. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
