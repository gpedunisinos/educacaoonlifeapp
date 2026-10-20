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

O voo dura cerca de 4,5 segundos e pode ser pulado; movimento reduzido conclui a aproximação imediatamente. O mapa não é desenhado no para-brisa. A cena fica pausada e oculta enquanto o Flutter apresenta outro módulo ou o painel do assistente; ao retornar, a cena e o áudio retomam. Na web, a visibilidade é acompanhada dentro do iframe: mudança de foco entre Flutter e HTML não deve ocultar a nave.

As falas de boas-vindas e navegação são textos locais de orientação; **Conversar com Iareté** abre o assistente real, com contexto do cockpit. Não há voz sintetizada nesta etapa. Diário limitado a 30 entradas por sessão. Não há simulação física nem pilotagem livre.

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
