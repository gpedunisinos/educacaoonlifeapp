# Problemáticas nas pistas

Na criação e edição, o card **Problemática** permite buscar registros por nome ou código, em páginas de 20 itens. Selecionar um resultado adiciona a referência abaixo do editor. É possível vincular mais de uma problemática, trocar cada vínculo ou desvinculá-lo, sem excluir o nodo nem substituir texto da descrição.

O conteúdo utiliza um bloco `onlife` de versão 1, provedor `node`, título e URL interna `/nodes/graph?focus=ID`. Outros blocos de texto, agentes, vídeos e integrações continuam preservados ao salvar e reabrir.

Na leitura, **Conectar-se à problemática** abre a Sala de Problemáticas com o nodo selecionado e suas relações destacadas. **Voltar à pista** retorna ao registro de origem. A sala preserva os controles, filtros e permissões existentes. Se o nodo foi removido, a sala informa a indisponibilidade, mantendo o vínculo editável na pista.

A referência serve para navegação; não cadastra automaticamente uma conexão entre nodos e não consulta o vínculo como uma fonte externa da Iareté.

Validação: suíte completa com 136 testes Flutter, análise sem erros e testes de persistência/contratos da API em banco isolado. Inclui busca com paginação, falha e nova tentativa, respostas fora de ordem, preservação de texto ao vincular, troca, remoção e retorno da sala para a pista.
