# Chat entre participantes da expedição

Clicar no corpo de uma nave ou em seu rótulo abre a identificação: primeiro nome reduzido, atividade genérica e região. A lista **Pessoas online** também oferece **Ver identificação** para participantes fora do campo visual. **Abrir chat** abre uma conversa privada; a ação não envia mensagem automaticamente nem move a nave.

O botão **Conversas** no cockpit mantém acesso ao histórico e mostra a quantidade de mensagens não lidas. Nas demais telas há um atalho no cabeçalho. O painel segue os materiais escuros e iluminação ciano da plataforma. Permite texto simples, seleção de emojis, Enter para enviar, Shift+Enter para nova linha e cópia de texto. Não inclui arquivos, chamadas ou conteúdo de IA.

Cada par de contas tem uma conversa única, persistida na API. O histórico usa páginas de 30 mensagens. Reabrir uma conversa ou reconectar recompõe seu conteúdo; conversas existentes podem continuar mesmo com o destinatário fora do espaço. Novas tentativas reutilizam o identificador do envio para impedir duplicação. O rascunho fica no app durante falhas, sem ser gravado em preferências; logout limpa o estado privado.

A presença recebe somente notificações privadas com o identificador da conversa. Texto e histórico são buscados na API autenticada e não atravessam o bridge da cena. Não são incluídos no contexto da Iareté. A API verifica as duas contas em cada acesso; terceiros não veem ou enviam mensagens naquela conversa.

Validação: 142 testes Flutter aprovados, suíte completa da API em banco isolado e detector de corrida do hub. Testes novos cobrem texto/emojis, preservação de rascunho em falha, repetição sem duplicação, limpeza no logout e layout de celular com área de teclado. No navegador, duas contas sintéticas distintas confirmaram identificação, abertura, envio/recebimento nos dois sentidos e aviso de não lidas. Nenhum registro oficial foi usado para enviar mensagens de teste.

Publicação: usar `flutter build web --release --no-web-resources-cdn --no-tree-shake-icons` com as definições de ambiente correspondentes. A versão preserva as fontes completas de ícones já corrigidas em produção; o publicador verifica essas fontes antes de trocar a versão ativa. Essa verificação evita sobrescrever a correção com um build que reduziu os ícones usados dinamicamente.
