# Integração de agentes com pistas

A criação e a edição de pistas oferecem o card **Agente da plataforma**. A busca consulta os agentes cadastrados por nome ou descrição, com paginação de 20 itens, espera curta durante digitação e descarte de respostas antigas. Há estados de carregamento, lista vazia e nova tentativa em caso de falha.

Selecionar um agente adiciona um card abaixo do editor. **Trocar agente** substitui o vínculo; **Desvincular agente** remove apenas essa referência da pista. Nenhuma dessas ações exclui o cadastro do agente ou seu histórico. Adicionar o vínculo não substitui o texto selecionado na descrição.

O Delta armazena um bloco `onlife` de versão 1, provedor `agent`, URL interna canônica `/space/agents/ID` e o nome escolhido como título. Os demais blocos de texto, vídeo e integrações são preservados. A referência não é um iframe ou um endereço externo.

Na leitura da pista, **Conectar-se ao agente** abre sua conversa na Câmara de Inteligências. A conversa consulta o agente atual pelo ID, inclusive fora das primeiras páginas da listagem, e oferece **Voltar à pista**. Usa as permissões e o histórico privado por usuário já existentes. Não envia mensagens, instruções, arquivos ou conversas automaticamente para a pista ou para a Iareté.

Se um agente for removido posteriormente, a pista preserva a referência e pode ser editada normalmente; abrir a conversa informa a indisponibilidade. Não há associação física por chave estrangeira que apague conteúdo da pista.

Validação: 130 testes Flutter na suíte completa, além dos contratos e testes de persistência da API em banco sintético. O fluxo de busca, vínculo e salvamento foi validado na pista de demonstração da prévia. Os registros de produção não são usados para criar vínculos de teste.
