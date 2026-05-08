---
description: Encerra sessão de desenvolvimento WSD com relatório padronizado. Use quando o usuário diz "wsd-finish", "finalizar WSD", "encerrar sessão", "fechar trabalho", "fim WSD", "finish WSD".
allowed-tools:
  - Bash
  - Read
  - Write
---

# WSD Finish

## Objetivo

Encerrar sessão com relatório padronizado Git e WSD, e registrar lições aprendidas se houver.

## Procedimento

**1. Executar estado final:**

```bash
git status --short --branch
git diff --stat
git diff --check
git log -1 --date=short --pretty='last=%ad | %h | %s'
```

**2. Se WSD presente:**

```bash
bash scripts/wsd_check.sh --risk L0 .
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
- Lista: itens em andamento (arquivo:linha se aplicável)
- Lista: próximos passos imediatos
- Branch atual e arquivos com uncommitted changes
- Referências relevantes ao STATE.md

**7. Relatório final:**

- repo e host
- branch e upstream
- estado limpo/sujo
- arquivos alterados
- commits criados
- links PR/spec usados
- validações executadas e resultado
- validações não executadas e motivo
- riscos ou bloqueadores residuais
- próximo passo seguro

## Limite

Não esconder estado sujo. Não executar `git add .`, `git stash`, `git reset`, `git clean` ou trocar branch apenas para deixar o relatório limpo.
