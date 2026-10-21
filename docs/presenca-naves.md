# Naves dos participantes

Piloto do plano https://wiki.spotec.app/index.php?curid=928. O serviço global de presença começa após autenticação e acompanha rotas, visibilidade da aba, interação recente e logout. A presença continua nas pistas, mapa, problemáticas e agentes. Diálogos, Locker e Iareté preservam a seção; áreas sem destino usam “Na plataforma” e conservam o último destino no servidor.

O cockpit recebe somente nomes reduzidos, identificadores opacos, destinos e atividades. Credenciais não atravessam o bridge. Naves leves compartilham geometrias e materiais, com posições reservadas por participante/região, interpolação suave, luzes e propulsão discretas. Rótulos fora da área segura do para-brisa ou sobrepostos são ocultados; a lista **Pessoas online** mantém acesso a todos e inclui **Você** no contador. Clicar uma identificação abre somente a lista. Não inicia chat, reunião ou voo.

Falhas de conexão exibem **Presença temporariamente indisponível**, preservando a navegação. A versão de presença é reiniciada a cada reconexão; o retrato recebido substitui informações anteriores, evitando participantes duplicados ou eventos antigos. Novas tentativas usam espera progressiva com variação. Heartbeat de 20s; sessões sem sinal expiram em aproximadamente 90–95s. Saída explícita encerra somente a sessão corrente.

As seções representam atividades genéricas, sem GPS, conteúdo em edição, pista específica ou presença no Jitsi. Uma nave por conta; várias abas são consolidadas no servidor pela interação visível mais recente. Uso prioritário no navegador. Android/iOS não foram homologados para presença e mantêm as funcionalidades existentes sem iniciar esse canal. Não há pilotagem multiplayer ou colisões.

Validação automatizada: testes do serviço Flutter (seções, autenticação, ordenação, reconexão, visibilidade, logout e indisponibilidade), suíte de regressão do app e testes Go de protocolo/hub. A validação visual usa contas sintéticas distintas em ambiente local, incluindo navegação fora do cockpit. Não utiliza registros oficiais para criar presença de teste.

Conferências desta entrega: 140 testes Flutter aprovados e análise sem erros. Na prévia web, duas contas distintas confirmaram contador, nome reduzido e atividade alterada ao abrir a listagem de pistas fora do cockpit. A lista foi conferida a 390×844, com fechamento por Esc e retorno de foco ao botão. Uma simulação adicional usou 28 identidades sintéticas, totalizando 30 participantes com as duas contas de navegador. Esse ensaio inicial não homologa uma capacidade máxima nem suporte nativo.
