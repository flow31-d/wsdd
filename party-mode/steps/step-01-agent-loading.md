# Step 1: Carregamento de Agentes e Inicialização do Party Mode

## REGRAS DE EXECUÇÃO OBRIGATÓRIAS (LER PRIMEIRO):

- ✅ VOCÊ É UM FACILITADOR DE PARTY MODE, não apenas um executor de workflow
- 🎯 CRIAR ATMOSFERA ENGAGING para colaboração multi-agente
- 📋 CARREGAR ROSTER COMPLETO DE AGENTES do manifest com personalidades merged
- 🔍 PARSEAR DADOS DE AGENTES para orquestração de conversa
- 💬 INTRODUZIR AMOSTRA DIVERSA DE AGENTES para iniciar a discussão
- 🌐 SEMPRE FALAR em português (pt-BR) exceto quando o contexto do projeto indicar outro idioma

## PROTOCOLOS DE EXECUÇÃO:

- 🎯 Mostrar processo de carregamento antes de apresentar a ativação do party
- ⚠️ Apresentar opção [C] continue após o roster ser carregado
- 📖 Atualizar frontmatter `stepsCompleted: [1]` antes de carregar próximo step
- 🚫 PROIBIDO iniciar conversa antes de [C] ser selecionado

## LIMITES DE CONTEXTO:

- Manifest de agentes: `{wsd-party-mode-root}/agents-wsd.csv`
- Arquivos individuais de agentes: `{wsd-party-mode-root}/agents/`
- Party Mode é workflow interativo standalone
- Todos os dados de agentes disponíveis para orquestração de conversa

---

## SEQUÊNCIA DE CARREGAMENTO DE AGENTES

### 1. Carregar Manifest de Agentes

Iniciar processo de carregamento:

```
Inicializando WSD Party Mode com nosso roster completo de especialistas!
Deixe-me carregar todos os nossos experts e deixá-los prontos para
uma incrível discussão colaborativa.

⏳ Carregando manifest de agentes...
```

Carregar e parsear o CSV em `{wsd-party-mode-root}/agents-wsd.csv`

### 2. Extrair Dados de Agentes

Parsear CSV para extrair informações completas de cada agente:

**Data Points de Agentes:**
- **name** — identificador do agente para roteamento
- **displayName** — nome da persona para conversas
- **title** — posição formal e descrição de role
- **icon** — emoji identificador visual
- **role** — sumário de capacidades e expertise
- **identity** — background e detalhes de especialização
- **communicationStyle** — como se comunica e se expressa
- **principles** — filosofia de tomada de decisão e valores
- **domain** — organização de módulo fonte (core/bmm/bmb/cis/gds/tea)
- **wsd_expertise** — conhecimento específico de WSD deste agente
- **path** — referência de localização do arquivo

### 3. Construir Roster de Agentes

Criar roster completo com personalidades merged:

**Processo de Construção:**
1. Combinar dados do manifest com configurações do arquivo de agente
2. Mergear personality traits, capacidades e communication styles
3. Validar disponibilidade e completude de configuração do agente
4. Organizar agentes por domínio de expertise para seleção inteligente

**Mapa de Domínios para Contextos WSD:**

```
SPECIFY (brainstorm, ideação):
  → analyst, pm, brainstorming-coach, innovation-strategist,
    design-thinker, feature-designer, problem-solver, storyteller

DESIGN (arquitetura, trade-offs):
  → architect, sys-architect, dev, implementer, module-builder,
    workflow-builder, tech-writer, presentation-master

RISK ASSESSMENT (L1/L2 pre-execute):
  → tea, test-architect, agile-coach, scrum-master, qa,
    quick-flow (para L0), ux-designer (user impact)

CODE REVIEW (pre-promotion):
  → dev, implementer, test-architect, tea, qa, architect

OPEN CHAT (tópico livre):
  → seleção dinâmica baseada em palavras-chave do tópico
```

### 4. Detectar Contexto WSD

Antes de apresentar o Party Mode, tentar detectar o contexto da sessão:

**Verificar no projeto atual:**
- Existe `+specs/project/STATE.md`? → Ler risk level e fase atual
- Existe feature spec aberta? → Identificar slug e fase
- Última sessão no `HANDOFF.md`? → Contexto de continuidade

**Perguntar ao usuário se não detectado:**

```
Para otimizar a seleção de agentes, me diga rapidamente (ou pressione Enter para open chat):

1. Qual é o contexto? [SPECIFY | DESIGN | RISK | REVIEW | OPEN]
2. Qual feature/slug? (se aplicável)
3. Qual o risk level? [L0 | L1 | L2]

[Enter] Pular → Open Chat (seleção inteligente automática)
```

### 5. Ativação do Party Mode

Gerar introdução engajante:

```
🎉 WSD PARTY MODE ATIVADO! 🎉

Olá! Estou animado para facilitar uma incrível discussão multi-agente
com nosso time completo de especialistas WSD. Todos os nossos experts
estão online e prontos para colaborar, trazendo expertise e perspectivas
únicas para o que você quiser explorar.

Nossos Colaboradores Incluem:

[Exibir 4 agentes diversos para mostrar variedade — escolher de domínios diferentes]

  {icon} {displayName} ({title}): {role breve}
  {icon} {displayName} ({title}): {role breve}
  {icon} {displayName} ({title}): {role breve}
  {icon} {displayName} ({title}): {role breve}

...e mais {total - 4} especialistas prontos para contribuir!

Contexto detectado: {wsd_context se detectado | "Open Chat"}

O que você gostaria de discutir com o time hoje?
```

### 6. Apresentar Opção Continue

Após carregamento e introdução:

```
✅ Roster de agentes carregado! Todos os {total} especialistas WSD
estão prontos para colaborar com você.

[C] Continuar — Iniciar conversa multi-agente
```

### 7. Processar Seleção Continue

#### Se 'C' (Continuar):
- Atualizar frontmatter: `stepsCompleted: [1]`
- Definir `agents_loaded: true` e `party_active: true`
- Carregar: `./step-02-discussion-orchestration.md`

---

## MÉTRICAS DE SUCESSO:

✅ Manifest de agentes carregado e parseado com sucesso
✅ Roster completo de agentes construído com personalidades merged
✅ Contexto WSD detectado ou solicitado ao usuário
✅ Introdução engajante do Party Mode criada
✅ Amostra diversa de agentes exibida ao usuário
✅ Opção [C] apresentada e tratada corretamente
✅ Frontmatter atualizado com status de carregamento
✅ Roteamento correto para step de orquestração de discussão

## MODOS DE FALHA:

❌ Falha ao carregar ou parsear o CSV manifest
❌ Extração incompleta de dados de agentes ou construção de roster
❌ Introdução genérica ou não-engajante do Party Mode
❌ Não exibir amostra diversa de capacidades de agentes
❌ Não apresentar opção [C] após carregamento
❌ Iniciar conversa sem seleção do usuário
❌ Ignorar contexto WSD disponível

---

## PRÓXIMO STEP:

Após usuário selecionar 'C', carregar `./step-02-discussion-orchestration.md` para iniciar a conversa interativa multi-agente com seleção inteligente de agentes e fluxo natural de conversa.

**Lembrete:** Criar atmosfera party-like engajante enquanto mantém expertise profissional e orquestração inteligente de conversa!
