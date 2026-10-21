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


## Checkpoint — revisão de formulário e análise preservada

Validação visual detectou que o InputText legado fixa texto/cursor em preto. Os formulários de pistas agora usam o campo que respeita o tema já empregado na Gestão, com rótulos acessíveis e suporte somente leitura; validações e controladores mantidos. O contexto de edição só envia `draft` quando há diferença real nos campos, documento ou metadados. Após recarregar sem editar, pergunta real à Iareté reconheceu ausência de alterações e Genially já salvo; a prova anterior com alteração local continua distinguindo o registro persistido. Evidência ignorada: `docs/evidencias/iarete-registro-sem-rascunho.png`.

Cada rota do grafo passa a possuir controlador próprio. Abrir uma nova análise não substitui seleção/filtros de uma tela mantida na pilha. Teste de navegação verifica busca, seleção e matriz de enquadramento na volta, junto dos testes existentes em desktop, celular e orientação horizontal. Suíte Flutter atual: **88 testes aprovados**, build web de validação concluído; análise estática sem erros.

FrameVR: exemplo público `https://framevr.io/edumetaverse`, anunciado na página do projeto educacional E-LIVE `https://sites.google.com/view/framevr-in-the-classroom/how-to/examples-virtual-visits`. Cena carregada e visitante conectado no Chrome, com contador de uma pessoa, movimentação por teclado e câmera/microfone desligados. Prova em `docs/evidencias/framevr-publico-chrome.png`. No navegador interno a cena também carregou, mas o provedor falhou ao configurar RTCPeerConnection; isso não é homologação de voz/vídeo nesse navegador. Inserção do bloco pela interface, gravação e reabertura da pista sintética confirmadas; leitor apresenta entrada explícita, sem criar o mundo antes do clique. Teste de iframe/retorno e mídia ainda em andamento. Nenhuma mensagem foi publicada no mundo, nenhuma configuração do ambiente público alterada.


## Implantação web e chat da própria pista

Frontend de produção compilado com API HTTPS do servidor e Encontros desabilitado por padrão. Publicado em `/var/www/onlife-releases/integrations-20261021T065514Z-495d00a`, revisão de código `495d00a`, arquivo SHA-256 `31bd7ecba4595bd33b852bf7b1aba58f349c172891ccd46cc80edd74407583f2`. O DocumentRoot anterior foi movido inteiro para `previous-integrations-20261021T065514Z-495d00a`, sem excluir arquivos, e `/var/www/usp_app` passou a apontar para a nova release. Rollback documentado em registro privado `/home/ubuntu/backups/onlife-web-releases/`; metadados públicos contêm somente revisão/hash. O script `scripts/deploy-web-release.py` mantém releases anteriores e volta ao diretório anterior se os checks HTTP falharem. Nenhuma configuração Apache ou banco é alterada por ele. As duas origens web responderam normalmente; preservação das 23 tabelas novamente conferida sem diferença. A credencial Gemini autorizada foi procurada em todos os arquivos do build e não estava presente.

Na prévia isolada, FrameVR foi aberto explicitamente e a cena carregou no iframe, mas a conexão falhou pelo limite WebRTC do navegador interno; o botão Voltar retornou à pista e removeu o iframe FrameVR da árvore de acessibilidade. A incorporação completa no Chrome segue pendente de continuidade do controle desse navegador.

Chat próprio da pista validado pela interface, com chamada real Gemini: começou sem o histórico da Iareté global; apresentou-se como Jardim Aurora, informou as 18 árvores, ausência de coordenadas/leituras e declarou possuir somente o link FrameVR, sem ter explorado o mundo. Evidência ignorada `docs/evidencias/chat-pista-gemini-dados-limites.png`. Nenhum histórico real foi usado ou alterado.


## Ajustes após a publicação

Permissão de captura do ponteiro adicionada ao sandbox somente dos ambientes FrameVR abertos explicitamente, permitindo a navegação 3D que depende desse recurso; os conteúdos comuns continuam sem essa permissão. A rota de foco do grafo é capturada antes das requisições, para que uma mudança de rota durante o carregamento não troque o ID solicitado. Análise estática desses arquivos e sete testes da sala/grafo aprovados. Esses dois ajustes ainda precisam ser incluídos no próximo build publicado.

Validação adicional do servidor: hashes dos arquivos públicos main.dart.js, space.bundle.js e space.css coincidem com a release; imagem da API não contém o arquivo de ambiente antes do mount em execução; tela de login abriu no navegador com identificação Educação Onlife. Os três arquivos de storage existentes, excluindo logs, mantêm seus hashes originais.


## Encerramento do mundo em segundo plano e contexto do conteúdo ampliado

A sala FrameVR agora desmonta seu iframe ao ser coberta por outra rota, ao ocultar a aplicação e ao abrir a origem externa. O retorno exibe “Ambiente encerrado” e exige “Entrar novamente”, evitando reconexão automática ou duas instâncias simultâneas. Apresentações comuns preservam sua instância durante a ampliação. O contexto da Iareté identifica o provedor/título e mantém o ID da pista de origem; não afirma observar pessoas, mensagens, áudio ou o mundo. Ao voltar de outra rota ou fechar a sala, o contexto correto é restaurado. Provedores de telas cobertas não ganham prioridade apenas por reconstruírem.

Seis testes novos verificam navegação/remoção real do widget (inclusive fora da árvore visível), ciclo de vida, retorno sem reconexão, falha de abertura externa, contexto com retorno entre rotas e controles em 390×844 com título extenso. Suíte completa: **94 testes aprovados**; análise dos arquivos alterados sem erros; build de validação concluído. A prova visual dessa nova revisão e sua publicação ainda seguem em andamento.

Padlet oficial lido e ampliado: `https://padlet.com/gallerytemplates/social-media-research-notes-u527etuc56i78kiv`. Não houve postagem nem mudança de permissões no mural. Genially real editado; um segundo bloco inexistente mostrou 404 isolado, foi removido pela interface e a remoção persistiu. GET autenticado da massa local confirmou Padlet/FrameVR/Genially na ordem esperada, título editado e texto autoral intactos. APK debug arm64 compilou sem instalação em dispositivo; iOS não compilado neste host Linux.

A release publicada foi atualizada para `5d08f8a`, diretório `/var/www/onlife-releases/integrations-20261021T072136Z-5d08f8a`, arquivo SHA-256 `ef4f3360b98fc6bc3bdb1baae176bec068aab0db432047de7477a4d29d615ee7`. Mantida a release anterior. A prévia principal `127.0.0.1:8772` foi recompilada para a API local `8080`, com serviço separado que usa somente a cópia local do banco e não inicia jobs; a prévia sintética permanece em `8773/8082`. Encontros segue habilitado só na prévia sintética para validação, sem ativação geral antes do aceite.


## Revalidação de 21/10/2026

Resultado atual e limites de homologação consolidados em [Validação das integrações](validacao-integracoes-2026-10-21.md): Flutter 94/94, testes Go em banco novo, benchmark determinístico 57/57 e nova rodada Gemini real 57/57. Inclui reedição/persistência, uso dos provedores na interface e pendências externas explicitadas.
