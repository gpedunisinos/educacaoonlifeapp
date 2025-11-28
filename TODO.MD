Implemente todos estes cruds criando os arquivos que a estrutura do projeto atual preve


2. Entidade: LivingClue (Pista Viva)
A entidade principal (o Nó do grafo). Representa tanto humanos quanto não-humanos.
CRUD LivingClue
id: Tipo uint, Chave Primária, Auto-incremento.
name: Tipo string, Max 255, Obrigatório. Nome da entidade (ex: "Dr. Rodrigo" ou "Rio dos Sinos").
category_id: Tipo uint, Obrigatório. Chave Estrangeira para Category.
description: Tipo text, Opcional. Resumo ou biografia da pista.
latitude: Tipo float64 (double), Obrigatório. Coordenada geográfica.
longitude: Tipo float64 (double), Obrigatório. Coordenada geográfica.
image_url: Tipo string, Opcional. URL de uma foto de capa/avatar para o nó.
metadata: Tipo json, Opcional.
Objetivo: Armazenar dados específicos que variam por categoria sem criar novas tabelas.
Exemplo para Pesquisador: {"lattes": "http://...", "titulacao": "Doutor"}
Exemplo para Rio: {"extensao_km": 200, "nivel_poluicao": "alto"}
is_active: Tipo bool, Default true. Para "soft delete" ou aprovação de cadastro.
3. Entidade: ConnectionType (Tipo de Conexão)
Define a semântica da relação (o verbo).
CRUD ConnectionType
id: Tipo uint, Chave Primária, Auto-incremento.
name: Tipo string, Max 100, Obrigatório. O verbo ou nome da relação (ex: "Monitora", "Habita", "Financia", "Contamina").
stroke_style: Tipo string, Default "solid". Define como a linha aparece no Flutter (ex: solid, dashed, dotted).
is_directional: Tipo bool, Default true. Define se a seta tem ponta (A afeta B) ou se é mútua (A é colega de B).
4. Entidade: ClueConnection (Conexão)
A tabela associativa que cria as arestas do grafo (Edge List).
CRUD ClueConnection
id: Tipo uint, Chave Primária, Auto-incremento.
source_clue_id: Tipo uint, Obrigatório. FK para LivingClue (Origem da seta).
target_clue_id: Tipo uint, Obrigatório. FK para LivingClue (Destino da seta).
connection_type_id: Tipo uint, Obrigatório. FK para ConnectionType.
strength: Tipo int, Default 1. Peso da conexão (usado na visualização D3/ForceGraph para atrair os nós mais fortes para perto).
evidence: Tipo text, Opcional. Campo de texto para justificar a conexão (ex: "Link para o artigo que prova essa relação").
Constraint: Deve existir um índice composto ou verificação no código para evitar duplicidade exata (A -> B do tipo X) repetida.
5. Entidade: Attachment (Biblioteca/Anexo)
Realiza o conceito de "Biblioteca Viva", permitindo anexar arquivos às pistas.
CRUD Attachment
id: Tipo uint, Chave Primária, Auto-incremento.
living_clue_id: Tipo uint, Obrigatório. FK para LivingClue.
title: Tipo string, Max 255, Obrigatório. Nome amigável do arquivo.
file_type: Tipo string, Max 50, Obrigatório. Ex: pdf, audio, video, link.
url: Tipo text, Obrigatório. Caminho do arquivo no S3/MinIO ou link externo.
created_at: Tipo datetime.

nome_social_alcunha,instituicao_vinculo,genero,minibio,instituicao_vinculo,nivel_formacao,link_lattes

Crie uma nova tela para ser aberta antes de lib/screens/living_clue/living_clue_create_screen.dart. Esta tela deve conter apenas o seletor category. Uma vez selecionado, o id do seletor é enviado para a próxima tela. Deve ser bucado na api para então utilizar o campo metadataTags a fim de renderizar os campos metadata. Os campos serão todos opcionais tipo texto. Ao salvar, estes campos devem ser colocados em metadata para serem persistidos na API. Na tela lib/screens/living_clue/living_clue_create_screen.dart o campo category deve ser somente leitura.
Faça a mesma renderização para a tela lib/screens/living_clue/living_clue_update_screen.dart em que o campo caetgory também é somente leitura e os campos de metadata são renderizados.

Deixei a tela mais bonita lib/screens/living_clue/living_clue_show_screen.dart

Deixe todas as telas, com exceção da lib/screens/home_screen.dart, e lib/screens/living_clue/living_clue_show_screen.dart que já foram feitas, mais bonitas.

Considere a API https://api.uniusp.gpedu.com.br/api/swagger/doc.json, implemente o envio e visualização de arquivos nas telas que forem apropriadas. Implemente um perview destes links utilizando algum componente.
