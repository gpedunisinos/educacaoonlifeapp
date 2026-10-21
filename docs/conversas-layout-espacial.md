# Conversas na estética da nave — 21/10/2026

Atualizados o painel global da Iareté, a conversa da própria pista e a conversa de agentes acessada pela Gestão. A Câmara de Inteligências já existente mantém sua apresentação e seus controles.

- Estrutura compartilhada com materiais escuros, fundo da sala de pesquisa, reforços nas bordas, contornos ciano e largura limitada para leitura.
- Cabeçalho da Iareté com fluxo luminoso discreto, respeitando a configuração de movimento reduzido; identificação de autor e mensagens em tons compatíveis com a nave.
- Compositores escuros, texto legível, links/Markdown, horários, histórico, paginação e callbacks de navegação preservados. Não há mudança de endpoint ou de política de dados.
- O atalho flutuante fica oculto enquanto um painel global está aberto e retorna ao fechar. A conversa de agentes da Gestão eleva seu atalho, como já faz a conversa da pista.
- Enter durante um envio não apaga a próxima pergunta digitada. Confirmação de limpar a conversa mantida e adaptada ao tema.

Validação: suíte Flutter completa com **99 testes aprovados**, incluindo cinco novos testes de conversa e ampliação do teste do launcher. Verificados títulos longos/histórico em 1280×800, 390×844 e 844×390, teclado de 300 px no celular, preservação do rascunho durante envio e cancelamento da limpeza sem apagar mensagens. Análise do projeto sem erros; sugestões/avisos preexistentes permanecem.

Pela interface da prévia isolada 8773, o histórico da pista foi reaberto e uma pergunta recebeu resposta real; a agente sintética Cartógrafa respondeu no acesso pela Gestão; o painel global da Iareté enviou e recebeu uma mensagem, sem atalho cobrindo o botão Enviar. Conferido também seu layout em 390×844. Os três históricos continuam separados. Não foram alteradas conversas de contas reais.

Builds web release concluídos: prévia principal 8772 usa a API local 8080; prévia isolada 8773 usa 8082 e mantém sua configuração de validação. Imagens locais não versionadas: `/tmp/onlife-iarete-layout-espacial.png`, `/tmp/onlife-iarete-layout-celular.png` e `/tmp/onlife-conversa-agente-novo-layout.png`.
