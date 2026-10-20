# Experiência espacial eCOnectiva — UU-95

Demonstração implementada na branch `UU-95-primeira-versao-plataforma-econectiva`.
Entrada: Home → **Entre na nave eCOnectiva**. Rota autenticada: `/space`.

## Percurso de validação

1. Entrar na nave e iniciar a expedição, com ou sem áudio.
2. Navegar até a Terra; observar aproximação, motor e mensagem de chegada.
3. Abrir o Mapa de Pistas real, em toda a largura; usar **Voltar à nave** no canto superior esquerdo. A posição e o destino devem permanecer.
4. Selecionar Pesquisa, Observatório, Conexões e Inteligências. Navegar ou usar acesso direto. Os módulos mantêm suas permissões existentes.
5. Abrir Iareté pelo console e fechar seu painel; conferir retomada da cena.
6. Abrir o diário de bordo, desligar som, ativar movimento reduzido e pular uma viagem.
7. Conferir desktop, celular em retrato/paisagem e navegação por teclado (Tab, Enter, 1–5).

## Arquitetura

- `lib/screens/space/space_screen.dart`: roteamento, autorização por políticas existentes e contexto do assistente. Não há credenciais ou chamadas de API no JavaScript.
- `space_view_web.dart`: iframe de mesma origem, mensagens filtradas por origem, janela e canal. O Flutter mantém a sessão e abre apenas destinos reconhecidos.
- `space_view_native.dart`: WebView para Android/iOS/macOS, carregando assets locais. Windows/Linux nativos exibem orientação para usar a versão web.
- `assets/space/space.js`: Three.js, Terra, estações procedurais, movimento assistido, mensagens, diário e controles.
- `assets/space/audio.js`: ambiência harmônica, propulsão e sinais polifônicos de digitação, seleção, partida e chegada. Áudio sintetizado, sem gravações externas; inicia após interação.
- `space.bundle.js`: bundle clássico, sem imports em tempo de execução, para compatibilidade com assets locais na WebView.
- `AppPageViewport`: cena e mapa usam toda a largura, preservando a árvore de navegação ao trocar de rota.

O salto dura cerca de 5,2 segundos e pode ser pulado; movimento reduzido conclui a aproximação imediatamente. O mapa não é desenhado no para-brisa. A cena fica pausada e oculta enquanto o Flutter apresenta outro módulo ou o painel do assistente; ao retornar, a cena e o áudio retomam. Na web, a visibilidade é acompanhada dentro do iframe: mudança de foco entre Flutter e HTML não deve ocultar a nave.

As falas de boas-vindas e navegação são textos locais de orientação; **Conversar com Iareté** abre o assistente real, com contexto do cockpit. Não há voz sintetizada nesta etapa. Diário limitado a 30 entradas por sessão. A nave percorre uma rota contínua em piloto automático; após a chegada mantém uma órbita de observação. Não há pilotagem livre.

## Build dos assets

Após alterar JavaScript:

```sh
npx --yes esbuild@0.25.12 assets/space/space.js --bundle --minify --format=iife --outfile=assets/space/space.bundle.js
```

O bundle e os recursos são versionados. A cena não depende de CDN. O mapa e a IA continuam precisando dos serviços usuais da plataforma.

Para visualizar somente a cena, sem autenticação ou módulos reais:

```sh
python3 -m http.server 8766 --bind 127.0.0.1 --directory assets/space
```

## Fontes e licenças

- Three.js e Space Grotesk reaproveitados do explorador em `/var/www/html/rieonlife-site/explorer`, preservando MIT e SIL OFL junto aos arquivos.
- Textura da Terra: NASA Earth Observatory, Blue Marble, `https://eoimages.gsfc.nasa.gov/images/imagerecords/57000/57730/land_ocean_ice_2048.png`.
- Cockpit, estações e áudio: implementação procedural desta demonstração. Não há trilhas comerciais.

## Validação

- Build Flutter Web local com API em `127.0.0.1:8080`.
- Suíte Flutter, incluindo testes de mensagens permitidas, pausa/retorno, foco do iframe e largura sem substituição do estado.
- Inspeção visual da cena e dos controles em desktop e celular no navegador.
- Android/iOS/macOS: adaptador incluído, mas validação em dispositivo físico ainda pendente. Não assumir desempenho nativo a partir dos resultados web.
- Sem deploy de produção ou merge.

### Resultado da rodada local

- 32 testes Flutter aprovados.
- Análise Dart sem erros; permanecem avisos legados fora desta alteração.
- Build web concluído. A prévia local foi construída com `--pwa-strategy=none` para evitar cache de versões durante a avaliação.
- Confirmados no navegador: login → home → nave → mapa real → retorno à mesma cena; abertura/fechamento da Iareté; aproximação da Terra e de estação; movimento reduzido e diário de bordo.
- Evidência visual: `space-cockpit.jpg`.
- Jira: o CLI instalado oferece get/search/update/create-issue/list-projects, mas não comentários ou transições. Nenhum comentário ou alteração de status foi realizado; revisão humana pendente.

## Revisão da experiência — cruzeiro e cockpit físico

- Cruzeiro contínuo com trajetória elíptica e partículas próximas que reforçam o deslocamento. Selecionar um destino não interrompe o voo; Navegar inicia o salto.
- Salto em três etapas: carga/alinhamento (3,6 s), salto com rastros estelares, campo de visão ampliado e áudio (2,4 s), desaceleração (1,2 s). Pular viagem e movimento reduzido continuam disponíveis.
- Cabine construída em geometria 3D presa à câmera: montantes, travessas, painel físico, parafusos e iluminação local. Console integrado ao painel e instrumentos laterais.
- Abertura de módulos com sequência de aproximadamente 1,9 s: recolhimento do console, aproximação visual e tela de transferência. Mapa usa fade de 900 ms. Movimento reduzido encurta a transferência e suprime deslocamentos.
- Retorno restaura a cabine e a órbita, sem repetir a entrada.

### Seleção sem alterar o voo

A entrada já começa em cruzeiro no espaço, inclusive antes de iniciar a expedição. Terra e estações ficam ocultas até o primeiro salto. Partículas próximas têm velocidades variadas; movimento reduzido mantém a cena estática.
Selecionar um destino altera somente o planejamento: a nave continua em sua órbita atual. Só o botão Navegar inicia alinhamento e salto. Selecionar novamente o local atual oferece Abrir módulo, sem um salto redundante.

Validação desta revisão no navegador: abertura sem corpos celestes; salto até a Terra; seleção de Pesquisa mantendo a Terra visível e a órbita ativa; salto até Pesquisa somente ao navegar; reseleção do local atual oferecendo Abrir Pistas. Bundle regenerado e análise Dart sem erros (avisos legados permanecem). Evidência da abertura: `space-cruise.jpg`.

### Alinhamento suave antes do salto

A virada interpola a orientação da câmera por quaternion com curva quintic smootherstep, partindo da orientação efetivamente exibida. Isso evita que a distância entre os alvos concentre a rotação no início. O alinhamento dura 3,6 s, com aceleração e desaceleração progressivas; carga sonora, partículas e início do salto usam os mesmos tempos. Validado no navegador em cruzeiro → Terra e Terra → Pesquisa. Bundle regenerado; análise Dart sem erros, com avisos legados.

### Cabine fechada e opaca

Casco contínuo nas laterais, teto e base, dimensionado para cobrir também o campo de visão máximo do salto. Painéis com camadas de revestimento, telas de instrumentação, interruptores, nervuras e luminárias embutidas. Console com fundo opaco. O brilho CSS sobre a tela foi removido para que não atravesse visualmente a estrutura; os rastros 3D permanecem atrás do casco.

Validação visual em desktop e largura móvel, incluindo salto Terra → Pesquisa com lente aberta: as bordas mostram a cabine, sem vãos para o espaço. Bundle regenerado e análise Dart sem erros, com avisos legados. Evidências: `space-solid-cockpit.jpg` e `space-solid-warp.jpg`.

### Experimento de cockpit envolvente a partir da referência

Base anterior preservada no commit `d2aacfb`, já publicado antes desta experiência. Nova cabine construída em geometria própria: para-brisa trapezoidal, montantes diagonais, placas extrudadas com chanfros, trilhos luminosos, fixadores, consoles inclinados e pedestal central. Instrumentos laterais e mesa holográfica em SVG/CSS; são elementos ilustrativos da demonstração, sem telemetria real. A imagem de referência não foi incorporada como asset.

O painel de controles foi compactado em telas maiores para liberar a vista; instrumentos decorativos são ocultados em telas estreitas ou muito baixas. Verificados no navegador: composição desktop e móvel, salto com campo de visão ampliado e chegada à Terra. Análise Dart sem erros (avisos legados permanecem), bundle regenerado. Evidências: `space-wraparound-cockpit.jpg` e `space-wraparound-warp.jpg`. Toda esta experiência foi isolada em um commit para permitir reversão com git revert.

### Salto com enquadramento fixo

Removida a variação de campo de visão durante o salto. A câmera permanece em 48 graus, preservando o tamanho e a posição aparente da cabine. Permanecem o alinhamento suave, deslocamento até o destino, rastros estelares no para-brisa e sons. Verificado no navegador durante o salto e chegada à Terra; análise Dart sem erros (avisos legados permanecem). Evidência: `space-fixed-framing-warp.jpg`.

### Painel interativo do local visitado

O instrumento à esquerda apresenta nome, setor, descrição e conteúdos do último destino alcançado, com botão de acesso ao módulo. Textos provisórios estão nos campos `description` e `contents` de cada destino, sem números ou contagens simuladas. Antes da primeira chegada, apresenta Espaço aberto. Selecionar outro destino mantém o local visitado; durante o salto o botão fica desabilitado. O acesso do painel usa o destino efetivamente visitado, independentemente do selecionado no console.

Validado no navegador: chegada à Terra, seleção de Pesquisa sem alterar o painel, abertura do mapa pelo painel, retorno à nave e chegada à Pesquisa com atualização do conteúdo. Bundle regenerado; análise Dart sem erros, com avisos legados. Evidência: `space-local-panel.jpg`.

### Transição do painel e câmera independente do mouse

Ao chegar a outro local, o conteúdo do painel esquerdo apaga em 180 ms e o novo aparece em 520 ms com deslocamento leve. Atualizações de estado do mesmo local não repetem a animação. Transições anteriores são canceladas quando substituídas, e movimento reduzido atualiza diretamente. Removidos o listener de pointermove e o deslocamento visual adicional da câmera: sua orientação agora segue somente o voo e as manobras.

Validada no navegador a troca Terra → Pesquisa e a atualização direta em movimento reduzido. Análise Dart sem erros, com avisos legados; bundle regenerado. Evidência: `space-panel-transition.jpg`.

### Mapa da expedição no painel direito

Substitui sensores decorativos por mapa SVG dos destinos permitidos, projetados a partir das posições X/Z da cena. O ponto dourado indica a nave: em espaço aberto antes da primeira chegada, no destino visitado após chegar, e em deslocamento pela rota tracejada durante o salto. Selecionar outro destino destaca seu ponto sem mover a nave. O texto do local e a descrição acessível do mapa acompanham o estado do voo. É um mapa esquemático, não um mapa geográfico.

Validado no navegador: marcador na Terra antes e depois de selecionar Pesquisa, posição intermediária durante o salto e chegada ao ponto de Pesquisa. Análise Dart sem erros (avisos legados permanecem), bundle regenerado. Evidência: `space-expedition-map.jpg`.

### Canopy panorâmico de vidro com reforços sobre o espaço

Substituídas as chapas laterais amplas por vidros transparentes com leve tonalidade e casco restrito ao contorno. Dois montantes diagonais foram deslocados para dentro da vista, criando janelas frontal e laterais pelas quais se vê o mesmo espaço e os mesmos destinos. Fixadores, trilhos luminosos e colares acompanham os reforços. Painéis de local e mapa passam para a parte inferior; o console fica mais compacto e o radar próximo à base. Telas mais baixas ajustam a posição dos instrumentos para manter os controles disponíveis.

Validado no navegador: cruzeiro, Terra visível além dos montantes, salto até Pesquisa e composição em tela mais baixa. Câmera mantém enquadramento fixo e não responde ao mouse. Análise Dart sem erros (avisos legados permanecem); bundle regenerado. Evidência: `space-panoramic-canopy.jpg`.

### Painel local ampliado e acesso com brilho pulsante

Painel esquerdo ampliado de 17% para 23% da largura em desktop, com título, descrição, conteúdos e botão maiores. Botão disponível recebe pulso suave de brilho (sem alterar escala); durante viagem fica desabilitado e o brilho para. Movimento reduzido mantém destaque estático. Após chegar, o acesso ao módulo fica somente no painel local: a área redundante de acesso junto à Iareté é recolhida. Selecionar outro destino restaura Navegar no console. Painel local passa a estar disponível também em telas estreitas após a chegada.

Validado no navegador: chegada à Terra com acesso único, abertura do mapa em largura móvel, retorno preservando posição, seleção de Pesquisa com Navegar disponível e reseleção da Terra. Análise Dart sem erros, com avisos legados; bundle regenerado. Evidência: `space-large-local-panel.jpg`.

### Piloto: sala de Conexões no interior da nave

A estação de Conexões agora abre `/space/connections`, um ambiente Flutter com paredes, iluminação, piso em perspectiva, mesa central e um monitor de parede interativo. A interface permite consultar conexões reais, pesquisar por pistas, tipo ou evidência, selecionar detalhes e atualizar a lista. Em telas estreitas, os detalhes abrem em um painel sobre a própria sala. Este piloto é de consulta; não inclui criação, edição ou exclusão dentro da sala.

Reutiliza os webclients autenticados e a política de visualização de Conexões. Tem estados explícitos de carregamento, falha com nova tentativa, lista vazia e busca sem resultados. A Iareté recebe contexto da sala, busca e seleção. A nave continua pausada e preservada ao entrar pela estação; Voltar ao cockpit retoma a mesma cena. Acesso direto à URL sem histórico retorna a `/space`. Transições respeitam movimento reduzido.

Validação: 5 testes de widget aprovados cobrindo busca, seleção de detalhes, falha/nova tentativa/lista vazia, detalhes móveis, ponte cockpit → sala → cockpit e viewport imersivo. Build web concluído; análise Dart sem erros, com avisos legados. Navegador: 14 conexões reais carregadas; busca CVV retornou 5 itens; detalhes em desktop e celular; retorno ao cockpit; entrada pelo painel da Estação de Conexões. Evidência: `space-connections-room.jpg`.

### Fade do resumo superior de destino

Nome, descrição e setor do destino agora apagam juntos em 180 ms antes da atualização e reaparecem em 500 ms com deslocamento discreto. Trocas rápidas cancelam a transição anterior e mantêm a última seleção. Movimento reduzido atualiza os dados imediatamente, inclusive ao ser ativado durante um fade. A seleção da rota continua imediata e independente da animação visual.

Validado no navegador: Terra → Pesquisa, sequência rápida Observatório → Terra → Observatório e ativação de movimento reduzido durante a troca para Pesquisa. Bundle regenerado; análise Dart sem erros, com avisos legados. Evidência: `space-destination-fade.jpg`.
