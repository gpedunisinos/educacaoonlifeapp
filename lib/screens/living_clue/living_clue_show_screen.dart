import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/widgets/living_clue_layout.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:unisinos_usp_app/widgets/clue_participation.dart';
import 'package:unisinos_usp_app/widgets/locker_panel.dart';
import 'package:unisinos_usp_app/policies/living_clue_policy.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/models/clue_connection_model.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/policies/clue_connection_policy.dart';
import 'package:unisinos_usp_app/webclients/clue_connection_webclient.dart';
import 'package:unisinos_usp_app/webclients/living_clue_webclient.dart';
import 'package:unisinos_usp_app/widgets/living_clue_description_view.dart';
import 'package:unisinos_usp_app/screens/space/space_record_shell.dart';
import 'package:unisinos_usp_app/widgets/environmental_context_card.dart';
import 'package:widgets_spo/widgets_spo.dart';

class LivingClueRecordSource {
  Future<LivingClueModel> clue(int id) => LivingClueWebclient().fetchById(id);
  Future<List<ClueConnectionModel>> connections(int id) =>
      ClueConnectionWebclient().fetchForLivingClue(id);
}

class LivingClueShowScreen extends StatefulWidget {
  const LivingClueShowScreen({
    super.key,
    this.clueId,
    this.initialClue,
    this.source,
  });
  final int? clueId;
  final LivingClueModel? initialClue;
  final LivingClueRecordSource? source;

  @override
  State<LivingClueShowScreen> createState() => _LivingClueShowScreenState();
}

class _LivingClueShowScreenState extends State<LivingClueShowScreen> {
  late LivingClueModel model;
  late final source = widget.source ?? LivingClueRecordSource();
  bool _initialLoading = false;
  String? _initialError;
  Timer? _refreshTimer;
  int _refreshAttempts = 0;
  late final String _route = Get.currentRoute;
  late final AiAssistantContextProvider _provider = () =>
      AiAssistantScreenContext(
        screenName: 'Registro de pista na nave',
        route: _route,
        stage: 'visualização completa de pista',
        goal: 'explorar a pista, suas relações, contexto e compartilhações',
        filledFields: {'pista': model.name, 'id': model.id.toString()},
      );
  List<ClueConnectionModel> _connections = <ClueConnectionModel>[];
  bool _isLoadingConnections = true;
  String? _connectionsError;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (widget.initialClue != null && widget.initialClue!.id == widget.clueId) {
      model = widget.initialClue!;
    } else if (args is LivingClueModel) {
      model = args;
    } else if (args is Map && args['model'] is LivingClueModel) {
      model = args['model'];
    } else {
      model = LivingClueModel(
        id: widget.clueId ?? int.tryParse(Get.parameters['id'] ?? '') ?? 0,
        name: '',
        categoryId: 0,
      );
      _initialLoading = true;
    }
    if (Get.isRegistered<AiAssistantContextService>()) {
      Get.find<AiAssistantContextService>().registerProvider(_route, _provider);
    }
    _refreshContext();
    _loadConnections();
  }

  Future<void> _loadConnections() async {
    if (mounted) {
      setState(() {
        _isLoadingConnections = true;
        _connectionsError = null;
      });
    }
    try {
      final connections = await source.connections(model.id);
      if (!mounted) return;
      setState(() => _connections = connections);
    } catch (_) {
      if (!mounted) return;
      setState(
        () => _connectionsError = 'Não foi possível carregar as relações.',
      );
    } finally {
      if (mounted) setState(() => _isLoadingConnections = false);
    }
  }

  Future<void> _refreshContext() async {
    try {
      final refreshed = await source.clue(model.id);
      if (!mounted) return;
      setState(() {
        model = refreshed;
        _initialLoading = false;
        _initialError = null;
      });
      final status = model.environmentalContext?.status;
      if ((status == 'pending' || status == 'processing') &&
          _refreshAttempts < 6) {
        _refreshAttempts++;
        _refreshTimer = Timer(const Duration(seconds: 5), _refreshContext);
      }
    } catch (_) {
      if (mounted && _initialLoading)
        setState(() {
          _initialLoading = false;
          _initialError = 'Não foi possível abrir esta pista.';
        });
    }
  }

  Future<void> _reprocessContext() async {
    await LivingClueWebclient().reprocessEnvironmentalContext(model.id);
    _refreshAttempts = 0;
    await _refreshContext();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    if (Get.isRegistered<AiAssistantContextService>()) {
      Get.find<AiAssistantContextService>().unregisterProvider(
        _route,
        _provider,
      );
    }
    super.dispose();
  }

  void _leave() {
    if (Navigator.of(context).canPop()) {
      Get.back();
    } else {
      Get.offNamed('/space/research');
    }
  }

  Widget _frame(Widget child, {List<Widget> actions = const []}) =>
      SpaceRecordShell(
        onBack: _leave,
        backLabel: Get.currentRoute.startsWith('/space/research/')
            ? 'Voltar à lista'
            : 'Voltar',
        actions: actions,
        child: child,
      );

  @override
  Widget build(BuildContext context) => Theme(
    data: spaceRecordTheme(),
    child: Builder(builder: _buildRecord),
  );

  Widget _buildRecord(BuildContext context) {
    if (_initialLoading) {
      return _frame(const Center(child: CircularProgressIndicator()));
    }
    if (_initialError != null) {
      return _frame(
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_initialError!),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _initialLoading = true;
                    _initialError = null;
                  });
                  _refreshContext();
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }
    final theme = Theme.of(context);
    final categoryName =
        model.category?.name ?? 'Categoria ${model.categoryId}';

    return _frame(
      Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: LivingClueLayout.pagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(
                        color: Color(0x8A46B6EC),
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  model.name,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Chip(
                                label: Text(
                                  model.isActive ? 'Ativa' : 'Inativa',
                                ),
                                backgroundColor: model.isActive
                                    ? Colors.green.shade100
                                    : Colors.grey.shade200,
                                labelStyle: TextStyle(
                                  color: model.isActive
                                      ? Colors.green.shade800
                                      : Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.category_outlined,
                                color: const Color(0xFF9CE7DF),
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  categoryName,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          if ((model.description ?? '').isNotEmpty ||
                              (model.descriptionDelta ?? '').isNotEmpty) ...[
                            const SizedBox(height: 12),
                            LivingClueDescriptionView(
                              clueId: model.id,
                              plainText: model.description ?? '',
                              delta: model.descriptionDelta,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (model.hasLocation)
                    EnvironmentalContextCard(
                      context: model.environmentalContext,
                      onRetry: _reprocessContext,
                    ),
                  const SizedBox(height: 12),
                  _buildConnectionsCard(context),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Color(0x8A46B6EC),
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Localização',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.place_outlined,
                                size: 18,
                                color: Colors.blueGrey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Lat: ${model.latitude?.toStringAsFixed(6) ?? 'Não informada'}',
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.place_outlined,
                                size: 18,
                                color: Colors.transparent,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Lng: ${model.longitude?.toStringAsFixed(6) ?? 'Não informada'}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Color(0x8A46B6EC),
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Conversa com a pista viva',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Abra um chat contextual para conversar com esta pista.',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => Get.toNamed(
                                '/living_clues/${model.id}/chat',
                                arguments: {'model': model},
                              ),
                              icon: const Icon(Icons.forum_outlined),
                              label: const Text('Conversar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (model.imageUrl != null && model.imageUrl!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Color(0x8A46B6EC),
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            color: const Color(0xFF15333D),
                            padding: const EdgeInsets.all(12),
                            child: const Text('Imagem'),
                          ),
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              model.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Center(child: Icon(Icons.broken_image)),
                              loadingBuilder: (context, child, progress) =>
                                  progress == null
                                  ? child
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (model.metadata != null && model.metadata!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Color(0x8A46B6EC),
                          width: 1.2,
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Metadata',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            ...model.metadata!.entries.map(
                              (entry) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _formatTagLabel(entry.key),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(entry.value?.toString() ?? ''),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  if (model.files.isNotEmpty)
                    Card(
                      child: Column(
                        children: [
                          const ListTile(
                            leading: Icon(Icons.attach_file),
                            title: Text('Anexos'),
                          ),
                          for (final file in model.files)
                            ListTile(
                              title: Text(file.name ?? 'Documento'),
                              trailing: const Icon(Icons.open_in_new),
                              onTap: () {
                                final uri = Uri.tryParse(file.publicUrl ?? '');
                                if (uri != null &&
                                    ['https', 'http'].contains(uri.scheme))
                                  launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                              },
                            ),
                        ],
                      ),
                    ),
                  ClueEditHistory(clueId: model.id),
                  const SizedBox(height: 12),
                  ClueParticipation(clueId: model.id),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        LockerButton(type: 'living_clue', id: model.id),
        if (LivingCluePolicy(
          Get.find<UserController>().user.value,
        ).update(model))
          IconButton(
            tooltip: 'Editar',
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Get.toNamed(
                '/living_clues/update',
                parameters: {'id': model.id.toString()},
              );
              if (mounted) await _refreshContext();
            },
          ),
      ],
    );
  }

  String _formatTagLabel(String raw) {
    final cleaned = raw.replaceAll('_', ' ');
    return cleaned
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  Widget _buildConnectionsCard(BuildContext context) {
    final policy = ClueConnectionPolicy(Get.find<UserController>().user.value);
    final outgoing = _connections
        .where(
          (item) =>
              (item.connectionType?.isDirectional ?? true) &&
              item.isOutgoingFrom(model.id),
        )
        .toList();
    final incoming = _connections
        .where(
          (item) =>
              (item.connectionType?.isDirectional ?? true) &&
              !item.isOutgoingFrom(model.id),
        )
        .toList();
    final related = _connections
        .where((item) => !(item.connectionType?.isDirectional ?? true))
        .toList();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0x8A46B6EC), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Relações com outras pistas',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                if (policy.create())
                  IconButton(
                    tooltip: 'Adicionar relação',
                    icon: const Icon(Icons.add_link),
                    onPressed: _createConnection,
                  ),
              ],
            ),
            if (_isLoadingConnections)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_connectionsError != null)
              Row(
                children: [
                  Expanded(child: Text(_connectionsError!)),
                  TextButton(
                    onPressed: _loadConnections,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              )
            else if (_connections.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Esta pista ainda não possui relações cadastradas.',
                ),
              )
            else ...[
              if (outgoing.isNotEmpty)
                _buildConnectionGroup(
                  context,
                  'Relações que partem desta pista',
                  outgoing,
                  policy,
                ),
              if (incoming.isNotEmpty)
                _buildConnectionGroup(
                  context,
                  'Relações que chegam nesta pista',
                  incoming,
                  policy,
                ),
              if (related.isNotEmpty)
                _buildConnectionGroup(
                  context,
                  'Pistas relacionadas',
                  related,
                  policy,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionGroup(
    BuildContext context,
    String title,
    List<ClueConnectionModel> connections,
    ClueConnectionPolicy policy,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          ...connections.map(
            (connection) => _buildConnectionTile(context, connection, policy),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionTile(
    BuildContext context,
    ClueConnectionModel connection,
    ClueConnectionPolicy policy,
  ) {
    final relatedClue = connection.relatedClueFor(model.id);
    final typeName =
        connection.connectionType?.name ??
        'Tipo #${connection.connectionTypeId}';
    final isDirectional = connection.connectionType?.isDirectional ?? true;
    final directionIcon = isDirectional
        ? (connection.isOutgoingFrom(model.id)
              ? Icons.arrow_forward
              : Icons.arrow_back)
        : Icons.sync_alt;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12, 6, 4, 6),
        leading: Icon(directionIcon, color: const Color(0xFF9CE7DF)),
        title: Text(
          relatedClue?.name ??
              'Pista #${connection.isOutgoingFrom(model.id) ? connection.targetClueId : connection.sourceClueId}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$typeName • Força ${connection.strength}'),
            if ((connection.evidence ?? '').trim().isNotEmpty)
              Text('Evidência: ${connection.evidence}'),
          ],
        ),
        onTap: relatedClue == null ? null : () => _openRelatedClue(relatedClue),
        trailing: policy.update(connection) || policy.delete(connection)
            ? PopupMenuButton<String>(
                tooltip: 'Ações da relação',
                onSelected: (value) {
                  if (value == 'edit') _editConnection(connection);
                  if (value == 'delete') _deleteConnection(connection);
                },
                itemBuilder: (_) => [
                  if (policy.update(connection))
                    const PopupMenuItem(value: 'edit', child: Text('Editar')),
                  if (policy.delete(connection))
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Excluir'),
                    ),
                ],
              )
            : const Icon(Icons.chevron_right),
      ),
    );
  }

  Future<void> _createConnection() async {
    final created = await Get.toNamed(
      '/living_clues/connect',
      arguments: model,
    );
    if (created == true) await _loadConnections();
  }

  Future<void> _editConnection(ClueConnectionModel connection) async {
    final updated = await Get.toNamed(
      '/clue_connections/update',
      parameters: {'id': connection.id.toString()},
    );
    if (updated == true) await _loadConnections();
  }

  Future<void> _deleteConnection(ClueConnectionModel connection) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Excluir relação'),
        content: const Text('Deseja realmente excluir esta relação?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ClueConnectionWebclient().delete(connection.id);
      await _loadConnections();
      Get.successSnackbar('Relação removida com sucesso.');
    } catch (error) {
      Get.customSnackbar('Erro', 'Não foi possível remover a relação. $error');
    }
  }

  void _openRelatedClue(LivingClueModel relatedClue) {
    Get.toNamed('/space/research/${relatedClue.id}', arguments: relatedClue);
  }
}
