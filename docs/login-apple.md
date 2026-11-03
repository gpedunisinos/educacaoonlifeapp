# Login com Apple

O aplicativo usa o componente AppleLoginButton compartilhado com o EFV. No iOS, ele solicita nome e e-mail à Apple e envia o token de identidade à API:

`POST /login/apple`

```json
{"id_token":"TOKEN_DA_APPLE","name":"Nome recebido da Apple"}
```

A resposta deve ter o mesmo formato de autenticação de `/login/google`. O nome pode estar vazio, pois a Apple normalmente o fornece somente na primeira autorização. O servidor deve validar assinatura, emissor, público (bundle ID do aplicativo) e validade do token com as chaves oficiais da Apple, identificar a conta pelo `sub` validado e tratar criação ou vinculação de conta com segurança. Não confiar em nome ou e-mail informado pelo cliente como prova de identidade. O endpoint ainda precisa estar disponível na API deste projeto.

O entitlement foi incluído no projeto iOS. A capacidade Sign in with Apple também deve estar habilitada para o App ID no Apple Developer e no perfil de provisionamento. O fluxo completo precisa de validação em dispositivo Apple com uma conta de teste e API configurada. A exclusão de conta e a revogação de autorização Apple não são implementadas por esta alteração.
