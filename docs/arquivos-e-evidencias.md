# Arquivos e evidências das pistas

O envio utiliza o S3 privado por meio da API. Não há chaves AWS no app. Acesso ao anexo solicita uma URL nova à API a cada clique, com validade de cinco minutos; não é persistida no modelo ou no armazenamento local.

Na criação, usar **Salvar e adicionar arquivos**. Na edição, a seção **Arquivos e evidências** permite selecionar e enviar um arquivo, acessar anexos ou remover o vínculo. O nome selecionado permanece visível até concluir o envio. Formatos aceitos: documentos, imagens, áudio, vídeo e ZIP, até 25 MiB. Links externos continuam disponíveis.

O picker usa stream para verificar tamanho antes de acumular bytes; os bytes preparados permitem tentar o envio novamente sem depender de caminhos blob no navegador. O cliente prioriza esses bytes e envia o ID da pista no multipart. As chamadas multipart também removem o interceptor que registrava corpos de requisições.

Na visualização, **Anexos** permite baixar os arquivos mediante autenticação. A janela é reservada durante o clique para preservar o gesto em navegadores que bloqueiam janelas abertas após uma chamada assíncrona. Os mesmos controles de acesso aparecem na edição. Escrita segue o modo Inventor; Explorador pode ler.

Validação desta entrega: 122 testes Flutter passaram; `dart analyze` sem erros. A prévia com banco sintético enviou um TXT pelo seletor, baixou-o pelo S3 com hash idêntico e confirmou acesso anônimo 403. A remoção foi conferida pela interface, seguida de novo envio de demonstração. Nenhuma pista de produção foi criada ou modificada para os testes. Configuração, recuperação de versões e operação estão em `docs/arquivos-s3.md` no repositório da API.
