# Encontros com acesso integrado

O botão Encontros do cockpit fica disponível na versão web. Qualquer pessoa autenticada, em Explorador ou Inventor, pode iniciar uma sala sem outra conta ou senha do Jitsi.

Ao clicar em Entrar na sala, o app reserva uma aba durante o gesto de clique e pede à API uma autorização para aquele nome de sala. A aba só navega após a resposta válida. Falhas fecham a aba de preparação e preservam o formulário; bloqueio de pop-up não dispara um pedido de autorização. A janela não mantém referência de abertura à plataforma.

O convite copiado é sempre o endereço público sem credenciais. A autorização JWT, específica da sala e com validade curta, permanece somente na abertura privada do anfitrião. O nome e o papel vêm da API e não de parâmetros editáveis do navegador. Identidade, gravações e presença no encontro não são adicionadas às pistas nem às conversas da Iareté.

Verificação: seis testes de entrada/validação, incluindo falha de autorização, sala, origem, validade, preservação do formulário e convite limpo; suíte completa com 115 testes aprovada; análise Dart sem erros; build web de produção aprovado. O backend e o Jitsi devem ser configurados antes de disponibilizar a interface. A alteração de texto do diálogo deve ser incorporada à próxima edição do catálogo de revisão pelos pesquisadores.

Publicação em 21/10/2026: código web `b7d2a57`, release `/var/www/onlife-releases/integrations-20261021T143206Z-b7d2a57`, arquivo SHA-256 `41bde2bf2dea35b92cc843c9c3d1fbe00131f871efcee7d75fbfdb9b2ae009f2`. Manifesto, JS principal, bootstrap e bundle espacial conferidos nas duas origens públicas. Prévia principal e prévia sintética recompiladas; APIs locais mantêm bancos isolados e configuração protegida.

A API em produção usa a imagem `onlife-api:release-40380fa`; o Jitsi foi configurado para JWT e convidados sem promoção. Teste real de protocolo confirmou anfitrião moderador, convidado participante, recusa antes do anfitrião, recusa de token para outra sala existente, assinatura inválida e token assinado expirado. A rodada não homologa áudio/vídeo em dispositivos e redes diferentes. Backup e release anterior preservados; comparação das 28 tabelas sem diferenças nos registros anteriores. Sessões técnicas encerradas e serviço JVB saudável, sem conferências ou endpoints de teste ativos ao concluir.
