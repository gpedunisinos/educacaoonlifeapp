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


### Checkpoint — contexto atual e referências da Iareté

O envio usa `screen_context` versionado, com IDs, até 20 registros visíveis, campos atuais e rascunho não salvo. Há provedores para cockpit, mapa/seleção, Lua de Pistas, grafo/filtros/relações, visualização, criação, edição, agentes e conversa da própria pista. Rotas mantêm seus provedores enquanto montadas; voltar de painéis/telas restaura a origem e o formulário é lido novamente a cada pergunta. A seleção do mapa é descartada ao fechar seu painel. O backend continua sendo responsável por reautorizar IDs e carregar os registros persistidos.

Os dois chats têm prazo de cliente de 60 segundos, superior ao limite de processamento do backend. Retirado o log de valores de contexto, grafo e corpos JSON dos interceptadores compartilhados; erros de transporte exibem apenas sua categoria no log, sem conteúdo. Mensagens conhecidas de quota/modelo/configuração/limite são apresentadas sem ecoar erros arbitrários. Respostas da Iareté usam Markdown e referências clicáveis para pistas e problemáticas; navegação interna fica restrita a telas de leitura. O chat da pista usa a mesma navegação segura, mantendo histórico próprio.

Verificações: sete testes de contexto/transporte (retorno de rota, provedor sobreposto, rascunho/IDs no JSON real, limites, chaves sensíveis e erros), testes de navegação do cockpit e testes da pesquisa/integrações aprovados. `dart analyze` sem erros; build web isolado `build/integrations-validation` concluído. A validação visual e conversa Gemini autenticada no navegador ainda está pendente e será feita com conta/banco sintéticos, sem inserir mensagens em contas reais.


## Checkpoint — formulários, encontros e isolamento de contexto

Os formulários de criação/edição adotam o tema escuro/ciano da nave, mantendo os controles existentes. Mensagens Markdown dos dois chats não carregam imagens externas passivamente. A suíte Flutter completa anterior a este checkpoint passou (86 testes); o teste adicional de propriedade de contexto por URL também passou. `dart analyze` não apontou erros; permanecem avisos preexistentes fora desta alteração. Contextos de formulários com IDs em parâmetros agora pertencem à URL completa; um formulário mantido na pilha não substitui o rascunho de outro após reconstruir. Provedores genéricos continuam atendendo variantes de consulta quando não há proprietário exato.

Encontros: controle web, campo para sala/convite, geração de nome, copiar link e abertura em outra aba por clique. Servidor permitido configurável, sem tokens da plataforma no endereço, validação de origem/caminho/credenciais e retorno com dados preservados quando a abertura falha. Seis testes de encontros/navegação aprovados, incluindo tela pequena e falha de abertura. Android/iOS não oferecem o controle. A flag `JITSI_ENABLED` permanece desligada por padrão até definição dos organizadores e aceite operacional; somente a prévia isolada foi compilada com a flag ligada.

Validação real na prévia isolada: clicar em Encontros, informar `piloto-onlife-validacao` e entrar abriu outra aba em `https://meet.spotec.app/piloto-onlife-validacao`, com tela de pré-entrada do Jitsi e a plataforma preservada na aba original. Não foram concedidas permissões de microfone/câmera nem realizada chamada nessa prova; ela não homologa mídia.
