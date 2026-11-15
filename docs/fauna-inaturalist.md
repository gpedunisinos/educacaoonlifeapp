# Fauna observada no entorno — UU-105

## Onde validar

- Abra uma pista com coordenadas → **Contexto socioambiental → Fauna observada no entorno**.
- Raio inicial 1 km, opções 500 m/5 km, até 12 espécies distintas a partir de uma amostra
  de 200 observações recentes. Nenhuma pista ou vínculo é criado.
- Fotos com crédito e licença; clique no card para data, precisão/aproximação e link original.
- No mapa: **Camadas ambientais → Fauna observada · iNaturalist**. Começa desativada em
  cada visita. Aproximar a zoom 8 ou maior e retângulo de até 3 graus por eixo.
- Até 100 observações individuais com marcador verde de pata. Toque para detalhes.
- Movimentos do mapa recarregam após 700 ms; respostas anteriores são descartadas.
- **Desativar todas** inclui a camada de fauna. Ela não altera filtros ou resultados das pistas.

## Casos a conferir

1. Alterar o raio durante o carregamento: somente a consulta atual deve ser mostrada.
2. Nenhuma observação: mensagem que não infere ausência de fauna.
3. Serviço indisponível: tentativa manual; a pista continua disponível.
4. Foto indisponível: ícone de fauna no lugar da imagem, créditos preservados.
5. Localização obscurecida: aviso explícito, sem apresentar distância como exata.
6. Ativar no mapa amplo: solicitar aproximação sem chamar a API.
7. Selecionar um marcador: detalhes e link original; desativar remove os marcadores.
8. Celular/desktop: controles, cards e diálogo sem cortar conteúdo.

Depende das branches UU-105 das APIs econectivageoapi e econectivaapi.
Após revisão: implantar Geo API, depois API principal e por último app.
Este piloto não foi publicado no site de produção. Cache/quota/contrato documentados na Geo API.
