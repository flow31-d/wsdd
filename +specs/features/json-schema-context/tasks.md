---
title: "Tasks — JSON Schema validation for .context.json (v0.1.5-alpha)"
created: 07/05/2026
modified: 07/05/2026
feature: json-schema-context
status: in_progress
---

# Tasks — JSON Schema validation for `.context.json`

Atomic tasks com gates RED/GREEN/VERIFY explícitos. Cada uma deve fechar com commit Conventional Commits 1.0.0.

---

## T1. Criar schema canônico

- [ ] Criar `schemas/context.schema.json` (JSON Schema 2020-12, `$id: wsd/context/v1`).
- [ ] Cobrir: project, environment, repository, permissions, workflow, wsd, ci.
- [ ] Required, types, enums (production_mutation_policy, secrets_policy, repo_type).
- [ ] **VERIFY:** `python3 -m json.tool schemas/context.schema.json >/dev/null` (JSON válido).

## T2. Implementar validator pure-JS

- [ ] Criar `templates/local-wsd/bin/wsd-validate-context.js`.
- [ ] CLI: `node wsd-validate-context.js <path-to-context.json> [--schema <path>]`.
- [ ] Suporte: type/required/properties/enum/pattern/items/additionalProperties/oneOf/const/minLength/maxLength/minimum/maximum.
- [ ] Erro com path JSON-pointer (ex.: `/permissions/write_paths: required`).
- [ ] Exit 0 ok, 1 schema fail, 2 IO/parse fail, 3 unsupported keyword.
- [ ] **VERIFY:** `node templates/local-wsd/bin/wsd-validate-context.js --help` lista uso.

## T3. Vendor schema + validator no installer

- [ ] `bin/wsd-method.js` `installVendorTree`: copiar `schemas/` → `.wsd/schemas/`.
- [ ] Copiar `templates/local-wsd/bin/wsd-validate-context.js` → `.wsd/bin/wsd-validate-context.js` (chmod 755).
- [ ] **VERIFY:** rodar `npm run test:install` e checar que arquivos aparecem.

## T4. Hook em wsd_check.sh

- [ ] `templates/repo/scripts/wsd_check.sh`: após JSON syntax, testar `command -v node`.
- [ ] Se Node OK: `node .wsd/bin/wsd-validate-context.js .context.json` (hard-fail).
- [ ] Se Node ausente: `warn: node missing — schema validation skipped`.
- [ ] **VERIFY:** rodar com Node presente em fixture válida (PASS); com Node em fixture inválida (FAIL com path).

## T5. Atualizar doctor (local-wsd)

- [ ] `templates/local-wsd/bin/wsd doctor`: linhas para `.wsd/schemas/context.schema.json` e `.wsd/bin/wsd-validate-context.js`.
- [ ] **VERIFY:** rodar doctor em projeto de teste e confirmar duas linhas novas.

## T6. Self-tests inline

- [ ] `scripts/wsd_self_check.sh`: bloco `validate-context self-test`:
  - sample válido (mínimo) deve passar
  - sample sem `permissions.write_paths` deve falhar
  - sample com `permissions.max_runtime_seconds` string deve falhar
  - sample com `workflow.production_mutation_policy` inválido deve falhar
- [ ] **VERIFY:** `bash scripts/wsd_self_check.sh` em PASS local.

## T7. Estender npm test

- [ ] `package.json` `test:install`: assertar `.wsd/schemas/context.schema.json` e `.wsd/bin/wsd-validate-context.js`.
- [ ] Adicionar invocação `node .wsd/bin/wsd-validate-context.js .context.json` na suite.
- [ ] Idem `test:install-claude` e `test:install-brownfield`.
- [ ] **VERIFY:** `npm test` PASS.

## T8. Atualizar wsd_self_check + wsd_docs_check

- [ ] `scripts/wsd_self_check.sh` `required_files`: adicionar `schemas/context.schema.json` e `templates/local-wsd/bin/wsd-validate-context.js`.
- [ ] `scripts/wsd_docs_check.sh`: assertar que `docs/05_contrato_artefatos.md` referencia `schemas/context.schema.json`.
- [ ] **VERIFY:** ambos os checkers passam.

## T9. Bump version + sync notas

- [ ] `package.json`: `0.1.4-alpha` → `0.1.5-alpha`.
- [ ] README, wsd.md, ROADMAP, CHANGELOG, docs/09: referenciar `v0.1.5-alpha`.
- [ ] `+specs/project/STATE.md`: nova decisão + fechar Todo "Decidir próxima frente".
- [ ] **VERIFY:** `bash scripts/wsd_docs_check.sh` PASS.

## T10. Atualizar docs 05 + 10

- [ ] `docs/05_contrato_artefatos.md`: nova subseção "Schema canônico" referenciando `schemas/context.schema.json` e `wsd-validate-context.js`.
- [ ] `docs/10_matriz_sincronizacao_notas.md`: linha nova mapeando schema↔installer↔check.
- [ ] **VERIFY:** docs-check passa.

## T11. Final gate

- [ ] `bash scripts/wsd_self_check.sh` PASS.
- [ ] `bash scripts/wsd_docs_check.sh` PASS.
- [ ] `npm test` PASS.
- [ ] Conventional Commits 1.0.0 em cada commit lógico.
- [ ] STATE.md atualizado com decisão e todo fechado.

---

## Estimativa

- Esforço: ~2-3h em foco contínuo.
- Risco: L1 — sem rollback formal além de reverter o gate.
- Dependências: nenhuma fora do próprio repo.
