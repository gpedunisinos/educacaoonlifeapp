# Educação Onlife — integrações e inteligência artificial

Referência: [plano aprovado na Wiki, revisão 2592](https://wiki.spotec.app/index.php/Plataforma_Educa%C3%A7%C3%A3o_Onlife_-_Planejamento_de_integra%C3%A7%C3%B5es_e_intelig%C3%AAncia_artificial), consultado em 21/10/2026. A matriz de requisitos e evidências é mantida também em `docs/integracoes-ia-execucao.md` do repositório da API.

## Checkpoint do editor e leitor

- Bloco Quill `onlife`, com payload JSON versionado (`v`, `provider`, `url`, `title`, `instructions`). Não aceita HTML/JavaScript de incorporação fornecido pela pessoa.
- Cartões responsivos abaixo do editor para YouTube e, no navegador, Genially, Padlet, FrameVR, Overte e Vircadia. Nome e explicação ficam visíveis. Metaverse não é oferecido enquanto o produto não for identificado.
- O editor guarda o cursor antes do diálogo e permite alterar/remover referências. Na visualização, Genially e Padlet têm conteúdo incorporado, ampliação e acesso externo; FrameVR só cria uma instância ao entrar no ambiente, com descarte ao voltar. Clientes Overte/Vircadia têm referência copiável e instruções, sem promessa de execução por iframe ou homologação de um mundo real.
- Leitores nativos mostram indicação neutra para integrações ainda não homologadas, sem ações incompatíveis. Os dados e a ordem dos blocos são preservados, inclusive para tipos/versões desconhecidos.
- URLs já representadas por integração não geram prévia duplicada. `description` continua texto autoral, sem simular extração dos provedores.
- Clientes novos enviam `description_format_version: 1`. A API bloqueia atualização por cliente antigo de um documento com blocos estendidos. Publicar a API antes do frontend.
- Testes: 18 testes de integrações, conteúdo e documentos Quill aprovados; build web e análise sem erros. Na API, testes de serviço e ciclo HTTP de criação/leitura/edição/remoção foram executados em banco local novo e isolado.

Este checkpoint não comprova acesso a conteúdos reais dos provedores. A validação no navegador e a homologação externa continuam pendentes, assim como Jitsi, MCP, contexto dinâmico, Gemini e benchmark completos. Evidências de validação ficam em `docs/evidencias/`, ignoradas pelo Git; credenciais permanecem somente no ambiente protegido do backend.
