# Educação OnLIFE

Plataforma de pesquisa e educação que conecta pessoas, territórios, vivências, publicações, dados e tecnologias por meio de **pistas**. Cada pista pode reunir diferentes materiais e estabelecer relações com outras pistas, permitindo explorar percursos de aprendizagem, práticas e metodologias inventivas.

A experiência de navegação acontece em uma nave espacial, acompanhada pela **IAraeté**, parceira epistêmica que orienta a exploração. O cockpit conecta o mapa dos territórios, o acervo de pistas, as problemáticas e os agentes de inteligência artificial.

**[Acessar a plataforma](https://educacaoonlife.gpedu.com.br)** · **[Documentação](#documentação)** · **[Financiamento](#financiamento)**

## Funcionalidades

- **Terra e mapa de pistas:** exploração georreferenciada, visualização de satélite, busca por pistas e lugares e marcadores por categoria.
- **Pistas em fluxo:** pesquisa do acervo, incluindo registros sem localização, com visualização e relações entre pistas.
- **Rastros e Problemáticas:** rede de nodos para investigar problemáticas e suas conexões.
- **Inteligências e IAraeté:** seleção de agentes e conversas por texto e áudio, conforme a configuração dos serviços de IA.
- **Registros e integrações:** editor de pistas, anexos, vídeos, agentes vinculados, problemáticas, leituras de sensores e QR Codes.
- **Explorador e Inventor:** modos de participação que organizam as possibilidades de exploração e criação, respeitando as permissões de acesso.
- **Participação e gestão:** presença de outras naves, conversas entre participantes, encontros e administração dos registros.

## Sobre este repositório

Este repositório contém o aplicativo **Flutter** da Educação OnLIFE, com versões para web, Android e iOS. A experiência espacial utiliza também recursos HTML, CSS e JavaScript integrados ao aplicativo.

A API da plataforma, o banco de dados, o armazenamento de arquivos e a API geográfica são serviços externos a este repositório. O funcionamento das integrações depende da configuração desses serviços no ambiente utilizado.

## Instalação

### Pré-requisitos

- Flutter **3.38 ou superior**, com Dart **3.10 ou superior**, conforme o `pubspec.yaml`.
- Git e acesso SSH ao GitHub.
- Acesso à dependência compartilhada `widgets_spo`, atualmente hospedada em um repositório privado no Bitbucket. A chave SSH utilizada precisa ter permissão nesse repositório para executar `flutter pub get`.
- Para Android, Android SDK e um dispositivo ou emulador configurado.
- Para iOS, macOS, Xcode e a configuração de assinatura correspondente.

```bash
git clone git@github.com:gpedunisinos/educacaoonlifeapp.git
cd educacaoonlifeapp
flutter pub get
```

## Execução local

Inicie uma API compatível e informe seu endereço ao aplicativo. O exemplo abaixo utiliza uma API local na porta `8081`:

```bash
flutter run -d chrome \
  --dart-define=API_HOST=127.0.0.1 \
  --dart-define=API_SCHEME=http \
  --dart-define=API_PORT=8081
```

| Parâmetro | Descrição |
| --- | --- |
| `API_HOST` | Domínio ou IP da API, sem protocolo e sem caminho. |
| `API_SCHEME` | Protocolo de acesso: `http` ou `https`. |
| `API_PORT` | Porta explícita, quando necessária. Use `0` para a porta padrão do protocolo. |

Para dispositivos físicos, utilize um endereço da API acessível pelo dispositivo. Login com provedores externos, notificações, reuniões e serviços de IA exigem as configurações correspondentes ao ambiente.

## Build e publicação web

O build de produção da Educação OnLIFE utiliza a API oficial e preserva as fontes completas dos ícones:

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

O pacote gerado fica em `build/production-release`. Para publicar no ambiente mantido pelo projeto, siga o [procedimento de publicação web](docs/publicacao-web.md), que descreve a identificação da revisão, a preservação da versão anterior e a conferência dos arquivos publicados.

## Estrutura do projeto

```text
lib/        Aplicação Flutter: telas, componentes, modelos e serviços
assets/     Recursos visuais, áudio e experiência espacial
web/        Inicialização e recursos específicos da versão web
android/    Configurações da versão Android
ios/        Configurações da versão iOS
docs/       Documentação técnica e funcional
scripts/    Ferramentas de apoio ao desenvolvimento e à publicação
```

## Documentação

- [Narrativa e vocabulário da Educação OnLIFE](docs/narrativa-onlife.md)
- [Experiência de navegação espacial](docs/experiencia-espacial.md)
- [Arquivos e evidências nas pistas](docs/arquivos-e-evidencias.md)
- [Classificação de práticas e metodologias inventivas](docs/classificacao-inventiva.md)
- [Agentes vinculados às pistas](docs/agentes-nas-pistas.md)
- [Problemáticas vinculadas às pistas](docs/problematicas-nas-pistas.md)
- [Presença de outras naves](docs/presenca-naves.md)
- [Conversas entre participantes](docs/chat-participantes.md)
- [Moderação](docs/moderacao.md)
- [Publicação web](docs/publicacao-web.md)
- [Financiamento e origem dos logos](docs/financiamento.md)

## Contribuições

Sugestões e problemas podem ser registrados nas [issues do projeto](https://github.com/gpedunisinos/educacaoonlifeapp/issues). Para contribuir com o código ou com a documentação, envie uma pull request descrevendo o objetivo e o alcance da alteração.

Preserve a grafia **Educação OnLIFE**, **IAraeté**, **Pistas em fluxo** e **COnversAÇÕES** nos textos públicos da plataforma.

## Financiamento

O desenvolvimento da plataforma Educação OnLIFE conta com financiamento da **Fundação de Amparo à Pesquisa do Estado do Rio Grande do Sul (FAPERGS)** e da **Fundação de Amparo à Pesquisa do Estado de São Paulo (FAPESP)**.

<p>
  <a href="https://fapergs.rs.gov.br/">
    <img src="docs/assets/financiamento/fapergs.jpg" alt="FAPERGS — Fundação de Amparo à Pesquisa do Estado do Rio Grande do Sul" width="280">
  </a>
  &nbsp;&nbsp;
  <a href="https://fapesp.br/">
    <img src="docs/assets/financiamento/fapesp.svg" alt="FAPESP — Fundação de Amparo à Pesquisa do Estado de São Paulo" width="260">
  </a>
</p>

As fontes dos arquivos institucionais estão registradas na [documentação de financiamento](docs/financiamento.md).

## Licença

O código está disponibilizado sob a [licença Apache 2.0](LICENSE). Os nomes e logos institucionais pertencem às respectivas instituições e não são abrangidos pela licença do código.
