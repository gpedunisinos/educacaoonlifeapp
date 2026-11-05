# Denúncia e bloqueio de conversas

O aplicativo envia as solicitações abaixo com a autenticação habitual. A API informa o estado na lista de conversas em `blocked` e `blocked_by_me`.

## Denúncias

`POST /api/me/conversations/{id}/report`

```json
{}
```

O campo `description` é opcional. A API registra uma denúncia da conversa; não recebe um ID de mensagem. A interface comunica essa abrangência ao usuário.

## Bloqueios

`POST /api/me/conversations/{id}/block`

`DELETE /api/me/conversations/{id}/block` desfaz o bloqueio. Ambos os participantes ficam impedidos de enviar mensagens enquanto a conversa estiver bloqueada. O participante bloqueado também não pode consultar mensagens. Essa API bloqueia a conversa, não garante bloqueio global do usuário em outras áreas do aplicativo.

A adequação à diretriz da Apple também depende de filtragem de conteúdo impróprio, canal de contato publicado e processo operacional de análise e resposta às denúncias. Os controles do aplicativo isoladamente não completam esses requisitos.
