---
title: "12 — Avaliação Crítica do WSD"
created: 05/05/2026
modified: 06/05/2026
tags:
  - x
  - wsd
  - avaliacao
  - critica
  - metodologia
  - agentes
status: ativo
tipo: referencia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/README]], [[wsd/ROADMAP]], [[wsd/docs/01_constituicao]], [[wsd/docs/02_matriz_risco]], [[wsd/docs/03_ciclo_operacional]], [[wsd/docs/05_contrato_artefatos]], [[wsd/docs/10_matriz_sincronizacao_notas]], [[wsd/docs/11_modulo_git_governance]], [[r.3.7_spec_driven_development/r.3.7.9_enforcement_agentes_cli]]"
otimizado_para_obsidian: true
---

# 12 — Avaliação Crítica do WSD

[[wsd/wsd|← WSD]]

---

> [!abstract] Contexto
> Avaliação externa do WSD como metodologia de desenvolvimento com agentes CLI, realizada em 06/05/2026 com base na leitura completa de todos os documentos, templates, profiles, CLI e scripts da versão `v0.1.2-alpha`. Objetivo: determinar se o WSD é adequado para uso em todos os projetos — e o que precisa mudar antes disso. Esta reavaliação consolida o WSD como **Codex-first**, com Claude Code quase igualmente importante na fase de suporte e preparação posterior.

> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. O que é Bem Feito]]
3. [[#3. O que Preocupa]]
4. [[#4. Recomendação]]
5. [[#5. Veredicto Final]]
6. [[#6. 🕒 Registro de Alterações por Agentes]]

---

## 1. 🔄 Atualizações

- 06/05/2026 11:31:14 -03 — Codex: Reavaliação da nota crítica do WSD com foco Codex-first, reconhecimento de Claude Code quase igualmente importante e atualização da data de análise para o momento atual.
- 06/05/2026 14:41:06 -03 — Codex: Padronização das listas de ação da nota crítica com checkboxes para facilitar acompanhamento do que falta implementar.
- 07/05/2026 — Claude: Marcação dos itens concluídos em 4.1, 4.2, 4.3, 4.4 e 4.5 com `[x]` (v0.1.3–v0.1.6-alpha).
- 07/05/2026 — Codex: Inclusão do MVP Git/GitHub Governance como próxima ação antes da estável (`v0.1.10-alpha`).
- 07/05/2026 — Codex: Marcação do MVP Git/GitHub Governance como concluído na `v0.1.10-alpha`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 2. O que é Bem Feito

### 2.1 Arquitetura em camadas — a melhor decisão do projeto

A separação `método global / template copiável / adapter por repo / rotina de sessão` é conceitualmente a decisão mais madura do WSD. Ela resolve o problema que destrói a maioria das tentativas de governança de agentes: a tendência de colapsar tudo em um único arquivo grande (CLAUDE.md de 500 linhas, AGENTS.md que tenta ser tudo ao mesmo tempo).

O que cada camada faz e por que importa:

- **Método global** (`docs/01` a `docs/11`): os princípios que não mudam de projeto para projeto. Nenhum agente reinventa o que é L2 ou o que é "worktree suja".
- **Template copiável** (`templates/repo/`, `templates/specs/`): artefatos com `{{placeholders}}` que o instalador renderiza. O agente nunca precisa inventar a estrutura do `+context.json` ou de uma spec L1 — existe um contrato explícito. Ver [[wsd/docs/05_contrato_artefatos|05 — Contrato de Artefatos]].
- **Adapter por repo** (`AGENTS.md` local, `+context.json`, `+specs/context/*.md`): o que é específico ao projeto. Write paths, forbidden paths, comandos de validação reais, host canônico. O método global não presume nada sobre o projeto — o adapter declara.
- **Rotina de sessão** (`wsd start` / `wsd check` / `wsd finish`): o procedimento de abertura e encerramento que garante que o agente não começa cego e não termina sem deixar rastreabilidade.

Essa separação também permite evolução independente: mudar os templates não quebra o método; mudar as regras de um repo não afeta os outros.

### 2.2 Matriz de risco L0/L1/L2 — proporcional e prática

A decisão de usar três níveis em vez de binário (sim/não) ou contínuo (1-10 sem semântica) é acertada. Cada nível tem:

- **Requisitos diferentes** de entrada (Task Card vs. spec aprovada vs. spec + aprovação humana)
- **Bloqueios explícitos** — o que não pode ser feito em cada nível
- **Escore numérico opcional** (1 a 10) para granularidade dentro do nível

O escore 1-10 mapeado sobre os níveis é especialmente útil: um L1 com score 7 exige mais atenção que um L1 com score 5, sem ter que criar um quarto nível burocrático.

A **regra de elevação** — "se em dúvida entre dois níveis, use o maior" — é a regra prática mais importante do documento inteiro. Agentes tendem a subestimar risco; essa regra compensa a tendência.

Exemplos específicos do que cada nível bloqueia, extraídos da [[wsd/docs/02_matriz_risco|02 — Matriz de Risco]]:

| L0 bloqueia | L1 bloqueia | L2 bloqueia |
|-------------|-------------|-------------|
| produção, secrets, banco | spec em `draft`, paths sensíveis não declarados | execução autônoma de produção por agente |
| autenticação, deploy | ausência de validação | ausência de rollback |
| alteração estrutural grande | mistura com mudanças preexistentes | segredo em prompt ou Git |

### 2.3 Constituição com 10 regras — cobre as falhas reais

As 10 regras da [[wsd/docs/01_constituicao|01 — Constituição]] não são abstratas — endereçam diretamente os padrões de falha mais comuns observados em agentes de código:

**Regra 1 — Intenção Antes de Execução:** exige que o agente responda 8 perguntas antes de editar qualquer coisa (qual repositório, qual host, qual branch, se a worktree está suja, qual objetivo, qual risco, quais arquivos pode alterar, como validar). Isso elimina o padrão de agente que "começa a trabalhar" antes de entender o contexto.

**Regra 4 — Agente Não Esconde Sujeira:** lista explicitamente os comandos proibidos para esconder estado — `git stash`, `git reset`, `git clean`, `git add .`, `git checkout --`, force push. Não é uma regra vaga ("seja cuidadoso com git"); é uma blocklist operacional.

**Regra 5 — Validação Deve Ser Real:** proíbe que o agente invente comandos de teste. Se não há teste formal, deve registrar isso e executar a melhor validação disponível. Isso evita o padrão de agente que declara "testes passando" sem ter rodado nada verificável.

**Regra 6 — Segredos Nunca Entram em Memória Longa:** a lista de onde secrets não podem aparecer é completa — Git, Obsidian, specs, issues, PRs, prompts, logs, `error_vault.json`, screenshots, exemplos. Cada item da lista existe porque é um vetor real de vazamento.

**Regra 10 — Saída Deve Ser Auditável:** exige que ao final de toda tarefa exista evidência suficiente para outro agente continuar: branch, commit ou diff, spec usada, validação executada, validação *não* executada com motivo, risco residual, próximo passo seguro. Isso transforma o encerramento de sessão de um ato informal em uma entrega verificável.

### 2.4 Ciclo de 7 fases — encerramento como cidadão de primeira classe

A maioria dos frameworks de agentes modela a fase de execução bem e ignora abertura e encerramento. O WSD inverte a prioridade relativa:

- **Fase 1 (Abrir):** não apenas "carregar contexto", mas executar comandos concretos — `git status`, `git branch -vv`, `git remote show origin` — e reportar estado antes de tocar qualquer arquivo.
- **Fase 7 (Fechar):** checklist com comandos reais (`wsd finish`, `git diff --check`, `git log -1`) e relatório estruturado obrigatório.

O encerramento de sessão é onde mais informação operacional se perde em fluxos tradicionais. Um agente que termina sem registrar "o que mudou, onde mudou, o que ficou pendente" força o próximo agente a reconstruir esse contexto do zero — o que frequentemente leva a retrabalho ou erros.

### 2.5 Matriz de sincronização documental — conhecimento operacional explícito

O [[wsd/docs/10_matriz_sincronizacao_notas|doc 10]] é raro em repositórios de qualquer tipo: um mapa explícito de quais artefatos devem ser atualizados juntos quando qualquer parte do sistema muda.

Exemplos concretos do que a matriz define:

- Mudou versão ou release → `package.json` + README + CHANGELOG + ROADMAP + docs/09
- Mudou instalador ou CLI → README + docs/00 + docs/04 + docs/08 + CHANGELOG
- Mudou regra para agentes → AGENTS + docs/01 ou docs/03 + docs/07 + templates de agentes + skills

Sem esse documento, atualizações parciais são a norma: o CHANGELOG é atualizado mas o README não; o instalador muda mas o playbook continua descrevendo o fluxo antigo. A matriz transforma "lembrar de atualizar tudo" em um procedimento verificável com `bash scripts/wsd_docs_check.sh`.

### 2.6 CLI local vendorizado — approach correto para portabilidade

O padrão `+wsd/bin/wsd` instalado dentro do repositório alvo (não como dependência global) resolve um problema prático: diferentes projetos podem ter versões diferentes do WSD sem conflito, e o CLI funciona mesmo sem `npm install -g` ou qualquer configuração de ambiente. O `install.sh` copia os artefatos necessários e os deixa autossuficientes no repo.

O `wsd-method.js` já implementa `install`, `doctor`, `help`, `update` e `--list-options` — um CLI funcional, não apenas um script de bootstrap.

### 2.7 Ciclo de vida de spec com estados explícitos

O status lifecycle das specs — `draft` → `approved` → `implemented` → `verified` → `closed` → `superseded` — é maduro. O estado `draft` bloqueando promoção L1/L2 é uma regra operacional importante: impede que agentes executem specs não aprovadas. O estado `superseded` resolve o problema de specs que ficam válidas na forma mas foram substituídas por uma decisão posterior.

### 2.8 Perfis de projeto — parametrização que funciona

Os 4 perfis existentes (`generic_node_frontend`, `generic_python_api`, `koomplet_office`, `prescreve_mais`) demonstram que a abstração de perfil resolve o problema de personalização sem poluir os templates genéricos. Cada perfil declara write_paths, forbidden_paths, ferramentas, comandos de validação e áreas L2 específicas do tipo de projeto.

O installer renderiza o `+context.json` a partir do perfil — o agente não precisa preencher campos manualmente; a estrutura correta emerge do tipo de projeto.

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 3. O que Preocupa

### 3.1 Codex-first com suporte Claude Code em evolução

> [!warning] Impacto imediato no uso diário
> O WSD foi construído e otimizado para Codex. Claude Code permanece quase igualmente importante no plano de suporte e expansão, mas ainda está em fase de preparação operacional.

**Lacunas específicas:**

O `wsd install --tools codex` cria três skills em `.codex/skills/`:
- `.codex/skills/wsd` — regras gerais WSD para o Codex
- `.codex/skills/wsd-start` — procedimento de abertura de sessão
- `.codex/skills/wsd-finish` — procedimento de encerramento

O equivalente para Claude Code ainda não está no mesmo nível de maturidade. Sem `.claude/` skills correspondentes, o agente não tem o fluxo de sessão automatizado. O `wsd start` pode rodar manualmente, mas não será invocado como skill no início de uma sessão Claude.

**O que isso significa na prática:** ao abrir uma sessão Claude Code em um repositório WSD, o agente ainda pode deixar de executar automaticamente o checklist da Fase 1 (git status, branch, remote, worktree) se a integração própria não estiver instalada. Vai começar a trabalhar diretamente — o exato problema que o WSD foi projetado para resolver.

**Mitigação até o suporte chegar:** adicionar no `AGENTS.md` local do repo uma instrução explícita — "ao iniciar qualquer sessão, execute `+wsd/bin/wsd start` antes de qualquer ação" — e no `CLAUDE.md` global um lembrete equivalente.

### 3.2 Nenhuma enforcement técnica das regras

> [!warning] Preocupação estrutural
> O sistema é inteiramente baseado em convenção. Um agente que não lê AGENTS.md, ou que inicia sem carregar o contexto correto, não tem nada que o bloqueie tecnicamente. O `wsd_check.sh` valida estrutura de arquivos, não conformidade de comportamento.

**O que especificamente fica sem cobertura:**

- Um agente pode editar arquivos em `forbidden_paths` declarados no `+context.json` sem qualquer bloqueio
- Um agente pode fazer commit sem spec aprovada em uma tarefa L1 — o `pre-commit` padrão não existe no bootstrap atual
- Um agente pode executar `git push` sem encerrar a sessão WSD corretamente
- Nada impede `git add .` mesmo com a Regra 4 proibindo explicitamente

**Por que isso é aceitável no curto prazo mas não no longo:**

Em uso solo com um único agente bem configurado, a convenção funciona — o agente vai ler AGENTS.md e seguir as regras. O problema surge com:
- Múltiplos agentes no mesmo repositório com contextos diferentes
- Sessões sem carregamento completo do contexto (contexto truncado, sessão nova)
- Outros desenvolvedores ou agentes sem conhecimento do WSD

**O caminho de solução já existe na estrutura:** `allowed_scopes` e `forbidden_scopes` nas specs, `write_paths` e `forbidden_paths` no `+context.json` — esses dados são exatamente o que um hook PreToolUse precisaria consultar para enforcement técnico. A informação está lá; falta a camada que a usa.

Para o mapa completo de estudo mecanismos disponíveis (teoria): [[r.3.7_spec_driven_development/r.3.7.9_enforcement_agentes_cli|r.3.7.9 — Enforcement Técnico em Agentes CLI]].

### 3.3 Ghost specs — aprovação sem substância

O `draft` bloqueando promoção L1/L2 é a proteção correta no lugar certo. O problema fica logo depois: uma spec com status `approved` mas campos preenchidos superficialmente passa pelo checker sem objeção.

**Exemplos de ghost spec que o sistema aceita:**

```yaml
intent:
  description: "implementar feature X"
acceptance_criteria:
  - "funcionar corretamente"
validation_commands:
  - "testar manualmente"
rollback_plan:
  - "reverter se necessário"
```

Nenhum desses campos viola nenhuma regra estrutural do WSD, mas nenhum deles é operacionalmente útil. Um `acceptance_criteria` sem condição verificável e um `rollback_plan` sem comando concreto são mais perigosos que nenhuma spec — criam a ilusão de rigor sem o rigor.

**Mitigação possível sem mudança de schema:** adicionar no template de spec L1 exemplos negativos explícitos — "acceptance_criteria não pode ser 'funcionar' ou 'estar correto'; deve ser uma condição verificável por comando" — e incluir essa verificação no `wsd_check.sh` como aviso (não bloqueio) para campos suspeitos.

### 3.4 Acoplamento ao Obsidian — portabilidade futura

O vault Obsidian é o ambiente de leitura primário do WSD. Todos os docs metodológicos usam wikilinks internos (`[[wsd/docs/02_matriz_risco]]`) para navegação, índices com links literais de heading, e callouts de Obsidian. Isso é correto para o uso atual.

**O problema surge em dois cenários:**

1. **Colaboração futura:** se o WSD for compartilhado (abertura parcial do repo, colaboradores, fork para outro projeto), os wikilinks quebram fora do vault. Alguém abrindo os docs no GitHub ou em qualquer editor vai ver links não resolvidos.

2. **Longevidade do vault:** se o vault mudar de estrutura, mover pastas, ou se o próprio Obsidian mudar a sintaxe de wikilinks, todos os docs WSD ficam com links quebrados simultaneamente.

**Isso não é urgente, mas é técnica acumulada.** A mitigação de longo prazo seria manter os docs metodológicos com markdown standard nos links internos (usando paths relativos) e deixar wikilinks apenas nas notas do vault. O nível de trabalho para fazer essa mudança cresce com o tempo.

### 3.5 `error_vault.json` — boa ideia, baixa adesão estrutural

O schema do `error_vault.json` com campos `id`, `data`, `escopo`, `sintoma`, `causa`, `correção`, `prevenção` e `TTL` é bem projetado. O problema não é o schema — é o incentivo de uso.

**O padrão de falha esperado:** agentes encerram sessões sem popular o vault porque nada no fluxo de encerramento exige ou pergunta explicitamente. O `wsd finish` executa um checklist de estado (git status, diff, log) mas não inclui nenhuma pergunta sobre lições aprendidas.

**O resultado prático:** o `error_vault.json` ficará vazio ou com entradas antigas, deixando de cumprir sua função de "memória operacional que evita retrabalho".

**Solução simples:** adicionar ao script `wsd finish` um prompt interativo — `"Houve erro ou lição aprendida nessa sessão? (s/n)"` — que, se confirmado, abre o editor para registrar a entrada estruturada. Um ato de escrita de 2 minutos no momento certo é mais valioso que um schema perfeito que nunca é preenchido.

### 3.6 `$schema` sem validação real

O `+context.json` declara `"$schema": "wsd/context/v1"` mas essa string não aponta para nenhum schema JSON validável por ferramentas externas (não é uma URL, não é um path resolvível). O mesmo vale para `"$schema": "wsd/spec/v1"` nas specs.

**Consequência:** ferramentas de validação JSON Schema (`ajv`, VS Code, etc.) não conseguem validar os arquivos contra o schema declarado. A validação fica restrita ao `wsd_check.sh`, que valida presença de campos mas não tipos, formatos ou valores válidos.

**Mitigação:** publicar os schemas como arquivos JSON reais em `templates/schemas/context.v1.schema.json` e `templates/schemas/spec.v1.schema.json`, e atualizar o `$schema` para um path relativo resolvível. Isso habilita validação automática em editores e no CI sem escrever código adicional.

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 4. Recomendação

> [!tip] Veredicto
> **Sim para uso em todos os projetos — o núcleo está pronto. Três ações desbloqueiam o potencial completo.**

O núcleo do WSD — Constituição + Matriz de Risco + Ciclo Operacional + Contrato de Artefatos + Matriz de Sincronização — é suficientemente sólido para uso agora. Os problemas identificados são todos evolutivos, não bloqueantes.

### 4.1 Ação imediata — suporte Codex-first e espelhamento Claude Code

- [x] Criar `.claude/` skills espelhando as `.codex/skills/` existentes. (`v0.1.3-alpha`)
- [x] Adicionar `--tools claude-code` ao CLI do installer. (`v0.1.3-alpha`)
- [x] Gerar `.claude/wsd.md` com as regras WSD adaptadas para instruções de Claude Code. (via `AGENTS.md` + `CLAUDE.md` no template — `v0.1.3-alpha`)
- [x] Gerar `.claude/wsd-start.md`, `wsd-finish.md`, `wsd-specify.md`, `wsd-design.md`, `wsd-tasks.md`. (`v0.1.3/v0.1.4-alpha`)
- [x] Incluir no `AGENTS.md` gerado pelo `wsd install` seção de início de sessão com comandos obrigatórios. (`v0.1.4-alpha`)

### 4.2 Ação de médio prazo — enforcement técnico via hooks

- [x] Gerar `.claude/settings.json` com hooks `PreToolUse` que consultam `+context.json`. (`v0.1.3-alpha`)
- [x] Bloquear `write_paths` e `forbidden_paths` fora da política do projeto via `pre-tool.sh`. (`v0.1.3-alpha`)
- [ ] Validar `git push` sem spec aprovada para L1/L2 (parcial: `pre-push` roda WSD gate, mas não verifica spec por branch).
- [x] Registrar a política em `AGENTS.md` gerado. (`v0.1.3-alpha`)

```bash
#!/bin/bash
# +wsd/hooks/pre-tool.sh
# Lê forbidden_paths do +context.json e bloqueia writes fora de write_paths

TOOL_INPUT=$(cat)
TOOL_NAME=$(echo "$TOOL_INPUT" | jq -r '.tool_name')
PATH_ARG=$(echo "$TOOL_INPUT" | jq -r '.tool_input.path // .tool_input.command // ""')

if [ -f "+context.json" ]; then
  FORBIDDEN=$(jq -r '.permissions.forbidden_paths[]' +context.json 2>/dev/null)
  for fp in $FORBIDDEN; do
    if [[ "$PATH_ARG" == *"$fp"* ]]; then
      echo "WSD: path proibido pelo +context.json: $fp" >&2
      exit 2
    fi
  done
fi
exit 0
```

Isso transforma as regras de convenção do `+context.json` em enforcement técnico real sem overhead de desenvolvimento significativo. Ver [[r.3.7_spec_driven_development/r.3.7.9_enforcement_agentes_cli#4. Nível 3 — Hooks PreToolUse|r.3.7.9 § Hooks PreToolUse]].

### 4.3 Ação de médio prazo — git hooks no bootstrap

- [x] Instalar hooks git no `.git/hooks/` do projeto alvo. (`v0.1.6-alpha`)
- [x] Fazer `pre-commit` executar `wsd_check.sh`. (`v0.1.6-alpha`)
- [x] Fazer `commit-msg` validar Conventional Commits 1.0.0. (`v0.1.6-alpha`)
- [x] Fazer `pre-push` rodar `wsd_check.sh --risk L0` antes de push. (`v0.1.6-alpha`)
- [x] `scripts/wsd_check.sh` é o validador invocado em `pre-commit` e `pre-push`. (`v0.1.6-alpha`)

### 4.4 Ação de longo prazo — piloto antes de escalar

- [x] Completar o piloto no `koomplet-office` antes de replicar para todos os projetos. (07/05/2026)
- [x] Medir se partes do `wsd start` são redundantes em sessões curtas. (lições em STATE.md)
- [x] Verificar `error_vault.json` — substituído por `STATE.md` em `v0.1.4-alpha`.
- [x] Validar se o template de spec L1 cobre os campos que projetos reais precisam. (9/9 acceptance criteria atendidos no piloto)
- [x] Verificar falsos positivos em `wsd_check.sh`. (zero durante piloto)

### 4.5 Roadmap completo de evolução

- [x] Skills Claude Code (`wsd-start`, `wsd-finish`, `wsd-specify`, `wsd-design`, `wsd-tasks`) — `v0.1.3/v0.1.4-alpha`.
- [x] Hook `PreToolUse` gerado pelo `wsd install` — `v0.1.3-alpha`.
- [x] Git hooks instalados no bootstrap — `v0.1.6-alpha`.
- [x] Piloto `koomplet-office` completo — 07/05/2026 (`v0.1.4-alpha`).
- [x] `$schema` como arquivo JSON real (`schemas/context.schema.json`) — `v0.1.5-alpha`.
- [x] Prompt de lição aprendida no `wsd finish` — HANDOFF.md + prompts STATE.md implementados em `v0.1.7-alpha`.
- [x] MVP Git/GitHub Governance antes da estável — `v0.1.10-alpha` (`--git-policy`, `wsd git doctor/preflight/pr-check`, PR/Issue templates).
- [x] Party Mode Integration — `v0.1.11-alpha` (`installPartyMode`, `/wsd-party-mode`, subcomando `wsd party`, seção AGENTS.md, gate de teste).
- [x] ~~Validação YAML formal para specs L1/L2.~~ **Descartado em 07/05/2026** — templates `.spec.yaml.template` são legados não copiados pelo installer; specs operacionais usam markdown + frontmatter + WHEN/THEN/SHALL, já validadas pelo ghost spec detector.
- [x] ~~Perfis genéricos adicionais (Go, React Native).~~ **Descartado em 07/05/2026** — instalação interativa rica (v0.1.8) e `--brownfield` cobrem o caso de uso; BMAD/TLC não usam perfis pré-definidos por stack.
- [ ] Server-side hook como módulo opcional — esforço médio, enforcement inquebrável (mantido fora de escopo inicial).
- [ ] OPA/Rego como módulo avançado — esforço alto, multi-agente e times (mantido fora de escopo inicial).

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 5. Veredicto Final

> [!important] Posição
> WSD é um dos frameworks de governança de agentes mais bem estruturados em repositório pessoal que já analisei. A maioria das tentativas equivalentes consiste em um CLAUDE.md de 300 linhas sem arquitetura. O WSD tem arquitetura.

**O que o diferencia de forma genuína:**
- Separação de camadas que permite evolução independente
- Constituição com regras operacionais (não princípios vagos)
- Ciclo com encerramento tratado como entrega, não como ato informal
- Matriz de sincronização que torna o conhecimento operacional explícito e auditável
- CLI vendorizado que funciona sem dependência global

**O que ainda é alpha de fato:**
- Suporte a Claude Code ainda não atingiu o mesmo nível de maturidade operacional de Codex
- Enforcement é 100% convencional — um agente mal configurado ignora tudo sem bloqueio
- O piloto real não aconteceu — o sistema ainda não foi testado sob pressão de projeto

**Conclusão:** use o núcleo agora. Implemente o espelhamento Claude Code em paralelo ao fluxo Codex antes de escalar. O WSD está a três ações de distância de ser o sistema de governança adequado para todos os projetos.

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 6. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 06/05/2026 11:31:14 -03 | Codex | `x/wsd/docs/12_avaliacao_critica.md` | Reavaliação da nota crítica do WSD com foco Codex-first, suporte Claude Code quase equivalente e atualização temporal da análise para o momento atual. |
| 06/05/2026 14:41:06 -03 | Codex | `x/wsd/docs/12_avaliacao_critica.md` | Padronização das listas de ação da nota crítica com checkboxes para facilitar acompanhamento do que falta implementar. |
| 07/05/2026 — | Claude | `x/wsd/docs/12_avaliacao_critica.md` | Marcação dos itens concluídos em 4.1–4.5 com `[x]` refletindo entregas v0.1.3–v0.1.6-alpha. |
| 07/05/2026 — | Codex | `x/wsd/docs/12_avaliacao_critica.md` | Saneamento documental v0.1.9-alpha: prompt de lição no `wsd finish` marcado como concluído conforme v0.1.7-alpha. |
| 07/05/2026 — | Codex | `x/wsd/docs/12_avaliacao_critica.md` | Inclusão do MVP Git/GitHub Governance como próxima ação antes da estável (`v0.1.10-alpha`). |
| 07/05/2026 — | Codex | `x/wsd/docs/12_avaliacao_critica.md` | Marcação do MVP Git/GitHub Governance como concluído na `v0.1.10-alpha`. |
| 07/05/2026 — | Claude | `x/wsd/docs/12_avaliacao_critica.md` | Inclusão da Party Mode Integration (`v0.1.11-alpha`) e fechamento dos itens descartados: validação YAML formal (formato legado) e perfis genéricos adicionais (instalação interativa cobre). Fase 3 fechada 100%. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
