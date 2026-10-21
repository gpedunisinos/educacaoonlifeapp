# Validação do rodapé do cockpit — 21/10/2026

Escopo: seletor Explorador/Inventor na última linha, links próximos e indicadores redundantes ocultos.

- Seis testes Node aprovados: troca de modo, espera pela persistência, recuperação após erro e posicionamento do tutorial.
- Doze testes Flutter aprovados: navegação do cockpit, preservação da cena, troca de modo, inicialização e abertura de Encontros.
- Análise do projeto sem erros; permanecem avisos e sugestões preexistentes (175 ocorrências). Análise específica de `space_view_web.dart` sem ocorrências.
- Build web release concluído para a API local em 127.0.0.1:8080. Após invalidar o cache de build de assets, o HTML/CSS do cockpit voltaram a ser incluídos e responderam HTTP 200.
- No navegador, com conta sintética em 8773: troca Explorador → Inventor confirmada, diário aberto/fechado, guia aberto/avançado/dispensado e salto completo até a Terra. Nenhuma alteração em registros reais.
- Layout conferido em 1280×720, 1024×768, 390×844 e 844×390. Em orientação horizontal baixa, a rolagem do console permite alcançar o rodapé.
- Corrigidos durante a revisão: controles superiores fora da tela no celular; ação de chegada parcialmente cortada em telas de altura reduzida; espaçamento excessivo entre modo e links no tablet. A descrição do local pode rolar e a ação permanece separada e visível.
- Versionados os endereços do HTML/CSS do cockpit para evitar reutilização da aparência anterior em cache.

A validação é funcional e visual no navegador. Não inclui avaliação auditiva humana dos sons nem teste físico em aparelhos móveis.
