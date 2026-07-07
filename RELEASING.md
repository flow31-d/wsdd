---
title: "RELEASING — WSD"
created: 2026-05-11
modified: 2026-05-13
tags:
  - wsd
  - release
  - processo
status: ativo
tipo: referencia
parent: "[[wsd/wsd]]"
---

# RELEASING — WSD

Checklist obrigatório antes de qualquer bump de versão. Nenhum release sai sem todos os itens marcados.

---

## Quando criar uma nova versão

| Tipo | Quando usar | Exemplo |
|---|---|---|
| `v0.x.y` patch | Bug fix, docs, governance — sem mudança de API | v0.1.3 |
| `v0.x+1.0` minor | Feature nova ou mudança no installer | v0.2.0 |
| `v1.0.0` major | Quebra de compatibilidade ou redesign | futuro |

---

## Checklist Pré-Release

### 1. Implementação e testes

- [ ] Todas as tasks da feature/fix estão marcadas `[x]`
- [ ] `npm test` passa com 7/7 gates (ou N/N se novos gates foram adicionados)
- [ ] `npm run self-check` passa sem `FAIL:`
- [ ] `npm run docs-check` passa sem `FAIL:`

### 2. Specs e documentação

- [ ] Spec da feature tem `status: implemented` (não `approved`)
- [ ] Tasks da feature têm `status: implemented` e todos `[x]`
- [ ] `+specs/features/<slug>/` tem `spec.md` e `tasks.md`
- [ ] `docs/05_contrato_artefatos.md` menciona novos artefatos (se a feature adicionou algum)
- [ ] `docs/10_matriz_sincronizacao_notas.md` atualizado (se há nova fonte de verdade)

### 3. Artefatos de release

- [ ] `package.json`: versão bumped (ex.: `0.1.2` → `0.1.3`)
- [ ] `CHANGELOG.md`: nova seção com número da versão, data, lista de mudanças
- [ ] `README.md`: versão atualizada na seção "Status" e em "Uso Oficial" se necessário
- [ ] `ROADMAP.md` (WSD): feature marcada `[x]` na Fase correspondente
- [ ] `+specs/project/STATE.md`: decisão registrada na tabela Decisões; todo marcado `[x]`

### 4. Git e tag

- [ ] Commit de release usa tipo Conventional Commits válido: `chore(release): v0.1.3`
- [ ] `git tag v0.1.3` criado no commit de release
- [ ] `git push origin main --tags`

---

## Sequência de Execução

### Automatizada (recomendado desde v0.2.0)

Após atualizar manualmente `CHANGELOG.md`, `README.md`, `ROADMAP.md` e `+specs/project/STATE.md` com a nova versão:

```bash
# Dry-run primeiro (não modifica nada, só mostra o que seria feito)
npm run release:dry

# Execução real (patch | minor | major)
npm run release:patch           # 0.1.4 -> 0.1.5
npm run release:minor           # 0.1.4 -> 0.2.0
npm run release:major           # 0.1.4 -> 1.0.0

# OU com flags adicionais (chamada direta):
bash scripts/wsd_release.sh minor --auto-merge
bash scripts/wsd_release.sh patch --skip-wsdd  # só WSD privado
bash scripts/wsd_release.sh patch --yes        # pula prompts (use só com auto-merge)
```

O script executa: pré-flight (branch/worktree/sync), cálculo de versão, validação de CHANGELOG/README/ROADMAP, bump do `package.json`, gates locais (`npm test`, `docs-check`, `self-check`), branch + commit + push + PR no WSD privado, merge (com confirmação), tag + push tag, sync para `wsdd` público via whitelist, validação no wsdd, commit + push + tag + GitHub Release no wsdd.

Cada passo de risco (push, merge, sync wsdd) é interativo com confirmação `y/N` — use `--yes` apenas em pipelines automatizados.

### Manual (fallback se o script quebrar)

```bash
# 1. Verificação pré-release
npm test              # N/N PASS
npm run self-check    # sem FAIL
npm run docs-check    # sem FAIL

# 2. Bump de versão
# Editar package.json: "version": "0.1.X" → "0.1.X+1"

# 3. Commit de release
git add package.json CHANGELOG.md README.md ROADMAP.md +specs/project/STATE.md
git commit -m "chore(release): v0.1.X+1"

# 4. Tag
git tag v0.1.X+1
git push origin main --tags

# 5. Sync para wsdd público (manual via cp + rsync conforme whitelist em archive/REVIEW_PRE_V1.md)
```

---

## O que NÃO fazer

- ❌ Bumpar `package.json` antes de `npm test` passar
- ❌ Fazer tag antes do commit de release estar em `main`
- ❌ Esquecer de marcar a feature como `[x]` no ROADMAP.md
- ❌ Usar tipo `release:` no commit — não é Conventional Commits 1.0.0; usar `chore(release):`
- ❌ Deixar spec com `status: approved` depois de implementada

---

## Registro de Alterações

| Data | Agente | Alteração |
|---|---|---|
| 11/05/2026 | Claude | Criação do documento. Motivação: sessão 11/05 esqueceu de atualizar ROADMAP.md, docs/05 e STATE após implementar v0.1.1 e v0.1.2 — checklist previne reincidência. |
| 13/05/2026 | Claude (Opus 4.7) | Adição da seção "Automatizada" referenciando `scripts/wsd_release.sh` criado em WSD-009 (v0.2.0). Script automatiza: pré-flight, bump, verificações, gates, branch/PR/merge no WSD privado, tag + push, sync wsdd via whitelist, validação, commit + push + tag + GitHub Release no wsdd. Refs: Issue #21. |
