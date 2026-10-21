import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/controllers/ai_assistant/ai_assistant_controller.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/policies/policies.dart';
import 'package:unisinos_usp_app/widgets/ai_assistant_panel.dart';
import 'package:unisinos_usp_app/screens/space/space_view.dart';

class SpaceScreen extends StatefulWidget {
  const SpaceScreen({super.key});
  @override
  State<SpaceScreen> createState() => _SpaceScreenState();
}

class _SpaceScreenState extends State<SpaceScreen> with WidgetsBindingObserver {
  final commands = StreamController<Map<String, dynamic>>.broadcast();
  final contextService = Get.find<AiAssistantContextService>();
  bool opening = false;
  String destination = 'Terra';
  // Keep the exact callback identity for unregisterProvider.
  late final AiAssistantContextProvider contextProvider = buildContext;
  AiAssistantScreenContext buildContext() => AiAssistantScreenContext(
    screenName: 'Cockpit eCOnectiva',
    route: '/space',
    stage: 'exploração espacial',
    goal: 'navegar pelos territórios e módulos com a orientação da Iareté',
    filledFields: {'destino selecionado': destination},
    notes: const [
      'A Terra abre o Mapa de Pistas em tela cheia. As estações abrem os módulos da plataforma.',
    ],
  );
  Map<String, String> get destinations {
    final user = Get.find<UserController>().user.value;
    return {
      if (LivingCluePolicy(user).viewAny()) 'earth': '/living_clues/map',
      if (LivingCluePolicy(user).viewAny()) 'research': '/living_clues',
      if (NodePolicy(user).viewAny()) 'observatory': '/nodes/graph',
      if (ClueConnectionPolicy(user).viewAny())
        'connections': '/space/connections',
      if (ChatTemplatePolicy(user).viewAny()) 'agents': '/space/agents',
    };
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    contextService.registerProvider('/space', contextProvider);
  }

  void send(String type, [Map<String, dynamic> extra = const {}]) {
    if (!commands.isClosed) commands.add({'type': type, ...extra});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // The iframe handles document.visibilitychange itself on web. Flutter's
    // focus lifecycle also fires when focus enters a platform view.
    if (kIsWeb || state == AppLifecycleState.inactive) return;
    if (state != AppLifecycleState.resumed) {
      send('pause');
    } else if (!opening) {
      send('resume');
    }
  }

  Future<void> onMessage(Map<String, dynamic> data) async {
    if (!mounted) return;
    if (data['type'] == 'ready') {
      send('configure', {'destinations': destinations.keys.toList()});
      return;
    }
    if (data['type'] == 'select' && data['name'] is String) {
      destination = data['name'] as String;
      return;
    }
    if (opening) return;
    if (data['type'] == 'exit') {
      exitCockpit();
      return;
    }
    final route = destinations[data['destination']];
    if (data['type'] != 'assistant' &&
        (data['type'] != 'open' || route == null)) {
      return;
    }
    opening = true;
    send('pause', {'cover': true});
    try {
      if (data['type'] == 'assistant') {
        final controller = Get.find<AiAssistantController>();
        controller.ensureHistoryLoaded();
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const AiAssistantPanel(),
        );
      } else {
        await Get.toNamed(route!, arguments: const {'fromSpace': true});
      }
    } finally {
      opening = false;
      if (mounted) {
        contextService.registerProvider('/space', contextProvider);
        send('resume', {'returned': true});
      }
    }
  }

  void exitCockpit() {
    if (Navigator.of(context).canPop()) {
      Get.back();
    } else {
      Get.offNamed('/home');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    contextService.unregisterProvider('/space', contextProvider);
    commands.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF030914),
    body: SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: SpaceView(onMessage: onMessage, commands: commands.stream),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: IconButton.filledTonal(
              tooltip: 'Voltar aos módulos',
              onPressed: exitCockpit,
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF10232D),
                foregroundColor: const Color(0xFFA3EFD9),
              ),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    ),
  );
}
