---
title: "Padrões BMAD — Como o Sistema Usa Agentes Bem"
created: 2026-05-07
type: referencia
tags:
  - wsd
  - party-mode
  - bmad
  - design
---

# Padrões BMAD — Insights de Design de Agentes

[[party-mode/README|← Party Mode WSD]]

Este documento captura os princípios não-óbvios por trás do design do Party Mode WSD — insights absorvidos ao estudar como o BMAD orquestra múltiplos agentes sem gerar overhead. Útil para quem quiser estender o sistema ou entender por que as escolhas foram feitas assim.

---

## 1. Volume de agentes ≠ overhead

**O insight:** A intuição inicial é "menos agentes = menos confusão". Está errada. Ter 28 agentes disponíveis não cria overhead — seleção errada cria overhead.

**Por que funciona:** Um roster grande permite especialização fina. Um agente de "test engineering" (Murat) e um de "test architecture" (GLaDOS) cobrem ângulos diferentes do mesmo problema. Se você colapsar os dois em um agente genérico de "testes", ele ou vai se perder tentando cobrir tudo ou vai fazer ambos superficialmente.

**Como se manifesta aqui:** 26 agentes no roster, mas o selection engine nunca convoca mais de 3 por contexto. O tamanho do roster é irrelevante para o usuário — ele só vê os 2-3 que importam para aquele momento.

---

## 2. O selection engine é separado dos agentes

**O insight:** A lógica de "quem chamar" e "quem são os agentes" são preocupações distintas — e misturá-las é o erro mais comum em sistemas multi-agente.

**Por que importa:** Se a lógica de seleção está embutida nos perfis dos agentes ("eu me ativo quando X"), qualquer mudança na estratégia de seleção exige editar todos os 26 arquivos. Se está separada em um step próprio, você evolui a estratégia sem tocar nos perfis.

**Como se manifesta aqui:** `step-02-discussion-orchestration.md` é o único lugar onde existe lógica de seleção. Os arquivos em `agents/` descrevem apenas identidade, expertise e comportamento. Mudar "quem chama quem em RISK L2" é uma edição de uma linha no step-02 — sem tocar em GLaDOS, Murat ou Cloud.

---

## 3. Context detection antes de agent selection

**O insight:** A ordem importa. Primeiro entender *onde você está* no ciclo; só depois decidir *quem chamar*. Inverter isso gera debates genéricos que não servem ao momento.

**Por que funciona:** Um arquiteto (Winston) em fase SPECIFY vai propor patterns prematuramente. O mesmo arquiteto em fase DESIGN vai avaliar trade-offs com os dados certos. É o mesmo agente, mas o momento certo muda completamente o valor da contribuição.

**Como se manifesta aqui:** O step-01 detecta L0/L1/L2 e fase (SPECIFY/DESIGN/EXECUTE) *antes* de qualquer seleção. O step-02 usa esse contexto como primeiro critério de filtro. Agentes nunca são convocados sem contexto estabelecido.

---

## 4. wsd_expertise é um contrato, não decoração

**O insight:** O campo `wsd_expertise` no frontmatter de cada agente não é metadata cosmética. É o que garante que o agente responde com vocabulário e raciocínio do domínio específico — não com conselhos genéricos que qualquer LLM daria.

**Por que importa:** Sem esse campo, "analyst" responderia sobre análise em geral. Com `wsd_expertise: WHEN/THEN/SHALL gap analysis, L0/L1 classification, spec completeness`, ela responde especificamente sobre specs WSD, classification de ciclos, e acceptance criteria testáveis.

**Como se manifesta aqui:** Cada agente tem um bloco `## WSD Domain Knowledge` que espelha o `wsd_expertise` do frontmatter com exemplos. O agente não apenas *sabe* que é especializado — ele *demonstra* como aplica isso em contexto WSD nos exemplos in-character.

---

## 5. Cross-questioning como mecanismo de qualidade

**O insight:** Agentes que apenas apresentam suas perspectivas em paralelo produzem uma lista de opiniões. Agentes que se questionam mutuamente produzem síntese — e revelam inconsistências que nenhum deles teria identificado sozinho.

**Por que funciona:** Quando Mary (analyst) diz "Quinn, você consegue escrever um teste para esse THEN?", ela está forçando a perspectiva de testabilidade a colidir com a perspectiva de spec antes que ambas fiquem isoladas. A tensão entre as duas perspectivas é onde a qualidade emerge.

**Como se manifesta aqui:** Os exemplos in-character de cada agente terminam frequentemente com uma pergunta direcionada a outro agente pelo nome. O step-02 facilita esse cross-talk explicitamente em vez de deixar agentes falando em paralelo.

---

## 6. Micro-file por agente permite evolução independente

**O insight:** Um agente em arquivo próprio pode ser editado, substituído ou removido sem risco de regressão nos outros. Um arquivo monolítico de 26 agentes cria acoplamento implícito — editar um pode afetar como os outros são interpretados.

**Por que importa na prática:** Quando você descobrir que Murat (tea) precisa de conhecimento de GitHub Actions para um projeto específico, você edita `agents/tea.md`. Se Samus (feature-designer) não está sendo útil em um contexto, você refina apenas `agents/feature-designer.md`. O resto do sistema não sabe que a mudança aconteceu.

**Como se manifesta aqui:** Cada arquivo em `agents/` é autossuficiente — frontmatter, persona, domain knowledge, exemplos, selection guide. O manifest `agents-wsd.csv` tem os metadados para seleção; o arquivo `.md` tem o comportamento. Separação limpa.

---

## 7. Agentes se complementam, não competem

**O insight:** A combinação arquitetural certa seleciona agentes com ângulos ortogonais — não agentes com expertise sobreposta. Se dois agentes concordam em tudo, um deles é desnecessário.

**Por que funciona:** `architect + dev + qa` funcionam bem juntos porque Winston pensa em estrutura de longo prazo, Amelia pensa em implementabilidade imediata, e Quinn pensa em verificabilidade. Esses três ângulos criam tensão produtiva. `architect + sys-architect + module-builder` teria sobreposição demais em um debate de código.

**Como se manifesta aqui:** O mapa de seleção do step-02 foi montado garantindo ortogonalidade: cada combinação tem pelo menos um agente de spec, um de técnica, e um de negócio/qualidade/estratégia. Agentes do mesmo domínio raramente aparecem juntos no mesmo contexto.

---

## Resumo: O Que Não Fazer

| Antipadrão | Por que falha | Alternativa |
|-----------|--------------|-------------|
| Reduzir agentes para "menos overhead" | Overhead vem de seleção errada, não de volume | Manter roster rico, afinar selection engine |
| Lógica de seleção embutida nos agentes | Mudança estratégica = editar 26 arquivos | Selection engine centralizado em step-02 |
| Convocar agentes sem estabelecer contexto | Debates genéricos, sem ancoragem ao momento WSD | Context detection primeiro (L0/L1/L2, fase) |
| Agentes com expertise genérica | Conselhos que qualquer LLM daria | wsd_expertise como contrato de especialização |
| Agentes monolíticos em arquivo único | Edição cria risco de regressão implícita | Micro-file por agente |
| Selecionar agentes com expertise sobreposta | Lista de opiniões, sem tensão produtiva | Combinações ortogonais (spec + técnica + qualidade) |
