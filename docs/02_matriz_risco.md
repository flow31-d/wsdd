---
title: "02 — Matriz de Risco WSD"
created: 05/05/2026
modified: 05/05/2026
tags:
  - x
  - wsd
  - risco
  - l0
  - l1
  - l2
status: ativo
tipo: guia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/docs/01_constituicao]], [[wsd/docs/03_ciclo_operacional]], [[wsd/docs/05_contrato_artefatos]], [[wsd/docs/10_matriz_sincronizacao_notas]]"
otimizado_para_obsidian: true
---
# 02 — Matriz de Risco WSD

[[wsd/wsd|← WSD]]

---

> [!abstract] Papel
> A matriz de risco decide quanto rigor a tarefa exige antes de edição, commit, PR ou deploy.


> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. L0 — Baixo Risco]]
3. [[#3. L1 — Risco Médio]]
4. [[#4. L2 — Alto Risco]]
5. [[#5. Escore de Risco]]
6. [[#6. Regra de Elevação]]
7. [[#7. Sincronização da Matriz de Risco]]
8. [[#8. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 05/05/2026 13:29:54 -03 — Codex: Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes.
- 05/05/2026 14:13:39 -03 — Codex: Inclusão da regra de sincronização quando os critérios L0/L1/L2 forem alterados.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. L0 — Baixo Risco

Use L0 quando a mudança for pequena, local e facilmente revisável.

Exemplos:

- corrigir typo;
- ajustar documentação;
- atualizar comentário técnico;
- corrigir teste isolado;
- alterar script sem impacto operacional;
- pequena melhoria visual sem deploy automático.

Requisitos:

- Task Card ou descrição clara no pedido;
- `git status`;
- diff revisado;
- validação proporcional;
- sem spec obrigatória.

Bloqueia:

- produção;
- secrets;
- banco;
- autenticação;
- deploy;
- alteração estrutural grande;
- múltiplos módulos sem spec.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. L1 — Risco Médio

Use L1 quando a mudança altera comportamento, estrutura, automação, integração ou fluxo de usuário, mas não executa produção diretamente.

Exemplos:

- feature nova;
- endpoint novo;
- alteração em regra de negócio;
- refatoração compartilhada;
- integração externa em modo dev;
- mudança relevante de frontend;
- automação de rotina;
- alteração em scripts de build/test;
- bootstrap WSD em repositório.

Requisitos:

- spec aprovada;
- branch dedicada;
- escopo permitido e proibido;
- critérios de aceite;
- comandos de validação;
- rollback proporcional;
- PR recomendado.

Bloqueia:

- spec em `draft`;
- ausência de validação;
- paths sensíveis não declarados;
- mistura com mudanças preexistentes.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. L2 — Alto Risco

Use L2 quando a mudança pode afetar produção, dados, disponibilidade, segurança, integridade ou custo.

Exemplos:

- deploy público;
- migração de banco;
- mudança de auth/autorização;
- secrets, certificados ou tokens;
- integração real com API externa sensível;
- alteração em backup/restore;
- infraestrutura;
- DNS, proxy, SSL;
- dados pessoais, clínicos, financeiros ou legais;
- scripts destrutivos;
- troca de branch padrão;
- alteração de permissões GitHub.

Requisitos:

- spec L2 aprovada;
- aprovação humana explícita;
- plano de rollback testável;
- health checks;
- janela operacional quando aplicável;
- evidência antes/depois;
- nenhum segredo registrado.

Bloqueia:

- execução autônoma de produção por agente;
- ausência de rollback;
- segredo em prompt ou Git;
- comando destrutivo não aprovado;
- falta de confirmação do host correto.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. Escore de Risco

Cada spec pode usar `risk_score` de 1 a 10.

| Score | Interpretação |
|---:|---|
| 1-2 | L0 trivial |
| 3-4 | L0 com atenção |
| 5-6 | L1 normal |
| 7-8 | L1 alto ou L2 controlado |
| 9-10 | L2 crítico |

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. Regra de Elevação

Se houver dúvida entre dois níveis, escolher o maior.

Uma tarefa L0 vira L1 se tocar múltiplos módulos, comportamento relevante ou contrato compartilhado.

Uma tarefa L1 vira L2 se tocar produção, secrets, dados sensíveis, deploy, banco, auth, rede ou disponibilidade.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. Sincronização da Matriz de Risco

Ao alterar critérios L0/L1/L2, revisar:

- [[wsd/docs/01_constituicao|01 Constituição]];
- [[wsd/docs/03_ciclo_operacional|03 Ciclo Operacional]];
- [[wsd/docs/05_contrato_artefatos|05 Contrato de Artefatos]];
- `templates/repo/AGENTS.md.template`;
- `templates/codex-skills/wsd/SKILL.md`;
- [[wsd/docs/10_matriz_sincronizacao_notas|10 Matriz de Sincronização]].

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 05/05/2026 13:29:54 -03 | Codex | `x/wsd/docs/02_matriz_risco.md` | Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes. |
| 05/05/2026 14:13:39 -03 | Codex | `x/wsd/docs/02_matriz_risco.md` | Inclusão da regra de sincronização quando os critérios L0/L1/L2 forem alterados. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
