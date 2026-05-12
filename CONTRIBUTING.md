# Contribuindo com WSD

Este documento orienta quem encontrar bugs, melhorias ou novas necessidades enquanto **usa o WSD em projetos clientes**. Se você é um agente (Codex, Claude Code, outro) ou um operador humano, comece por aqui.

WSD é um kit pessoal estável (`v0.1.0`) usado em múltiplos projetos. Correções precisam mirar o lugar certo para não se perderem em `wsd update` ou contaminarem outros projetos.

---

## 1. Onde mora o bug, onde corrigir

| Tipo de problema | Onde corrigir | Por quê |
|---|---|---|
| Arquivo do projeto-alvo (`+context.json`, `+specs/*`, `AGENTS.md` já preenchido, código do produto) | **No projeto-alvo** | É propriedade dele, não do WSD |
| Arquivo vendorizado pelo WSD (`+wsd/bin/wsd`, `+wsd/hooks/*`, `+wsd/schemas/*`, `+wsd/party-mode/*`) | **Aqui (`flow31-d/WSD`)** | Patch local some no próximo `./+wsd/bin/wsd update` |
| Skill ou comando de agente (`.codex/skills/*`, `.claude/commands/*`) | **Aqui (`flow31-d/WSD`)** | Mesma razão: é vendorizado |
| Template (`templates/repo/*.template`, `templates/specs/*.template`) | **Aqui (`flow31-d/WSD`)** | Para outros projetos não herdarem o mesmo bug |
| Lógica do installer (`bin/wsd-method.js`, `install.sh`) | **Aqui (`flow31-d/WSD`)** | Está fora do projeto-alvo |
| Doc metodológica (`docs/00`–`docs/14`, `README`, `ROADMAP`, `CHANGELOG`) | **Aqui (`flow31-d/WSD`)** | Fonte da verdade |

**Regra prática**: se você editou e a edição tem chance de sumir num `wsd update`, o lugar correto é aqui.

---

## 2. Fluxo de bug fix

### 2.1 Quick fix local (se está bloqueando)

1. Edite no projeto-alvo o suficiente para destravar.
2. Anote em `+specs/project/STATE.md` do projeto: data, arquivo, mudança, motivo.
3. Continue para a 2.2 — não esqueça que essa edição vai sumir.

### 2.2 Issue + PR no `flow31-d/WSD`

1. **Abrir Issue**: descreva o sintoma, arquivo, projeto onde apareceu, edição local que resolveu.
2. **Branch dedicada**: `fix/<slug>` ou `docs/<slug>` partindo de `main`.
3. **Commit**: Conventional Commits 1.0.0 obrigatório (ver §4).
4. **Validar gates** antes do push (ver §5).
5. **Push + PR para `main`**: descrição clara, link para a Issue, test plan.
6. **Merge**: depois de revisão, com `gh pr merge --merge`.
7. **Tag + release**: se a correção justifica patch, bump `v0.1.x`, tag, GitHub release.
8. **Update nos projetos**: rodar `./+wsd/bin/wsd update` em cada projeto que precise.

### 2.3 Bug arquitetural ou feature nova

- Se é mudança breaking ou feature grande: **não corrija direto**. Abra Issue com proposta. Provavelmente vira `v0.2.0`, não `v0.1.x`.
- Veja em `+specs/project/STATE.md` (decisões anteriores) e `docs/12_avaliacao_critica.md` (gaps conhecidos) antes de propor — pode já ter sido discutido.

---

## 3. Convenção de versionamento (semver)

WSD segue [SemVer 2.0.0](https://semver.org):

- **`v0.1.x`** (patches): bug fixes, ajustes de doc, melhorias internas que **não mudam contrato**. Projetos instalados na `v0.1.0` continuam funcionando após `wsd update`.
- **`v0.2.0`**: novas features grandes ou mudanças de contrato (campo novo no `+context.json`, comando renomeado, schema alterado). Requer piloto antes do release. Nota de migração no `CHANGELOG.md`.
- **`v1.0.0`**: contrato auditado e múltiplos pilotos concluídos. Compromisso forte de estabilidade.

Mudanças que **quebram** instalação existente nunca devem ir em `v0.1.x`.

---

## 4. Convenção de commits (Conventional Commits 1.0.0)

Tipos válidos:

```
feat:      nova feature
fix:       bug fix
docs:      mudança apenas de documentação
chore:     tarefa de manutenção (release, deps, config)
refactor:  refactor sem mudar comportamento
perf:      otimização de performance
test:      adicionar ou corrigir testes
build:     mudanças no build/dependências
ci:        mudanças em CI/CD
revert:    reverter commit anterior
style:     formatação, semicolons, etc. (sem mudar lógica)
```

Escopo opcional entre parênteses: `fix(installer): ...`, `feat(party-mode): ...`, `chore(release): v0.2.0`.

**Tipos NÃO válidos**: `release:`, `update:`, `improve:`, `misc:` etc. Se o `wsd-method install` aplicou hooks, o `commit-msg` bloqueia. No próprio repo do método (este aqui) o hook não roda — atenção redobrada.

---

## 5. Validação obrigatória antes do PR

Rode os 3 gates no diretório `x/wsd/` antes de pedir merge:

```bash
npm test                              # 7 gates de instalação (Codex, Claude, brownfield, git, party-mode)
bash scripts/wsd_docs_check.sh        # sincronização documental
bash scripts/wsd_self_check.sh        # consistência interna, scan de segredos
```

Se algum falhar, **conserte antes** de abrir PR. PRs com gate vermelho não são merge-prontos.

---

## 6. Política Git para Agentes

Esta repo segue a política em `Recursos/r.3_recursos_sincronizacao/r.3.4_git_github/r.3.4.6_politica_git_para_agentes.md` da VPS:

- HTTPS via `gh` (sem SSH manual como padrão).
- `git pull --ff-only` (evitar merge commits desnecessários).
- Branch dedicada para mudanças não triviais — **não trabalhar direto em `main`**.
- Não deletar branches/tags sem registrar o motivo (no commit, na PR, ou no `STATE.md`).
- Não usar `git reset --hard`, `git clean -fd`, force push em branch compartilhada sem decisão consciente e documentada.

---

## 7. Sincronização documental

Mudou versão, instalador, regra de agente, template, profile ou script? Antes do commit:

- abra `docs/10_matriz_sincronizacao_notas.md`;
- revise o grupo mínimo de notas para o tipo de mudança;
- atualize `README.md`, `wsd.md`, `ROADMAP.md`, `CHANGELOG.md` quando aplicável;
- atualize as seções "🔄 Atualizações" e o registro final de alterações dos arquivos editados;
- rode `wsd_docs_check.sh` e `wsd_self_check.sh`.

---

## 8. Onde encontrar contexto

| Pergunta | Onde olhar |
|---|---|
| Qual é a visão e princípios do WSD? | `README.md`, `wsd.md`, `docs/01_constituicao.md` |
| Como o método se comporta operacionalmente? | `docs/03_ciclo_operacional.md`, `docs/08_rotinas_sessao.md` |
| Quais decisões já foram tomadas e por quê? | `+specs/project/STATE.md` (tabelas Decisões, Lições, Bloqueadores, Ideias Adiadas) |
| Quais features estão entregues e quais foram descartadas? | `ROADMAP.md`, `docs/12_avaliacao_critica.md` |
| Como fazer release? | `docs/09_publicacao_github_privado.md` |
| Como mudou cada versão? | `CHANGELOG.md` |
| Como agentes devem se comportar editando este repo? | `AGENTS.md` |

Lendo essas fontes, qualquer agente competente entende o estado atual e pode contribuir sem precisar de uma sessão prévia específica.

---

## 9. Em caso de dúvida

- Se não está claro **onde** o bug mora: abra Issue descritiva e pergunte antes de mexer.
- Se a mudança parece grande: proponha como Issue de discussão antes de codar.
- Se é trivial e óbvio: pode ir direto pelo fluxo §2.2.

O objetivo é manter `flow31-d/WSD` como fonte única e estável, e que cada projeto cliente saiba que recebe correções via `wsd update`, não via patches locais perpétuos.
