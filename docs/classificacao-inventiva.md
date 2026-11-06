# Práticas e metodologias nas pistas

Catálogo local revisado em 21/10/2026 contra o documento dos pesquisadores:
https://docs.google.com/document/d/1vim56rGs0j5d2ZVtASM6xB9rrGahDg2MUo-2kkhraBo/edit

Plano: https://wiki.spotec.app/index.php?title=Plataforma_Educa%C3%A7%C3%A3o_Onlife_-_Classifica%C3%A7%C3%A3o_de_pr%C3%A1ticas_e_metodologias_inventivas_nas_pistas

Os campos são opcionais, independentes e de múltipla seleção. O catálogo tem dez práticas e três metodologias. Os resumos são apresentações breves, sem roteiros de aplicação inferidos. MUP-ERG, CHE, RuPu e EsC-Traces recebem apresentação bibliográfica. Relicário Ecológico não é uma opção, pois está em desenvolvimento no documento-base.

## Contrato

`metadata.praticas_inventivas` e `metadata.metodologias_inventivas` armazenam arrays de códigos estáveis. Ausência ou null significa nenhuma seleção; remoção explícita salva `[]`. Campos desconhecidos, listas genéricas e classificações desconhecidas são preservados. Valores antigos que não sejam arrays de strings são apresentados como registros legados e só removidos explicitamente. A edição copia os metadados carregados e altera somente os campos editados.

O mesmo mapa, incluindo arrays, é fornecido no rascunho da Iareté. Nenhuma mudança de prompts ou classificação automática foi introduzida. A descrição Quill e suas integrações seguem seu fluxo existente.

## Habilitação

A categoria habilita cada seletor incluindo `praticas_inventivas` e/ou `metodologias_inventivas` no CSV `metadata_tags`. Os componentes não dependem de IDs ou do nome da categoria. Classificações existentes continuam visíveis/editáveis se a configuração for removida.

A API contém `deploy/enable-inventive-classifications.py`, que configura a categoria existente **Vivência de Cidadania Digital**, preservando suas tags atuais. É uma operação explícita, idempotente, com dry run e proteção contra alteração concorrente; não modifica pistas. Não há novas tabelas, colunas ou preenchimento automático de pistas antigas.

## Compatibilidade

Clientes antigos podem converter metadados em texto ou omitir chaves na edição. O PUT da API continua aceitando dados legados e substituindo o mapa recebido, para manter o contrato existente. Portanto, editar classificações exige o cliente atualizado; não foi criado bloqueio global de versões antigas. Clientes externos devem realizar leitura/mesclagem antes do PUT.

## Validação

Testes Flutter cobrem catálogo, preservação de JSON, valores desconhecidos/legados, confirmação/cancelamento/limpeza e leitura pelo Explorador. Testes HTTP da API comprovam persistência e reabertura dos arrays, edição/limpeza, permissões, valores legados e preservação da descrição com integração, com e sem coordenadas. A validação interativa utiliza apenas registros sintéticos em banco isolado.
