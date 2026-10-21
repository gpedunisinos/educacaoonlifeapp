import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:unisinos_usp_app/models/clue_integration.dart';
import 'package:unisinos_usp_app/widgets/integration_frame.dart';
import 'package:unisinos_usp_app/widgets/clue_media.dart';
import 'package:unisinos_usp_app/screens/space/space_record_shell.dart';

IconData integrationIcon(String provider) => switch (provider) {
  'youtube' => Icons.smart_display_outlined,
  'genially' => Icons.auto_awesome_outlined,
  'padlet' => Icons.dashboard_outlined,
  'framevr' => Icons.view_in_ar_outlined,
  'overte' || 'vircadia' => Icons.public,
  _ => Icons.extension_outlined,
};

class ClueIntegrationCards extends StatelessWidget {
  const ClueIntegrationCards({super.key, required this.controller});
  final QuillController controller;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 850
          ? 3
          : constraints.maxWidth >= 520
          ? 2
          : 1;
      final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
      final providers = ['youtube', if (kIsWeb) ...ClueIntegration.providers];
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: providers.map((provider) {
          final name = provider == 'youtube'
              ? 'YouTube'
              : ClueIntegration(provider: provider, url: '').name;
          return SizedBox(
            width: width,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => provider == 'youtube'
                    ? insertYouTube(context, controller)
                    : editClueIntegration(
                        context,
                        controller,
                        provider: provider,
                      ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        integrationIcon(provider),
                        color: const Color(0xFF9CE7DF),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              provider == 'youtube'
                                  ? 'Adicione um vídeo à pista.'
                                  : ClueIntegration.explanation(provider),
                              style: const TextStyle(height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.add, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    },
  );
}

Future<void> editClueIntegration(
  BuildContext context,
  QuillController controller, {
  required String provider,
  ClueIntegration? initial,
  int? offset,
}) async {
  final selection = controller.selection;
  final url = TextEditingController(text: initial?.url);
  final title = TextEditingController(text: initial?.title);
  final instructions = TextEditingController(text: initial?.instructions);
  final form = GlobalKey<FormState>();
  final name = ClueIntegration(provider: provider, url: '').name;
  final result = await showDialog<ClueIntegration>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('${initial == null ? 'Adicionar' : 'Editar'} $name'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(ClueIntegration.explanation(provider)),
                const SizedBox(height: 18),
                TextFormField(
                  controller: url,
                  autofocus: true,
                  maxLength: 2000,
                  decoration: InputDecoration(
                    labelText:
                        initial?.desktopClient == true ||
                            provider == 'overte' ||
                            provider == 'vircadia'
                        ? 'Endereço hifi:// do mundo'
                        : 'Link de visualização',
                    hintText: provider == 'genially'
                        ? 'https://view.genially.com/…'
                        : null,
                  ),
                  validator: (value) => ClueIntegration.validateURL(
                    provider,
                    value?.trim() ?? '',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: title,
                  maxLength: 300,
                  decoration: const InputDecoration(
                    labelText: 'Título (opcional)',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: instructions,
                  maxLength: 3000,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Instruções de acesso (opcional)',
                  ),
                ),
                if (provider == 'overte' || provider == 'vircadia')
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      'O mundo abre em um cliente instalado. A compatibilidade do ambiente precisa ser conferida; não há execução 3D incorporada.',
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (form.currentState?.validate() != true) return;
            Navigator.pop(
              context,
              ClueIntegration(
                provider: provider,
                url: url.text.trim(),
                title: title.text.trim(),
                instructions: instructions.text.trim(),
              ),
            );
          },
          child: Text(
            initial == null ? 'Inserir integração' : 'Salvar integração',
          ),
        ),
      ],
    ),
  );
  url.dispose();
  title.dispose();
  instructions.dispose();
  if (result == null) return;
  final at = (offset ?? selection.start).clamp(
    0,
    controller.document.length - 1,
  );
  final length = offset != null
      ? 1
      : selection.isValid
      ? selection.end - selection.start
      : 0;
  controller.replaceText(
    at,
    length,
    BlockEmbed('onlife', result.encode()),
    TextSelection.collapsed(offset: at + 1),
  );
}

class ClueIntegrationBuilder extends EmbedBuilder {
  const ClueIntegrationBuilder();
  @override
  String get key => 'onlife';
  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final block = ClueIntegration.decode(embedContext.node.value.data);
    if (block == null ||
        !block.supported ||
        ClueIntegration.validateURL(block.provider, block.url) != null)
      return const _UnavailableIntegration();
    final editing = !embedContext.readOnly;
    return ClueIntegrationView(
      block: block,
      onEdit: editing && kIsWeb
          ? () => editClueIntegration(
              context,
              embedContext.controller,
              provider: block.provider,
              initial: block,
              offset: embedContext.node.documentOffset,
            )
          : null,
      onRemove: editing && kIsWeb
          ? () => embedContext.controller.replaceText(
              embedContext.node.documentOffset,
              1,
              '',
              TextSelection.collapsed(offset: embedContext.node.documentOffset),
            )
          : null,
      editing: editing,
    );
  }
}

class UnknownClueEmbedBuilder extends EmbedBuilder {
  const UnknownClueEmbedBuilder();
  @override
  String get key => 'unsupported';
  @override
  Widget build(BuildContext context, EmbedContext embedContext) =>
      const _UnavailableIntegration();
}

class _UnavailableIntegration extends StatelessWidget {
  const _UnavailableIntegration();
  @override
  Widget build(BuildContext context) => const Card(
    child: Padding(
      padding: EdgeInsets.all(18),
      child: Text(
        'Conteúdo de outra versão preservado no documento. Sua visualização não está disponível nesta versão.',
      ),
    ),
  );
}

class ClueIntegrationView extends StatelessWidget {
  const ClueIntegrationView({
    super.key,
    required this.block,
    this.editing = false,
    this.onEdit,
    this.onRemove,
  });
  final ClueIntegration block;
  final bool editing;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;
  Future<void> _open(BuildContext context) async {
    try {
      if (await launchUrl(
        Uri.parse(block.url),
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      ))
        return;
    } catch (_) {
      /* Clipboard and access instructions remain available. */
    }
    if (context.mounted)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível abrir. Confira o acesso ou use o endereço copiado.',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  integrationIcon(block.provider),
                  color: const Color(0xFF9CE7DF),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    block.title.isEmpty ? block.name : block.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(block.name, style: Theme.of(context).textTheme.labelMedium),
            if (block.instructions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(block.instructions),
              ),
            if (!kIsWeb)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Integração preservada. Acesse esta pista no navegador para usar este recurso.',
                ),
              )
            else if (editing) ...[
              const SizedBox(height: 10),
              Text(block.url),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                children: [
                  OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Editar integração'),
                  ),
                  TextButton.icon(
                    onPressed: onRemove,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Remover integração'),
                  ),
                ],
              ),
            ] else ...[
              if (block.inline && block.embedURI != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: LayoutBuilder(
                    builder: (context, size) => SizedBox(
                      height: block.provider == 'padlet'
                          ? 420
                          : (size.maxWidth * 9 / 16).clamp(220.0, 440.0),
                      child: IntegrationFrame(
                        key: ValueKey(block.url),
                        uri: block.embedURI!,
                        title: block.title.isEmpty ? block.name : block.title,
                      ),
                    ),
                  ),
                ),
              if (block.desktopClient)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Requer o cliente instalado. A abertura deste ambiente ainda precisa ser conferida no aplicativo de origem.',
                  ),
                ),
              if (block.desktopClient) SelectableText(block.url),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  if (!block.desktopClient && block.embedURI != null)
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => _IntegrationRoom(block: block),
                        ),
                      ),
                      icon: Icon(
                        block.inline
                            ? Icons.fullscreen
                            : Icons.view_in_ar_outlined,
                      ),
                      label: Text(
                        block.inline
                            ? 'Ampliar conteúdo'
                            : 'Entrar no ambiente',
                      ),
                    ),
                  TextButton.icon(
                    onPressed: () => _open(context),
                    icon: const Icon(Icons.open_in_new),
                    label: Text(
                      block.desktopClient
                          ? 'Abrir no ${block.name}'
                          : 'Abrir na origem',
                    ),
                  ),
                  if (block.desktopClient)
                    TextButton.icon(
                      onPressed: () =>
                          Clipboard.setData(ClipboardData(text: block.url)),
                      icon: const Icon(Icons.copy),
                      label: const Text('Copiar endereço'),
                    ),
                  if (block.desktopClient)
                    TextButton(
                      onPressed: () => launchUrl(
                        Uri.parse(
                          block.provider == 'overte'
                              ? 'https://overte.org/downloads.html'
                              : 'https://vircadia.com/',
                        ),
                        webOnlyWindowName: '_blank',
                      ),
                      child: const Text('Conhecer o aplicativo'),
                    ),
                ],
              ),
              if (!block.desktopClient)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'O acesso e a participação seguem as regras do provedor. Se não carregar aqui, abra na origem.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
            ],
          ],
        ),
      ),
    ),
  );
}

class _IntegrationRoom extends StatelessWidget {
  const _IntegrationRoom({required this.block});
  final ClueIntegration block;
  @override
  Widget build(BuildContext context) => Theme(
    data: spaceRecordTheme(),
    child: Scaffold(
      appBar: AppBar(
        title: Text(block.title.isEmpty ? block.name : block.title),
        actions: [
          TextButton.icon(
            onPressed: () =>
                launchUrl(Uri.parse(block.url), webOnlyWindowName: '_blank'),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Abrir na origem'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              block.provider == 'framevr'
                  ? 'Você está entrando em um ambiente externo. Câmera e microfone serão solicitados pelo provedor quando necessários. Ao voltar, o ambiente será encerrado.'
                  : 'As permissões deste conteúdo são controladas pelo provedor.',
            ),
          ),
          Expanded(
            child: IntegrationFrame(
              uri: block.embedURI!,
              title: block.name,
              media: block.provider == 'framevr',
            ),
          ),
        ],
      ),
    ),
  );
}
