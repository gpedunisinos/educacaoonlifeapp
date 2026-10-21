import 'package:unisinos_usp_app/screens/living_clue/living_clue_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/services/location_privacy_service.dart';

class LivingClueMapCreateScreen extends StatefulWidget {
  const LivingClueMapCreateScreen({super.key});

  @override
  State<LivingClueMapCreateScreen> createState() =>
      _LivingClueMapCreateScreenState();
}

class _LivingClueMapCreateScreenState extends State<LivingClueMapCreateScreen> {
  static const String _screenName = 'Escolha do local da pista';
  LatLng _center = const LatLng(-29.718, -51.143);
  LatLng? _selected;

  @override
  void initState() {
    super.initState();
    _prefillFromArgs();
  }

  void _prefillFromArgs() {
    final args = Get.arguments;
    if (args is Map) {
      final lat = args['latitude'];
      final lng = args['longitude'];
      if (lat is num && lng is num) {
        _center = LatLng(lat.toDouble(), lng.toDouble());
        _selected = _center;
      }
    }
  }

  Future<void> _goToCreate() async {
    if (_selected == null) {
      Get.snackbar(
        'Selecione um ponto',
        'Toque no mapa ou pesquise um local para marcar a localização.',
      );
      return;
    }
    if (!await LocationPrivacyService.ensureAcknowledged(context)) return;
    if (!mounted) return;

    final result = await Get.toNamed(
      '/living_clues/type_select',
      arguments: {
        'latitude': _selected!.latitude,
        'longitude': _selected!.longitude,
      },
    );
    if (_isCreatedResult(result)) {
      Get.back(result: result);
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.find<AiAssistantContextService>().registerProvider(
      Get.currentRoute,
      _buildAiContext,
    );
    return LivingClueLocationScreen(
      initialPoint: _selected,
      onPointChanged: (point) => _selected = point,
      onConfirm: (point) async {
        _selected = point;
        await _goToCreate();
      },
    );
  }

  AiAssistantScreenContext _buildAiContext() {
    return AiAssistantScreenContext(
      screenName: _screenName,
      route: Get.currentRoute,
      stage: 'seleção do ponto no mapa',
      goal: 'marcar um ponto público ou aproximado para a pista viva',
      visibleFields: const <String>[
        'mapa',
        'usar minha localização',
        'pesquisar local',
        'satélite ou mapa',
        'remover ponto',
        'usar esta localização',
      ],
      filledFields: <String, String>{
        'ponto selecionado': _selected == null
            ? 'nenhum'
            : '${_selected!.latitude.toStringAsFixed(5)}, ${_selected!.longitude.toStringAsFixed(5)}',
      },
      notes: <String>[
        'O usuário deve evitar sua casa ou localização exata e preferir um ponto público ou aproximado.',
      ],
    );
  }

  bool _isCreatedResult(Object? result) {
    return result == true || (result is Map && result['created'] == true);
  }
}
