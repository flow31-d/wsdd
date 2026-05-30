---
description: Inicia sessão de desenvolvimento WSD. Use quando o usuário diz "wsd-start", "iniciar WSD", "abrir sessão", "começar trabalho", "start WSD", ou pede para iniciar trabalho em repositório governado por WSD.
argument-hint: caminho do repositório (opcional — usa diretório atual se omitido)
allowed-tools:
  - Bash
  - Read
---

# WSD Start

## Objetivo

Abrir sessão de desenvolvimento sem implementar mudanças.

## Procedimento

**1. Identificar repositório** a partir do argumento ou diretório atual.

**2. Executar estado Git:**

```bash
git status --short --branch
git branch -vv
git remote -v
git remote show origin
```

**3. Carregar contexto base:**

- Ler `+specs/project/STATE.md` — resumir decisões ativas e bloqueadores
- Ler `+specs/HANDOFF.md` se existir — resumir e perguntar "Continuar de onde parou?"
- Ler `AGENTS.md` se presente
- Ler `+context.json` se presente — identificar `write_paths`, `forbidden_paths`, `wsd.risk_default`

**4. Se WSD presente, executar checker:**

```bash
./+wsd/bin/wsd version 2>/dev/null || true
bash scripts/wsd_check.sh --risk L0 .
```

**5. Descobrir specs e PRs:**

```bash
find +specs/features -maxdepth 2 -name 'spec.md' 2>/dev/null | sort
gh pr list --state open --limit 20 2>/dev/null || true
```

**6. Auto-sizing:** classificar a tarefa solicitada pelo usuário:

- **L0 / Quick**: ≤3 arquivos, mudança local e reversível → implementar diretamente
- **L1**: feature, endpoint, integração, refatoração → `/wsd-specify` → (design) → (tasks) → implementar
- **L2**: produção, deploy, banco, auth, secrets → 4 fases + aguardar aprovação humana

**7. Reportar:**

- repo e host canônico
- branch e upstream
- worktree limpa/suja
- versão WSD instalada quando disponível
- contexto presente/ausente
- specs encontradas (id, título, status, risco)
- paths permitidos e proibidos do `+context.json`
- classificação inicial de risco da tarefa
- próxima ação segura

## Limite

Não implementar mudanças durante a rotina de abertura. Aguardar instrução explícita do usuário após o relatório.
