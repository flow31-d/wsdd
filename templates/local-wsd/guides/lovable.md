# Guia — Lovable Workflow (obrigatório em repos Lovable)

Este repositório é editado pela **Lovable** (`gpt-engineer-app[bot]`) — editor
visual de UI por IA que sincroniza com o GitHub e rejeita o build
silenciosamente quando o repo sai do estado canônico.

## Regras técnicas obrigatórias

1. **Bun puro**: `bun install`, `bun add`, `bun run`. NUNCA `npm install`.
2. **`package-lock.json` é proibido** (causa raiz confirmada do "Preview
   travado", 17/05/2026). Está em `forbidden_paths` e no `.gitignore`.
3. **`src/routeTree.gen.ts`**: commitar quando o build modificar. NUNCA
   `git checkout src/routeTree.gen.ts` antes de commitar.
4. A Lovable só conecta a repos que ela criou. Migrar owner = recriar o projeto
   Lovable do zero; não tente transferir o repo.

## Áreas frágeis — preferir fluxo manual (Issue + branch + PR)

A Lovable já resetou/refatorou estas áreas em incidentes anteriores:

- `src/routes/index.tsx` — entrypoint raiz (resetado 2×; manter thin)
- Keyframes CSS multi-step (órbita, halo, espiral)
- Parallax tilt / mousemove handlers
- Posicionamento absoluto com cálculo trigonométrico

## Modelo de colaboração

- **Owner**: Lovable conectada + deploy oficial.
- **Colaboradores externos** (Claude Code, outros agentes, humanos): nunca push
  direto na branch principal — sempre **Fork → PR**, com preview próprio.

## Setup e gate

- GitHub: `Settings → Pull Requests → "Automatically delete head branches"`
  deve ficar **OFF** — aplicar via `./+wsd/bin/wsd lovable bootstrap`.
- Gate antes de commitar: `./+wsd/bin/wsd lovable doctor` (sem
  `package-lock.json`, com `bun.lock`, `lovable_integration.enabled: true`).
  Também roda dentro do `wsd_check.sh` quando o repo declara `lovable_integration`.
