Toda a lógica de navegação, ou seja, abrir novas telas, fechar, secureBack, etc, deve estar nas screens. Ajuste isto.
Cada tela deve ter o seu controller individual. Ajuste para que funcione desta forma.
A tela lib/screens/category/category_update_screen.dart e o controller, devem receber um id de parameters do getx e com este id buscar individualmente category na API. Da forma que está agora, se eu acessar por meio de um link direto da web vai quebrar o projeto. Ajuste para que seja desta forma.
Todas as operações que chamam a API devem ter algum loading visível. Adicione isto.
