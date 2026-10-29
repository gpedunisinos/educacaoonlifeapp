# Publicação web da Educação Onlife

## Build obrigatório

Usar o comando de produção do README, com `--no-tree-shake-icons`, `--pwa-strategy=none` e API oficial. Não publicar um build local configurado para `127.0.0.1`.

A opção `--no-tree-shake-icons` mantém as fontes completas. Parte dos ícones é selecionada dinamicamente pelos componentes compartilhados e pode desaparecer quando o Flutter reduz as fontes. `--pwa-strategy=none` evita gerar uma nova estratégia de cache PWA que mantenha arquivos de versões diferentes. A remoção do service worker Flutter legado já existe em `web/index.html`; preservar o worker específico de notificações Firebase.

A pipeline contém os parâmetros, mas builds manuais não os herdam automaticamente. Não usar o comando simples `flutter build web --release` para publicação.

## Preparação e publicação

1. Conferir revisão, alterações locais, ambiente/API e funcionalidades incluídas. Coordenar com outras sessões; usar saída isolada se necessário.
2. Gerar o pacote completo com o comando de produção do README.
3. Conferir `assets/FontManifest.json` e as fontes referenciadas. Na versão do SDK verificada em 21/10/2026, MaterialIcons completa tem 1.645.184 bytes e CupertinoIcons tem 257.628 bytes. Esses tamanhos são referência dessa versão, não valores universais para outros SDKs.
4. Confirmar que o build não anunciou redução dessas fontes por tree shaking.
5. Publicar com `scripts/deploy-web-release.py`, informando a revisão efetiva do artefato. O script valida tamanhos mínimos das fontes e preserva a versão anterior. Conferir a proteção existente no script ao atualizar o SDK; não remover a verificação apenas para aceitar um build reduzido.
6. O publicador mantém releases em `/var/www/onlife-releases`, muda o link `/var/www/usp_app` e registra a publicação em `/home/ubuntu/backups/onlife-web-releases`. Usar esse fluxo nas publicações manuais, sem apagar previamente o diretório oficial.

## Conferência após publicar

Verificar os dois domínios:

- https://plataforma.atopos.spotec.app/
- https://educacaoonlife.gpedu.com.br/

Conferir `onlife-release.json` e comparar o SHA-256 das duas fontes servidas com os arquivos do artefato validado:

- `/assets/fonts/MaterialIcons-Regular.otf`
- `/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf`

Um HTTP 200 sozinho não comprova o arquivo correto: verificar o conteúdo e o hash. Conferir visualmente ícones em uma sessão nova e em uma sessão existente após `Ctrl + Shift + R`. Se persistir cache antigo, testar janela privativa e investigar o service worker legado, sem apagar indiscriminadamente os dados do usuário.

Se houver falha, restaurar o link para a release anterior registrada no manifesto. Não restaurar banco nem API para corrigir somente arquivos do frontend.

## Ocorrência de 21/10/2026

O build manual publicado sem `--no-tree-shake-icons` continha MaterialIcons de 28.660 bytes, com 226 símbolos, e CupertinoIcons de 1.472 bytes. A configuração da pipeline já previa a opção; a divergência estava no build manual.

Foi executado build isolado com as fontes completas. Para preservar o código da release oficial e o trabalho simultâneo de outra sessão, foi republicada uma cópia do pacote oficial substituindo somente as duas fontes. O JavaScript da aplicação permaneceu idêntico. A release anterior foi mantida e os hashes das fontes completas foram conferidos nos dois domínios.

Essa recuperação pontual não substitui o fluxo normal: os próximos builds devem gerar o pacote completo com os parâmetros obrigatórios. O script de publicação também passou a conter proteção contra fontes reduzidas; manter essa proteção.
