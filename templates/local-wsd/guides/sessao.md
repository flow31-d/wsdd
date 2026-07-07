# Guia — Sessão, HANDOFF e compactação (on-demand)

## Abrir sessão

`./+wsd/bin/wsd start` (completo) ou `start --brief` (compacto). O brief mostra
branch, worktree, versão WSD, presença dos artefatos e contadores (concerns
ativas, features). Se `+specs/HANDOFF.md` existir, resumir e continuar de onde
parou.

## Fechar sessão (full-auto por padrão)

`./+wsd/bin/wsd finish` roda, nesta ordem: `git diff --check` → gates do
`wsd_check.sh` → auditoria documental local (se houver) → prompts de STATE.md
(quando interativo) → snapshot → `+specs/HANDOFF.md` → commit de fechamento →
falha se a worktree não terminar limpa. Flags: `--no-commit`,
`--skip-docs-check`, `-m "mensagem"`.

## Memória entre sessões

- `STATE.md`: decisões, bloqueadores, lições, ideias adiadas. Atualizar a cada
  sessão relevante.
- `CONCERNS.md` + `CONCERNS_PIPELINE.md`: preocupações ativas `CONC-###` com
  plano/evidência. Registrar na hora em que a fragilidade aparecer.
- `HANDOFF.md`: passe de bastão gerado pelo finish (branch, últimos commits,
  specs abertas).

## Compactação (obrigatória — evita context rot)

Nada é apagado; o resolvido sai do caminho de leitura. O comando mecânico faz
isso por você:

```bash
./+wsd/bin/wsd compact --dry-run   # mostra o que seria arquivado
./+wsd/bin/wsd compact             # arquiva entradas fechadas/antigas
```

Regras determinísticas: bloqueadores resolvidos, todos `- [x]`, concerns
`resolved`/`accepted-risk`/`obsolete` e decisões/lições além das 10 mais
recentes vão para `+specs/project/archive/<NOTA>_<AAAA-SEM>.md`, com IDs
preservados. O `wsd finish` roda `compact --if-bloated` automaticamente quando
uma nota passa do limiar (150 linhas ou ~2k tokens no STATE; 120 linhas ou
~1,5k tokens nas concerns). Arquivamento manual continua válido:

- Quando `STATE.md` passar de ~150 linhas: mover decisões/lições antigas e
  bloqueadores resolvidos para `+specs/project/archive/STATE_<AAAA-SEM>.md`
  (ex.: `STATE_2026H1.md`), mantendo no ativo só o vigente + uma linha de
  ponteiro para o arquivo.
- Quando concerns forem `resolved`/`accepted-risk`/`obsolete` há mais de uma
  sessão: mover as linhas (mantendo IDs) para
  `+specs/project/archive/CONCERNS_<AAAA-SEM>.md`.
- `wsd check` e `wsd finish` avisam quando uma nota passa do limiar.
- Nunca renumerar IDs arquivados; `CONC-017` continua `CONC-017` no arquivo.
