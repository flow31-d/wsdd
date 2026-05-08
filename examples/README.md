# Examples

Esta pasta contém exemplos de uso do `wsdd` em projetos hipotéticos. Os exemplos são **descritivos**, não executáveis — servem para ilustrar como o método se comporta em cenários comuns.

Os exemplos privados do desenvolvimento original (perfis e bootstraps de clientes específicos) **não foram publicados** aqui por respeito à confidencialidade. Para gerar seus próprios exemplos, basta rodar:

```bash
node bin/wsd-method.js install --directory /tmp/exemplo-greenfield --tools both --yes --github skip
```

E inspecionar o resultado.

## Disponíveis

- (vazio nesta versão pública — exemplos serão adicionados conforme casos de uso reais aparecerem)

## Como contribuir com um exemplo

1. Instale `wsdd` em um projeto seu (greenfield ou brownfield).
2. Após uma sessão real, exporte um trecho relevante (`+specs/HANDOFF.md`, decisões em `STATE.md`, spec WHEN/THEN/SHALL).
3. Anonimize qualquer nome de cliente, URL privada ou path interno.
4. Abra PR em `examples/<nome-do-cenario>.md` seguindo o padrão de markdown limpo.
5. Veja [`CONTRIBUTING.md`](../CONTRIBUTING.md) para fluxo completo.
