# unisinos_usp_app

A new Flutter project.

### Keytool

keytool -genkey -v -keystore unisinos_usp_app.jks -keyalg RSA -keysize 2048 -validity 10000 -alias unisinos_usp_app
CN=SPO Tecnologia, OU=Mobile, O=SPO Tecnologia, L=Tupandi, ST=Rio Grande do Sul, C=BR
Senha em key.properties

### Deploy app 
flutter build web --pwa-strategy=none --no-tree-shake-icons
# recomendação: limpar destino para evitar artefatos antigos
ssh -o IdentitiesOnly=yes -o IdentityAgent=none -i ~/.ssh/aws_spo.pem ubuntu@18.230.235.236 "rm -rf /var/www/unisinos_usp_app/*"
scp -o IdentitiesOnly=yes -o IdentityAgent=none -i ~/.ssh/aws_spo.pem -r build/web/. ubuntu@18.230.235.236:/var/www/unisinos_usp_app/

## Integration tests (with screenshot)

### Login + print da primeira tela

Credenciais padrão de teste (vindas do `config/database.go` da API):
- email: `admin@admin.com`
- senha: `uu2admin`

Com valores padrão:

```bash
flutter test integration_test/login_screenshot_test.dart -d linux
```

Com credenciais explícitas:

```bash
flutter test integration_test/login_screenshot_test.dart -d linux \
  --dart-define=E2E_EMAIL=admin@admin.com \
  --dart-define=E2E_PASSWORD=uu2admin
```

Saída esperada da imagem:
- `/home/odair/.openclaw/workspace/unisinos_usp_first_screen_after_login.png`

### Print da tela alterada (Nova conexão) via Chrome headless

Quando o `integration_test` Linux falhar por dependência de linker do Flutter snap, use este fluxo de fallback:

1. Build web

```bash
flutter build web
```

2. Subir servidor local do build

```bash
python3 -m http.server 8123 --directory build/web
```

3. Captura automatizada via Playwright/Chrome

```bash
cd /tmp
npm init -y
npm i playwright
npx playwright install chromium
```

Script de captura (exemplo):
- Login com `admin@admin.com / uu2admin`
- Navegação para `#/clue_connections/create`
- Geração de `/home/odair/.openclaw/workspace/unisinos_usp_nova_conexao.png`

4. Upload da imagem

```bash
curl -F 'file=@/home/odair/.openclaw/workspace/unisinos_usp_nova_conexao.png' https://nexus01.spotec.app/upload
```

Saída esperada da imagem alterada:
- `/home/odair/.openclaw/workspace/unisinos_usp_nova_conexao.png`

### Teste de integração de API

```bash
flutter test integration_test/api_integration_test.dart -d linux \
  --dart-define=E2E_EMAIL=admin@admin.com \
  --dart-define=E2E_PASSWORD=uu2admin
```
