# unisinos_usp_app

A new Flutter project.

### Keytool

keytool -genkey -v -keystore unisinos_usp_app.jks -keyalg RSA -keysize 2048 -validity 10000 -alias unisinos_usp_app
CN=SPO Tecnologia, OU=Mobile, O=SPO Tecnologia, L=Tupandi, ST=Rio Grande do Sul, C=BR
Senha em key.properties

### Publicação web

Siga o procedimento em [docs/publicacao-web.md](docs/publicacao-web.md), incluindo build, validação das fontes, publicação com backup e conferência dos dois domínios.

**Todo build web de publicação deve usar `--no-tree-shake-icons` e `--pwa-strategy=none`.** A pipeline já contém esses parâmetros; builds manuais também precisam deles.

```bash
flutter build web --release \
  --no-tree-shake-icons \
  --no-web-resources-cdn \
  --pwa-strategy=none \
  --output build/production-release \
  --dart-define=API_HOST=api.uniusp.gpedu.com.br \
  --dart-define=API_SCHEME=https \
  --dart-define=JITSI_ENABLED=true
```

Publicar somente o artefato validado e correspondente à revisão informada:

```bash
python3 scripts/deploy-web-release.py \
  --build build/production-release \
  --revision "$(git rev-parse HEAD)"
```

O comando acima pressupõe que o build foi gerado dessa revisão, sem alterações locais não registradas. Não compilar ou publicar simultaneamente com outra sessão usando o mesmo diretório de saída.

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
flutter build web --no-tree-shake-icons --pwa-strategy=none
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
