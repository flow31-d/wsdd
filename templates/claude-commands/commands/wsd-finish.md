---
description: Encerra sessão WSD com gates, auditoria documental quando disponível, HANDOFF.md, snapshot, commit de fechamento e worktree limpo.
allowed-tools:
  - Bash
  - Read
  - Write
---

# WSD Finish

## Objetivo

Encerrar sessão com gates aprovados, relatório Git/WSD, memória operacional e worktree limpo.

## Procedimento

**1. Preferir o comando local:**

```bash
./+wsd/bin/wsd finish
```

Ele executa gates, gera `HANDOFF.md`, atualiza snapshot e cria commit de fechamento por padrão.

**2. Gates esperados:**

```bash
git status --short --branch
git diff --stat
git diff --check
git log -1 --date=short --pretty='last=%ad | %h | %s'
bash scripts/wsd_check.sh --risk L0 .
bash scripts/wsd_docs_check.sh
```

**3. Se PR pode existir:**

```bash
gh pr status 2>/dev/null || true
gh pr view --json number,title,state,isDraft,headRefName,baseRefName,url 2>/dev/null || true
```

**4. Perguntar ao usuário:**

> Houve decisões, bloqueadores ou lições aprendidas nessa sessão?

Se sim, atualizar `+specs/project/STATE.md`:
- Decisão nova → tabela Decisões
- Bloqueador ativo → tabela Bloqueadores Ativos
- Lição aprendida → tabela Lições Aprendidas
- Ideia fora do escopo → tabela Ideias Adiadas

**5. Gerar `+specs/HANDOFF.md` com:**
- Data e hora ISO
- Feature/task atual e status resumido
- Lista: itens concluídos nessa sessão
- Lista: alterações capturadas pelo finish
- Lista: próximos passos imediatos
- Branch atual e gates de aprovação
- Referências relevantes ao STATE.md

**6. Garantir fechamento limpo:**

- `wsd finish` deve commitar por padrão com `chore(wsd): finish session`.
- O comando só é considerado concluído quando `git status --short` fica vazio.
- Se hook, gate ou path sensível falhar, parar e reportar o bloqueio.

**7. Relatório final:**

- repo e host
- branch e upstream
- estado final limpo
- arquivos alterados
- commits criados
- links PR/spec usados
- validações executadas e resultado
- validações não executadas e motivo
- riscos ou bloqueadores residuais
- próximo passo seguro

## Limite

Não usar `git reset`, `git stash`, `git clean`, `git commit --no-verify`, auto-push ou auto-merge para simular fechamento limpo.
