---
title: "Exemplo Real: Design Review — Sistema de Cache"
created: 2026-05-07
type: exemplo
---

# Exemplo Real: Design Review — Sistema de Cache WSD

[[party-mode/README|← Party Mode WSD]]

---

## 📋 Contexto

**Feature:** Adicionar cache de usuário em API  
**Workflow:** design-review  
**Status:** ✅ Consenso alcançado  
**Data:** 2026-05-06 14:30  
**Duração:** 27 min

---

## 👥 Participantes

- 💻 **ImplementationExpert** — propõe padrões
- 🔴 **RiskAnalyst** — questiona riscos
- ⚙️ **OpsEngineer** — valida operação
- 📋 **SpecReviewer** — fecha com spec

---

## 🎤 Debate Transcrito

### 1️⃣ ImplementationExpert (abre)

> "Spec tá aprovada. Agora, qual cache usar?
>
> Tenho 3 padrões viáveis:
>
> **Opção A: Redis (distributed cache)**
> - Persistência opcional, TTL automático
> - Shared entre instances, escalável
> - Complexidade: média (quer redis cluster ou redis sentinel)
>
> **Opção B: Memcached (ephemeral cache)**
> - Simples, rápido, pronto pra usar
> - Não persiste (perda em restart)
> - Complexidade: baixa
>
> **Opção C: Database query cache (inline)**
> - Tira redundância de BD
> - Tá já integrada no código
> - Complexidade: baixa, risco: médio (invalidation complexity)
>
> Qual desses faz mais sense?"

---

### 2️⃣ RiskAnalyst (responde)

> "Tech-wise parecem viáveis. Risk-wise, questões:
>
> **Opção A (Redis):**
> 🔴 Network partition — Redis unreachable → fallback? queues?
> 🟡 Data consistency — quem invalida cache quando BD muda?
> 🟡 Rollback — se adicionar Redis, como remove depois?
>
> **Opção B (Memcached):**
> 🟡 Loss de dados em deploy — é aceitável por ~2 min?
> 🟡 Invalidation — sem TTL automático como em Redis
>
> **Opção C (Database):**
> 🔴 Query time cresce se cache miss (queries não otimizadas?)
> 🟡 Invalidation strategy precisa ser clara
>
> Pergunta pra você: Qual é a penalty se cache miss? 
> (1ms vs 100ms?"

---

### 3️⃣ ImplementationExpert (responde)

> "Boa pergunta. Cache miss hoje é ~150ms (BD query + ORM overhead).
> Com cache, esperamos drop pra ~5ms.
>
> Então sim, fallback pra BD é aceitável, mas penaliza UX.
>
> Isso reforça — se usar Redis, é importante ter fallback robusto."

---

### 4️⃣ OpsEngineer (entra)

> "Ops perspective:
>
> **Opção A (Redis):**
> ✅ Monitoring bem estabelecido (redis-exporter, prometheus)
> ✅ Escalabilidade clara (redis cluster)
> ❌ Outra infra pra monitorar/operacionalizar
> ⏱️ Deploy + monitoring setup: ~1 semana
>
> **Opção B (Memcached):**
> ✅ Simples, menos pra monitorar
> ✅ Fallback pra BD é automático (não temos Memcached)
> ❌ Perda de dados a cada deploy
> ⏱️ Mais rápido de ship: ~2 dias
>
> **Opção C (Database):**
> ✅ Nada novo pra ops
> ❌ Aumenta pressão no BD
> ⏱️ Ship rápido: ~1 dia
>
> Pra L1, eu recomendo: Opção C (database), depois evoluir pra Redis se needed."

---

### 5️⃣ RiskAnalyst (contra-argumenta)

> "Ops faz sentido em simplificar. Mas risk-wise:
>
> Opção C (database query cache) traz dependency no ORM:
> - É configurável? Invalidável? Testável?
>
> Se BD grow 10x em 6 meses, essa cache se torna bottleneck.
>
> Meu concern: estamos evitando problema agora que volta pior depois.
>
> Proposta: Start com Opção B (Memcached ephemeral) — simples, rápido.
> Design isso já pensando em Redis migration depois (abstract interface).
>
> Melhor compromisso entre velocidade + preparado pra scale."

---

### 6️⃣ ImplementationExpert (reflete)

> "RiskAnalyst tem ponto. Se desenhamos cache abstrato (interface):
>
> ```typescript
> interface CacheProvider {
>   get(key): Promise<T>
>   set(key, value, ttl): Promise<void>
>   invalidate(pattern): Promise<void>
> }
>
> // Implementações: MemcachedCache, RedisCache, DatabaseCache
> ```
>
> Então migrar Memcached → Redis depois é low-friction.
>
> Concordo: Opção B (Memcached) com interface pra evolução.
> Isso tá viável? Ops?"

---

### 7️⃣ OpsEngineer (fecha)

> "✅ Viável. Memcached é simpler.
>
> HANDOFF pra ops:
> - Memcached instance provisioning: ~1 day
> - Monitoring: padrão (RAM, evictions, hit rate)
> - Runbook: restart, scale, rollback → tudo documentado
>
> Go. Próxima review se hit scaling limits."

---

### 8️⃣ SpecReviewer (sintetiza)

> "Spec tá bem. Confirmando:
>
> **WHEN:** User query hit API  
> **THEN:** Response tem dados cached (se < 5 min old)  
> **SHALL:** Fallback to BD if cache miss ou Redis unreachable
>
> Tudo claro. Próximo: design da interface pra permitir Redis migration.
>
> ✅ Spec pronta. Manda pro EXECUTE."

---

## ✅ Consensos

- ✅ **Solução:** Memcached como L1 cache
- ✅ **Interface:** Abstract CacheProvider para evolução futura
- ✅ **Fallback:** BD query é aceitável como fallback
- ✅ **Invalidation:** TTL 5 min, manual invalidation trigger
- ✅ **Monitoring:** Hit rate + RAM + eviction tracking
- ✅ **Risco:** Baixo, preparado pra evoluir

---

## ⚠️ Tensões (Resolvidas)

### Tensão 1: Simplicidade vs Escalabilidade

| Opção | Simples? | Escalável? | Quando Mudar? |
|-------|---------|-----------|---------------|
| Redis | Não | Sim | Imediatamente |
| Memcached | Sim | Pouco | 6+ meses, 10x BD |
| Database | Sim | Não | 3 meses |

**Resolução:** Memcached + interface abstrata = simple agora, escalável depois.

### Tensão 2: Deploy Speed vs Operations Debt

| Opção | Speed | Debt |
|-------|-------|------|
| Database | 1 dia | Alto (BD pressure) |
| Memcached | 2 dias | Baixo (simples) |
| Redis | 1 semana | Zero (proper setup) |

**Resolução:** Memcached 2 dias resolve bem, depois migra se needed.

---

## 🔴 Riscos Capturados & Mitigações

| Risco | Severidade | Mitigação | Owner |
|-------|-----------|----------|-------|
| Cache invalidation complexity | Médio | TTL + manual trigger em admin | Implementação |
| Memcached data loss on deploy | Baixo | OK aceitável por ~2 min (spec diz fallback) | Ops |
| Future scaling (10x BD) | Médio | Interface abstrata permite Redis depois | Design |
| Monitoring gaps | Baixo | Standard Memcached metrics em Prometheus | Ops |

---

## 🎯 Recomendação Final

### Decisão

→ **Implementar cache com Memcached + CacheProvider interface**

### Rationale

1. **Velocidade:** Ship em 2 dias vs 1 semana (Redis)
2. **Risco:** Baixo — fallback à BD é transparente
3. **Operações:** Simples — Memcached é battle-tested
4. **Escalabilidade:** Preparado — interface permite Redis depois sem refactor
5. **L1 appropriate:** Feature é learning experience, OK ser simples

### Trade-off Explícito

**Custo:** Se BD realmente crescer 10x em próximos 3 meses, precisaremos migrar pra Redis.  
**Mitigação:** Interface prepara isso. Migração será refactor isolado, não cascata.

---

## 📌 Próximos Passos

- [ ] **Spec refinement:** ImplementationExpert detalha interface CacheProvider
- [ ] **Ops planning:** Memcached provisioning, monitoring setup
- [ ] **Design:** Task card "implement CacheProvider abstraction"
- [ ] **Execute:** Implementar com Memcached backend
- [ ] **Release:** Ship e monitor hit rates por 1 semana
- [ ] **Review:** Se hit rate < 60%, reabre Party Mode pra avaliar estratégia

---

## 📊 Resultado Esperado

**Before Party Mode:**
- Uncertainty: 3 opções, não claro qual escolher
- Rework risk: 50% (escolhe errado, refactor depois)
- Time estimate: 2-4 sprints com incerteza

**After Party Mode:**
- Clear decision: Memcached + interface
- Design prep: Interface permite evolução
- Time estimate: 1-2 sprints com confiança
- Ops ready: Monitoring já pensada

**Net benefit:** +40% clarity, -2 sprints potencial de rework.

---

## 📚 Referências

- **Spec:** `+specs/features/cache-layer/spec.md`
- **Party Mode Output:** Este documento
- **Next Task:** `+specs/features/cache-layer/tasks.md`

---

**Status:** ✅ Consenso — Ready pra EXECUTE

Próximo passo: `+wsd/bin/wsd tasks --feature cache-layer`
