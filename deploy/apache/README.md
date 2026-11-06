# Domínio web Educação OnLIFE

Domínio canônico: https://educacaoonlife.gpedu.com.br.
API permanece em https://api.uniusp.gpedu.com.br/api.

O virtual host usa o mesmo symlink de releases `/var/www/usp_app`. Emitir o certificado com o virtual host HTTP ativo antes de ativar o bloco TLS:

```
sudo certbot certonly --webroot -w /var/www/usp_app -d educacaoonlife.gpedu.com.br
sudo apache2ctl configtest && sudo systemctl reload apache2
```

O domínio anterior `web.uniusp.gpedu.com.br` redireciona com HTTP 301, preservando caminho e query; o navegador preserva o fragmento das rotas Flutter. Manter seu certificado e a exceção HTTP de `/.well-known/acme-challenge/` para renovação.

No Google Cloud Console, adicionar a origem JavaScript autorizada `https://educacaoonlife.gpedu.com.br` no cliente OAuth web. Se houver Firebase Authentication, adicionar também o hostname em Authorized domains. Não alterar o callback Firebase existente sem mudar a configuração de autenticação. As sessões salvas no domínio anterior não migram entre origens: poderá ser necessário entrar novamente.
