# Navegação, mapa e pistas

O mapa inicia na camada de satélite oferecida pelo catálogo geográfico autenticado. Na indisponibilidade dessa camada, mantém o mapa-base convencional. A escolha manual permanece disponível durante a visita. A barra superior reúne retorno ao cockpit, identificação e ferramentas; em telas pequenas, distribui as ações sem sobrepor o mapa.

Os acessos aos destinos espaciais usam “Conecte-se”. A Lua de Pistas oferece criação para usuários autorizados em modo Inventor, utilizando o fluxo existente de tipo, categoria e cadastro. Ao retornar, atualiza a lista preservando a busca.

As respostas novas da Iareté global aparecem em pequenos trechos, com notas suaves inspiradas no cockpit. Histórico é exibido completo. É possível silenciar, mostrar a resposta completa imediatamente e respeitar redução de movimento. A preferência de áudio é compartilhada com o cockpit; fechar a conversa interrompe seus sons e temporizadores. Não há alteração no conteúdo ou na persistência das respostas do servidor.

As integrações possuem altura uniforme calculada a partir do maior texto, incluindo escala de fonte. Na edição de pistas, coordenadas aparecem somente para leitura e continuam sendo alteradas pelo seletor de localização. A criação e edição de vínculos usam a sala da nave, mantendo os seletores, validações e salvamento existentes.

## Validação

Executar `flutter test`, `dart analyze` e a compilação web. Os testes cobrem entrada em satélite/fallback, controles do mapa em desktop/celular, acesso de criação por modo, resposta progressiva/histórico/interrupção/redução de movimento e retorno ao cockpit com áudio sincronizado.

Para conferir visualmente, usar a prévia local e testar as ações de escrita com dados de demonstração no ambiente isolado. A disponibilidade efetiva das imagens depende do serviço geográfico e de sua credencial configurada.

Validação em 21/10/2026: suíte completa com 107 testes aprovados; formulário de vínculo reconferido em 390 e 1280 px após ajuste de contraste. Análise sem erros. Imagem de satélite confirmada na prévia conectada ao serviço geográfico; criação e conversa verificadas com conta de demonstração no ambiente isolado.
