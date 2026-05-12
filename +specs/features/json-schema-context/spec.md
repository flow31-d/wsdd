---
title: "Spec — JSON Schema validation for +context.json (v0.1.5-alpha)"
created: 07/05/2026
modified: 07/05/2026
feature: json-schema-context
risco: L1
status: approved
owner: flow31-d
---

# Spec — JSON Schema validation for `+context.json` (v0.1.5-alpha)

## Problema

`+context.json` é o contrato runtime que cada projeto declara para os agentes (paths, permissões, validações, política de produção). O `wsd_check.sh` atual só valida sintaxe JSON via `python3 -m json.tool`. Campos faltantes, tipos errados ou enums fora do contrato passam silenciosamente — o agente só descobre quando algo quebra em runtime. A nota crítica `12 — Avaliação Crítica` e o pendente da Fase 1 do roadmap apontam isso há duas releases.

## Goals

- [ ] JSON Schema canônico em `schemas/context.schema.json` cobrindo o contrato de `docs/05`.
- [ ] Validador pure-JS zero-deps, vendorizado em `+wsd/bin/wsd-validate-context.js` durante install.
- [ ] `scripts/wsd_check.sh` falha com mensagem clara em qualquer violação de schema.
- [ ] Todos os profiles do installer (`generic_node_frontend`, `generic_python_api`, `koomplet_office`, `prescreve_mais`) produzem `+context.json` que passa no validator.

## Fora de Escopo

| Item | Motivo |
|---|---|
| Validar `+specs/*.spec.yaml` via JSON Schema | YAML schema é frente própria; spec contracts já estão migrando para `feature-spec.md` MD-based |
| Adicionar dependência `ajv` ou similar | Precisamos zero-deps no `+wsd/` vendorizado para não tocar `package.json` do projeto-alvo |
| Auto-fix de `+context.json` inválido | Validator só sinaliza; correção é responsabilidade do operador |
| Validar `+wsd/config.json` (config interno do installer) | Fora do escopo do contrato com agentes |

---

## User Stories

### P1: Operador que instala WSD em um repo novo ⭐ MVP

**Como** operador, **quero** que `wsd-method install` deixe o validador pronto-para-uso **para que** o `wsd check` me alerte se eu (ou o agente) quebrar o `+context.json`.

**Acceptance Criteria:**

1. WHEN `wsd-method install` termina com sucesso THEN o instalador SHALL ter copiado `schemas/context.schema.json` para `+wsd/schemas/context.schema.json` no projeto-alvo.
2. WHEN `wsd-method install` termina com sucesso THEN o instalador SHALL ter copiado o validador executável para `+wsd/bin/wsd-validate-context.js` (chmod 755).
3. WHEN `wsd-method install --profile <qualquer profile>` é executado THEN o `+context.json` renderizado SHALL passar `node +wsd/bin/wsd-validate-context.js +context.json` com exit 0.

### P1: Operador rodando `wsd check` ⭐ MVP

**Como** operador, **quero** que `wsd check` valide o schema do `+context.json` **para que** eu detecte campos faltantes ou tipos errados antes de qualquer sessão.

**Acceptance Criteria:**

4. WHEN `bash scripts/wsd_check.sh` roda em projeto com `+context.json` válido E Node disponível THEN o script SHALL imprimir `ok: +context.json schema valid` e seguir.
5. WHEN `bash scripts/wsd_check.sh` roda em projeto com `+context.json` faltando campo obrigatório THEN o script SHALL imprimir o caminho do erro (ex.: `permissions.write_paths is required`) e exitar com código ≠ 0.
6. WHEN `bash scripts/wsd_check.sh` roda em projeto com `+context.json` com tipo errado (ex.: `permissions.max_runtime_seconds: "600"` em vez de `600`) THEN o script SHALL falhar com mensagem indicando type mismatch.
7. WHEN `bash scripts/wsd_check.sh` roda em ambiente SEM `node` THEN o script SHALL imprimir `warn: node missing — schema validation skipped` mas SHALL preservar o gate de JSON syntax (não falhar).

### P2: Manutenção do schema

**Como** mantenedor do WSD, **quero** o schema canônico versionado em `schemas/` **para que** eu possa evoluí-lo sem mexer em N cópias.

**Acceptance Criteria:**

8. WHEN o schema canônico é alterado em `schemas/context.schema.json` THEN o próximo `wsd-method install --force` SHALL propagar a versão nova para `+wsd/schemas/`.
9. WHEN o `bash scripts/wsd_self_check.sh` roda THEN ele SHALL falhar se `schemas/context.schema.json` ou `templates/local-wsd/bin/wsd-validate-context.js` estiverem ausentes.

---

## Escopo de Execução

**Paths permitidos:**
- `schemas/`
- `bin/wsd-method.js`
- `templates/local-wsd/bin/`
- `templates/repo/scripts/wsd_check.sh`
- `scripts/wsd_self_check.sh`
- `scripts/wsd_docs_check.sh`
- `package.json` (version + tests)
- `docs/05_contrato_artefatos.md`, `docs/10_matriz_sincronizacao_notas.md`
- `README.md`, `wsd.md`, `ROADMAP.md`, `CHANGELOG.md`, `+specs/project/STATE.md`

**Paths proibidos:**
- `wsd_philo/` (referência conceitual, não operacional)
- `+imbox/` (inbox)
- qualquer arquivo com secret real

## Riscos e Mitigações

| Risco | Probabilidade | Mitigação |
|---|---|---|
| Validator pure-JS divergir de JSON Schema 2020-12 e dar falso positivo | Média | Limitar suporte explicitamente ao subconjunto necessário; documentar no top do arquivo |
| Schema rígido demais quebrar profiles existentes | Alta | Validator + suite de fixtures testando cada profile renderizado antes de liberar |
| Node ausente no host fazer o check sair silencioso | Baixa | Fallback degradado com `warn:` (não `fail:`) e doctor reporta o gap |

## Rollback

L1 — sem rollback formal. Se o schema rejeitar `+context.json` legítimos:
1. Reverter o commit que ativa o gate em `wsd_check.sh`;
2. Manter os artefatos novos (schema + validator) como ferramenta opt-in até ajustar.

---

> **Nota para agente:** Esta spec é L1 e está `approved`. Implementar nas tasks listadas em `tasks.md`. Conventional Commits 1.0.0 obrigatório.
