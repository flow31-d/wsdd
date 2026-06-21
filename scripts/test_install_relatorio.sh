#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

tmpdir="$(mktemp -d)"
report_out="$(mktemp)"
save_out="$(mktemp)"
trap 'rm -rf "$tmpdir" "$report_out" "$save_out"' EXIT

node bin/wsd-method.js install \
  --directory "$tmpdir" \
  --init-git \
  --yes \
  --github skip \
  --tools codex \
  --profile generic_node_frontend >/dev/null

mkdir -p "$tmpdir/+specs/features/checkout-flow"
cat > "$tmpdir/+specs/features/checkout-flow/spec.md" <<'EOF'
---
title: Checkout Flow
status: in-progress
risk: L1
---
# Checkout Flow

## Acceptance Criteria

- WHEN checkout runs THEN it SHALL complete.
EOF

cat > "$tmpdir/+specs/features/checkout-flow/tasks.md" <<'EOF'
# Tasks

- [ ] Implement checkout submit
- [ ] Add regression test
EOF

cat > "$tmpdir/+specs/project/ROADMAP.md" <<'EOF'
# ROADMAP

## Features Ativas

| Feature | Status | Prioridade | Spec | Notas |
|---|---|---|---|---|
| Checkout Flow | `in-progress` | Alta | `+specs/features/checkout-flow/spec.md` | Finalizar submit |

## Backlog

| Feature | Prioridade | Notas |
|---|---|---|
| Reports | Media | Melhorar visao executiva |

## Concluídas

| Feature | Entregue em | Spec |
|---|---|---|
EOF

cat > "$tmpdir/+specs/project/IDEAS.md" <<'EOF'
# IDEAS

## IDEA-001 — Relatorios melhores

**Status:** raw
EOF

cat > "$tmpdir/+specs/project/IDEAS_PIPELINE.md" <<'EOF'
# IDEAS PIPELINE

## Pipeline

| ID | Título | Status | Etapa sugerida | WSD artefato | Notas |
|---|---|---|---|---|---|
| IDEA-001 | Relatorios melhores | raw | L1 specify | — | Avaliar depois |
EOF

cat > "$tmpdir/+specs/project/CONCERNS.md" <<'EOF'
# CONCERNS

## Preocupações Ativas

| ID | Preocupação | Categoria | Severidade | Status | Área/Arquivo | Plano | Owner | Aberta em |
|---|---|---|---|---|---|---|---|---|
| CONC-001 | Checkout sem teste regressivo | Qualidade | Alta | active | src/checkout | Criar teste | Codex | 2026-06-21 |
EOF

cat > "$tmpdir/+specs/project/CONCERNS_PIPELINE.md" <<'EOF'
# CONCERNS PIPELINE

## Pipeline

| ID | Concern | Status | Etapa | Plano | Proximo passo | Gate/Evidencia | Owner | Revisar em |
|---|---|---|---|---|---|---|---|---|
| CONC-001 | Checkout sem teste regressivo | active | verification | Criar cobertura | Rodar npm test | — | Codex | hoje |
EOF

git -C "$tmpdir" config user.email wsd@example.invalid
git -C "$tmpdir" config user.name "WSD Test"
git -C "$tmpdir" add -A
git -C "$tmpdir" commit -m "chore: relatorio fixture" >/dev/null

"$tmpdir/+wsd/bin/wsd" relatorio >"$report_out"

grep -q '^# Relatorio WSD' "$report_out"
grep -q 'Implementação pela metade: sim' "$report_out"
grep -q 'Checkout Flow' "$report_out"
grep -q 'IDEA-001' "$report_out"
grep -q 'CONC-001' "$report_out"
grep -q 'Concerns: 1 ativa(s), 1 ativa(s) no pipeline, 0 sem pipeline' "$report_out"
grep -q 'Sugestão do agente:' "$report_out"
grep -q 'Worktree: clean' "$report_out"

"$tmpdir/+wsd/bin/wsd" relatorio --save >"$save_out"
grep -q 'PASS: relatorio WSD salvo em +specs/RELATORIO.md' "$save_out"
test -f "$tmpdir/+specs/RELATORIO.md"
grep -q 'Pipeline de Concerns' "$tmpdir/+specs/RELATORIO.md"

"$tmpdir/+wsd/bin/wsd" report | grep -q '^# Relatorio WSD'
