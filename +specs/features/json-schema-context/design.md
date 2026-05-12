---
title: "Design — JSON Schema validation for +context.json (v0.1.5-alpha)"
created: 07/05/2026
modified: 07/05/2026
feature: json-schema-context
status: approved
---

# Design — JSON Schema validation for `+context.json`

## Decisões

### D1 — Schema canônico vive em `schemas/context.schema.json`

Pasta nova `schemas/` no root do WSD. Evita poluir `templates/repo/`, e o nome reflete que é fonte-de-verdade (não template parametrizado). O `$id` do schema é `wsd/context/v1`, batendo com `$schema` de `+context.json`.

### D2 — Validador pure-JS zero-deps em vez de ajv

Ajv é o padrão de mercado, mas:
- Adiciona `node_modules/` ao `+wsd/` vendorizado (~500 KB) — viola "kit pessoal enxuto";
- Cria pressão para `npm install` no projeto-alvo, que pode não ser Node;
- Para o subconjunto que precisamos (type/required/properties/enum/pattern/items/additionalProperties/oneOf/const), 150 linhas de JS resolvem.

Trade-off aceito: o validador NÃO é spec-completo de JSON Schema 2020-12. Doc do arquivo lista o subconjunto e referencia ajv como migração futura se necessário.

### D3 — Wiring por bash + node, sem novo binário

`scripts/wsd_check.sh` chama `node +wsd/bin/wsd-validate-context.js +context.json`. Não criamos `wsd validate` separado. Razão: o gate de schema é parte do check operacional, não comando standalone.

### D4 — Fallback degradado quando Node ausente

`wsd_check.sh` testa `command -v node` antes de invocar o validator. Se ausente: `warn: node missing — schema validation skipped` e segue. JSON syntax check (python3) continua hard-fail. Doctor reporta o gap.

Justificativa: hosts mínimos (containers, CI minimal) podem não ter Node. Não queremos que `wsd check` quebre por isso, mas o operador precisa saber.

### D5 — Schema modela o contrato real, não o ideal

Vamos derivar required/types/enums do que `+context.json.template` realmente produz após render, não do "como queríamos que fosse". Isso evita falso-positivo dia-1.

Campos obrigatórios (mínimo viável):
- `$schema`, `project.name`, `environment.canonical_host`, `repository.default_branch`, `permissions.write_paths`, `permissions.forbidden_paths`, `permissions.tool_allowlist`, `permissions.secrets_policy`, `workflow.production_mutation_policy`, `wsd.method`, `wsd.context_documents`.

Campos opcionais (presentes mas com defaults razoáveis):
- `repository.clone_policy`, `ci.*`, `permissions.max_runtime_seconds`, etc.

Enums fortes:
- `workflow.production_mutation_policy ∈ {forbidden_for_agents, requires_human_approval}`
- `permissions.secrets_policy ∈ {read_only_env_vars, denied}`
- `repository.repo_type ∈ {private, public, internal}`

### D6 — Testes seguem o padrão "fixtures inline na suite"

Em vez de criar pasta `tests/fixtures/` separada (que vira manutenção paralela), os self-tests do validator vivem inline em `scripts/wsd_self_check.sh`: passa stdin/temp file, espera exit code esperado. Mesma filosofia dos demais checks.

## Estrutura final

```
schemas/
└── context.schema.json                          NEW — JSON Schema 2020-12 canônico

templates/local-wsd/bin/
└── wsd-validate-context.js                      NEW — validator pure-JS

bin/wsd-method.js                                CHANGED — installVendorTree copia schemas/ + validator

templates/repo/scripts/wsd_check.sh              CHANGED — invoca validator após JSON syntax

templates/local-wsd/bin/wsd                      CHANGED — doctor checa schema + validator

scripts/wsd_self_check.sh                        CHANGED — required_files + self-test do validator
scripts/wsd_docs_check.sh                        CHANGED — verifica docs/05 referenciar schema

package.json                                     CHANGED — version → 0.1.5-alpha + asserts em test:install*

docs/05_contrato_artefatos.md                    CHANGED — seção schema canônico
docs/10_matriz_sincronizacao_notas.md            CHANGED — entrada nova
README.md, wsd.md, ROADMAP.md, CHANGELOG.md      CHANGED — sync v0.1.5-alpha
+specs/project/STATE.md                          CHANGED — Decisão + Todo fechado
```

## Subconjunto JSON Schema suportado pelo validator

| Keyword | Suporte | Notas |
|---|---|---|
| `type` | ✅ | string, number, integer, boolean, object, array, null |
| `required` | ✅ | só em objetos |
| `properties` | ✅ | recursivo |
| `additionalProperties` | ✅ | true (default), false, ou schema |
| `items` | ✅ | schema único (não tuple) |
| `enum` | ✅ | array de literais |
| `const` | ✅ | match exato |
| `pattern` | ✅ | regex JS |
| `minLength` / `maxLength` | ✅ | strings |
| `minimum` / `maximum` | ✅ | number/integer |
| `oneOf` | ✅ | exatamente 1 match |
| `$schema`, `$id`, `title`, `description` | ✅ ignored | meta |
| `$ref`, `definitions`, `allOf`, `anyOf`, `not` | ❌ | fora do escopo v0.1.5 |

Sai erro com mensagem `unsupported keyword: <keyword>` se o schema usar algo fora da lista — força disciplina ao evoluir o schema.

## Plano de teste

1. **Rendered profile passes**: cada profile renderiza `+context.json` que valida.
2. **Missing required field fails**: remove `permissions.write_paths`, validator exit 1 com path do erro.
3. **Wrong type fails**: `permissions.max_runtime_seconds: "600"` (string) → fail.
4. **Bad enum fails**: `workflow.production_mutation_policy: "yolo"` → fail.
5. **Extra unknown property** com `additionalProperties: false` no top → fail (a decidir per-section).
6. **Bash check graceful** sem Node: warn, no fail.
