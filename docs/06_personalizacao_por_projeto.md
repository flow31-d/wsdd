---
title: "06 — Personalização WSD por Projeto"
created: 05/05/2026
modified: 05/05/2026
tags:
  - x
  - wsd
  - personalizacao
  - projetos
status: ativo
tipo: guia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/docs/04_playbook_implantacao]], [[wsd/docs/05_contrato_artefatos]], [[wsd/docs/10_matriz_sincronizacao_notas]], [[wsd/examples/koomplet-office-bootstrap-plan]]"
otimizado_para_obsidian: true
---
# 06 — Personalização WSD por Projeto

[[wsd/wsd|← WSD]]

---

> [!abstract] Decisão
> Não criar uma metodologia nova por projeto. Criar um adapter WSD local por projeto.


> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. O Que Fica Global]]
3. [[#3. O Que Muda por Projeto]]
4. [[#4. Adapter Local]]
5. [[#5. Exemplo — Prescreve Mais]]
6. [[#6. Exemplo — Koomplet Office]]
7. [[#7. Perfil de Projeto]]
8. [[#8. Regra Prática]]
9. [[#9. Sincronização de Perfis]]
10. [[#10. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 05/05/2026 13:29:54 -03 — Codex: Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes.
- 05/05/2026 14:13:39 -03 — Codex: Registro da sincronização obrigatória entre perfis, exemplos, README e matriz documental.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. O Que Fica Global

Permanece igual em todos os projetos:

- matriz L0/L1/L2;
- política de worktree suja;
- proibição de secrets;
- uso de branch/PR;
- necessidade de spec para L1/L2;
- fechamento de sessão com evidência;
- produção como L2;
- validação real, não inventada.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. O Que Muda por Projeto

Cada repo deve personalizar:

- host canônico;
- path;
- remote;
- branch padrão;
- stack;
- comandos de teste;
- comandos de build;
- paths permitidos;
- paths proibidos;
- deploy;
- riscos L2;
- contexto de produto;
- dívidas ativas;
- integrações externas.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. Adapter Local

O adapter local é composto por:

```text
AGENTS.md
+context.json
+specs/context/*.md
scripts/wsd_check.sh
```

Ele deve ser pequeno, claro e diretamente executável.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. Exemplo — Prescreve Mais

Personalização:

- host operacional: Oct;
- path operacional: `/srv/oct/prescreve_mais`;
- DLP: auditoria/laboratório;
- branch: `main`;
- risco L2: Vidaas, dados sensíveis, produção, auth, banco;
- validação: backend Python, frontend, Docker.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. Exemplo — Koomplet Office

Personalização:

- host operacional: DLP;
- path: `/srv/CLI/x/dev_cli/koomplet-office`;
- Oct: publicação/proxy/frontend servido;
- branch atual: `master`;
- risco L2: deploy público, proxy/SSL, rsync para Oct, base path `/office/`;
- validação: `npm test`, `npm run build`, asset público servido.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. Perfil de Projeto

Um perfil em `profiles/*.profile.yaml` deve ser usado para preencher templates.

Campos sugeridos:

```yaml
project:
  name: ""
  type: ""
repository:
  name: ""
  remote: ""
  default_branch: ""
environment:
  canonical_host: ""
  canonical_path: ""
validation:
  lint: []
  test: []
  build: []
risk:
  l2_areas: []
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. Regra Prática

Se uma informação muda entre projetos, ela não deve estar hardcoded no template global. Deve ir para:

- profile;
- `+context.json`;
- `AGENTS.md`;
- `+specs/context/*.md`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 9. Sincronização de Perfis

Ao alterar `profiles/*.profile.yaml`, revisar:

- esta nota;
- [[wsd/docs/04_playbook_implantacao|04 Playbook]], se a instalação recomendada mudar;
- `examples/`, se houver exemplo relacionado ao perfil;
- [[wsd/README|README]], se o perfil virar recomendado;
- [[wsd/docs/10_matriz_sincronizacao_notas|10 Matriz de Sincronização]], se mudar o grupo de arquivos obrigatórios.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 10. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 05/05/2026 13:29:54 -03 | Codex | `x/wsd/docs/06_personalizacao_por_projeto.md` | Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes. |
| 05/05/2026 14:13:39 -03 | Codex | `x/wsd/docs/06_personalizacao_por_projeto.md` | Registro da sincronização obrigatória entre perfis, exemplos, README e matriz documental. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
