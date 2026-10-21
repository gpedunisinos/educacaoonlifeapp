# Publicação — 21/10/2026

Publicação autorizada do app e da API na infraestrutura existente, sem alterar Apache, Geo API ou Jitsi.

- App: código `64e1a00`, build release para `https://api.uniusp.gpedu.com.br`, sem service worker novo, encontros mantendo o padrão desabilitado. Release `/var/www/onlife-releases/integrations-20261021T135939Z-64e1a00`; arquivo SHA-256 `7a43cd17713348a55254b76168cb534d67b35f4487e815e1c5b913ba7e5c25ea`. Anterior `integrations-20261021T072136Z-5d08f8a` preservada.
- API: código `c203aca`, imagem `onlife-api:release-c203aca`, revisão OCI completa conferida. Recriado somente o serviço da API, preservando volumes e configurações. Imagem anterior `onlife-api:integrations-4df9141` mantida. Referências `API_IMAGE` e `APP_REVISION` atualizadas no ambiente protegido para persistir em próximas inicializações.
- Backup privado no servidor: `/home/ubuntu/backups/onlife-integrations-20261021T135657Z`, incluindo banco, armazenamento, configurações e estado anterior. Comparação de preservação nas 28 tabelas antes/depois sem registros anteriores removidos ou modificados; nenhum dado restaurado ou apagado.
- Validação: suíte Flutter de 112 testes aprovada no checkpoint publicado; análise sem erros. Todos os pacotes Go testados novamente em banco sintético exclusivo. API pública: status, política e documentação HTTP 200; MCP sem autenticação HTTP 401. Nos dois domínios do frontend, manifesto da revisão e SHA-256 de `main.dart.js`, bundle espacial e bootstrap conferidos contra o build local.

Esta publicação não equivale a nova homologação de mídia, dispositivos ou integrações externas. Permanecem os limites registrados em `validacao-integracoes-2026-10-21.md`. A conferência visual automatizada do tutorial continua limitada pela indisponibilidade do controle do navegador, conforme entrega anterior.

## Reversão

App: apontar `/var/www/usp_app` novamente para a release anterior preservada, com troca atômica do link. Os registros privados de publicação ficam em `/home/ubuntu/backups/onlife-web-releases`.

API: recuperar somente as referências anteriores de imagem/revisão no ambiente protegido e recriar apenas `unisinos_usp_api_go` com `docker compose up -d --no-deps --no-build unisinos_usp_api_go`. Não restaurar banco ou armazenamento automaticamente. O backup contém o ambiente anterior para consulta privada.
