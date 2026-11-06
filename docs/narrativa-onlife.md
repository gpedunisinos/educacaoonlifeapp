# Narrativa da Educação OnLIFE

A grafia pública é **Educação OnLIFE**. Identificadores, rotas, URLs, chaves de armazenamento e formatos de dados conservam seus nomes técnicos para manter compatibilidade.

| Elemento | Papel |
| --- | --- |
| Expedição | Experiência de exploração da pessoa. |
| Cockpit | Ponto central de navegação da nave. |
| Terra / Mapa de Pistas | Pistas exploradas pela localização nos territórios. |
| Pistas em fluxo / sala de pesquisa | Busca no mesmo acervo, inclusive pistas sem localização; representação das pistas em um fluxo com forma de infinito e destaque da seleção. |
| Observatório / Rastros e Problemáticas | Destino exterior e ambiente interior para analisar problemáticas e relações. |
| Campo / Câmara de Inteligências | Destino exterior e sala de seleção e conversa com agentes de IA. |
| IAraeté | Parceira epistêmica da exploração, com conversa própria e orientações durante a navegação. |
| Conversa com a pista | Responde como a própria pista, apoiada nos registros e leituras disponíveis. |
| Locker | Referências guardadas durante a exploração. |
| Central de Gestão | Organização de registros e configurações administrativas. |

“Destino” é o termo geral para os elementos espaciais. “Conecte-se” orienta o acesso a um destino; ações continuam explícitas: Criar pista, Salvar, Editar, Excluir, Iniciar conversa. A metáfora espacial orienta a navegação e não altera a identidade dos conceitos da pesquisa ou os dados consultados.

As falas de abertura e tutorial, transições e descrições das salas seguem esse vocabulário. As conversas da IAraeté, dos agentes e das pistas permanecem separadas. As instruções da IAraeté na API são versionadas em `onlife-iarete-5`, com metáforas discretas e sem promessas de escrita ou ampliação de permissões.

Mensagens de erro exibem orientações compreensíveis; diagnósticos continuam nos registros técnicos. O adaptador de erros da IA preserva o reconhecimento das respostas do servidor e oculta detalhes desconhecidos.

Validação: 107 testes Flutter aprovados, análise sem erros, testes determinísticos de IA/conversa da API em banco sintético aprovados e documentação Swagger regenerada sem alteração de contrato. O benchmark Gemini anterior pertence à versão 4 do prompt; não constitui validação da versão 5. Conteúdos cadastrados e históricos não foram reescritos.
