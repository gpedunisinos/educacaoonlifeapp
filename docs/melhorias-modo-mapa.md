# Modo de exploração, abertura e localização

A troca de Explorador/Inventor nas telas de consulta salva a preferência e atualiza os controles na mesma rota. As páginas de consulta observam o usuário e preservam seu State: busca, seleção e posição de visualização não são reinicializadas. Falhas de gravação conservam o modo confirmado anteriormente. A tela de escolha inicial continua destinada a contas que ainda não escolheram seu modo.

O atalho aparece somente nas rotas de consulta explicitamente permitidas e fica oculto em criação, edição, vinculação, seleção de tipo/categoria e diálogos ou painéis sobrepostos. As permissões e os guards existentes continuam controlando o acesso.

A splash utiliza a identidade Educação OnLIFE e a representação da Iareté. A referência e o arquivo do logo da USP foram removidos do pacote de assets. Os identificadores técnicos do aplicativo permanecem compatíveis.

O tutorial do Mapa de Pistas apresenta a Iareté nos cartões com realce do controle, texto progressivo e som conforme a preferência compartilhada. Avançar, voltar ou fechar cancela a fala anterior. Redução de movimento é respeitada, e ações de autoria são omitidas no modo Explorador. Os cartões têm altura limitada e rolagem em telas menores.

A escolha de localização utiliza o mesmo seletor na criação pelo mapa e nos formulários. Inicia em satélite quando o catálogo disponibiliza a camada; oferece Mapa/Satélite, busca por cidade/endereço/lugar/CEP, seleção pelo mapa, zoom, localização atual sob solicitação e remoção do ponto. A seleção é preservada ao alternar a camada e só é devolvida ao formulário na confirmação. Na indisponibilidade do satélite, o mapa convencional continua disponível. O aviso de localização pública/aproximada e o reconhecimento de privacidade da criação pelo mapa são preservados.

Validação automatizada: 110 testes Flutter aprovados e análise sem erros. Os testes incluem preservação de estado na troca de modo, bloqueio do atalho em formulários, alternância de camada sem perda de coordenadas, busca/retorno do ponto e tutorial da Iareté em desktop e celular.

Conferência visual em conta sintética: busca por Jardim preservada ao alternar Inventor → Explorador → Inventor, na mesma rota da Lua de Pistas. A ação Nova pista acompanha o modo, e o seletor de modo desaparece no formulário de criação. Tutorial da Iareté e seletor compartilhado de localização conferidos no navegador.
