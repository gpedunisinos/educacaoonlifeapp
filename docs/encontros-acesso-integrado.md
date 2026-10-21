# Encontros com acesso integrado

O botão Encontros do cockpit fica disponível na versão web. Qualquer pessoa autenticada, em Explorador ou Inventor, pode iniciar uma sala sem outra conta ou senha do Jitsi.

Ao clicar em Entrar na sala, o app reserva uma aba durante o gesto de clique e pede à API uma autorização para aquele nome de sala. A aba só navega após a resposta válida. Falhas fecham a aba de preparação e preservam o formulário; bloqueio de pop-up não dispara um pedido de autorização. A janela não mantém referência de abertura à plataforma.

O convite copiado é sempre o endereço público sem credenciais. A autorização JWT, específica da sala e com validade curta, permanece somente na abertura privada do anfitrião. O nome e o papel vêm da API e não de parâmetros editáveis do navegador. Identidade, gravações e presença no encontro não são adicionadas às pistas nem às conversas da Iareté.

Verificação: cinco testes de entrada/validação, incluindo falha de autorização, sala, origem, validade, preservação do formulário e convite limpo; suíte completa com 114 testes aprovada; análise Dart sem erros; build web de produção aprovado. O backend e o Jitsi devem ser configurados antes de disponibilizar a interface. A alteração de texto do diálogo deve ser incorporada à próxima edição do catálogo de revisão pelos pesquisadores.
