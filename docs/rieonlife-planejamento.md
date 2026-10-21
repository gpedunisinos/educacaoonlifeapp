# Educação Onlife — experiência de exploração e autoria

Implementação dos REQ-01 a REQ-06 do [planejamento consolidado](https://wiki.spotec.app/index.php/Plataforma_Rieonlife_-_Planejamento_de_altera%C3%A7%C3%B5es_e_requisitos), revisão 2589, com a reunião de 19/10/2026 como contexto. Base Flutter confirmada: `origin/main` em `6daf964`, neste repositório. Branch local: `UU-95-primeira-versao-plataforma-econectiva`.

## Percursos

1. Primeiro login sem modo: abre `/choose_mode`, uma tela inteira com explicações, ícones, indicação da seleção atual e duas escolhas.
2. Explorador e Inventor abrem `/home`, com as permissões correspondentes a cada modo. O indicador global mostra nome/ícone e abre a mesma tela para trocar sem logout.
3. A preferência é guardada no objeto local da própria conta e reconciliada com `/me/preferences` ao restaurar uma sessão. Não há escolha silenciosa para contas antigas. Permissões de perfil e modo são verificadas separadamente, inclusive nas rotas diretas.
4. O botão flutuante expande os atalhos **Iareté** e **Locker**. O Locker abre à direita em telas amplas (a partir de 800 px), ou quase em tela inteira no celular. Os dois painéis são mutuamente exclusivos. Fechar preserva a tela de origem.
5. Marcadores nas pistas, na lista e no grafo de problemáticas permitem salvar/remover referências. Busca por nome, filtros e estados de carregamento, erro, vazio e indisponível compõem o painel. Abrir problemática preserva o modo e seleciona o nó indicado por `focus` no grafo.
6. Na lista de pistas, a criação começa pela seleção de tipo/categoria e chega ao formulário sem passar pelo mapa. Os campos de coordenadas são opcionais como par; o formulário de edição também oferece remoção integral. A criação pelo mapa continua preenchendo o ponto escolhido.
7. O documento Quill conserva a barra atual e acrescenta **Adicionar vídeo do YouTube** abaixo do editor. A seleção é guardada antes do diálogo, validada e usada por `replaceText`/`BlockEmbed.video`. Texto e links colados não viram vídeos automaticamente. Prévias aparecem abaixo do documento, com deduplicação de URLs e supressão do vídeo já incorporado.
8. A leitura apresenta o mesmo documento em modo somente leitura, vídeo responsivo, link original, prévias, metadados, relações, anexos, histórico e Compartilhações. A edição é uma ação separada. Links diretos `/living_clues/{id}` ou `/living_clues/show?id={id}` recuperam a pista pela API.
9. Compartilhações aceita texto e emoji nos dois modos; cada grupo conserva um comentário raiz e respostas, com indicação do destinatário. Há atualização manual, paginação e edição/exclusão das próprias mensagens. Erros preservam o texto digitado e não bloqueiam a leitura.

A identidade usa o fundo estrelado e os componentes existentes, com acentos em turquesa para Explorador e violeta para Inventor. Nome e ícone comunicam o modo sem depender apenas de cor. A faixa superior reserva espaço para o indicador sem cobrir controles do conteúdo. O tutorial do mapa é removido quando a navegação muda de tela.

## Ferramentas

O player atual requer Flutter 3.38/Dart 3.10; os limites foram explicitados no pubspec. Kotlin foi atualizado para 2.1.0, compatível com a WebView utilizada. O Android usa o mínimo da versão atual do Flutter (API 24).

## Conteúdo e reprodução

- `description_delta` é o contrato principal. O texto puro ignora o marcador de incorporação e não tenta transcrever vídeos. Um documento contendo apenas vídeo continua persistível.
- A leitura usa a API pública `Document.fromDelta`, evitando a transformação de importação do Quill 11.5 que adicionava uma nova linha ao último vídeo a cada reabertura. Nenhuma dependência foi modificada.
- O player `youtube_player_iframe` atende web/Android/iOS/macOS; o link original permanece acessível. Plataformas sem WebView suportada mostram a alternativa de abertura externa.
- Metadados de páginas são buscados pela API com cache separado, de forma assíncrona. Não são inseridos no Delta nem enviados automaticamente à IA.
- Pistas sem coordenadas não geram marcadores/linhas geográficas e continuam consultáveis na lista, busca e link direto. Não exibem contexto socioambiental calculado. A IA conserva os dados não geográficos.

## Validação local

```
flutter test --no-pub
flutter analyze --no-pub
flutter build web
flutter build apk --debug
```

A análise não contém erros de compilação; o repositório mantém avisos preexistentes. Os testes novos verificam políticas por modo/perfil, coordenadas nulas/zero, URLs YouTube, deduplicação, persistência de vídeo sem texto, inserção no início/meio/fim, desfazer/refazer, reabertura sem novas linhas e abertura/fechamento global do Locker sem perder a origem.

A inspeção em navegador utilizou API e MariaDB locais, com dados de demonstração; foram verificados primeiro login, modo salvo, troca sem login, Locker, vídeo incorporado, prévia real de link, publicação de mensagem e bloqueio de rota de edição em Explorador. A leitura e a seleção de modo foram revisadas em largura de celular (390 px), além da apresentação desktop. Isso não substitui homologação em aparelhos físicos iOS/Android.

O build local de demonstração usa `API_HOST=127.0.0.1`, `API_SCHEME=http` e `API_PORT=8080`; esses valores são fornecidos por `--dart-define`, sem alterar os padrões do aplicativo. O build de testes Android usa `10.0.2.2` para alcançar a máquina anfitriã pelo emulador. Não houve publicação ou alteração de produção.

## Resultado registrado

Em 20/10/2026: 155 testes/casos da API aprovados, 22 testes Flutter aprovados e 1 fluxo de integração aprovado no emulador Android API 35. O teste Android compilou e instalou o APK e verificou primeiro acesso, escolha de modo, Locker e abertura de pista sem localização com documento rico e player. A inicialização passou a aguardar seu preparo e a publicação de mudanças de rota é feita após o quadro, evitando navegação prematura e reconstrução durante a montagem do navegador.

Evidências em `docs/evidencias/`: relatório JSON e imagens de seleção de modo e Compartilhações (desktop/celular). Builds web e APK debug concluídos. A dica do modo por foco de teclado também é verificada no teste do controle global. O build Android conserva um aviso da configuração NDK preexistente, sem impedir compilação ou o teste no emulador. A análise Dart não tem erros; permanecem avisos anteriores ao trabalho.

## Seleção de localização no mapa

Criação e edição oferecem **Escolher localização no mapa**. A tela preserva o ponto atual, permite pesquisar cidade/endereço/lugar/CEP (busca existente Nominatim, Brasil), selecionar um resultado, ajustar por toque e aproximar/afastar. O botão **Satélite** utiliza a camada autenticada do Geo API. A confirmação devolve as coordenadas ao formulário; voltar cancela e não muda os campos. O banco só muda ao salvar a pista. Pesquisa e catálogo têm tempo limite e mensagem de falha; o mapa convencional segue disponível se o catálogo de satélite falhar.

Validado no navegador com pesquisa real por São Leopoldo e imagens de satélite. Dois testes de widget verificam pesquisa/retorno de coordenadas, confirmação desabilitada sem ponto, cancelamento e layout de 390×844. A suíte `test/rieonlife` passou com 14 testes. Evidência: `docs/evidencias/selecao-localizacao-satelite.jpg`.

## Visualização após salvar

Após criar uma pista, o aplicativo usa o modelo e o ID retornados pela API e substitui o formulário pela rota `/living_clues/{id}`. Após editar, abre a mesma rota e carrega os dados atualizados. Falha no salvamento mantém o formulário. Validado no navegador com criação e edição de uma pista temporária, posteriormente excluída; a suíte de 14 testes passou e o build web foi atualizado. Evidência: `docs/evidencias/visualizacao-apos-salvar.jpg`.

## Largura global

`AppPageViewport`, aplicado uma única vez ao navegador de rotas em `main.dart`, limita todas as páginas a 1040 px centralizados. Telas menores usam toda a largura disponível; os limites menores de formulários de autenticação e cartões são preservados. Fundos e faixa global permanecem em toda a janela. A MediaQuery interna reflete a largura efetiva para evitar margens duplicadas e manter grids/mapas responsivos. Aplica-se também a novas rotas, mapas e grafos. A largura das pistas referencia a mesma constante.

Três testes verificam a largura, a centralização e as margens em janelas de 1920, 1040 e 390 px; suíte total de 17 testes aprovada, análise dos arquivos alterados sem problemas e build web atualizado. Home e categorias conferidas no navegador. Evidência: `docs/evidencias/largura-global-categorias.jpg`.

## Remoção dos cadastros manuais de geografia — 20/10/2026

Removidos módulos/menu, telas, rotas, bindings, controllers, políticas, modelos e clientes de Biomas e Territórios. O aplicativo usa exclusivamente o contexto ambiental da Geo API, incluindo o bioma calculado e as camadas do mapa. Categorias, metadados livres existentes e demais dados de pistas continuam disponíveis. A API e a base local também removeram as entidades e seus vínculos por migração com backup; veja o relatório da API.

Suíte Flutter completa: 28 testes aprovados; análise sem erros (avisos legados preservados), build web atualizado e home conferida no navegador. Evidência: `docs/evidencias/home-contexto-geo-api.jpg`.

## Nome oficial

O nome oficial é **Plataforma eCOnectiva**. Corrigidos cabeçalho global, seleção de modo, boas-vindas, nome instalado/manifesto web, metadados iOS e título da janela Linux. Android, título web e home já utilizavam essa grafia. Removida a marca anterior do código executável Flutter e dos caminhos de assets; o cliente de API agora é `EconectivaApi`. Título da documentação da API e identificação do buscador de prévias também foram atualizados. Referências históricas a fontes, caminhos de backup e identificadores da infraestrutura local permanecem para rastreabilidade, sem exposição como nome da plataforma.

28 testes Flutter aprovados, análise sem erros (avisos legados), build web atualizado e marca conferida no navegador. Evidência: `docs/evidencias/plataforma-econectiva-identidade.jpg`.

## Fundo contínuo e menu ampliado

Removidos os fundos estelares/cênicos de todas as telas: apenas `AppPageViewport` desenha a composição em toda a janela. Scaffolds e barras de navegação usam superfície transparente, eliminando o corte nas bordas do conteúdo centralizado. O limite de largura continua valendo para o conteúdo.

Menu inicial ampliado: ícones de 30 px em blocos de 60 px, títulos de 20 px, descrições de 15 px e maior espaçamento. Duas colunas em desktop e uma abaixo de 700 px. A composição visual dos cartões também volta a aparecer sem a pintura do fundo local sobre a tinta do Material.

28 testes existentes e dois novos testes da home aprovados. Os novos testes verificam um único fundo ocupando toda a janela, superfície transparente, colunas responsivas e ausência de overflow em 390 e 1920 px. Análise sem erros e build web concluído. Home e categorias conferidas no navegador; imagens em `docs/evidencias/home-fundo-continuo-menu-ampliado.jpg` e `docs/evidencias/categorias-fundo-continuo.jpg`.


## Registro da entrega

Tarefa: [UU-95](https://spo-tec.atlassian.net/browse/UU-95). Branch: `UU-95-primeira-versao-plataforma-econectiva`, compartilhada com o repositório da API. Inclui os ajustes de interface aprovados durante a validação. Sem merge ou deploy de produção.

Verificação final da UU-95: suíte Flutter completa com 30 testes aprovados e análise Dart sem erros. Build web concluído. A branch contém a primeira versão consolidada e os ajustes aprovados durante a validação.


Identificação atual da plataforma: **Educação Onlife**. A alteração substitui a denominação anterior nas interfaces e metadados do aplicativo; registros históricos acima documentam as etapas anteriores.
