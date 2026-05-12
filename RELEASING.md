---
title: "RELEASING — WSD"
created: 2026-05-11
modified: 2026-05-11
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

```bash
# 1. Verificação pré-release
npm test              # 7/7 PASS
npm run self-check    # sem FAIL
npm run docs-check    # sem FAIL

# 2. Bump de versão
# Editar package.json: "version": "0.1.X" → "0.1.X+1"

# 3. Commit de release
git add package.json CHANGELOG.md README.md ROADMAP.md docs/ +specs/
git commit -m "chore(release): v0.1.X+1"

# 4. Tag
git tag v0.1.X+1
git push origin main --tags
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
