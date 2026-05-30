---
title: "00 — Planejamento de Instalação WSD"
created: 05/05/2026
modified: 30/05/2026
tags:
  - x
  - wsd
  - planejamento
  - instalacao
  - github
  - codex
  - claude-code
status: ativo
tipo: guia
parent: "[[wsd/wsd]]"
links: "[[wsd/wsd]], [[wsd/docs/04_playbook_implantacao]], [[wsd/docs/06_personalizacao_por_projeto]], [[wsd/docs/09_publicacao_github_privado]], [[wsd/docs/10_matriz_sincronizacao_notas]], [[wsd/docs/11_modulo_git_governance]]"
otimizado_para_obsidian: true
---
# 00 — Planejamento de Instalação WSD

[[wsd/wsd|← WSD]]

---

> [!abstract] Objetivo
> Registrar as definições atuais para transformar o WSD em um método instalável, inspirado em fluxos como BMad, mas adequado à preferência operacional de manter todos os arquivos dentro da pasta do projeto.


> [!info] Otimização Obsidian
> Esta nota é otimizada para visualização no Obsidian, com índice navegável, links literais de cabeçalho e rastreabilidade de alterações por agentes.

## 📑 Índice

1. [[#1. 🔄 Atualizações]]
2. [[#2. Decisão Principal]]
3. [[#3. Por Que Não Depender de WSD Global]]
4. [[#4. Estrutura Local Esperada]]
5. [[#5. Comando de Instalação Desejado]]
    5.1. [[#5.1. Pré-Requisitos e Canais de Instalação]]
6. [[#6. GitHub Deve Ser Opcional]]
7. [[#7. Perguntas Interativas]]
8. [[#8. Módulos Opcionais]]
9. [[#9. Configuração Para Codex]]
10. [[#10. Configuração Para Claude Code]]
11. [[#11. Subcomandos Desejados]]
12. [[#12. Modo Automático e Modo Assistido]]
13. [[#13. Primeira Implementação Recomendada]]
14. [[#14. Decisão Sobre Instalação Fora do Projeto]]
15. [[#15. Relação Com BMad]]
16. [[#16. Sincronização Deste Planejamento]]
17. [[#17. 🕒 Registro de Alterações por Agentes]]

## 1. 🔄 Atualizações

Esta seção documenta o histórico evolutivo do documento, assegurando a rastreabilidade das decisões e alterações realizadas por agentes ou operadores humanos.

- 05/05/2026 13:29:54 -03 — Codex: Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes.
- 05/05/2026 13:33:20 -03 — Codex: Inclusão de pré-requisitos, canais `npx`, prerelease e modos interativo/não interativo inspirados no BMad.
- 05/05/2026 13:33:56 -03 — Codex: Limpeza de navegação duplicada após a subseção de pré-requisitos.
- 05/05/2026 14:13:39 -03 — Codex: Registro do estado implementado em `v0.1.2-alpha` e das notas que devem ser sincronizadas quando o instalador mudar.
- 05/05/2026 14:38:29 -03 — Codex: Inclusão do planejamento de módulos opcionais, com `git-governance` como primeiro módulo proposto para perguntas do instalador.
- 06/05/2026 14:41:06 -03 — Codex: Padronização das listas de implementação da nota de instalação com checkboxes para acompanhar o que está concluído e o que falta.
- 07/05/2026 — Codex: Planejamento da `v0.1.10-alpha` como MVP Git/GitHub Governance antes da estabilização.
- 07/05/2026 — Codex: Marcação da `v0.1.10-alpha` como implementada: `--git-policy none|basic|full`, Git namespace local, `git_governance` e templates PR/Issue no modo `full`.
- 30/05/2026 18:15:09 -03 — Codex: Inclusão do subcomando local `wsd version` e do modo de inventário para rastrear a versão WSD instalada em múltiplos projetos.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 2. Decisão Principal

O WSD deve ser instalado **localmente dentro de cada projeto**, não obrigatoriamente como estado global da máquina.

Modelo recomendado:

```text
repo GitHub privado WSD = fonte oficial do método
projeto alvo = recebe uma cópia local e personalizada do WSD
GitHub do projeto = opcional no momento da instalação
Codex/Claude = configurados dentro do projeto quando solicitado
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 3. Por Que Não Depender de WSD Global

A instalação global em `~/.wsd` tem vantagens, mas cria dependência externa ao projeto. Para este uso pessoal, a prioridade é portabilidade e auditabilidade local.

Motivos para preferir WSD por projeto:

- o projeto fica autossuficiente;
- agentes leem tudo dentro da pasta do repo;
- reduz risco de usar versão global errada;
- facilita versionar a governança junto com o código;
- evita arquivos obrigatórios fora do diretório onde o comando foi rodado;
- torna o comportamento mais parecido com métodos SDD instaláveis por projeto.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 4. Estrutura Local Esperada

Após instalação, o projeto alvo deve ficar assim:

```text
meu-projeto/
├── +wsd/
│   ├── docs/
│   ├── templates/
│   ├── profiles/
│   ├── scripts/
│   ├── bin/
│   └── config.json
├── AGENTS.md
├── CLAUDE.md
├── +context.json
├── +specs/
│   ├── features/
│   │   └── wsd-bootstrap/
│   │       └── spec.md
│   └── context/
├── +logs/
│   └── error_vault.json
└── scripts/
    └── wsd_check.sh
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 5. Comando de Instalação Desejado

Comando interativo:

```bash
npx wsd-method install
```

Comando com diretório explícito:

```bash
npx wsd-method install --directory /path/to/project
```

Comando não interativo:

```bash
npx wsd-method install \
  --directory /path/to/project \
  --tools codex,claude-code \
  --profile node-frontend \
  --github existing \
  --repo owner/name \
  --branch main \
  --yes
```

Overrides:

```bash
npx wsd-method install \
  --directory /path/to/project \
  --set project.name="Koomplet Office" \
  --set environment.canonical_host="DLP" \
  --set validation.test="npm test" \
  --set validation.build="npm run build" \
  --yes
```

### 5.1. Pré-Requisitos e Canais de Instalação

Pré-requisitos recomendados:

- Node.js v20 ou superior para instalação via `npx`;
- Python 3.10 ou superior para validadores e automações locais;
- Git;
- GitHub CLI `gh` opcional, somente para fluxos automáticos de GitHub;
- `uv` opcional, caso o WSD futuramente inclua módulos Python empacotados.

Canais desejados:

```bash
npx wsd-method install
npx wsd-method@next install
```

`@next` deve ser tratado como canal de pré-release, com maior churn e sem promessa de estabilidade.

Modo não interativo:

```bash
npx wsd-method install --directory /path/to/project --tools claude-code,codex --yes
```

Descoberta de opções:

```bash
npx wsd-method install --list-options
npx wsd-method help
```

O comando de ajuda deve explicar exatamente o próximo passo e o que é opcional.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 6. GitHub Deve Ser Opcional

O instalador não deve exigir GitHub para configurar WSD local.

Pergunta obrigatória:

```text
Como deseja lidar com GitHub?
- já existe repositório
- criar automaticamente com gh
- criar em conjunto com instruções para o usuário
- pular GitHub por enquanto
```

Regras:

- se o WSD fonte estiver em repo privado, autenticação é necessária apenas para baixar automaticamente esse WSD;
- se o pacote estiver sendo instalado por `npx`, o GitHub do projeto pode ser configurado depois;
- se `gh` estiver autenticado e o usuário escolher automático, o instalador pode criar repo;
- se não houver `gh` ou permissão, o instalador deve gerar instruções manuais;
- se o usuário escolher pular, WSD local deve funcionar mesmo sem remote.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 7. Perguntas Interativas

O instalador deve perguntar:

- pasta do projeto;
- nome do projeto;
- tipo de projeto;
- se o diretório já é Git;
- se já existe GitHub;
- se GitHub deve ser usado como repo existente, configurado em modo assistido ou ignorado;
- host canônico;
- branch principal;
- comandos reais de validação;
- paths que agentes podem editar;
- paths proibidos;
- se há deploy;
- se deploy é público/produção;
- se usa Codex;
- se usa Claude Code;
- se deseja instalar módulos opcionais;
- se deseja instalar `git-governance` em modo `none`, `basic` ou `full`;
- se deve criar `AGENTS.md`;
- se deve criar `CLAUDE.md`;
- se deve criar comandos Claude em `.claude/commands`;
- se deve criar skills Codex locais;
- se deve criar spec `TASK-001-wsd-bootstrap`.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 8. Módulos Opcionais

O instalador deve suportar módulos opcionais sem tornar o WSD core dependente deles.

Primeiro módulo planejado:

- [[wsd/docs/11_modulo_git_governance|11 — Módulo Git Governance WSD]]

Pergunta recomendada:

```text
Deseja instalar o módulo de Governança Git/GitHub?
- não
- básico
- completo
```

Regra para `v0.1.10-alpha`: `none` ou resposta negativa mantém apenas a segurança Git mínima do core. `basic` e `full` geram política Git adicional, campos no `+context.json`, scripts locais e instruções extras para agentes. Topologia `multi-host`, auditoria completa e bootstrap administrativo ficam fora do primeiro MVP.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 9. Configuração Para Codex

Quando Codex for selecionado, o instalador deve criar dentro do projeto:

```text
.codex/skills/wsd/SKILL.md
.codex/skills/wsd-start/SKILL.md
.codex/skills/wsd-finish/SKILL.md
AGENTS.md
```

Objetivo:

- permitir que agentes Codex usem WSD sem depender de skills globais;
- deixar instruções versionadas com o projeto;
- manter início e fim de sessão como comandos simples.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 10. Configuração Para Claude Code

Quando Claude Code for selecionado, o instalador deve criar:

```text
CLAUDE.md
.claude/commands/wsd-start.md
.claude/commands/wsd-check.md
.claude/commands/wsd-finish.md
```

Objetivo:

- orientar Claude Code a ler `+context.json`;
- exigir spec para L1/L2;
- impedir `git add .`;
- impedir ocultação de worktree suja;
- executar `scripts/wsd_check.sh`;
- usar validações reais do projeto.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 11. Subcomandos Desejados

Durante instalação via pacote:

```bash
npx wsd-method install
npx wsd-method update
npx wsd-method doctor
npx wsd-method help
```

Depois de instalado dentro do projeto:

```bash
./+wsd/bin/wsd start
./+wsd/bin/wsd check
./+wsd/bin/wsd finish
./+wsd/bin/wsd doctor
./+wsd/bin/wsd version
./+wsd/bin/wsd update
```

Inventário de versões WSD em vários projetos:

```bash
./+wsd/bin/wsd version --inventory --path /path/com/projetos --max-depth 4
./+wsd/bin/wsd version --json --inventory --path /path/com/projetos
```

Esse comando usa `+wsd/config.json` como fonte local da versão instalada e compara com `wsd_source/package.json` quando a fonte original ainda está acessível.

Com o módulo `git-governance`, o CLI local também deve suportar:

```bash
./+wsd/bin/wsd git doctor
./+wsd/bin/wsd git preflight
./+wsd/bin/wsd git pr-check
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 12. Modo Automático e Modo Assistido

Automático:

- usa `gh` autenticado;
- cria repo se autorizado;
- inicializa Git se necessário;
- gera arquivos;
- roda validação;
- pode abrir branch de bootstrap.

Assistido:

- gera instruções para o usuário;
- mostra comandos;
- não exige autenticação;
- permite copiar/colar etapas;
- mantém WSD local funcional.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 13. Primeira Implementação Recomendada

Estado implementado até `v0.1.10-alpha`:

- [x] Adaptar o WSD atual para suportar `+wsd/` local por projeto.
- [x] Criar CLI local instalada em `+wsd/bin/wsd`.
- [x] Criar `install` por `wsd-method install`.
- [x] Ajustar templates Codex para instalação local.
- [x] Publicar WSD como GitHub privado.
- [x] Criar matriz e checker de sincronização documental.
- [x] Adicionar `./+wsd/bin/wsd version` para rastrear versão instalada por projeto e inventariar múltiplos repos.
- [x] Registrar plano do módulo opcional `git-governance`.
- [x] Criar templates Claude Code.
- [x] Testar em projeto brownfield real (`koomplet-office`) antes de escalar.
- [x] Enriquecer prompts interativos de instalação (linguagem, path, test/build/lint, forbidden_paths).
- [x] Criar JSON Schema formal para `+context.json` e validador zero-deps.
- [x] Implementar `v0.1.10-alpha`: MVP Git/GitHub Governance antes da estabilização.
- [x] Adicionar `--git-policy none|basic|full` ao instalador.
- [x] Gerar seção Git/GitHub no `AGENTS.md`, campos `git_governance` no `+context.json` e templates PR/Issue no modo `full`.
- [x] Adicionar comandos `./+wsd/bin/wsd git doctor`, `preflight` e `pr-check`.

Próximos itens:

- [ ] Criar validação YAML formal para specs.
- [x] Consolidar `v0.1.0` estável — concluído em 07/05/2026.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 14. Decisão Sobre Instalação Fora do Projeto

O instalador não deve instalar arquivos fora do projeto por padrão.

Exceções só podem ocorrer com confirmação explícita:

- adicionar alias no shell;
- instalar comando global;
- instalar skill global do Codex;
- cache local opcional.

Padrão:

```text
somente escrever dentro da pasta do projeto indicada
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 15. Relação Com BMad

O WSD deve se inspirar no BMad nestes pontos:

- instalação por comando único;
- perguntas interativas;
- modo não interativo para CI/CD;
- seleção de módulos/ferramentas;
- opções `--directory`, `--yes`, `--set`;
- comando de ajuda que diga o próximo passo.

Diferença central:

```text
WSD deve priorizar instalação local vendorizada por projeto.
```

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 16. Sincronização Deste Planejamento

Quando esta nota mudar, revisar:

- [[wsd/README|README]], se o comando recomendado mudar;
- [[wsd/docs/04_playbook_implantacao|04 Playbook]], se o fluxo de implantação mudar;
- [[wsd/docs/08_rotinas_sessao|08 Rotinas]], se comandos locais mudarem;
- [[wsd/docs/09_publicacao_github_privado|09 Publicação]], se canais, tags ou GitHub mudarem;
- [[wsd/docs/10_matriz_sincronizacao_notas|10 Matriz de Sincronização]], se surgir nova relação obrigatória;
- [[wsd/docs/11_modulo_git_governance|11 Módulo Git Governance]], se perguntas de módulo Git mudarem;
- `bin/wsd-method.js`, `install.sh` e `package.json`, se a nota descrever comportamento executável.

[[#📑 Índice|⬆️ Voltar ao Índice]]

## 17. 🕒 Registro de Alterações por Agentes

| Data e hora | Agente | Arquivos/escopo | Alteração registrada |
|---|---|---|---|
| 05/05/2026 13:29:54 -03 | Codex | `x/wsd/docs/00_planejamento_instalacao_wsd.md` | Aplicação do padrão Obsidian WSD: frontmatter, índice literal, seção de atualizações, navegação e registro final de alterações por agentes. |
| 05/05/2026 13:33:20 -03 | Codex | `x/wsd/docs/00_planejamento_instalacao_wsd.md` | Inclusão de pré-requisitos, canais `npx`, prerelease e modos interativo/não interativo inspirados no BMad. |
| 05/05/2026 13:33:56 -03 | Codex | `x/wsd/docs/00_planejamento_instalacao_wsd.md` | Limpeza de navegação duplicada após a subseção de pré-requisitos. |
| 05/05/2026 14:13:39 -03 | Codex | `x/wsd/docs/00_planejamento_instalacao_wsd.md` | Registro do estado implementado em `v0.1.2-alpha` e das notas que devem ser sincronizadas quando o instalador mudar. |
| 05/05/2026 14:38:29 -03 | Codex | `x/wsd/docs/00_planejamento_instalacao_wsd.md` | Inclusão do planejamento de módulos opcionais, com `git-governance` como primeiro módulo proposto para perguntas do instalador. |
| 06/05/2026 14:41:06 -03 | Codex | `x/wsd/docs/00_planejamento_instalacao_wsd.md` | Padronização das listas de implementação com checkboxes para acompanhar o que está concluído e o que falta. |
| 07/05/2026 — | Codex | `x/wsd/docs/00_planejamento_instalacao_wsd.md` | Planejamento da `v0.1.10-alpha` como MVP Git/GitHub Governance antes da estabilização. |
| 07/05/2026 — | Codex | `x/wsd/docs/00_planejamento_instalacao_wsd.md` | Marcação da `v0.1.10-alpha` como implementada no instalador, CLI local, contexto e templates GitHub. |
| 30/05/2026 18:15:09 -03 | Codex | `+Apps/wsd/docs/00_planejamento_instalacao_wsd.md` | Inclusão do `wsd version` nos subcomandos locais e documentação do inventário multi-repo por `+wsd/config.json`. |

[[#📑 Índice|⬆️ Voltar ao Índice]]
