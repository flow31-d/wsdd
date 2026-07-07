---
title: "17 — O que é e o que contém o Snapshot WSD"
created: 12/05/2026
modified: 12/05/2026
tags:
  - wsd
  - snapshot
  - observabilidade
  - guia
status: ativo
tipo: guia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/docs/05_contrato_artefatos]], [[wsd/docs/16_wdb_snapshot_integration]]"
otimizado_para_obsidian: true
---

# 17 — O que é e o que contém o Snapshot WSD

> [!note] v0.5.1
> O engine `+wsd/bin/wsd-report.cjs` também alimenta `wsd relatorio`, `start --brief`
> e a compactação (`wsd compact`); os limiares de inchaço são medidos em linhas E
> em tokens estimados (~bytes/4).


[[wsd/wsd|← WSD]]

---

> [!abstract] Para que serve este documento
> Explica em linguagem simples o que é o `snapshot.json`, por que ele existe, o que cada campo significa na prática e o que acontece quando um agente ou dashboard o lê. Complementa o [[wsd/docs/16_wdb_snapshot_integration|16 — WDB Snapshot Integration]], que cobre o schema técnico e a integração com o dashboard.

> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. O que é o Snapshot]]
3. [[#3. Bloco 1 — Cabeçalho (schema e generated_at)]]
4. [[#4. Bloco 2 — Identidade do Projeto (project)]]
5. [[#5. Bloco 3 — Estado do Git (git)]]
6. [[#6. Bloco 4 — Estado da Sessão de Trabalho (session)]]
7. [[#7. Bloco 5 — Roadmap de Features (roadmap)]]
8. [[#8. Bloco 6 — Pipeline de Ideias (ideas)]]
9. [[#9. Bloco 7 — Saúde Operacional (state e health)]]
10. [[#10. O que o Snapshot não contém]]
11. [[#11. Como ler um Snapshot na prática]]

---

## 1. 🔄 Atualizações

Histórico completo desta nota: `git log --follow -- <arquivo>` e [CHANGELOG.md](../CHANGELOG.md). Seções de histórico manual foram removidas na v0.5.0 (lean-core); conteúdo preservado em `archive/historico_notas_2026H1.md`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. O que é o Snapshot

O snapshot é uma **fotografia instantânea do estado de um projeto**, gravada em um único arquivo JSON chamado `+wsd/snapshot.json`.

Imagine que um projeto de software é como uma obra em andamento. A qualquer momento existem perguntas válidas sobre esse projeto: *em qual etapa estamos? Há algo travado? O código está organizado ou bagunçado? Quantas ideias ainda não foram trabalhadas?* Para responder a essas perguntas hoje, seria necessário abrir vários arquivos separados — o ROADMAP, o STATE, o log do Git, a lista de ideias — e juntar as peças manualmente.

O snapshot faz isso automaticamente: ele lê todos esses arquivos de uma vez, extrai as informações relevantes e consolida tudo em um único arquivo estruturado que qualquer agente ou sistema externo pode ler em segundos.

> [!important] Fotografia, não histórico
> O snapshot representa **apenas o momento em que foi gerado**. Toda vez que é executado, o arquivo anterior é sobrescrito. Não há histórico acumulado. Se você quer saber o estado do projeto agora, gere um novo snapshot. Se quer comparar com o passado, isso requer uma feature separada que ainda não existe.

> [!tip] Quando é gerado
> Automaticamente ao final de `wsd check` (que agentes rodam ao abrir sessão) e ao rodar `wsd finish`. Manualmente com `./+wsd/bin/wsd snapshot`. Não é gerado por nenhum hook automático de commit ou cron — depende de interação com o CLI.

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 3. Bloco 1 — Cabeçalho (`schema` e `generated_at`)

```json
{
  "schema": "wsd/project-snapshot/v1",
  "generated_at": "2026-05-12T14:30:00-03:00"
}
```

### `schema`

Identifica qual versão do formato de snapshot está sendo usada. Hoje é sempre `"wsd/project-snapshot/v1"`.

**Por que existe:** o WSD pode evoluir e adicionar novos campos ao snapshot no futuro. Qualquer sistema que leia o arquivo precisa saber se está preparado para interpretar aquele formato. Se amanhã surgir um `v2` com campos diferentes, o leitor pode detectar isso e se adaptar antes de tentar processar algo que não entende.

**Na prática:** quem consome o snapshot (como o `wdb`) deve verificar se `schema === "wsd/project-snapshot/v1"` antes de processar qualquer outro campo.

### `generated_at`

Data e hora exatas em que o snapshot foi gerado, no formato internacional ISO-8601 (com fuso horário incluído).

**Por que existe:** um snapshot tem prazo de validade implícito. Se o arquivo foi gerado há 3 horas, ele ainda pode ser útil para uma visão geral. Se foi gerado há 3 dias, os dados de Git e sessão provavelmente estão desatualizados. O dashboard usa esse campo para mostrar "atualizado há X minutos" e alertar quando o snapshot está obsoleto.

**Na prática:** se `generated_at` tiver mais de 30 minutos, considere o snapshot desatualizado e gere um novo antes de tomar decisões baseadas nele.

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 4. Bloco 2 — Identidade do Projeto (`project`)

```json
{
  "project": {
    "name": "Koomplet Office",
    "slug": "koomplet-office",
    "type": "node_frontend_multiplayer_workspace"
  }
}
```

**Fonte:** lido diretamente do `+context.json` do projeto.

### `name`

O nome completo e legível do projeto, exatamente como foi definido no momento da instalação do WSD.

**Por que existe:** quando o dashboard lê múltiplos snapshots de diferentes projetos ao mesmo tempo, precisa saber de qual projeto cada um fala. O nome é o identificador humano.

**Limitação importante:** o snapshot não sabe em qual pasta do servidor está. Só sabe o nome que foi configurado. Por isso o nome precisa ser único entre os projetos monitorados.

### `slug`

O nome do projeto convertido para formato URL — sem letras maiúsculas, sem espaços, sem caracteres especiais. "Koomplet Office" vira "koomplet-office". "Meu App!" vira "meu-app".

**Por que existe:** o `slug` é usado como chave em sistemas que precisam de identificadores sem espaços — nomes de arquivos, IDs em dashboards, nomes de skills de agente (`/idea-koomplet-office`). É gerado automaticamente a partir do `name`, mas uma vez gerado é estável.

### `type`

A categoria do projeto: que tipo de sistema é esse? Exemplos: `node_frontend`, `python_api`, `node_frontend_multiplayer_workspace`.

**Por que existe:** agentes que recebem o snapshot sem conhecer o projeto podem inferir, pela categoria, quais ferramentas e comandos esperar. Um projeto `python_api` provavelmente usa `pytest` e `ruff`; um `node_frontend` usa `npm test` e `npm run build`. O tipo não determina isso sozinho — é só uma pista contextual.

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 5. Bloco 3 — Estado do Git (`git`)

```json
{
  "git": {
    "branch": "feat/nova-feature",
    "is_dirty": true,
    "ahead_count": 3,
    "dirty_count": 5,
    "source_dirty_count": 2,
    "generated_dirty_count": 3,
    "has_source_changes": true,
    "source_dirty_files": ["src/app.ts", "README.md"],
    "generated_dirty_files": ["+wsd/snapshot.json"],
    "last_commit_message": "feat: adiciona tela de login"
  }
}
```

Este bloco responde à pergunta: *em que estado está o repositório de código agora?*

**Fonte:** executado via comandos Git no momento da geração do snapshot.

### `branch`

O nome do ramo de trabalho atual.

**Por que existe:** um projeto Git pode ter dezenas de ramos paralelos, cada um representando uma linha de trabalho diferente. Saber em qual ramo o trabalho está acontecendo é fundamental para entender o contexto. Um agente que vê `branch: "main"` sabe que qualquer mudança vai direto para a versão principal — risco alto. Um agente que vê `branch: "feat/login"` sabe que está numa área isolada — risco menor.

**Na prática:** se o branch for `main` ou `master`, agentes devem redobrar a atenção antes de qualquer modificação.

### `is_dirty`

`true` se há arquivos modificados que ainda não foram commitados. `false` se o repositório está limpo.

**Por que existe:** indica se existe trabalho "em voo" — começado mas não registrado. Um repositório sujo com `is_dirty: true` significa que alguém (ou algum agente) fez mudanças que ainda não foram salvas formalmente no histórico Git. Isso é importante porque:
- Se o servidor reiniciar ou algo der errado, essas mudanças podem se perder
- Um agente que inicia trabalho sobre um repositório sujo pode criar conflitos

**Cenário prático:** você abre o dashboard e vê `is_dirty: true` em um projeto que ninguém deveria estar modificando. Isso indica que algo ficou pela metade numa sessão anterior.

### `ahead_count`

Quantos commits existem localmente que ainda não foram enviados para o GitHub (ou outro servidor remoto).

**Por que existe:** um commit no Git é como um "salvo" no histórico local. Mas esse histórico só existe na máquina onde o projeto está. Enquanto não é enviado ao GitHub (`git push`), o trabalho existe em apenas um lugar. Se `ahead_count` for 5, significa que há 5 "salvos" que ainda vivem só nesta VPS.

**Cenário prático:** `ahead_count: 0` — tudo sincronizado, seguro. `ahead_count: 3` — há 3 commits locais não publicados; se esta máquina falhar, esses commits se perdem. `ahead_count: 15` — alguém está trabalhando offline há muito tempo sem sincronizar.

### `dirty_count`, `source_dirty_count`, `generated_dirty_count`

`dirty_count` é o total de arquivos reportados por `git status`. `source_dirty_count` conta apenas mudanças que parecem código, docs, specs ou configuração de projeto. `generated_dirty_count` conta artefatos locais gerados, como `+wsd/snapshot.json`, `.last-check.json`, caches, builds e logs.

**Por que existe:** dashboards precisam distinguir trabalho humano não fechado de ruído operacional. Um repo com `source_dirty_count: 0` e `generated_dirty_count: 2` normalmente só precisa de ignore/limpeza. Um repo com `source_dirty_count: 8` precisa de revisão, commit ou descarte consciente.

### `has_source_changes`

Atalho booleano para `source_dirty_count > 0`.

**Na prática:** consumidores como o WDB podem usar este campo para pintar o projeto em amarelo sem tratar snapshots gerados como falha real.

### `source_dirty_files` e `generated_dirty_files`

Listas curtas, limitadas, dos arquivos sujos classificados em cada grupo.

**Limitação:** são listas para diagnóstico rápido, não inventário completo. Para decisão de commit, ainda rode `git status --short`.

### `last_commit_message`

O texto do último commit feito no projeto (limitado a 72 caracteres).

**Por que existe:** sem abrir o terminal e rodar `git log`, um agente ou dashboard pode ver imediatamente o que foi feito por último. Isso dá contexto instantâneo: o projeto foi modificado para "fix: corrige bug no pagamento" ou para "chore: atualiza dependências"? São situações muito diferentes.

**Limitação:** mostra apenas o último commit, não o histórico completo. Para contexto profundo, ainda é necessário ler o HANDOFF.md ou rodar `git log`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 6. Bloco 4 — Estado da Sessão de Trabalho (`session`)

```json
{
  "session": {
    "handoff_exists": true,
    "open_specs": ["auth-flow", "dashboard-ui"]
  }
}
```

Este bloco responde à pergunta: *existe trabalho em andamento que precisa ser retomado?*

### `handoff_exists`

`true` se existe um arquivo `+specs/HANDOFF.md` no projeto. `false` se não existe.

**O que é o HANDOFF.md:** quando um agente termina uma sessão de trabalho rodando `wsd finish`, ele gera automaticamente um arquivo de "passagem de bastão". Desde `v0.4.3`, o finish também fecha a sessão com commit automático quando os gates passam; por isso o HANDOFF registra a branch, os gates, as alterações capturadas pelo fechamento, os commits recentes e as specs abertas, mas o estado final aprovado deve ser worktree limpo. É como um bilhete deixado para o próximo agente (ou para você mesmo no dia seguinte) dizendo "é aqui que paramos".

**Por que o snapshot só diz se existe ou não:** o conteúdo do HANDOFF é rico demais para ser embutido no snapshot. O snapshot apenas avisa que o bilhete existe — cabe ao agente lê-lo por conta própria antes de começar a trabalhar.

**Cenário prático:** um agente inicia uma sessão, lê o snapshot e vê `handoff_exists: true`. A primeira coisa que deve fazer é ler o `+specs/HANDOFF.md` para não começar do zero sem entender onde o trabalho anterior parou.

### `open_specs`

Lista dos IDs das features que estão marcadas como `in-progress` no ROADMAP do projeto.

**Por que existe:** evita que um agente comece a implementar algo que já está sendo trabalhado. Se `open_specs` contém `["auth-flow", "dashboard-ui"]`, significa que essas duas features têm trabalho ativo em andamento. Um agente que recebe a instrução "implemente o dashboard" e vê essa lista sabe que já há uma spec aberta para isso — deve continuá-la em vez de criar outra do zero.

**Quando a lista está vazia:** `open_specs: []` significa que não há feature em progresso ativo. O projeto está ou parado, ou entre ciclos de desenvolvimento.

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 7. Bloco 5 — Roadmap de Features (`roadmap`)

```json
{
  "roadmap": {
    "total": 8,
    "by_status": {
      "planned": 3,
      "in-progress": 2,
      "done": 2,
      "discarded": 1
    },
    "items": [
      { "id": "auth-flow",    "title": "Autenticação OAuth2",  "status": "in-progress" },
      { "id": "dashboard-ui", "title": "Dashboard principal",   "status": "in-progress" },
      { "id": "export-pdf",   "title": "Exportar relatório PDF","status": "planned" }
    ]
  }
}
```

**Fonte:** lido e parseado do arquivo `+specs/project/ROADMAP.md`.

Este bloco responde à pergunta: *qual é o estado geral do desenvolvimento planejado do projeto?*

### `total`

Quantidade total de features já registradas no ROADMAP, independente do status.

**O que indica:** maturidade do planejamento. Um projeto com `total: 2` está nos primeiros passos de planejamento. Um projeto com `total: 47` tem uma história longa de features pensadas, implementadas e descartadas.

### `by_status`

Distribuição das features por situação atual. Os status possíveis são:

| Status | Significado |
|---|---|
| `planned` | Planejada, ainda não começada |
| `specified` | Tem spec escrita, mas ainda não está sendo implementada |
| `in-progress` | Em implementação ativa no momento |
| `done` | Implementada e validada |
| `blocked` | Travada por algum impedimento externo |
| `discarded` | Foi descartada com justificativa registrada |

**Por que a distribuição importa:** olhar `by_status` de relance diz muito sobre o momento do projeto. Se `in-progress: 5` e `blocked: 3`, o projeto está congestionado — muita coisa começada, pouca terminando. Se `done: 40` e `planned: 2`, o projeto está maduro e quase completo. Se `discarded: 15`, houve muita experimentação e descarte — o que é saudável se cada descarte tem justificativa.

### `items`

A lista completa de features, cada uma com três campos:
- **`id`**: identificador único em formato slug (ex: `"auth-flow"`)
- **`title`**: título legível, truncado a 60 caracteres
- **`status`**: situação atual da feature

**Ordenação:** as features são ordenadas por prioridade de atenção — `in-progress` e `blocked` aparecem primeiro, depois `specified`, `planned`, `done` e `discarded`.

**Por que o limite de 60 caracteres no título:** o snapshot é lido por dashboards e agentes que precisam exibir ou processar muitos títulos ao mesmo tempo. Títulos longos indicam falta de clareza na definição — uma feature bem definida tem um nome curto e preciso. O truncamento é tanto uma limitação técnica quanto um sinal de qualidade.

> [!warning] Títulos longos no ROADMAP
> Se um título aparece truncado no snapshot (com `...` no final), isso é um sinal de que o título da feature no `ROADMAP.md` precisa ser encurtado. O snapshot não inventa o truncamento — ele reflete o que está escrito.

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 8. Bloco 6 — Pipeline de Ideias (`ideas`)

```json
{
  "ideas": {
    "total": 12,
    "by_status": {
      "raw": 7,
      "triaged": 2,
      "spec-criada": 1,
      "implementada": 2
    },
    "items": [
      { "id": "IDEA-001", "title": "Dark mode no dashboard",  "status": "raw" },
      { "id": "IDEA-007", "title": "Exportar relatório PDF",  "status": "triaged" }
    ]
  }
}
```

**Fonte:** lido e parseado do arquivo `+specs/project/IDEAS_PIPELINE.md`.

Este bloco responde à pergunta: *qual é a pressão de ideias não processadas?*

### A diferença entre `ideas` e `roadmap`

O roadmap contém features que **já foram decididas** — passaram por uma avaliação, têm spec e foram formalmente aceitas para desenvolvimento. As ideias são **matéria-prima bruta**: surgiram durante uma conversa, foram anotadas para não se perder, mas ainda não foram avaliadas se valem a pena ser feitas.

Pense assim: o roadmap é a fila de trabalho. As ideias são a caixa de sugestões.

### `total`

Total de ideias já capturadas no projeto, em qualquer estágio.

### `by_status`

Os status das ideias seguem um funil de maturidade:

| Status | Significado |
|---|---|
| `raw` | Capturada tal como surgiu, sem avaliação |
| `triaged` | Foi lida e avaliada superficialmente — vale investigar mais |
| `spec-criada` | Foi suficientemente boa para virar uma spec formal |
| `implementada` | Saiu do funil de ideias e foi entregue |
| `descartada` | Avaliada e rejeitada com justificativa |

**O que a distribuição indica:** muitas ideias `raw` significa que a caixa de sugestões está cheia e ninguém está triando. Isso não é necessariamente ruim — às vezes é melhor deixar ideias acumularem antes de processar em lote. Mas se `raw: 50` há meses, provavelmente muita coisa boa está se perdendo por falta de revisão.

### `items`

Mesmo formato do roadmap: `id`, `title` e `status` para cada ideia.

**Diferença do roadmap:** os IDs das ideias geralmente seguem um formato sequencial (`IDEA-001`, `IDEA-002`) enquanto os IDs do roadmap são slugs descritivos (`auth-flow`, `dashboard-ui`). Isso reflete a natureza das ideias — chegam em ordem de captura, não em ordem de importância.

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 9. Bloco 7 — Saúde Operacional (`state` e `health`)

```json
{
  "state": {
    "active_blockers": 1,
    "total_decisions": 23
  },
  "health": {
    "last_check_passed": true,
    "ghost_specs_detected": 0
  }
}
```

Este bloco responde à pergunta: *o projeto está saudável? Há algo travado ou quebrado?*

---

### `state.active_blockers`

Quantos bloqueadores ativos existem na tabela de "Bloqueadores Ativos" do `STATE.md`. Bloqueadores já marcados como "resolvido" não são contados.

**O que é um bloqueador:** uma situação externa que impede o progresso do projeto e que não pode ser resolvida pela equipe de desenvolvimento sozinha. Exemplos: "aguardando aprovação do cliente para avançar na integração", "dependência de API externa fora do ar", "decisão de arquitetura pendente de revisão".

**Por que importa:** `active_blockers: 0` é o estado ideal — nada está travando o projeto. `active_blockers: 1` ou mais significa que antes de qualquer trabalho novo, o agente ou humano deveria verificar o `STATE.md` para entender o que está impedindo o andamento.

**O que o snapshot não diz:** qual é o bloqueador. Apenas que existe. Para saber o que está bloqueado e por quê, é necessário abrir o `STATE.md`.

### `state.total_decisions`

Quantas decisões foram registradas na tabela de "Decisões" do `STATE.md` ao longo de toda a história do projeto.

**O que é uma decisão registrada:** toda escolha arquitetural ou de processo que foi deliberadamente anotada com data e justificativa. Exemplos: "decidimos usar PostgreSQL em vez de MongoDB porque precisamos de transações"; "optamos por não usar testes unitários no frontend neste sprint por falta de tempo — revisitar na v2".

**O que indica:** um projeto com `total_decisions: 0` ou `1` é um projeto que não está documentando suas escolhas — difícil para um novo agente entender por que as coisas são como são. Um projeto com `total_decisions: 30` tem um histórico rico de raciocínio registrado. Não é uma medida de qualidade direta, mas é um indicador de maturidade de governança.

---

### `health.last_check_passed`

`true` se o último `wsd check` executado neste projeto passou sem erros. `false` se reprovou. `null` se nunca foi executado.

**O que o `wsd check` verifica:** a saúde estrutural do projeto WSD — se o `+context.json` existe e é válido, se o `STATE.md` está presente, se as pastas essenciais existem, se não há placeholders de template esquecidos, se as specs têm critérios WHEN/THEN/SHALL definidos. É uma verificação de integridade, não de código de negócio.

**Por que é o campo mais crítico do bloco de saúde:** se `last_check_passed: false`, algo fundamental está quebrado na estrutura do projeto. Agentes não devem começar trabalho novo antes de investigar e corrigir o que reprovou no check. Um projeto com check reprovado é como uma obra com laudo de engenheiro negativo — pode até funcionar hoje, mas há risco estrutural.

**Se for `null`:** o check nunca foi executado neste projeto. Isso significa que o snapshot foi gerado via `wsd snapshot` direto, sem passar pelo fluxo `wsd check` que normalmente o precede. O projeto pode estar bem — simplesmente ninguém rodou o check ainda.

### `health.ghost_specs_detected`

Quantas specs foram detectadas como "fantasma" pelo `wsd check`.

**O que é uma ghost spec:** uma spec que foi criada e marcada como `approved` ou `implemented`, mas que não tem critérios de aceitação no formato WHEN/THEN/SHALL. Ou seja: é uma spec que diz "vamos fazer X" mas não especifica de forma verificável como saber que X foi feito corretamente.

**Por que é um problema:** agentes que implementam com base em ghost specs estão trabalhando sem um contrato claro. A implementação pode estar correta ou errada — não há como verificar objetivamente. É o equivalente a um contrato de obra que diz "construa uma casa boa" sem especificar metragem, materiais ou prazo.

**`ghost_specs_detected: 0`** é o estado ideal — todas as specs aprovadas têm critérios verificáveis.

**`ghost_specs_detected: 3`** significa que há 3 specs com definição incompleta. Antes de implementar qualquer uma delas, é necessário completar os critérios WHEN/THEN/SHALL.

**Fonte do dado:** o `wsd check` grava o resultado em `+wsd/.last-check.json` ao ser executado. O snapshot lê esse cache para preencher os campos de health. Se `wsd check` não foi rodado recentemente, os dados de health estão desatualizados mesmo que `generated_at` seja recente.

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 10. O que o Snapshot não contém

É tão importante saber o que o snapshot **não** inclui quanto saber o que inclui:

| O que não está no snapshot | Por quê |
|---|---|
| Conteúdo do código-fonte | Tornaria o arquivo imenso e o tornaria sensível |
| Senhas, tokens, variáveis de ambiente | Nunca devem estar em JSON lido por sistemas externos |
| Paths absolutos de servidor | Informação de infraestrutura privada |
| Conteúdo completo do HANDOFF.md | Rico demais — o snapshot apenas avisa que existe |
| Conteúdo das decisões no STATE.md | Idem — o snapshot conta quantas há, não o que dizem |
| Histórico de commits do Git | Para isso existe `git log` |
| Logs de erros ou outputs de testes | Efêmeros demais para um snapshot |
| Histórico de snapshots anteriores | O snapshot é sempre uma fotografia do agora |

[[#📑 Índice|⬆️ Voltar ao Índice]]

---

## 11. Como ler um Snapshot na prática

Um snapshot bem interpretado conta uma história sobre o projeto em segundos. Alguns cenários:

### Cenário A — Projeto saudável em andamento

```json
{ "git": { "branch": "feat/auth", "is_dirty": false, "ahead_count": 2 },
  "session": { "handoff_exists": true, "open_specs": ["auth-flow"] },
  "state": { "active_blockers": 0 },
  "health": { "last_check_passed": true, "ghost_specs_detected": 0 } }
```

Leitura: trabalho em andamento numa feature branch, repositório limpo, 2 commits prontos para push. Há um HANDOFF — a sessão anterior deixou notas. Nenhum bloqueador, check passou, specs bem definidas. **Ação: ler o HANDOFF.md e continuar o trabalho da spec `auth-flow`.**

---

### Cenário B — Projeto com sinais de alerta

```json
{ "git": { "branch": "main", "is_dirty": true, "ahead_count": 7 },
  "session": { "handoff_exists": false, "open_specs": [] },
  "state": { "active_blockers": 2 },
  "health": { "last_check_passed": false, "ghost_specs_detected": 4 } }
```

Leitura: trabalho direto em `main` com arquivos modificados sem commit, 7 commits locais não publicados, 2 bloqueadores ativos, check reprovado, 4 specs sem critérios. **Ação: antes de qualquer coisa, rodar `wsd check` para entender o que está quebrado, resolver os bloqueadores e completar as ghost specs.**

---

### Cenário C — Projeto parado há dias

```json
{ "generated_at": "2026-05-09T08:00:00-03:00",
  "git": { "branch": "main", "is_dirty": false, "ahead_count": 0 },
  "session": { "handoff_exists": false, "open_specs": [] },
  "roadmap": { "by_status": { "planned": 5, "done": 3 } },
  "health": { "last_check_passed": null } }
```

Leitura: snapshot gerado há 3 dias (hoje é dia 12), branch limpa, nenhum trabalho em andamento. 5 features planejadas, 3 entregues. Check nunca executado. **Ação: gerar novo snapshot para atualizar o estado, rodar `wsd check` para verificar saúde estrutural antes de retomar.**

[[#📑 Índice|⬆️ Voltar ao Índice]]

---
